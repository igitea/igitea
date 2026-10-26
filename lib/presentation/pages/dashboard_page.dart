import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/animations/animated_wrapper.dart';
import '../../core/di/injection.dart';
import '../../core/platform/desktop_layout.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../domain/entities/auth_state.dart';
import '../../domain/usecases/user_usecases.dart';
import '../../l10n/app_localizations.dart';
import '../models/issue_filter_state.dart';
import '../theme/app_palette.dart';
import '../widgets/activity_tile.dart';
import '../widgets/desktop/app_hover_region.dart';
import '../widgets/app_skeleton.dart';
import '../widgets/app_surface.dart';
import '../widgets/forui/app_chrome.dart';
import '../widgets/forui/app_section.dart';
import '../widgets/forui/app_state_views.dart';
import '../widgets/forui/app_tile.dart';
import '../widgets/language_dot.dart';
import '../widgets/user_avatar.dart';
import 'activity_page.dart';
import 'create_repo_page.dart';
import 'issue_list_page.dart';
import 'organizations_list_page.dart';
import 'repo_detail_page.dart';
import 'repo_list_page.dart';
import 'starred_repos_page.dart';

/// The home dashboard.
///
/// A calm overview: a greeting card, five work destinations, the repositories
/// you actually use, and a live activity rail. The layout folds from two
/// columns to one as the window narrows.
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Kept in local state so this page never clobbers the shared UserNotifier
  // lists used elsewhere (profile page repos, ActivityPage pagination).
  List<Repository> _favRepos = [];
  bool _favLoading = true;
  String? _favError;

  List<Activity> _recentActivities = [];
  bool _recentLoading = true;
  String? _recentError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAll();
    });
  }

  String? get _username {
    final authState = Injection.authNotifier.state;
    if (authState is AuthAuthenticated) return authState.user.login;
    return null;
  }

  Future<void> _loadAll() async {
    await Future.wait([
      Injection.userNotifier.loadCurrentUser(),
      _loadFavorites(),
      _loadRecent(),
    ]);
  }

  Future<void> _loadFavorites() async {
    if (_favRepos.isEmpty) {
      setState(() {
        _favLoading = true;
        _favError = null;
      });
    }
    final result = await Injection.listCurrentUserReposUseCase(
      const ListCurrentUserReposParams(limit: 3),
    );
    if (!mounted) return;
    switch (result) {
      case Left<Failure, List<Repository>>(:final value):
        setState(() {
          _favError = value.message;
          _favLoading = false;
        });
      case Right<Failure, List<Repository>>(:final value):
        setState(() {
          _favRepos = value;
          _favError = null;
          _favLoading = false;
        });
    }
  }

  Future<void> _loadRecent() async {
    final username = _username;
    if (username == null) {
      setState(() => _recentLoading = false);
      return;
    }
    if (_recentActivities.isEmpty) {
      setState(() {
        _recentLoading = true;
        _recentError = null;
      });
    }
    final result = await Injection.getUserActivitiesUseCase(
      GetUserActivitiesParams(username: username, page: 1, limit: 5),
    );
    if (!mounted) return;
    switch (result) {
      case Left<Failure, List<Activity>>(:final value):
        setState(() {
          _recentError = value.message;
          _recentLoading = false;
        });
      case Right<Failure, List<Activity>>(:final value):
        setState(() {
          _recentActivities = value;
          _recentError = null;
          _recentLoading = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return RefreshIndicator(
      color: context.palette.brand,
      backgroundColor: context.palette.surface,
      onRefresh: _loadAll,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 920;
          final inset = constraints.maxWidth >= 1000 ? 32.0 : 20.0;

          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(inset, 20, inset, 48),
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FadeInWrapper(
                        duration: const Duration(milliseconds: 320),
                        child: _Hero(
                          dateText: _today(context),
                          title: l10n.myWork,
                          subtitle: l10n.myWorkSubtitle,
                          refreshLabel: l10n.refresh,
                          onRefresh: _loadAll,
                          onAction: () =>
                              _push(context, const CreateRepoPage()),
                          actionLabel: l10n.createRepository,
                        ),
                      ),
                      const SizedBox(height: 18),
                      FadeInWrapper(
                        delay: const Duration(milliseconds: 40),
                        duration: const Duration(milliseconds: 320),
                        child: _buildWorkGrid(context, l10n),
                      ),
                      const SizedBox(height: 26),
                      if (wide)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 7,
                              child: Column(
                                children: [
                                  _buildFavorites(context, l10n),
                                  const SizedBox(height: 24),
                                  _buildShortcuts(context, l10n),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              flex: 5,
                              child: _buildRecent(context, l10n),
                            ),
                          ],
                        )
                      else ...[
                        _buildFavorites(context, l10n),
                        const SizedBox(height: 24),
                        _buildShortcuts(context, l10n),
                        const SizedBox(height: 24),
                        _buildRecent(context, l10n),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _today(BuildContext context) {
    final localization = MaterialLocalizations.of(context);
    return localization.formatMediumDate(DateTime.now()).toUpperCase();
  }

  // ── Work destinations ──────────────────────────────────────────────────

  Widget _buildWorkGrid(BuildContext context, AppLocalizations l10n) {
    final palette = context.palette;
    final tiles = <_WorkTileData>[
      _WorkTileData(
        icon: FIcons.circleDot,
        color: palette.success,
        soft: palette.successSoft,
        label: l10n.issues,
        onPress: () =>
            _openIssues(context, const IssueFilterState(type: 'issues')),
      ),
      _WorkTileData(
        icon: FIcons.gitPullRequest,
        color: palette.purple,
        soft: palette.purpleSoft,
        label: l10n.pullRequests,
        onPress: () =>
            _openIssues(context, const IssueFilterState(type: 'pulls')),
      ),
      _WorkTileData(
        icon: FIcons.trendingUp,
        color: palette.info,
        soft: palette.infoSoft,
        label: l10n.topRepositories,
        onPress: () => _push(context, const RepoListPage()),
      ),
      _WorkTileData(
        icon: FIcons.building2,
        color: palette.warning,
        soft: palette.warningSoft,
        label: l10n.organisations,
        onPress: () => _openOrganizations(context),
      ),
      _WorkTileData(
        icon: FIcons.star,
        color: palette.brand,
        soft: palette.brandSoft,
        label: l10n.starredRepos,
        onPress: () => _push(context, const StarredReposPage()),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        // Five destinations never split evenly into two or three columns, so
        // narrow windows get a grouped list instead of a ragged grid.
        if (constraints.maxWidth < 600) {
          return AppSection(
            title: '',
            showHeader: false,
            children: [
              for (final tile in tiles)
                AppTile(
                  leading: _SoftIcon(
                    icon: tile.icon,
                    color: tile.color,
                    soft: tile.soft,
                  ),
                  title: tile.label,
                  onPress: tile.onPress,
                ),
            ],
          );
        }
        const columns = 5;
        const spacing = 12.0;
        final width =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final tile in tiles)
              SizedBox(
                width: width,
                child: _WorkTile(data: tile),
              ),
          ],
        );
      },
    );
  }

  // ── Favorites ──────────────────────────────────────────────────────────

  Widget _buildFavorites(BuildContext context, AppLocalizations l10n) {
    if (_favLoading && _favRepos.isEmpty) {
      return _SectionSkeleton(title: l10n.favorites, rows: 3);
    }
    if (_favError != null && _favRepos.isEmpty) {
      return AppSection(
        title: l10n.favorites,
        children: [_InlineError(message: _favError!, onRetry: _loadFavorites)],
      );
    }
    if (_favRepos.isEmpty) {
      return AppSection(
        title: l10n.favorites,
        children: [
          _InlineEmpty(icon: FIcons.folderOpen, text: l10n.noRepositoriesFound),
        ],
      );
    }

    return AppSection(
      title: l10n.favorites,
      children: _favRepos.take(3).map((repo) {
        final owner =
            repo.owner?.login ?? repo.full_name?.split('/').firstOrNull ?? '';
        final name = repo.name ?? repo.full_name?.split('/').lastOrNull ?? '';
        return _RepoRow(
          repo: repo,
          owner: owner,
          name: name,
          onPress: () {
            if (owner.isNotEmpty && name.isNotEmpty) {
              _push(context, RepoDetailPage(owner: owner, repo: name));
            }
          },
        );
      }).toList(),
    );
  }

  // ── Shortcuts ──────────────────────────────────────────────────────────

  Widget _buildShortcuts(BuildContext context, AppLocalizations l10n) {
    final palette = context.palette;
    return AppSection(
      title: l10n.shortcuts,
      children: [
        AppTile(
          leading: _SoftIcon(
            icon: FIcons.atSign,
            color: palette.success,
            soft: palette.successSoft,
          ),
          title: l10n.issues,
          subtitle: l10n.mentioned,
          onPress: () => _openIssues(
            context,
            const IssueFilterState(type: 'issues', mentionedMe: true),
          ),
        ),
        AppTile(
          leading: _SoftIcon(
            icon: FIcons.messageSquare,
            color: palette.info,
            soft: palette.infoSoft,
          ),
          title: l10n.pullRequests,
          subtitle: l10n.reviewRequested,
          onPress: () => _openIssues(
            context,
            const IssueFilterState(type: 'pulls', reviewRequested: true),
          ),
        ),
      ],
    );
  }

  // ── Recent activity ────────────────────────────────────────────────────

  Widget _buildRecent(BuildContext context, AppLocalizations l10n) {
    final username = _username;
    final viewAll = username == null
        ? null
        : AppSectionAction(
            label: l10n.viewAll,
            onPress: () => _push(context, ActivityPage(username: username)),
          );

    if (_recentLoading && _recentActivities.isEmpty) {
      return _SectionSkeleton(
        title: l10n.recentActivity,
        rows: 4,
        trailing: viewAll,
      );
    }
    if (_recentError != null && _recentActivities.isEmpty) {
      return AppSection(
        title: l10n.recentActivity,
        trailing: viewAll,
        children: [_InlineError(message: _recentError!, onRetry: _loadRecent)],
      );
    }
    if (_recentActivities.isEmpty) {
      return AppSection(
        title: l10n.recentActivity,
        trailing: viewAll,
        children: [_InlineEmpty(icon: FIcons.activity, text: l10n.noActivity)],
      );
    }

    return AppSection(
      title: l10n.recentActivity,
      trailing: viewAll,
      children: _recentActivities.take(5).map((activity) {
        return ActivityTile(
          activity: activity,
          timeText: _formatDate(activity.created, l10n),
          onTap: () => _openActivityRepo(context, activity),
        );
      }).toList(),
    );
  }

  void _openActivityRepo(BuildContext context, Activity activity) {
    final repo = activity.repo;
    final owner =
        repo?.owner?.login ?? repo?.full_name?.split('/').firstOrNull ?? '';
    final name = repo?.name ?? repo?.full_name?.split('/').lastOrNull ?? '';
    if (owner.isNotEmpty && name.isNotEmpty) {
      _push(context, RepoDetailPage(owner: owner, repo: name));
    }
  }

  String _formatDate(DateTime? date, AppLocalizations l10n) {
    if (date == null) return '';
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 365) return l10n.ago('${diff.inDays ~/ 365}y');
    if (diff.inDays > 30) return l10n.ago('${diff.inDays ~/ 30}mo');
    if (diff.inDays > 0) return l10n.ago('${diff.inDays}d');
    if (diff.inHours > 0) return l10n.ago('${diff.inHours}h');
    if (diff.inMinutes > 0) return l10n.ago('${diff.inMinutes}m');
    return l10n.justNow;
  }

  // ── Navigation ─────────────────────────────────────────────────────────

  void _openIssues(BuildContext context, IssueFilterState filter) {
    _push(context, IssueListPage(initialFilter: filter));
  }

  Future<void> _openOrganizations(BuildContext context) async {
    final result = await Injection.listCurrentUserOrgsUseCase();
    if (result is Right<Failure, List<Organization>>) {
      if (context.mounted) {
        _push(context, OrganizationsListPage(orgs: result.value));
      }
    }
  }

  void _push(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }
}

// ── Building blocks ──────────────────────────────────────────────────────

class _Hero extends StatelessWidget {
  const _Hero({
    required this.dateText,
    required this.title,
    required this.subtitle,
    required this.refreshLabel,
    required this.onRefresh,
    required this.onAction,
    required this.actionLabel,
  });

  final String dateText;
  final String title;
  final String subtitle;
  final String refreshLabel;
  final VoidCallback onRefresh;
  final VoidCallback onAction;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 560;

        final heading = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: palette.brand,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 7),
                Text(
                  dateText,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                    color: palette.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.6,
                color: palette.textPrimary,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                height: 1.4,
                color: palette.textSecondary,
              ),
            ),
          ],
        );

        // Touch screens refresh with pull-to-refresh, so the button is only
        // offered where there is no such gesture.
        final actions = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!DesktopLayout.isTouch()) ...[
              AppIconButton(
                icon: FIcons.refreshCw,
                label: refreshLabel,
                onPress: onRefresh,
              ),
              const SizedBox(width: 8),
            ],
            FButton(
              variant: FButtonVariant.primary,
              size: FButtonSizeVariant.sm,
              prefix: const Icon(FIcons.plus, size: 14),
              onPress: onAction,
              child: Text(actionLabel),
            ),
          ],
        );
        final compactAction = Semantics(
          button: true,
          label: actionLabel,
          child: FButton.icon(
            variant: FButtonVariant.primary,
            onPress: onAction,
            child: const Icon(FIcons.plus),
          ),
        );

        return ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Container(
            decoration: BoxDecoration(
              color: palette.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: palette.brand.withValues(
                  alpha: palette.isDark ? 0.24 : 0.16,
                ),
              ),
              boxShadow: palette.cardShadow,
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -60,
                  top: -90,
                  child: IgnorePointer(
                    child: Container(
                      width: 260,
                      height: 260,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            palette.brand.withValues(
                              alpha: palette.isDark ? 0.20 : 0.13,
                            ),
                            palette.brand.withValues(alpha: 0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(compact ? 20 : 24, 20, 20, 20),
                  child: compact
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: heading),
                            const SizedBox(width: 12),
                            compactAction,
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(child: heading),
                            const SizedBox(width: 16),
                            actions,
                          ],
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _WorkTileData {
  const _WorkTileData({
    required this.icon,
    required this.color,
    required this.soft,
    required this.label,
    required this.onPress,
  });

  final IconData icon;
  final Color color;
  final Color soft;
  final String label;
  final VoidCallback onPress;
}

class _WorkTile extends StatelessWidget {
  const _WorkTile({required this.data});

  final _WorkTileData data;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final theme = Theme.of(context);

    return AppSurface(
      onPress: data.onPress,
      padding: const EdgeInsets.fromLTRB(13, 12, 12, 12),
      child: SizedBox(
        height: 58,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _SoftIcon(icon: data.icon, color: data.color, soft: data.soft),
                const Spacer(),
                Icon(
                  FIcons.chevronRight,
                  size: 14,
                  color: palette.textSecondary.withValues(alpha: 0.7),
                ),
              ],
            ),
            const Spacer(),
            Text(
              data.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: palette.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SoftIcon extends StatelessWidget {
  const _SoftIcon({
    required this.icon,
    required this.color,
    required this.soft,
  });

  final IconData icon;
  final Color color;
  final Color soft;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: soft,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 15, color: color),
    );
  }
}

class _RepoRow extends StatefulWidget {
  const _RepoRow({
    required this.repo,
    required this.owner,
    required this.name,
    required this.onPress,
  });

  final Repository repo;
  final String owner;
  final String name;
  final VoidCallback onPress;

  @override
  State<_RepoRow> createState() => _RepoRowState();
}

class _RepoRowState extends State<_RepoRow> {
  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final description = widget.repo.description?.trim() ?? '';

    return AppHoverRegion(
      onTap: widget.onPress,
      semanticsLabel: '${widget.owner}/${widget.name}',
      hoverColor: palette.surfaceMuted.withValues(alpha: 0.55),
      borderRadius: BorderRadius.zero,
      contextMenuItems: [
        AppMenuItem(
          label: l10n.open,
          icon: FIcons.folderGit,
          onSelected: widget.onPress,
        ),
        AppMenuItem(
          label: l10n.copyName,
          icon: FIcons.copy,
          onSelected: () async {
            await Clipboard.setData(
              ClipboardData(text: '${widget.owner}/${widget.name}'),
            );
            if (context.mounted) {
              showFToast(context: context, title: Text(l10n.copied));
            }
          },
        ),
        if (widget.repo.html_url != null)
          AppMenuItem(
            label: l10n.openInBrowser,
            icon: FIcons.externalLink,
            onSelected: () => launchUrl(
              Uri.parse(widget.repo.html_url!),
              mode: LaunchMode.externalApplication,
            ),
          ),
      ],
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 12, 10),
        child: Row(
          children: [
            if (widget.repo.owner != null)
              UserAvatar(user: widget.repo.owner!, radius: 14)
            else
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: palette.surfaceMuted,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  widget.repo.private == true ? FIcons.lock : FIcons.folderGit,
                  size: 14,
                  color: palette.textSecondary,
                ),
              ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        if (widget.owner.isNotEmpty)
                          TextSpan(
                            text: '${widget.owner}/',
                            style: TextStyle(
                              fontSize: 12,
                              color: palette.textSecondary,
                            ),
                          ),
                        TextSpan(
                          text: widget.name,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: palette.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (description.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: palette.textSecondary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            if (widget.repo.language != null)
              LanguageDot(language: widget.repo.language),
            if (widget.repo.language != null) const SizedBox(width: 14),
            Icon(FIcons.star, size: 12, color: palette.textSecondary),
            const SizedBox(width: 3),
            Text(
              _compact(widget.repo.stars_count ?? 0),
              style: TextStyle(fontSize: 11, color: palette.textSecondary),
            ),
            const SizedBox(width: 6),
            Icon(
              FIcons.chevronRight,
              size: 14,
              color: palette.textSecondary.withValues(alpha: 0.7),
            ),
          ],
        ),
      ),
    );
  }
}

class _InlineError extends StatelessWidget {
  const _InlineError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
      child: Row(
        children: [
          Icon(FIcons.circleAlert, size: 15, color: palette.danger),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              friendlyErrorMessage(context, message),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11.5, color: palette.textSecondary),
            ),
          ),
          FButton(
            variant: FButtonVariant.ghost,
            size: FButtonSizeVariant.sm,
            onPress: onRetry,
            child: Text(l10n.retry),
          ),
        ],
      ),
    );
  }
}

class _InlineEmpty extends StatelessWidget {
  const _InlineEmpty({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      child: Row(
        children: [
          Icon(icon, size: 15, color: palette.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 12, color: palette.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionSkeleton extends StatelessWidget {
  const _SectionSkeleton({
    required this.title,
    required this.rows,
    this.trailing,
  });

  final String title;
  final int rows;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return AppSection(
      title: title,
      trailing: trailing,
      children: [
        AppSkeleton(
          child: Column(
            children: List.generate(rows, (index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: palette.surfaceMuted,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SkeletonLine(widthFactor: 0.45, height: 9),
                          SizedBox(height: 6),
                          SkeletonLine(widthFactor: 0.7, height: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

String _compact(int value) {
  if (value >= 1000000) {
    return '${(value / 1000000).toStringAsFixed(1)}m';
  }
  if (value >= 1000) {
    final digits = value >= 10000 ? 0 : 1;
    return '${(value / 1000).toStringAsFixed(digits)}k';
  }
  return '$value';
}
