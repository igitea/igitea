import 'package:flutter/material.dart';
import '../../core/animations/animated_wrapper.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../domain/entities/auth_state.dart';
import '../../domain/usecases/user_usecases.dart';
import '../../l10n/app_localizations.dart';
import '../models/issue_filter_state.dart';
import '../widgets/activity_tile.dart';
import '../widgets/home/home_icon_tile.dart';
import '../widgets/home/home_repo_tile.dart';
import '../widgets/home/home_section_card.dart';
import 'activity_page.dart';
import 'issue_list_page.dart';
import 'organizations_list_page.dart';
import 'repo_detail_page.dart';
import 'repo_list_page.dart';
import 'starred_repos_page.dart';

/// 首页（GitHub Mobile 风格）：
/// Section A 我的工作 → Section B 收藏 → Section C 快捷方式 → Section D 最近。
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Favorites and recent activities are kept in local state so this page
  // never clobbers the shared UserNotifier lists used elsewhere
  // (profile page repos, ActivityPage pagination).
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
    setState(() {
      _favLoading = true;
      _favError = null;
    });
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
    setState(() {
      _recentLoading = true;
      _recentError = null;
    });
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
      onRefresh: _loadAll,
      child: ListView(
        padding: const EdgeInsets.all(UIConstants.md),
        children: [
          FadeInWrapper(child: _buildMyWork(context, l10n)),
          const SizedBox(height: UIConstants.lg),
          FadeInWrapper(
            delay: const Duration(milliseconds: 50),
            child: _buildFavorites(context, l10n),
          ),
          const SizedBox(height: UIConstants.lg),
          FadeInWrapper(
            delay: const Duration(milliseconds: 100),
            child: _buildShortcuts(context, l10n),
          ),
          const SizedBox(height: UIConstants.lg),
          FadeInWrapper(
            delay: const Duration(milliseconds: 150),
            child: _buildRecent(context, l10n),
          ),
        ],
      ),
    );
  }

  // ── Section A: 我的工作 ────────────────────────────────────────────────

  Widget _buildMyWork(BuildContext context, AppLocalizations l10n) {
    return HomeSectionCard(
      title: '',
      showHeader: false,
      children: [
        HomeIconTile(
          iconBg: const Color(0xFF2EA043),
          icon: Icons.bug_report_outlined,
          title: l10n.issues,
          onTap: () => _openIssues(context,
              const IssueFilterState(type: 'issues')),
        ),
        HomeIconTile(
          iconBg: const Color(0xFF0969DA),
          icon: Icons.merge_type,
          title: l10n.pullRequests,
          onTap: () => _openIssues(context,
              const IssueFilterState(type: 'pulls')),
        ),
        HomeIconTile(
          iconBg: const Color(0xFF57606A),
          icon: Icons.trending_up,
          title: l10n.topRepositories,
          onTap: () => _push(context, const RepoListPage()),
        ),
        HomeIconTile(
          iconBg: const Color(0xFFBC4C00),
          icon: Icons.business_outlined,
          title: l10n.organisations,
          onTap: () => _openOrganizations(context),
        ),
        HomeIconTile(
          iconBg: const Color(0xFFBF8700),
          icon: Icons.star_outline,
          title: l10n.starredRepos,
          onTap: () => _push(context, const StarredReposPage()),
        ),
      ],
    );
  }

  // ── Section B: 收藏（我的仓库 top3）──────────────────────────────────

  Widget _buildFavorites(BuildContext context, AppLocalizations l10n) {
    if (_favLoading) {
      return HomeSectionCard(
        title: l10n.favorites,
        children: const [
          _HomePlaceholder(text: null, showProgress: true),
        ],
      );
    }
    if (_favError != null) {
      return HomeSectionCard(
        title: l10n.favorites,
        children: [
          _HomePlaceholder(
            text: '${l10n.error}: $_favError',
            onRetry: _loadFavorites,
          ),
        ],
      );
    }
    if (_favRepos.isEmpty) {
      return HomeSectionCard(
        title: l10n.favorites,
        children: [
          _HomePlaceholder(text: l10n.noRepositoriesFound),
        ],
      );
    }
    return HomeSectionCard(
      title: l10n.favorites,
      children: _favRepos.take(3).map((repo) {
        return HomeRepoTile(
          repo: repo,
          onTap: () {
            final owner = repo.owner?.login ?? repo.full_name?.split('/').firstOrNull ?? '';
            final name = repo.name ?? repo.full_name?.split('/').lastOrNull ?? '';
            if (owner.isNotEmpty && name.isNotEmpty) {
              _push(context, RepoDetailPage(owner: owner, repo: name));
            }
          },
        );
      }).toList(),
    );
  }

  // ── Section C: 快捷方式 ────────────────────────────────────────────────

  Widget _buildShortcuts(BuildContext context, AppLocalizations l10n) {
    return HomeSectionCard(
      title: l10n.shortcuts,
      children: [
        HomeIconTile(
          iconBg: const Color(0xFF2EA043),
          icon: Icons.alternate_email,
          title: l10n.issues,
          subtitle: l10n.mentioned,
          onTap: () => _openIssues(
            context,
            const IssueFilterState(type: 'issues', mentionedMe: true),
          ),
        ),
        HomeIconTile(
          iconBg: const Color(0xFF0969DA),
          icon: Icons.rate_review_outlined,
          title: l10n.pullRequests,
          subtitle: l10n.reviewRequested,
          onTap: () => _openIssues(
            context,
            const IssueFilterState(type: 'pulls', reviewRequested: true),
          ),
        ),
      ],
    );
  }

  // ── Section D: 近期活动（activities top5 + 查看全部）──────────────────

  Widget _buildRecent(BuildContext context, AppLocalizations l10n) {
    final username = _username;
    final viewAllButton = username == null
        ? null
        : TextButton(
            onPressed: () => _push(
              context,
              ActivityPage(username: username),
            ),
            child: Text(l10n.viewAll),
          );

    if (_recentLoading) {
      return HomeSectionCard(
        title: l10n.recent,
        children: const [
          _HomePlaceholder(text: null, showProgress: true),
        ],
      );
    }
    if (_recentError != null) {
      return HomeSectionCard(
        title: l10n.recent,
        trailing: viewAllButton,
        children: [
          _HomePlaceholder(
            text: '${l10n.error}: $_recentError',
            onRetry: _loadRecent,
          ),
        ],
      );
    }
    if (_recentActivities.isEmpty) {
      return HomeSectionCard(
        title: l10n.recent,
        trailing: viewAllButton,
        children: [
          _HomePlaceholder(text: l10n.noActivity),
        ],
      );
    }
    return HomeSectionCard(
      title: l10n.recent,
      trailing: viewAllButton,
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

  // ── 导航 ────────────────────────────────────────────────────────────────

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

/// 区块内的占位行：空态提示 / 加载指示 / 错误重试。
class _HomePlaceholder extends StatelessWidget {
  final String? text;
  final bool showProgress;
  final VoidCallback? onRetry;

  const _HomePlaceholder({this.text, this.showProgress = false, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (showProgress) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            text ?? '',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: UIConstants.sm),
            TextButton(onPressed: onRetry, child: Text(AppLocalizations.of(context)!.retry)),
          ],
        ],
      ),
    );
  }
}
