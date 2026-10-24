import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/animations/animated_wrapper.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../domain/usecases/user_usecases.dart';
import '../../l10n/app_localizations.dart';
import '../theme/app_palette.dart';
import '../widgets/app_skeleton.dart';
import '../widgets/app_surface.dart';
import '../widgets/org_avatar.dart';
import '../widgets/forui/app_page.dart';
import '../widgets/forui/app_section.dart';
import '../widgets/forui/app_state_views.dart';
import '../widgets/forui/app_tile.dart';
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

    final followResult = await Injection.checkUserFollowUseCase(
      widget.username,
    );
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

    return AppPage(
      title: widget.username,
      child: _loading
          ? _buildSkeleton()
          : _user == null
          ? _buildError(l10n)
          : LayoutBuilder(
              builder: (context, constraints) {
                final inset = constraints.maxWidth > 940
                    ? (constraints.maxWidth - 900) / 2
                    : 20.0;
                return RefreshIndicator(
                  color: context.palette.brand,
                  backgroundColor: context.palette.surface,
                  onRefresh: _load,
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(inset, 20, inset, 32),
                    children: [
                      FadeInWrapper(
                        child: _UserHeader(
                          user: _user!,
                          isFollowing: _isFollowing,
                          followLoading: _followLoading,
                          onToggleFollow: _toggleFollow,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _StatsRow(
                        user: _user!,
                        reposCount: _repos.length,
                        username: widget.username,
                      ),
                      const SizedBox(height: 16),
                      _InfoCards(user: _user!, l10n: l10n),
                      if (_orgs.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        _OrgsSection(orgs: _orgs, l10n: l10n),
                      ],
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(3, 0, 3, 8),
                        child: Text(
                          l10n.repositories,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.4,
                            color: context.palette.textSecondary,
                          ),
                        ),
                      ),
                      ..._repos
                          .take(5)
                          .map((r) => FadeInWrapper(child: _RepoItem(repo: r))),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildSkeleton() {
    final palette = context.palette;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      children: [
        AppSkeleton(
          child: Column(
            children: [
              AppSurface(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const SkeletonBox(width: 56, height: 56, radius: 28),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          SkeletonLine(widthFactor: 0.35, height: 14),
                          SizedBox(height: 8),
                          SkeletonLine(widthFactor: 0.22, height: 9),
                          SizedBox(height: 6),
                          SkeletonLine(widthFactor: 0.52, height: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppSurface(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                child: Row(
                  children: [
                    for (var i = 0; i < 3; i++) ...[
                      if (i > 0)
                        Container(width: 1, height: 28, color: palette.border),
                      Expanded(
                        child: Column(
                          children: const [
                            SkeletonLine(widthFactor: 0.35, height: 14),
                            SizedBox(height: 6),
                            SkeletonLine(widthFactor: 0.55, height: 8),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppSurface(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  children: List.generate(4, (index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(14, 11, 14, 11),
                      child: Row(
                        children: [
                          Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              color: palette.surfaceMuted,
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: SkeletonLine(widthFactor: 0.55, height: 9),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildError(AppLocalizations l10n) {
    return AppError(message: l10n.error, onRetry: _load);
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
    final palette = context.palette;
    final description = user.description?.trim() ?? '';

    final followButton = followLoading
        ? const SizedBox(
            width: 64,
            height: 32,
            child: Padding(
              padding: EdgeInsets.all(7),
              child: FCircularProgress(size: FCircularProgressSizeVariant.xs),
            ),
          )
        : isFollowing
        ? FButton(
            variant: FButtonVariant.outline,
            size: FButtonSizeVariant.sm,
            onPress: onToggleFollow,
            child: Text(l10n.unfollow),
          )
        : FButton(
            size: FButtonSizeVariant.sm,
            onPress: onToggleFollow,
            child: Text(l10n.follow),
          );

    return AppSurface(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAvatar(user: user, radius: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    Text(
                      user.full_name?.isNotEmpty == true
                          ? user.full_name!
                          : user.login ?? l10n.unknownUser,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.4,
                        height: 1.2,
                        color: palette.textPrimary,
                      ),
                    ),
                    if (user.is_admin == true)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2.5,
                        ),
                        decoration: BoxDecoration(
                          color: palette.brandSoft,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              FIcons.shieldCheck,
                              size: 10,
                              color: palette.brand,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              l10n.admin,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: palette.brand,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                if (user.login != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '@${user.login}',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: palette.textSecondary,
                    ),
                  ),
                ],
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.5,
                      color: palette.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (user.login != null) ...[const SizedBox(width: 12), followButton],
        ],
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
    final palette = context.palette;
    final stats = <_StatData>[
      _StatData(
        label: l10n.repositories,
        value: '$reposCount',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => UserReposPage(username: username)),
        ),
      ),
      _StatData(
        label: l10n.followers,
        value: '${user.followers_count ?? 0}',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) =>
                FollowPage(username: username, type: FollowType.followers),
          ),
        ),
      ),
      _StatData(
        label: l10n.following,
        value: '${user.following_count ?? 0}',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) =>
                FollowPage(username: username, type: FollowType.following),
          ),
        ),
      ),
      _StatData(label: l10n.stars, value: '${user.starred_repos_count ?? 0}'),
    ];

    return AppSurface(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          for (var i = 0; i < stats.length; i++) ...[
            if (i > 0) Container(width: 1, height: 28, color: palette.border),
            Expanded(child: _StatItem(data: stats[i])),
          ],
        ],
      ),
    );
  }
}

class _StatData {
  const _StatData({required this.label, required this.value, this.onTap});

  final String label;
  final String value;
  final VoidCallback? onTap;
}

class _StatItem extends StatelessWidget {
  final _StatData data;

  const _StatItem({required this.data});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          data.value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
            color: palette.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          data.label,
          style: TextStyle(fontSize: 11, color: palette.textSecondary),
        ),
      ],
    );
    if (data.onTap == null) return content;
    return FTappable(onPress: data.onTap, child: content);
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
          icon: FIcons.mail,
          label: user.email!,
          onTap: () => _launchUrl('mailto:${user.email!}'),
        ),
      );
    }
    if (user.location != null && user.location!.isNotEmpty) {
      items.add(_InfoTile(icon: FIcons.mapPin, label: user.location!));
    }
    if (user.website != null && user.website!.isNotEmpty) {
      items.add(
        _InfoTile(
          icon: FIcons.globe,
          label: user.website!,
          onTap: () => _launchUrl(user.website!),
        ),
      );
    }
    if (user.created != null) {
      items.add(
        _InfoTile(
          icon: FIcons.calendar,
          label: l10n.joinedOnParams(_formatDate(user.created!)),
        ),
      );
    }

    if (items.isEmpty) return const SizedBox.shrink();

    return AppSection(title: l10n.accountInfo, children: items);
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
    return AppTile(
      leading: Icon(
        icon,
        size: UIConstants.iconMd,
        color: theme.colorScheme.primary,
      ),
      title: label,
      showChevron: false,
      trailing: onTap != null
          ? const Icon(FIcons.externalLink, size: UIConstants.iconSm)
          : null,
      onPress: onTap,
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
          child: FTappable(
            onPress: () {
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
                  FIcons.chevronRight,
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
                child: FTooltip(
                  tipBuilder: (context, controller) => Text(
                    [org.full_name, org.name, org.username]
                            .whereType<String>()
                            .where((s) => s.isNotEmpty)
                            .firstOrNull ??
                        '',
                  ),
                  child: FTappable(
                    onPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OrganizationDetailPage(
                            orgName:
                                [org.username, org.name]
                                    .whereType<String>()
                                    .where((s) => s.isNotEmpty)
                                    .firstOrNull ??
                                '',
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
            repo.private == true ? FIcons.lock : FIcons.globe,
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
          const Icon(FIcons.chevronRight, size: 18),
        ],
      ),
    );
  }
}
