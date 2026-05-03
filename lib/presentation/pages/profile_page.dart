import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../../presentation/state/user_notifier.dart';
import '../../core/animations/animated_wrapper.dart';
import '../widgets/empty_state.dart';
import '../widgets/org_avatar.dart';
import '../widgets/premium_card.dart';
import '../widgets/user_avatar.dart';
import 'create_org_page.dart';
import 'create_repo_page.dart';
import 'emails_page.dart';
import 'follow_page.dart';
import 'gpg_keys_page.dart';
import 'user_repos_page.dart';
import 'package_list_page.dart';
import 'organization_detail_page.dart';
import 'organizations_list_page.dart';
import 'settings_page.dart';
import 'starred_repos_page.dart';

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
    final l10n = AppLocalizations.of(context)!;
    return EmptyState(
      icon: Icons.error_outline,
      title: l10n.failedToLoadProfile,
      subtitle: message,
      action: FilledButton.icon(
        onPressed: onRetry,
        icon: const Icon(Icons.refresh),
        label: Text(l10n.retry),
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
    final l10n = AppLocalizations.of(context)!;
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView(
        padding: const EdgeInsets.only(bottom: UIConstants.xl),
        children: [
          FadeInWrapper(child: _UserHeader(user: user)),
          const SizedBox(height: UIConstants.md),
          _StatsRow(user: user, l10n: l10n),
          const SizedBox(height: UIConstants.md),
          _InfoCards(user: user, l10n: l10n),
          if (orgs.isNotEmpty) ...[
            const SizedBox(height: UIConstants.md),
            _OrgsSection(orgs: orgs, loading: orgsLoading, l10n: l10n),
          ],
          const SizedBox(height: UIConstants.md),
          PremiumCard(
            onTap: () async {
              final result = await Navigator.of(context).push<bool>(
                MaterialPageRoute(builder: (_) => const CreateRepoPage()),
              );
              if (result == true && context.mounted) {
                await Injection.userNotifier.listCurrentUserRepos();
              }
            },
            child: Row(
              children: [
                Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: UIConstants.md),
                Expanded(child: Text(l10n.createRepository)),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
          PremiumCard(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const StarredReposPage(),
              ));
            },
            child: Row(
              children: [
                Icon(Icons.star_outline, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: UIConstants.md),
                Expanded(child: Text(l10n.starredRepos)),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
          PremiumCard(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => PackageListPage(owner: user.login ?? ''),
              ));
            },
            child: Row(
              children: [
                Icon(Icons.inventory_2_outlined, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: UIConstants.md),
                Expanded(child: Text(l10n.packages)),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
          PremiumCard(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EmailsPage()));
            },
            child: Row(
              children: [
                Icon(Icons.email_outlined, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: UIConstants.md),
                Expanded(child: Text(l10n.emails)),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
          PremiumCard(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const GpgKeysPage()));
            },
            child: Row(
              children: [
                Icon(Icons.vpn_key_outlined, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: UIConstants.md),
                Expanded(child: Text(l10n.gpgKeys)),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
          PremiumCard(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const SettingsPage(),
              ));
            },
            child: Row(
              children: [
                Icon(Icons.settings_outlined, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: UIConstants.md),
                Expanded(child: Text(l10n.settings)),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
          const SizedBox(height: UIConstants.lg),
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
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
            theme.colorScheme.surface,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(UIConstants.lg, UIConstants.lg, UIConstants.lg, UIConstants.md),
        child: Column(
          children: [
            UserAvatar(user: user, radius: UIConstants.avatarXxl),
            const SizedBox(height: UIConstants.sm),
            Text(
              user.full_name ?? user.login ?? l10n.unknownUser,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            ),
            if (user.login != null) ...[
              const SizedBox(height: UIConstants.xs),
              Text(
                '@${user.login}',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            if (user.description != null && user.description!.isNotEmpty) ...[
              const SizedBox(height: UIConstants.sm),
              Text(
                user.description!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (user.is_admin == true) ...[
              const SizedBox(height: UIConstants.sm),
              Chip(
                label: Text(l10n.admin),
                avatar: Icon(Icons.shield, size: UIConstants.iconSm, color: theme.colorScheme.onError),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final User user;
  final AppLocalizations l10n;

  const _StatsRow({required this.user, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: UIConstants.pagePadding,
      child: Row(
        children: [
          Expanded(child: _StatItem(label: l10n.repos, value: '${user.starred_repos_count ?? 0}', onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => UserReposPage(username: user.login ?? '')));
          })),
          const SizedBox(width: UIConstants.sm),
          Expanded(child: _StatItem(label: l10n.followers, value: '${user.followers_count ?? 0}', onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => FollowPage(username: user.login ?? '', type: FollowType.followers)));
          })),
          const SizedBox(width: UIConstants.sm),
          Expanded(child: _StatItem(label: l10n.following, value: '${user.following_count ?? 0}', onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => FollowPage(username: user.login ?? '', type: FollowType.following)));
          })),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onTap;

  const _StatItem({required this.label, required this.value, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PremiumCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(vertical: UIConstants.md),
      child: Column(
        children: [
          Text(value, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: UIConstants.xs),
          Text(label, style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          )),
        ],
      ),
    );
  }
}

class _InfoCards extends StatelessWidget {
  final User user;
  final AppLocalizations l10n;

  const _InfoCards({required this.user, required this.l10n});

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
        label: l10n.joinedOnParams(_formatDate(user.created!)),
      ));
    }

    if (items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: UIConstants.pagePadding,
      child: PremiumCard(
        padding: EdgeInsets.zero,
        child: Column(children: items),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
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
      leading: Icon(icon, size: UIConstants.iconMd, color: theme.colorScheme.primary),
      title: Text(label, style: theme.textTheme.bodyMedium),
      dense: true,
      trailing: onTap != null ? const Icon(Icons.open_in_new, size: UIConstants.iconSm) : null,
      onTap: onTap,
    );
  }
}

class _OrgsSection extends StatelessWidget {
  final List<Organization> orgs;
  final bool loading;
  final AppLocalizations l10n;

  const _OrgsSection({required this.orgs, required this.loading, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: UIConstants.pagePadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrganizationsListPage(orgs: orgs),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      l10n.organisations,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: UIConstants.xs),
                    Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CreateOrgPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: UIConstants.sm),
        SizedBox(
          height: 56,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: UIConstants.pagePadding,
            itemCount: orgs.length,
            separatorBuilder: (_, _) => const SizedBox(width: UIConstants.md),
            itemBuilder: (context, index) {
              final org = orgs[index];
              return FadeInWrapper(
                delay: Duration(milliseconds: index * 30),
                child: Tooltip(
                  message: [org.full_name, org.name, org.username]
                    .whereType<String>()
                    .where((s) => s.isNotEmpty)
                    .firstOrNull ?? '',
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OrganizationDetailPage(
                            orgName: [org.username, org.name]
                              .whereType<String>()
                              .where((s) => s.isNotEmpty)
                              .firstOrNull ?? '',
                          ),
                        ),
                      );
                    },
                    child: OrgAvatar(org: org, radius: UIConstants.avatarXl),
                  ),
                ),
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
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: UIConstants.pagePadding,
      child: FilledButton.icon(
        onPressed: () => _handleSignOut(context),
        icon: const Icon(Icons.logout),
        label: Text(l10n.signOut),
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
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.signOut),
        content: Text(l10n.signOutConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel),
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
            child: Text(l10n.signOut),
          ),
        ],
      ),
    );
  }
}
