import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/animations/animated_wrapper.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../domain/usecases/user_usecases.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/org_avatar.dart';
import '../widgets/premium_card.dart';
import '../widgets/user_avatar.dart';
import 'follow_page.dart';
import 'organization_detail_page.dart';
import 'organizations_list_page.dart';
import 'repo_detail_page.dart';
import 'user_repos_page.dart';

class UserProfilePage extends StatefulWidget {
  final String username;

  const UserProfilePage({super.key, required this.username});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  User? _user;
  List<Organization> _orgs = [];
  List<Repository> _repos = [];
  bool _loading = true;
  bool _isFollowing = false;
  bool _followLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    setState(() => _loading = true);

    final userResult = await Injection.getUserUseCase(widget.username);
    if (userResult is Right<Failure, User>) {
      _user = userResult.value;
    }

    final orgResult = await Injection.listUserOrgsUseCase(widget.username);
    if (orgResult is Right<Failure, List<Organization>>) {
      _orgs = orgResult.value;
    }

    final repoResult = await Injection.listUserReposUseCase(
      ListUserReposParams(username: widget.username),
    );
    if (repoResult is Right<Failure, List<Repository>>) {
      _repos = repoResult.value;
    }

    final followResult = await Injection.checkUserFollowUseCase(widget.username);
    if (followResult is Right<Failure, bool>) {
      _isFollowing = followResult.value;
    }

    if (mounted) setState(() => _loading = false);
  }

  Future<void> _toggleFollow() async {
    setState(() => _followLoading = true);
    final result = _isFollowing
        ? await Injection.unfollowUserUseCase(widget.username)
        : await Injection.followUserUseCase(widget.username);
    if (result is Right<Failure, void>) {
      _isFollowing = !_isFollowing;
    }
    if (mounted) setState(() => _followLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(widget.username)),
      body: _loading
          ? _buildSkeleton()
          : _user == null
              ? _buildError(l10n)
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: UIConstants.xl),
                    children: [
                      FadeInWrapper(
                        child: _UserHeader(
                          user: _user!,
                          isFollowing: _isFollowing,
                          followLoading: _followLoading,
                          onToggleFollow: _toggleFollow,
                        ),
                      ),
                      const SizedBox(height: UIConstants.md),
                      Padding(
                        padding: UIConstants.pagePadding,
                        child: _StatsRow(
                          user: _user!,
                          reposCount: _repos.length,
                          username: widget.username,
                        ),
                      ),
                      const SizedBox(height: UIConstants.md),
                      _InfoCards(user: _user!, l10n: l10n),
                      if (_orgs.isNotEmpty) ...[
                        const SizedBox(height: UIConstants.md),
                        _OrgsSection(orgs: _orgs, l10n: l10n),
                      ],
                      const SizedBox(height: UIConstants.md),
                      Padding(
                        padding: UIConstants.pagePadding,
                        child: Text(
                          l10n.repositories,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: UIConstants.sm),
                      ..._repos.take(5).map((r) => Padding(
                            padding: UIConstants.pagePadding,
                            child: FadeInWrapper(child: _RepoItem(repo: r)),
                          )),
                    ],
                  ),
                ),
    );
  }

  Widget _buildSkeleton() {
    final theme = Theme.of(context);
    return ListView(
      children: [
        Container(
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
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                ),
                const SizedBox(height: 12),
                Container(
                  width: 140, height: 16,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 100, height: 12,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: List.generate(4, (i) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: i > 0 ? 8 : 0),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: theme.colorScheme.outlineVariant),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      children: [
                        Container(
                          width: 32, height: 16,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: 48, height: 10,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: List.generate(2, (i) => Padding(
                  padding: EdgeInsets.only(bottom: i < 1 ? 12 : 0),
                  child: Row(
                    children: [
                      Container(
                        width: 20, height: 20,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          height: 14,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            width: 100, height: 14,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(3, (i) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 20, height: 20,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 120, height: 14,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: 180, height: 10,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildError(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(l10n.error, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 16),
          FilledButton.tonalIcon(
            onPressed: _load,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: Text(l10n.retry),
          ),
        ],
      ),
    );
  }
}

class _UserHeader extends StatelessWidget {
  final User user;
  final bool isFollowing;
  final bool followLoading;
  final VoidCallback onToggleFollow;

  const _UserHeader({
    required this.user,
    required this.isFollowing,
    required this.followLoading,
    required this.onToggleFollow,
  });

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
        padding: const EdgeInsets.fromLTRB(
          UIConstants.lg,
          UIConstants.lg,
          UIConstants.lg,
          UIConstants.md,
        ),
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
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '@${user.login}',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: UIConstants.sm),
                  SizedBox(
                    height: 28,
                    child: followLoading
                        ? const SizedBox(
                            width: 28,
                            height: 28,
                            child: Padding(
                              padding: EdgeInsets.all(4),
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : isFollowing
                            ? OutlinedButton(
                                onPressed: onToggleFollow,
                                style: OutlinedButton.styleFrom(
                                  minimumSize: Size.zero,
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                                child: Text(
                                  l10n.unfollow,
                                  style: theme.textTheme.labelSmall,
                                ),
                              )
                            : FilledButton(
                                onPressed: onToggleFollow,
                                style: FilledButton.styleFrom(
                                  minimumSize: Size.zero,
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                                child: Text(
                                  l10n.follow,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                  ),
                ],
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
                avatar: Icon(
                  Icons.shield,
                  size: UIConstants.iconSm,
                  color: theme.colorScheme.onError,
                ),
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
  final int reposCount;
  final String username;

  const _StatsRow({
    required this.user,
    required this.reposCount,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: _StatItem(
            label: l10n.repositories,
            value: '$reposCount',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => UserReposPage(username: username),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: UIConstants.sm),
        Expanded(
          child: _StatItem(
            label: l10n.followers,
            value: '${user.followers_count ?? 0}',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => FollowPage(
                    username: username,
                    type: FollowType.followers,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: UIConstants.sm),
        Expanded(
          child: _StatItem(
            label: l10n.following,
            value: '${user.following_count ?? 0}',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => FollowPage(
                    username: username,
                    type: FollowType.following,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: UIConstants.sm),
        Expanded(
          child: _StatItem(
            label: l10n.stars,
            value: '${user.starred_repos_count ?? 0}',
          ),
        ),
      ],
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
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: UIConstants.xs),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
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
      items.add(
        _InfoTile(
          icon: Icons.email_outlined,
          label: user.email!,
          onTap: () => _launchUrl('mailto:${user.email!}'),
        ),
      );
    }
    if (user.location != null && user.location!.isNotEmpty) {
      items.add(
        _InfoTile(
          icon: Icons.location_on_outlined,
          label: user.location!,
        ),
      );
    }
    if (user.website != null && user.website!.isNotEmpty) {
      items.add(
        _InfoTile(
          icon: Icons.language,
          label: user.website!,
          onTap: () => _launchUrl(user.website!),
        ),
      );
    }
    if (user.created != null) {
      items.add(
        _InfoTile(
          icon: Icons.calendar_today_outlined,
          label: l10n.joinedOnParams(_formatDate(user.created!)),
        ),
      );
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
      leading: Icon(
        icon,
        size: UIConstants.iconMd,
        color: theme.colorScheme.primary,
      ),
      title: Text(label, style: theme.textTheme.bodyMedium),
      dense: true,
      trailing: onTap != null
          ? const Icon(Icons.open_in_new, size: UIConstants.iconSm)
          : null,
      onTap: onTap,
    );
  }
}

class _OrgsSection extends StatelessWidget {
  final List<Organization> orgs;
  final AppLocalizations l10n;

  const _OrgsSection({required this.orgs, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: UIConstants.pagePadding,
          child: GestureDetector(
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
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
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
                    child: OrgAvatar(
                      org: org,
                      radius: UIConstants.avatarXl,
                    ),
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

class _RepoItem extends StatelessWidget {
  final Repository repo;

  const _RepoItem({required this.repo});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PremiumCard(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => RepoDetailPage(
              owner: repo.owner?.login ?? '',
              repo: repo.name ?? '',
            ),
          ),
        );
      },
      child: Row(
        children: [
          Icon(
            repo.private == true ? Icons.lock : Icons.public,
            size: 20,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: UIConstants.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  repo.name ?? '',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (repo.description != null) ...[
                  const SizedBox(height: UIConstants.xs),
                  Text(
                    repo.description!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 18),
        ],
      ),
    );
  }
}
