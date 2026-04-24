import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/di/injection.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../domain/entities/auth_state.dart';
import '../../presentation/state/user_notifier.dart';
import '../widgets/org_avatar.dart';
import '../widgets/user_avatar.dart';
import 'settings_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Organization> _orgs = [];
  bool _orgsLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    await Future.wait([
      Injection.userNotifier.loadCurrentUser(),
      Injection.userNotifier.listCurrentUserRepos(),
    ]);
    _loadOrgs();
  }

  Future<void> _loadOrgs() async {
    if (_orgsLoading) return;
    setState(() => _orgsLoading = true);
    final result = await Injection.listCurrentUserOrgsUseCase();
    switch (result) {
      case Right<Failure, List<Organization>>(:final value):
        if (mounted) {
          setState(() {
            _orgs = value;
            _orgsLoading = false;
          });
        }
      case Left<Failure, List<Organization>>():
        if (mounted) {
          setState(() => _orgsLoading = false);
        }
    }
  }

  Future<void> _refresh() async {
    await Future.wait([
      Injection.userNotifier.loadCurrentUser(),
      Injection.userNotifier.listCurrentUserRepos(),
    ]);
    _loadOrgs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListenableBuilder(
        listenable: Injection.userNotifier,
        builder: (context, _) {
          final state = Injection.userNotifier.state;
          return switch (state) {
            UserLoading() => const _LoadingView(),
            UserError(:final message) => _ErrorView(message: message, onRetry: _refresh),
            UserLoaded(:final user) => _ProfileContent(
              user: user,
              orgs: _orgs,
              orgsLoading: _orgsLoading,
              onRefresh: _refresh,
            ),
            _ => const _LoadingView(),
          };
        },
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text('Failed to load profile', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(message, style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  final User user;
  final List<Organization> orgs;
  final bool orgsLoading;
  final VoidCallback onRefresh;

  const _ProfileContent({
    required this.user,
    required this.orgs,
    required this.orgsLoading,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          _UserHeader(user: user),
          const SizedBox(height: 16),
          _StatsRow(user: user),
          const SizedBox(height: 16),
          _InfoCards(user: user),
          if (orgs.isNotEmpty) ...[
            const SizedBox(height: 16),
            _OrgsSection(orgs: orgs, loading: orgsLoading),
          ],
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const SettingsPage(),
              ));
            },
          ),
          const SizedBox(height: 24),
          _SignOutButton(),
        ],
      ),
    );
  }
}

class _UserHeader extends StatelessWidget {
  final User user;

  const _UserHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        children: [
          UserAvatar(user: user, radius: 52),
          const SizedBox(height: 12),
          Text(
            user.full_name ?? user.login ?? 'Unknown User',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (user.login != null) ...[
            const SizedBox(height: 2),
            Text(
              '@${user.login}',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          if (user.description != null && user.description!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              user.description!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (user.is_admin == true) ...[
            const SizedBox(height: 8),
            Chip(
              label: const Text('Admin'),
              avatar: Icon(Icons.shield, size: 16, color: theme.colorScheme.onError),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
          ],
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final User user;

  const _StatsRow({required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: _StatItem(label: 'Repos', value: '${user.starred_repos_count ?? 0}')),
          Expanded(child: _StatItem(label: 'Followers', value: '${user.followers_count ?? 0}')),
          Expanded(child: _StatItem(label: 'Following', value: '${user.following_count ?? 0}')),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Text(value, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(label, style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            )),
          ],
        ),
      ),
    );
  }
}

class _InfoCards extends StatelessWidget {
  final User user;

  const _InfoCards({required this.user});

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];
    if (user.email != null && user.email!.isNotEmpty) {
      items.add(_InfoTile(
        icon: Icons.email_outlined,
        label: user.email!,
        onTap: () => _launchUrl('mailto:${user.email!}'),
      ));
    }
    if (user.location != null && user.location!.isNotEmpty) {
      items.add(_InfoTile(icon: Icons.location_on_outlined, label: user.location!));
    }
    if (user.website != null && user.website!.isNotEmpty) {
      items.add(_InfoTile(
        icon: Icons.language,
        label: user.website!,
        onTap: () => _launchUrl(user.website!),
      ));
    }
    if (user.created != null) {
      items.add(_InfoTile(
        icon: Icons.calendar_today_outlined,
        label: 'Joined ${_formatDate(user.created!)}',
      ));
    }

    if (items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: Column(children: items),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month]} ${date.day}, ${date.year}';
  }

  Future<void> _launchUrl(String url) async {
    var uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) {
      uri = Uri.tryParse('https://$url');
    }
    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _InfoTile({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, size: 20, color: theme.colorScheme.primary),
      title: Text(label, style: theme.textTheme.bodyMedium),
      dense: true,
      trailing: onTap != null ? const Icon(Icons.open_in_new, size: 16) : null,
      onTap: onTap,
    );
  }
}

class _OrgsSection extends StatelessWidget {
  final List<Organization> orgs;
  final bool loading;

  const _OrgsSection({required this.orgs, required this.loading});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Organizations', style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          )),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 56,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: orgs.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final org = orgs[index];
              return Tooltip(
                message: org.full_name ?? org.username ?? '',
                child: OrgAvatar(org: org, radius: 24),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SignOutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FilledButton.icon(
        onPressed: () => _handleSignOut(context),
        icon: const Icon(Icons.logout),
        label: const Text('Sign Out'),
        style: FilledButton.styleFrom(
          backgroundColor: theme.colorScheme.error,
          foregroundColor: theme.colorScheme.onError,
          minimumSize: const Size.fromHeight(48),
        ),
      ),
    );
  }

  void _handleSignOut(BuildContext context) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await Injection.authNotifier.logout();
            },
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}