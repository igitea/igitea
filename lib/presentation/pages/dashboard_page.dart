import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

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
import '../widgets/user_avatar.dart';
import '../widgets/forui/app_section.dart';
import '../widgets/forui/app_state_views.dart';
import '../widgets/forui/app_tile.dart';
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
    return AppSection(
      title: '',
      showHeader: false,
      children: [
        AppTile(
          leading: const _IconBox(color: Color(0xFF2EA043), icon: Icons.bug_report_outlined),
          title: l10n.issues,
          onPress: () =>
              _openIssues(context, const IssueFilterState(type: 'issues')),
        ),
        AppTile(
          leading: const _IconBox(color: Color(0xFF0969DA), icon: Icons.merge_type),
          title: l10n.pullRequests,
          onPress: () =>
              _openIssues(context, const IssueFilterState(type: 'pulls')),
        ),
        AppTile(
          leading: const _IconBox(color: Color(0xFF57606A), icon: Icons.trending_up),
          title: l10n.topRepositories,
          onPress: () => _push(context, const RepoListPage()),
        ),
        AppTile(
          leading: const _IconBox(color: Color(0xFFBC4C00), icon: Icons.business_outlined),
          title: l10n.organisations,
          onPress: () => _openOrganizations(context),
        ),
        AppTile(
          leading: const _IconBox(color: Color(0xFFBF8700), icon: Icons.star_outline),
          title: l10n.starredRepos,
          onPress: () => _push(context, const StarredReposPage()),
        ),
      ],
    );
  }

  // ── Section B: 收藏（我的仓库 top3）──────────────────────────────────

  Widget _buildFavorites(BuildContext context, AppLocalizations l10n) {
    if (_favLoading) {
      return AppSection(
        title: l10n.favorites,
        children: const [
          AppSectionPlaceholder(showProgress: true),
        ],
      );
    }
    if (_favError != null) {
      return AppSection(
        title: l10n.favorites,
        children: [
          AppSectionPlaceholder(
            text: '${l10n.error}: $_favError',
            onRetry: _loadFavorites,
          ),
        ],
      );
    }
    if (_favRepos.isEmpty) {
      return AppSection(
        title: l10n.favorites,
        children: [
          AppSectionPlaceholder(text: l10n.noRepositoriesFound),
        ],
      );
    }
    return AppSection(
      title: l10n.favorites,
      children: _favRepos.take(3).map((repo) {
        final owner = repo.owner?.login ??
            repo.full_name?.split('/').firstOrNull ??
            '';
        final name =
            repo.name ?? repo.full_name?.split('/').lastOrNull ?? '';
        return AppTile(
          leading: repo.owner != null
              ? UserAvatar(user: repo.owner!, radius: 16)
              : const Icon(FIcons.globe, size: 18),
          title: name,
          subtitle: owner,
          onPress: () {
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
    return AppSection(
      title: l10n.shortcuts,
      children: [
        AppTile(
          leading: const _IconBox(color: Color(0xFF2EA043), icon: Icons.alternate_email),
          title: l10n.issues,
          subtitle: l10n.mentioned,
          onPress: () => _openIssues(
            context,
            const IssueFilterState(type: 'issues', mentionedMe: true),
          ),
        ),
        AppTile(
          leading: const _IconBox(color: Color(0xFF0969DA), icon: Icons.rate_review_outlined),
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

  // ── Section D: 近期活动（activities top5 + 查看全部）──────────────────

  Widget _buildRecent(BuildContext context, AppLocalizations l10n) {
    final username = _username;
    final viewAllButton = username == null
        ? null
        : FButton(
            variant: .ghost,
            size: .sm,
            onPress: () => _push(
              context,
              ActivityPage(username: username),
            ),
            child: Text(l10n.viewAll),
          );

    if (_recentLoading) {
      return AppSection(
        title: l10n.recent,
        trailing: viewAllButton,
        children: const [
          AppSectionPlaceholder(showProgress: true),
        ],
      );
    }
    if (_recentError != null) {
      return AppSection(
        title: l10n.recent,
        trailing: viewAllButton,
        children: [
          AppSectionPlaceholder(
            text: '${l10n.error}: $_recentError',
            onRetry: _loadRecent,
          ),
        ],
      );
    }
    if (_recentActivities.isEmpty) {
      return AppSection(
        title: l10n.recent,
        trailing: viewAllButton,
        children: [
          AppSectionPlaceholder(text: l10n.noActivity),
        ],
      );
    }
    return AppSection(
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

/// A small colored rounded square used as the leading icon of a home row.
class _IconBox extends StatelessWidget {
  final Color color;
  final IconData icon;

  const _IconBox({required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Icon(icon, color: Colors.white, size: 16),
    );
  }
}
