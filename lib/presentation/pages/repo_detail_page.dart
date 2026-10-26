import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/animations/animated_wrapper.dart';
import '../../core/animations/app_animations.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/platform/desktop_layout.dart';
import '../../core/di/injection.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../domain/usecases/issue_usecases.dart';
import '../../domain/usecases/repo_usecases.dart';
import '../../domain/entities/auth_state.dart';
import '../../domain/entities/issue_state.dart';
import '../../l10n/app_localizations.dart';
import '../state/repo_notifier.dart';
import '../state/issue_notifier.dart';
import '../models/issue_filter_state.dart';
import '../widgets/issue_filter_bottom_sheet.dart';
import '../widgets/empty_state.dart';
import '../widgets/forui/app_filter_chip.dart';
import '../widgets/desktop/app_hover_region.dart';
import '../widgets/desktop/app_three_pane.dart';
import '../widgets/forui/app_page.dart';
import '../widgets/forui/app_section.dart';
import '../widgets/forui/app_state_views.dart';
import '../widgets/forui/app_tile.dart';
import '../theme/app_palette.dart';
import '../widgets/app_markdown.dart';
import '../widgets/app_skeleton.dart';
import '../widgets/app_surface.dart';
import '../widgets/forui/app_chrome.dart';
import '../widgets/language_dot.dart';
import '../widgets/premium_card.dart';
import '../widgets/user_avatar.dart';
import '../widgets/file_icon.dart';
import '../widgets/slow_loading_indicator.dart';
import 'commit_detail_page.dart';
import 'create_release_page.dart';
import 'branch_protection_page.dart';
import 'collaborators_page.dart';
import 'issue_detail_page.dart';
import 'milestone_detail_page.dart';
import 'pr_detail_page.dart';
import 'release_detail_page.dart';
import 'repo_file_page.dart';
import 'repo_settings_page.dart';
import 'tag_detail_page.dart';
import 'wiki_list_page.dart';
import 'create_issue_page.dart';
import 'create_milestone_page.dart';
import 'create_pr_page.dart';
import 'webhook_list_page.dart';
import 'label_list_page.dart';
import 'actions_list_page.dart';
import 'repo_stargazers_page.dart';

class RepoDetailPage extends StatefulWidget {
  final String owner;
  final String repo;

  const RepoDetailPage({super.key, required this.owner, required this.repo});

  @override
  State<RepoDetailPage> createState() => _RepoDetailPageState();
}

class _RepoDetailPageState extends State<RepoDetailPage> {
  Map<String, int> _languages = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Injection.repoNotifier.getRepo(widget.owner, widget.repo);
      Injection.repoNotifier.checkStarred(widget.owner, widget.repo);
      Injection.repoNotifier.checkWatched(widget.owner, widget.repo);
      _loadLanguages();
    });
  }

  Future<void> _loadLanguages() async {
    try {
      final langs = await Injection.apiService.repoGetLanguages(
        owner: widget.owner,
        repo: widget.repo,
      );
      if (mounted) setState(() => _languages = langs);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final desktop = DesktopLayout.isRepositoryDesktop(context);
    return AppPage(
      title: '${widget.owner}/${widget.repo}',
      maxContentWidth: desktop ? null : 1120,
      actions: [
        ListenableBuilder(
          listenable: Injection.repoNotifier,
          builder: (context, _) {
            final isStarred = Injection.repoNotifier.isStarred;
            final starLoading = Injection.repoNotifier.starLoading;
            final isWatched = Injection.repoNotifier.isWatched;
            final watchLoading = Injection.repoNotifier.watchLoading;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FHeaderAction(
                  icon: Icon(isStarred ? FIcons.star : FIcons.star),
                  selected: isStarred,
                  onPress: starLoading
                      ? null
                      : () => Injection.repoNotifier.toggleStar(
                          widget.owner,
                          widget.repo,
                        ),
                ),
                FHeaderAction(
                  icon: Icon(isWatched ? FIcons.bell : FIcons.bell),
                  selected: isWatched,
                  onPress: watchLoading
                      ? null
                      : () => Injection.repoNotifier.toggleWatch(
                          widget.owner,
                          widget.repo,
                        ),
                ),
                FHeaderAction(
                  icon: const Icon(FIcons.gitFork),
                  onPress: () => _showForkDialog(context, l10n),
                ),
                if (Injection.repoNotifier.state case RepoLoaded(:final repo))
                  FHeaderAction(
                    icon: const Icon(FIcons.externalLink),
                    semanticsLabel: l10n.openInBrowser,
                    onPress: () {
                      final url = repo.html_url;
                      if (url != null) {
                        launchUrl(
                          Uri.parse(url),
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    },
                  ),
                if (Injection.repoNotifier.state case RepoLoaded(:final repo))
                  FHeaderAction(
                    icon: const Icon(FIcons.settings),
                    semanticsLabel: l10n.settings,
                    onPress: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RepoSettingsPage(repo: repo),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
      child: ListenableBuilder(
        listenable: Injection.repoNotifier,
        builder: (context, _) {
          final state = Injection.repoNotifier.state;
          return switch (state) {
            RepoLoading() => const SlowLoadingIndicator(),
            RepoError(:final message) => AppError(
              title: l10n.failedToLoadRepo,
              message: message,
              onRetry: () =>
                  Injection.repoNotifier.getRepo(widget.owner, widget.repo),
            ),
            RepoLoaded(:final repo) => _buildContent(context, repo, l10n),
            _ => const AppLoading(),
          };
        },
      ),
    );
  }

  List<_SectionItem> _sections(AppLocalizations l10n) => [
    _SectionItem(id: 'code', title: l10n.code, icon: FIcons.code),
    _SectionItem(id: 'issues', title: l10n.issues, icon: FIcons.circleDot),
    _SectionItem(id: 'milestones', title: l10n.milestones, icon: FIcons.flag),
    _SectionItem(
      id: 'pullRequests',
      title: l10n.pullRequests,
      icon: FIcons.gitPullRequest,
    ),
    _SectionItem(id: 'releases', title: l10n.releases, icon: FIcons.tag),
    _SectionItem(
      id: 'commits',
      title: l10n.commits,
      icon: FIcons.gitCommitHorizontal,
    ),
    _SectionItem(id: 'branches', title: l10n.branches, icon: FIcons.gitBranch),
    _SectionItem(id: 'tags', title: l10n.tags, icon: FIcons.tag),
    _SectionItem(
      id: 'branch_protection',
      title: l10n.branchProtection,
      icon: FIcons.shield,
    ),
    _SectionItem(id: 'wiki', title: l10n.wiki, icon: FIcons.bookOpen),
    _SectionItem(id: 'webhooks', title: l10n.webhooks, icon: FIcons.webhook),
    _SectionItem(
      id: 'collaborators',
      title: l10n.collaborators,
      icon: FIcons.users,
    ),
    _SectionItem(id: 'labels', title: l10n.labels, icon: FIcons.tag),
    _SectionItem(id: 'actions', title: l10n.actions, icon: FIcons.play),
  ];

  Widget _buildContent(
    BuildContext context,
    Repository repo,
    AppLocalizations l10n,
  ) {
    if (DesktopLayout.isRepositoryDesktop(context)) {
      return _RepoDesktopWorkspace(
        repo: repo,
        owner: widget.owner,
        repoName: widget.repo,
        languages: _languages,
        l10n: l10n,
        sections: _sections(l10n),
        onSection: (id) =>
            _navigateToSection(context, id, repo.default_branch, l10n),
        onOpenSettings: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => RepoSettingsPage(repo: repo))),
        onRefresh: () =>
            Injection.repoNotifier.getRepo(widget.owner, widget.repo),
      );
    }

    final sections = _sections(l10n);

    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        FadeInWrapper(
          duration: AppAnimations.slow,
          child: _RepoHeader(
            repo: repo,
            l10n: l10n,
            owner: widget.owner,
            repoName: widget.repo,
            languages: _languages,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: _ReadmePreview(
            owner: widget.owner,
            repo: widget.repo,
            ref: repo.default_branch,
            l10n: l10n,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: AppSection(
            title: l10n.repositorySections,
            children: [
              for (final section in sections)
                AppTile(
                  leading: _SectionIcon(icon: section.icon),
                  title: section.title,
                  onPress: () => _navigateToSection(
                    context,
                    section.id,
                    repo.default_branch,
                    l10n,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  void _navigateToSection(
    BuildContext context,
    String sectionId,
    String? defaultBranch,
    AppLocalizations l10n,
  ) {
    if (sectionId == 'wiki') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => WikiListPage(owner: widget.owner, repo: widget.repo),
        ),
      );
      return;
    }
    if (sectionId == 'webhooks') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              WebhookListPage(owner: widget.owner, repo: widget.repo),
        ),
      );
      return;
    }
    if (sectionId == 'collaborators') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              CollaboratorsPage(owner: widget.owner, repo: widget.repo),
        ),
      );
      return;
    }
    if (sectionId == 'branch_protection') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              BranchProtectionPage(owner: widget.owner, repo: widget.repo),
        ),
      );
      return;
    }
    if (sectionId == 'labels') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => LabelListPage(owner: widget.owner, repo: widget.repo),
        ),
      );
      return;
    }
    if (sectionId == 'actions') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              ActionsListPage(owner: widget.owner, repo: widget.repo),
        ),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _RepoSectionPage(
          owner: widget.owner,
          repo: widget.repo,
          sectionId: sectionId,
          defaultBranch: defaultBranch,
        ),
      ),
    );
  }

  Future<void> _showForkDialog(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showFDialog<bool>(
      context: context,
      builder: (context, style, animation) => FDialog(
        title: Text(l10n.forks),
        body: Text('${l10n.forkRepoConfirm} ${widget.owner}/${widget.repo}'),
        actions: [
          FButton(
            variant: .outline,
            onPress: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FButton(
            onPress: () => Navigator.of(context).pop(true),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final result = await Injection.repoNotifier.createFork(
      widget.owner,
      widget.repo,
    );
    if (!context.mounted) return;
    switch (result) {
      case Left<Failure, Repository>(:final value):
        showFToast(
          context: context,
          variant: .destructive,
          title: Text('${l10n.error}: ${value.message}'),
        );
      case Right<Failure, Repository>(:final value):
        showFToast(
          context: context,
          title: Text('${l10n.forked}: ${value.full_name ?? value.name ?? ''}'),
        );
    }
  }
}

class _RepoDesktopWorkspace extends StatefulWidget {
  const _RepoDesktopWorkspace({
    required this.repo,
    required this.owner,
    required this.repoName,
    required this.languages,
    required this.l10n,
    required this.sections,
    required this.onSection,
    required this.onOpenSettings,
    required this.onRefresh,
  });

  final Repository repo;
  final String owner;
  final String repoName;
  final Map<String, int> languages;
  final AppLocalizations l10n;
  final List<_SectionItem> sections;
  final ValueChanged<String> onSection;
  final VoidCallback onOpenSettings;
  final VoidCallback onRefresh;

  @override
  State<_RepoDesktopWorkspace> createState() => _RepoDesktopWorkspaceState();
}

class _RepoDesktopWorkspaceState extends State<_RepoDesktopWorkspace> {
  final ScrollController _centerController = ScrollController();

  @override
  void dispose() {
    _centerController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    if (!_centerController.hasClients) return;
    _centerController.animateTo(
      0,
      duration: AppAnimations.normal,
      curve: AppAnimations.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppThreePane(
      leading: _RepoNavRail(
        repo: widget.repo,
        l10n: widget.l10n,
        sections: widget.sections,
        onSection: widget.onSection,
        onOverview: _scrollToTop,
      ),
      center: _RepoOverviewPane(
        repo: widget.repo,
        owner: widget.owner,
        repoName: widget.repoName,
        languages: widget.languages,
        l10n: widget.l10n,
        controller: _centerController,
        onOpenSettings: widget.onOpenSettings,
        onRefresh: widget.onRefresh,
      ),
      trailing: _RepoContextPane(
        repo: widget.repo,
        owner: widget.owner,
        repoName: widget.repoName,
        languages: widget.languages,
        l10n: widget.l10n,
        onOpenSettings: widget.onOpenSettings,
        onRefresh: widget.onRefresh,
      ),
    );
  }
}

class _RepoNavRail extends StatelessWidget {
  const _RepoNavRail({
    required this.repo,
    required this.l10n,
    required this.sections,
    required this.onSection,
    required this.onOverview,
  });

  final Repository repo;
  final AppLocalizations l10n;
  final List<_SectionItem> sections;
  final ValueChanged<String> onSection;
  final VoidCallback onOverview;

  static const _groups = <String, List<String>>{
    'sourceControl': ['code'],
    'collaboration': ['issues', 'pullRequests', 'milestones'],
    'insights': ['commits', 'releases', 'branches', 'tags'],
    'administration': [
      'labels',
      'collaborators',
      'webhooks',
      'branch_protection',
      'actions',
      'wiki',
    ],
  };

  String _groupLabel(String key) => switch (key) {
    'sourceControl' => l10n.sourceControl,
    'collaboration' => l10n.collaboration,
    'insights' => l10n.insights,
    _ => l10n.administration,
  };

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final theme = Theme.of(context);
    final byId = {for (final section in sections) section.id: section};
    final name = repo.full_name ?? repo.name ?? '';

    return ListView(
      padding: const EdgeInsets.fromLTRB(10, 22, 10, 26),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              if (repo.owner != null)
                UserAvatar(user: repo.owner!, radius: 15)
              else
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: palette.brandSoft,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    FIcons.folderGit2,
                    size: 15,
                    color: palette.brand,
                  ),
                ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: palette.textPrimary,
                      ),
                    ),
                    Text(
                      repo.private == true ? l10n.private : l10n.public,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 10.5,
                        color: palette.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SidebarNavItem(
          icon: FIcons.layoutDashboard,
          label: l10n.overview,
          selected: true,
          onPress: onOverview,
        ),
        for (final entry in _groups.entries) ...[
          SidebarLabel(_groupLabel(entry.key)),
          for (final id in entry.value)
            if (byId[id] case final section?)
              SidebarNavItem(
                icon: section.icon,
                label: section.title,
                selected: false,
                onPress: () => onSection(section.id),
              ),
        ],
      ],
    );
  }
}

class _RepoOverviewPane extends StatelessWidget {
  const _RepoOverviewPane({
    required this.repo,
    required this.owner,
    required this.repoName,
    required this.languages,
    required this.l10n,
    required this.controller,
    required this.onOpenSettings,
    required this.onRefresh,
  });

  final Repository repo;
  final String owner;
  final String repoName;
  final Map<String, int> languages;
  final AppLocalizations l10n;
  final ScrollController controller;
  final VoidCallback onOpenSettings;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: controller,
      padding: const EdgeInsets.only(bottom: 40),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 920),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _RepoHeader(
                  repo: repo,
                  l10n: l10n,
                  owner: owner,
                  repoName: repoName,
                  languages: languages,
                  showStats: true,
                  showLanguages: false,
                  showTopics: false,
                  showCloneUrls: false,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _RepoQuickAction(
                        icon: FIcons.circleDot,
                        label: l10n.newIssue,
                        onPress: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                CreateIssuePage(owner: owner, repo: repoName),
                          ),
                        ),
                      ),
                      _RepoQuickAction(
                        icon: FIcons.gitPullRequest,
                        label: l10n.newPullRequest,
                        onPress: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                CreatePRPage(owner: owner, repo: repoName),
                          ),
                        ),
                      ),
                      _RepoQuickAction(
                        icon: FIcons.settings,
                        label: l10n.settings,
                        onPress: onOpenSettings,
                      ),
                      _RepoQuickAction(
                        icon: FIcons.refreshCw,
                        label: l10n.refresh,
                        onPress: onRefresh,
                      ),
                      if (repo.html_url != null)
                        _RepoQuickAction(
                          icon: FIcons.externalLink,
                          label: l10n.openInBrowser,
                          onPress: () => launchUrl(
                            Uri.parse(repo.html_url!),
                            mode: LaunchMode.externalApplication,
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: _ReadmePreview(
                    owner: owner,
                    repo: repoName,
                    ref: repo.default_branch,
                    l10n: l10n,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _RepoContextPane extends StatelessWidget {
  const _RepoContextPane({
    required this.repo,
    required this.owner,
    required this.repoName,
    required this.languages,
    required this.l10n,
    required this.onOpenSettings,
    required this.onRefresh,
  });

  final Repository repo;
  final String owner;
  final String repoName;
  final Map<String, int> languages;
  final AppLocalizations l10n;
  final VoidCallback onOpenSettings;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final theme = Theme.of(context);
    final localization = MaterialLocalizations.of(context);
    final description = repo.description?.trim() ?? '';

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 32),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.about,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                  color: palette.textPrimary,
                ),
              ),
            ),
            if (repo.html_url != null)
              AppIconButton(
                icon: FIcons.externalLink,
                label: l10n.openInBrowser,
                size: 26,
                iconSize: 14,
                onPress: () => launchUrl(
                  Uri.parse(repo.html_url!),
                  mode: LaunchMode.externalApplication,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        AppSurface(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                description.isEmpty ? l10n.noDescriptionProvided : description,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: description.isEmpty
                      ? palette.textSecondary
                      : palette.textPrimary,
                ),
              ),
              if (repo.website != null && repo.website!.isNotEmpty) ...[
                const SizedBox(height: 10),
                AppHoverRegion(
                  onTap: () => launchUrl(
                    Uri.parse(repo.website!),
                    mode: LaunchMode.externalApplication,
                  ),
                  hoverColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  child: Row(
                    children: [
                      Icon(
                        FIcons.globe,
                        size: 13,
                        color: palette.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          repo.website!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.5,
                            color: palette.brand,
                            decoration: TextDecoration.underline,
                            decorationColor: palette.brand.withValues(
                              alpha: 0.4,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Container(height: 1, color: palette.border),
              const SizedBox(height: 12),
              _ContextStats(repo: repo, l10n: l10n),
              if (languages.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(height: 1, color: palette.border),
                const SizedBox(height: 10),
                _LanguageBar(languages: languages),
              ],
              const SizedBox(height: 12),
              Container(height: 1, color: palette.border),
              const SizedBox(height: 10),
              _TopicsRow(
                repo: repo,
                l10n: l10n,
                owner: owner,
                repoName: repoName,
              ),
              const SizedBox(height: 12),
              Container(height: 1, color: palette.border),
              const SizedBox(height: 10),
              _CloneUrls(repo: repo, l10n: l10n),
              if (repo.created_at != null || repo.updated_at != null) ...[
                const SizedBox(height: 10),
                Container(height: 1, color: palette.border),
                const SizedBox(height: 10),
                if (repo.created_at != null)
                  _ContextMetaRow(
                    icon: FIcons.calendar,
                    label: l10n.createdAt,
                    value: localization.formatShortDate(repo.created_at!),
                  ),
                if (repo.updated_at != null)
                  _ContextMetaRow(
                    icon: FIcons.clock,
                    label: l10n.updatedAt,
                    value: localization.formatShortDate(repo.updated_at!),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _RepoQuickAction extends StatelessWidget {
  const _RepoQuickAction({
    required this.icon,
    required this.label,
    required this.onPress,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return AppHoverRegion(
      onTap: onPress,
      semanticsLabel: label,
      hoverColor: palette.surfaceMuted.withValues(alpha: 0.7),
      borderColor: palette.border,
      hoverBorderColor: palette.borderStrong,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: palette.textSecondary),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: palette.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContextStats extends StatelessWidget {
  const _ContextStats({required this.repo, required this.l10n});

  final Repository repo;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final stats = [
      (FIcons.star, '${repo.stars_count ?? 0}', l10n.stars),
      (FIcons.gitFork, '${repo.forks_count ?? 0}', l10n.forks),
      (FIcons.eye, '${repo.watchers_count ?? 0}', l10n.watchers),
      (FIcons.circleDot, '${repo.open_issues_count ?? 0}', l10n.issues),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 12) / 2;
        return Wrap(
          spacing: 12,
          runSpacing: 10,
          children: [
            for (final stat in stats)
              SizedBox(
                width: itemWidth,
                child: Row(
                  children: [
                    Icon(
                      stat.$1,
                      size: 13,
                      color: context.palette.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      stat.$2,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        stat.$3,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10.5,
                          color: context.palette.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ContextMetaRow extends StatelessWidget {
  const _ContextMetaRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Icon(icon, size: 12, color: palette.textSecondary),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 11, color: palette.textSecondary),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: palette.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _RepoHeader extends StatelessWidget {
  final Repository repo;
  final AppLocalizations l10n;
  final String owner;
  final String repoName;
  final Map<String, int> languages;

  /// Sections rendered inside the header. The desktop workspace moves the
  /// languages, topics and clone URLs into the context pane.
  final bool showStats;
  final bool showLanguages;
  final bool showTopics;
  final bool showCloneUrls;

  const _RepoHeader({
    required this.repo,
    required this.l10n,
    required this.owner,
    required this.repoName,
    required this.languages,
    this.showStats = true,
    this.showLanguages = true,
    this.showTopics = true,
    this.showCloneUrls = true,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final theme = Theme.of(context);
    final description = repo.description?.trim() ?? '';
    final login = repo.owner?.login ?? owner;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: AppSurface(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (repo.owner != null)
                  UserAvatar(user: repo.owner!, radius: 24)
                else
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: palette.brandSoft,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      FIcons.folderGit2,
                      size: 22,
                      color: palette.brand,
                    ),
                  ),
                const SizedBox(width: 14),
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
                            repo.full_name ?? repo.name ?? '',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.4,
                              height: 1.2,
                              color: palette.textPrimary,
                            ),
                          ),
                          if (repo.private == true)
                            _RepoBadge(
                              icon: FIcons.lock,
                              label: l10n.private,
                              color: palette.textSecondary,
                              background: palette.surfaceMuted,
                            ),
                          if (repo.archived == true)
                            _RepoBadge(
                              icon: FIcons.archive,
                              label: l10n.archived,
                              color: palette.warning,
                              background: palette.warningSoft,
                            ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          Text(
                            '@$login',
                            style: TextStyle(
                              fontSize: 12,
                              color: palette.textSecondary,
                            ),
                          ),
                          if (repo.language != null &&
                              repo.language!.isNotEmpty) ...[
                            const _MetaDot(),
                            LanguageDot(language: repo.language),
                          ],
                          if (repo.default_branch != null &&
                              repo.default_branch!.isNotEmpty) ...[
                            const _MetaDot(),
                            Icon(
                              FIcons.gitBranch,
                              size: 11,
                              color: palette.textSecondary,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              repo.default_branch!,
                              style: TextStyle(
                                fontSize: 11.5,
                                color: palette.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (description.isNotEmpty) ...[
              const SizedBox(height: 14),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: palette.textSecondary,
                ),
              ),
            ],
            if (showStats) ...[
              const SizedBox(height: 18),
              _StatsRow(
                repo: repo,
                l10n: l10n,
                owner: owner,
                repoName: repoName,
              ),
            ],
            if (showLanguages && languages.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(height: 1, color: palette.border),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    l10n.language,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.4,
                      color: palette.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _LanguageBar(languages: languages),
            ],
            if (showTopics || showCloneUrls) ...[
              if (showStats || (showLanguages && languages.isNotEmpty))
                const SizedBox(height: 16),
              Container(height: 1, color: palette.border),
              const SizedBox(height: 14),
              if (showTopics)
                _TopicsRow(
                  repo: repo,
                  l10n: l10n,
                  owner: owner,
                  repoName: repoName,
                ),
              if (showTopics && showCloneUrls) const SizedBox(height: 14),
              if (showCloneUrls) _CloneUrls(repo: repo, l10n: l10n),
            ],
          ],
        ),
      ),
    );
  }
}

class _MetaDot extends StatelessWidget {
  const _MetaDot();

  @override
  Widget build(BuildContext context) {
    return Text(
      '·',
      style: TextStyle(fontSize: 12, color: context.palette.borderStrong),
    );
  }
}

class _RepoBadge extends StatelessWidget {
  const _RepoBadge({
    required this.label,
    required this.color,
    required this.background,
    this.icon,
  });

  final String label;
  final Color color;
  final Color background;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 10, color: color),
            const SizedBox(width: 3),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final Repository repo;
  final AppLocalizations l10n;
  final String owner;
  final String repoName;

  const _StatsRow({
    required this.repo,
    required this.l10n,
    required this.owner,
    required this.repoName,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final stats = <_StatData>[
      _StatData(
        icon: FIcons.star,
        value: '${repo.stars_count ?? 0}',
        label: l10n.stars,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => RepoStargazersPage(owner: owner, repo: repoName),
          ),
        ),
      ),
      _StatData(
        icon: FIcons.gitFork,
        value: '${repo.forks_count ?? 0}',
        label: l10n.forks,
      ),
      _StatData(
        icon: FIcons.eye,
        value: '${repo.watchers_count ?? 0}',
        label: l10n.watchers,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => RepoStargazersPage(owner: owner, repo: repoName),
          ),
        ),
      ),
      _StatData(
        icon: FIcons.circleDot,
        value: '${repo.open_issues_count ?? 0}',
        label: l10n.issues,
      ),
    ];

    return Row(
      children: [
        for (var i = 0; i < stats.length; i++) ...[
          if (i > 0)
            Container(
              width: 1,
              height: 26,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              color: palette.border,
            ),
          Expanded(child: _StatItem(data: stats[i])),
        ],
      ],
    );
  }
}

class _StatData {
  const _StatData({
    required this.icon,
    required this.value,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String value;
  final String label;
  final VoidCallback? onTap;
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.data});

  final _StatData data;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(data.icon, size: 13, color: palette.textSecondary),
            const SizedBox(width: 5),
            Text(
              data.value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: palette.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 1),
        Text(
          data.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 10.5, color: palette.textSecondary),
        ),
      ],
    );
    if (data.onTap == null) return content;
    return FTappable(onPress: data.onTap, child: content);
  }
}

class _TopicsRow extends StatelessWidget {
  final Repository repo;
  final AppLocalizations l10n;
  final String owner;
  final String repoName;

  const _TopicsRow({
    required this.repo,
    required this.l10n,
    required this.owner,
    required this.repoName,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final topics = repo.topics ?? const <String>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              l10n.topics,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
                color: palette.textSecondary,
              ),
            ),
            const Spacer(),
            AppIconButton(
              icon: FIcons.pencil,
              label: '${l10n.edit} ${l10n.topics}',
              size: 26,
              iconSize: 13,
              onPress: () =>
                  showTopicEditDialog(context, owner, repoName, topics),
            ),
          ],
        ),
        const SizedBox(height: 7),
        if (topics.isNotEmpty)
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final topic in topics)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: palette.brandSoft,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    topic,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: palette.brand,
                    ),
                  ),
                ),
            ],
          )
        else
          Row(
            children: [
              Icon(FIcons.tag, size: 12, color: palette.textSecondary),
              const SizedBox(width: 6),
              Text(
                l10n.noTopics,
                style: TextStyle(fontSize: 11.5, color: palette.textSecondary),
              ),
            ],
          ),
      ],
    );
  }
}

class _CloneUrls extends StatelessWidget {
  final Repository repo;
  final AppLocalizations l10n;

  const _CloneUrls({required this.repo, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(FIcons.link2, size: 12, color: palette.textSecondary),
            const SizedBox(width: 6),
            Text(
              l10n.cloneUrl,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
                color: palette.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        if (repo.clone_url != null)
          _CloneRow(label: 'HTTPS', url: repo.clone_url!, l10n: l10n),
        if (repo.ssh_url != null)
          _CloneRow(label: 'SSH', url: repo.ssh_url!, l10n: l10n),
      ],
    );
  }
}

class _CloneRow extends StatelessWidget {
  final String label;
  final String url;
  final AppLocalizations l10n;

  const _CloneRow({required this.label, required this.url, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
      decoration: BoxDecoration(
        color: palette.surfaceMuted.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 44,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: palette.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              url,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11.5, color: palette.textSecondary),
            ),
          ),
          AppIconButton(
            icon: FIcons.copy,
            label: l10n.copy,
            size: 24,
            iconSize: 13,
            onPress: () async {
              await Clipboard.setData(ClipboardData(text: url));
              if (context.mounted) {
                showFToast(context: context, title: Text(l10n.copied));
              }
            },
          ),
        ],
      ),
    );
  }
}

class _CodeTab extends StatefulWidget {
  final String owner;
  final String repo;
  final String? defaultBranch;

  const _CodeTab({required this.owner, required this.repo, this.defaultBranch});

  @override
  State<_CodeTab> createState() => _CodeTabState();
}

class _CodeTabState extends State<_CodeTab> {
  String _currentPath = '';
  final List<String> _pathStack = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Injection.repoNotifier.loadContents(
        widget.owner,
        widget.repo,
        ref: widget.defaultBranch,
      );
    });
  }

  void _navigateTo(String path) {
    setState(() {
      _pathStack.add(_currentPath);
      _currentPath = path;
    });
    Injection.repoNotifier.loadContents(
      widget.owner,
      widget.repo,
      path: path,
      ref: widget.defaultBranch,
    );
  }

  void _navigateUp() {
    if (_pathStack.isEmpty) return;
    setState(() {
      _currentPath = _pathStack.removeLast();
    });
    Injection.repoNotifier.loadContents(
      widget.owner,
      widget.repo,
      path: _currentPath.isEmpty ? null : _currentPath,
      ref: widget.defaultBranch,
    );
  }

  void _openFile(ContentsResponse item) async {
    if (item.type == 'file' || item.type == 'symlink') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => RepoFilePage(
            owner: widget.owner,
            repo: widget.repo,
            path: item.path ?? item.name ?? '',
            name: item.name ?? '',
            downloadUrl: item.download_url,
            htmlUrl: item.html_url,
            ref: widget.defaultBranch,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = context.palette;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: palette.surface,
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: palette.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      FIcons.gitBranch,
                      size: 11,
                      color: palette.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.defaultBranch ?? 'main',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: palette.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (_currentPath.isNotEmpty) ...[
                const SizedBox(width: 8),
                Icon(
                  FIcons.chevronRight,
                  size: 12,
                  color: palette.textSecondary,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    _currentPath,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: palette.textSecondary,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              if (_pathStack.isNotEmpty)
                AppIconButton(
                  icon: FIcons.arrowUp,
                  label: MaterialLocalizations.of(context).backButtonTooltip,
                  size: 28,
                  iconSize: 15,
                  onPress: _navigateUp,
                ),
            ],
          ),
        ),
        Expanded(
          child: ListenableBuilder(
            listenable: Injection.repoNotifier,
            builder: (context, _) {
              final state = Injection.repoNotifier.contentsState;
              return switch (state) {
                ContentsLoading() => _CodeSkeleton(),
                ContentsError(:final message) => AppError(
                  message: message,
                  onRetry: () => Injection.repoNotifier.loadContents(
                    widget.owner,
                    widget.repo,
                    path: _currentPath.isEmpty ? null : _currentPath,
                    ref: widget.defaultBranch,
                  ),
                ),
                ContentsLoaded(:final contents) => _buildFileList(
                  contents,
                  l10n,
                ),
                _ => const AppLoading(),
              };
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFileList(
    List<ContentsResponse> contents,
    AppLocalizations l10n,
  ) {
    if (contents.isEmpty) {
      return EmptyState(icon: FIcons.folderOpen, title: l10n.emptyDirectory);
    }
    final dirs = contents.where((c) => c.type == 'dir').toList()
      ..sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
    final files = contents.where((c) => c.type != 'dir').toList()
      ..sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
    final sorted = [...dirs, ...files];

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 2, 20, 28),
      children: [
        AppSection(
          title: '',
          showHeader: false,
          children: [
            for (final item in sorted)
              _FileItem(
                item: item,
                onTap: () {
                  if (item.type == 'dir') {
                    _navigateTo(item.path ?? item.name ?? '');
                  } else {
                    _openFile(item);
                  }
                },
              ),
          ],
        ),
      ],
    );
  }
}

class _CodeSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 2, 20, 28),
      children: [
        AppSection(
          title: '',
          showHeader: false,
          children: [
            AppSkeleton(
              child: Column(
                children: List.generate(6, (index) {
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              SkeletonLine(widthFactor: 0.42, height: 9),
                              SizedBox(height: 5),
                              SkeletonLine(widthFactor: 0.22, height: 7),
                            ],
                          ),
                        ),
                        const SkeletonBox(width: 30, height: 8),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FileItem extends StatelessWidget {
  final ContentsResponse item;
  final VoidCallback onTap;

  const _FileItem({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isDir = item.type == 'dir';
    final size = item.size;

    return AppTile(
      leading: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: isDir ? palette.brandSoft : palette.surfaceMuted,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Icon(
          isDir ? FIcons.folder : fileIcon(item.type, item.name),
          size: 13,
          color: isDir ? palette.brand : palette.textSecondary,
        ),
      ),
      title: item.name ?? '',
      showChevron: false,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (size != null && !isDir)
            Text(
              _formatSize(size),
              style: TextStyle(
                fontSize: 10.5,
                fontFeatures: const [FontFeature.tabularFigures()],
                color: palette.textSecondary.withValues(alpha: 0.8),
              ),
            ),
          const SizedBox(width: 6),
          Icon(
            FIcons.chevronRight,
            size: 14,
            color: palette.textSecondary.withValues(alpha: 0.7),
          ),
        ],
      ),
      onPress: onTap,
    );
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

class _IssuesTab extends StatefulWidget {
  final String owner;
  final String repo;
  final AppLocalizations l10n;

  const _IssuesTab({
    required this.owner,
    required this.repo,
    required this.l10n,
  });

  @override
  State<_IssuesTab> createState() => _IssuesTabState();
}

class _IssuesTabState extends State<_IssuesTab> {
  String _selectedFilter = 'open';
  final ValueNotifier<IssueFilterState> _filterState = ValueNotifier(
    const IssueFilterState(),
  );
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isFilterSheetOpen = false;
  Timer? _debounceTimer;

  void _loadIssues() {
    final authState = Injection.authNotifier.state;
    String? currentUsername;
    if (authState is AuthAuthenticated) {
      currentUsername = authState.user.login;
    }

    Injection.issueNotifier.listIssues(
      ListIssuesParams(
        owner: widget.owner,
        repo: widget.repo,
        state: _selectedFilter,
        q: _searchQuery.isEmpty ? null : _searchQuery,
        labels: _filterState.value.labelsParam,
        milestones: _filterState.value.milestonesParam,
        type: _filterState.value.type,
        assigned_by: _filterState.value.assignedToMe ? currentUsername : null,
        created_by: _filterState.value.createdByMe ? currentUsername : null,
        mentioned_by: _filterState.value.mentionedMe ? currentUsername : null,
      ),
    );
  }

  bool _canCreateIssue() {
    final state = Injection.repoNotifier.state;
    if (state is RepoLoaded) {
      final p = state.repo.permissions;
      return (p?.push == true || p?.admin == true) &&
          state.repo.has_issues != false;
    }
    return false;
  }

  Future<void> _showFilterSheet() async {
    if (_isFilterSheetOpen) return;
    _isFilterSheetOpen = true;

    try {
      await Injection.issueNotifier.listLabels(widget.owner, widget.repo);
      await Injection.issueNotifier.listMilestones(widget.owner, widget.repo);

      final labels = <String>[];
      final milestones = <String>[];

      final state = Injection.issueNotifier.state;
      if (state is LabelsLoaded) {
        labels.addAll(
          state.labels.map((l) => l.name ?? '').where((n) => n.isNotEmpty),
        );
      }
      if (state is MilestonesLoaded) {
        milestones.addAll(
          state.milestones.map((m) => m.title ?? '').where((t) => t.isNotEmpty),
        );
      }

      if (!mounted) return;

      final result = await showFSheet<IssueFilterState>(
        context: context,
        side: FLayout.btt,
        mainAxisMaxRatio: 0.85,
        constraints: const BoxConstraints(maxWidth: 560),
        useSafeArea: true,
        builder: (_) => IssueFilterBottomSheet(
          initialState: _filterState.value,
          availableLabels: labels,
          availableMilestones: milestones,
        ),
      );

      if (result != null) {
        _filterState.value = result;
        _loadIssues();
      }
    } finally {
      _isFilterSheetOpen = false;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadIssues());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Injection.issueNotifier,
      builder: (context, _) {
        final issuesState = Injection.issueNotifier.issuesListState;
        return Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 4),
                  child: FTextField(
                    control: FTextFieldControl.managed(
                      controller: _searchController,
                      onChange: (value) {
                        setState(() => _searchQuery = value.text);
                        _debounceTimer?.cancel();
                        _debounceTimer = Timer(
                          const Duration(milliseconds: 300),
                          _loadIssues,
                        );
                      },
                    ),
                    hint: widget.l10n.searchIssues,
                    prefixBuilder: (context, style, variants) =>
                        FTextField.prefixIconBuilder(
                          context,
                          style,
                          variants,
                          const Icon(FIcons.search, size: 16),
                        ),
                    clearable: (value) => value.text.isNotEmpty,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 6),
                  child: ValueListenableBuilder<IssueFilterState>(
                    valueListenable: _filterState,
                    builder: (context, filter, _) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 240,
                                child: AppSegmentedControl(
                                  index: [
                                    'open',
                                    'closed',
                                    'all',
                                  ].indexOf(_selectedFilter),
                                  labels: [
                                    widget.l10n.open,
                                    widget.l10n.closed,
                                    widget.l10n.all,
                                  ],
                                  onChanged: (index) {
                                    final value = [
                                      'open',
                                      'closed',
                                      'all',
                                    ][index];
                                    setState(() {
                                      _selectedFilter = value;
                                      _loadIssues();
                                    });
                                  },
                                ),
                              ),
                              const Spacer(),
                              AppIconButton(
                                icon: FIcons.listFilter,
                                label: widget.l10n.moreFilters,
                                selected: filter.hasFilters,
                                onPress: _showFilterSheet,
                              ),
                            ],
                          ),
                          if (filter.hasFilters)
                            Padding(
                              padding: const EdgeInsets.only(
                                top: UIConstants.sm,
                              ),
                              child: Wrap(
                                spacing: UIConstants.sm,
                                runSpacing: UIConstants.sm,
                                children: [
                                  ...filter.labels.map(
                                    (label) => AppFilterChip(
                                      label: label,
                                      onRemove: () {
                                        _filterState.value = filter.copyWith(
                                          labels: filter.labels.difference({
                                            label,
                                          }),
                                        );
                                        _loadIssues();
                                      },
                                    ),
                                  ),
                                  ...filter.milestones.map(
                                    (m) => AppFilterChip(
                                      label: m,
                                      onRemove: () {
                                        _filterState.value = filter.copyWith(
                                          milestones: filter.milestones
                                              .difference({m}),
                                        );
                                        _loadIssues();
                                      },
                                    ),
                                  ),
                                  if (filter.type != null)
                                    AppFilterChip(
                                      label: filter.type!,
                                      onRemove: () {
                                        _filterState.value = filter.copyWith(
                                          clearType: true,
                                        );
                                        _loadIssues();
                                      },
                                    ),
                                  if (filter.assignedToMe)
                                    AppFilterChip(
                                      label: widget.l10n.assignedToMe,
                                      onRemove: () {
                                        _filterState.value = filter.copyWith(
                                          assignedToMe: false,
                                        );
                                        _loadIssues();
                                      },
                                    ),
                                  if (filter.createdByMe)
                                    AppFilterChip(
                                      label: widget.l10n.createdByMe,
                                      onRemove: () {
                                        _filterState.value = filter.copyWith(
                                          createdByMe: false,
                                        );
                                        _loadIssues();
                                      },
                                    ),
                                  if (filter.mentionedMe)
                                    AppFilterChip(
                                      label: widget.l10n.mentionedMe,
                                      onRemove: () {
                                        _filterState.value = filter.copyWith(
                                          mentionedMe: false,
                                        );
                                        _loadIssues();
                                      },
                                    ),
                                ],
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
                Expanded(
                  child: switch (issuesState) {
                    IssuesListLoading() => const AppLoading(),
                    IssuesListError(:final message) => AppError(
                      message: message,
                      onRetry: _loadIssues,
                    ),
                    IssuesListLoaded(:final issues) =>
                      issues.isEmpty
                          ? AppEmpty(
                              icon: FIcons.circleDot,
                              title: widget.l10n.noIssues,
                            )
                          : RefreshIndicator(
                              onRefresh: () async {
                                _loadIssues();
                              },
                              child: ListView.builder(
                                padding: const EdgeInsets.fromLTRB(
                                  20,
                                  4,
                                  20,
                                  24,
                                ),
                                itemCount: issues.length,
                                itemBuilder: (context, index) {
                                  final issue = issues[index];
                                  return FadeInWrapper(
                                    delay: Duration(milliseconds: index * 20),
                                    child: _IssueItem(
                                      issue: issue,
                                      owner: widget.owner,
                                      repo: widget.repo,
                                      l10n: widget.l10n,
                                      onRefresh: _loadIssues,
                                    ),
                                  );
                                },
                              ),
                            ),
                    _ => EmptyState(
                      icon: FIcons.bug,
                      title: widget.l10n.noIssues,
                    ),
                  },
                ),
              ],
            ),
            Positioned(
              right: UIConstants.md,
              bottom: UIConstants.md,
              child: _canCreateIssue()
                  ? FButton(
                      variant: .primary,
                      size: .sm,
                      prefix: const Icon(FIcons.plus, size: 14),
                      onPress: () async {
                        final result = await Navigator.of(context).push<Issue>(
                          MaterialPageRoute(
                            builder: (_) => CreateIssuePage(
                              owner: widget.owner,
                              repo: widget.repo,
                            ),
                          ),
                        );
                        if (result != null && context.mounted) {
                          _selectedFilter = 'open';
                          _loadIssues();
                        }
                      },
                      child: Text(widget.l10n.newIssue),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        );
      },
    );
  }
}

class _IssueItem extends StatelessWidget {
  final Issue issue;
  final String owner;
  final String repo;
  final AppLocalizations l10n;
  final VoidCallback? onRefresh;

  const _IssueItem({
    required this.issue,
    required this.owner,
    required this.repo,
    required this.l10n,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOpen = issue.state?.isOpen == true;
    final stateIcon = isOpen ? FIcons.circleAlert : FIcons.circleCheck;
    final stateColor = isOpen ? Colors.green : Colors.purple;

    return PremiumListCard(
      onTap: () async {
        final changed = await Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => IssueDetailPage(
              owner: owner,
              repo: repo,
              index: issue.number ?? 0,
            ),
          ),
        );
        if (changed == true) onRefresh?.call();
      },
      child: Row(
        children: [
          issue.user != null
              ? UserAvatar(user: issue.user!, radius: UIConstants.avatarMd)
              : Icon(stateIcon, color: stateColor, size: UIConstants.iconLg),
          const SizedBox(width: UIConstants.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        issue.title ?? l10n.untitled,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: UIConstants.sm),
                    Text(
                      '#${issue.number ?? 0}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: UIConstants.xs),
                Row(
                  children: [
                    Icon(
                      stateIcon,
                      size: UIConstants.iconSm,
                      color: stateColor,
                    ),
                    const SizedBox(width: UIConstants.xs),
                    Text(
                      isOpen ? l10n.open : l10n.closed,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: stateColor,
                      ),
                    ),
                    if (issue.user?.login != null) ...[
                      Text(
                        ' · ${issue.user!.login!}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    if (issue.created_at != null)
                      Text(
                        ' · ${_relativeTime(issue.created_at!)}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    if ((issue.comments ?? 0) > 0)
                      Text(
                        ' · ${l10n.commentsCountParams(issue.comments!)}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
                if (issue.labels != null && issue.labels!.isNotEmpty) ...[
                  const SizedBox(height: UIConstants.xs),
                  _LabelRow(labels: issue.labels!),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _relativeTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 365) return l10n.ago('${diff.inDays ~/ 365}y');
    if (diff.inDays > 30) return l10n.ago('${diff.inDays ~/ 30}mo');
    if (diff.inDays > 0) return l10n.ago('${diff.inDays}d');
    if (diff.inHours > 0) return l10n.ago('${diff.inHours}h');
    if (diff.inMinutes > 0) return l10n.ago('${diff.inMinutes}m');
    return l10n.justNow;
  }
}

class _LabelRow extends StatelessWidget {
  final List<Label> labels;
  const _LabelRow({required this.labels});

  Color _color(String? hex) {
    if (hex == null || hex.isEmpty) return Colors.grey;
    try {
      final h = hex.replaceFirst('#', '');
      return Color(int.parse('FF$h', radix: 16));
    } catch (_) {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const maxShow = 4;
    final overflow = labels.length - maxShow;

    return Wrap(
      spacing: 4,
      runSpacing: 3,
      children: [
        ...labels.take(maxShow).map((label) {
          final c = _color(label.color);
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            decoration: BoxDecoration(
              color: c.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: c.withValues(alpha: 0.35), width: 0.5),
            ),
            child: Text(
              label.name ?? '',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: c,
                height: 1.2,
              ),
            ),
          );
        }),
        if (overflow > 0)
          Text(
            '+$overflow',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
      ],
    );
  }
}

class _PullRequestsTab extends StatefulWidget {
  final String owner;
  final String repo;
  final AppLocalizations l10n;

  const _PullRequestsTab({
    required this.owner,
    required this.repo,
    required this.l10n,
  });

  @override
  State<_PullRequestsTab> createState() => _PullRequestsTabState();
}

class _PullRequestsTabState extends State<_PullRequestsTab> {
  String _selectedFilter = 'open';

  void _loadPullRequests() {
    Injection.repoNotifier.listPullRequests(
      widget.owner,
      widget.repo,
      state: _selectedFilter,
    );
  }

  bool _canCreatePR() {
    final state = Injection.repoNotifier.state;
    if (state is RepoLoaded) {
      final p = state.repo.permissions;
      return (p?.push == true || p?.admin == true) &&
          state.repo.has_pull_requests != false;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadPullRequests());
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Injection.repoNotifier,
      builder: (context, _) {
        final state = Injection.repoNotifier.pullRequestsState;
        return Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 240,
                        child: AppSegmentedControl(
                          index: [
                            'open',
                            'closed',
                            'all',
                          ].indexOf(_selectedFilter),
                          labels: [
                            widget.l10n.open,
                            widget.l10n.closed,
                            widget.l10n.all,
                          ],
                          onChanged: (index) {
                            final value = ['open', 'closed', 'all'][index];
                            setState(() {
                              _selectedFilter = value;
                              _loadPullRequests();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: switch (state) {
                    PullRequestsLoading() => const AppLoading(),
                    PullRequestsError(:final message) => AppError(
                      message: message,
                      onRetry: _loadPullRequests,
                    ),
                    PullRequestsLoaded(:final pullRequests, :final hasMore) =>
                      pullRequests.isEmpty
                          ? AppEmpty(
                              icon: FIcons.gitPullRequest,
                              title: widget.l10n.noPullRequests,
                            )
                          : RefreshIndicator(
                              onRefresh: () async => _loadPullRequests(),
                              child: ListView.builder(
                                padding: const EdgeInsets.fromLTRB(
                                  20,
                                  4,
                                  20,
                                  24,
                                ),
                                itemCount:
                                    pullRequests.length + (hasMore ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index == pullRequests.length) {
                                    return Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child:
                                            Injection.repoNotifier.prLoadingMore
                                            ? const SizedBox(
                                                height: 24,
                                                width: 24,
                                                child: FCircularProgress(
                                                  size: .xs,
                                                ),
                                              )
                                            : FButton(
                                                variant: .ghost,
                                                size: .sm,
                                                onPress: () => Injection
                                                    .repoNotifier
                                                    .loadMorePullRequests(
                                                      widget.owner,
                                                      widget.repo,
                                                      state: _selectedFilter,
                                                    ),
                                                child: Text(
                                                  widget.l10n.loadMore,
                                                ),
                                              ),
                                      ),
                                    );
                                  }
                                  final pr = pullRequests[index];
                                  return FadeInWrapper(
                                    delay: Duration(milliseconds: index * 20),
                                    child: _PRItem(
                                      pr: pr,
                                      owner: widget.owner,
                                      repo: widget.repo,
                                      l10n: widget.l10n,
                                      onRefresh: _loadPullRequests,
                                    ),
                                  );
                                },
                              ),
                            ),
                    _ => AppEmpty(
                      icon: FIcons.gitPullRequest,
                      title: widget.l10n.noPullRequests,
                    ),
                  },
                ),
              ],
            ),
            Positioned(
              right: UIConstants.md,
              bottom: UIConstants.md,
              child: _canCreatePR()
                  ? FButton(
                      variant: .primary,
                      size: .sm,
                      prefix: const Icon(FIcons.plus, size: 14),
                      onPress: () async {
                        final result = await Navigator.of(context)
                            .push<PullRequest>(
                              MaterialPageRoute(
                                builder: (_) => CreatePRPage(
                                  owner: widget.owner,
                                  repo: widget.repo,
                                ),
                              ),
                            );
                        if (result != null && context.mounted) {
                          _selectedFilter = 'open';
                          _loadPullRequests();
                        }
                      },
                      child: Text(widget.l10n.newPullRequest),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        );
      },
    );
  }
}

class _PRItem extends StatelessWidget {
  final PullRequest pr;
  final String owner;
  final String repo;
  final AppLocalizations l10n;
  final VoidCallback? onRefresh;

  const _PRItem({
    required this.pr,
    required this.owner,
    required this.repo,
    required this.l10n,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    IconData stateIcon;
    Color stateColor;
    if (pr.merged == true) {
      stateIcon = FIcons.gitMerge;
      stateColor = Colors.purple;
    } else if (pr.draft == true) {
      stateIcon = FIcons.filePenLine;
      stateColor = Colors.grey;
    } else {
      stateIcon = FIcons.gitMerge;
      stateColor = Colors.green;
    }

    return PremiumListCard(
      onTap: () async {
        final changed = await Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) =>
                PRDetailPage(owner: owner, repo: repo, index: pr.number ?? 0),
          ),
        );
        if (changed == true) onRefresh?.call();
      },
      child: Row(
        children: [
          pr.user != null
              ? UserAvatar(user: pr.user!, radius: UIConstants.avatarMd)
              : Icon(stateIcon, color: stateColor, size: UIConstants.iconLg),
          const SizedBox(width: UIConstants.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        pr.title ?? l10n.untitled,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: UIConstants.sm),
                    Text(
                      '#${pr.number ?? 0}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: UIConstants.xs),
                Row(
                  children: [
                    Icon(
                      stateIcon,
                      size: UIConstants.iconSm,
                      color: stateColor,
                    ),
                    const SizedBox(width: UIConstants.xs),
                    Text(
                      pr.merged == true
                          ? l10n.merged
                          : pr.draft == true
                          ? l10n.draft
                          : l10n.open,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: stateColor,
                      ),
                    ),
                    if (pr.user?.login != null)
                      Text(
                        ' · ${pr.user!.login!}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    if (pr.created_at != null)
                      Text(
                        ' · ${_relativeTime(pr.created_at!)}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    if ((pr.comments ?? 0) > 0)
                      Text(
                        ' · ${l10n.commentsCountParams(pr.comments!)}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _relativeTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 365) return l10n.ago('${diff.inDays ~/ 365}y');
    if (diff.inDays > 30) return l10n.ago('${diff.inDays ~/ 30}mo');
    if (diff.inDays > 0) return l10n.ago('${diff.inDays}d');
    if (diff.inHours > 0) return l10n.ago('${diff.inHours}h');
    if (diff.inMinutes > 0) return l10n.ago('${diff.inMinutes}m');
    return l10n.justNow;
  }
}

class _ReleasesTab extends StatefulWidget {
  final String owner;
  final String repo;
  final AppLocalizations l10n;

  const _ReleasesTab({
    required this.owner,
    required this.repo,
    required this.l10n,
  });

  @override
  State<_ReleasesTab> createState() => _ReleasesTabState();
}

class _ReleasesTabState extends State<_ReleasesTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Injection.repoNotifier.listReleases(widget.owner, widget.repo);
    });
  }

  bool _canCreateRelease() {
    final state = Injection.repoNotifier.state;
    if (state is RepoLoaded) {
      final p = state.repo.permissions;
      return (p?.push == true || p?.admin == true) &&
          state.repo.has_releases != false;
    }
    return false;
  }

  void _createRelease() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            CreateReleasePage(owner: widget.owner, repo: widget.repo),
      ),
    );
    if (result == true && mounted) {
      Injection.repoNotifier.listReleases(widget.owner, widget.repo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListenableBuilder(
          listenable: Injection.repoNotifier,
          builder: (context, _) {
            final state = Injection.repoNotifier.releasesState;
            return switch (state) {
              ReleasesLoading() => const AppLoading(),
              ReleasesError(:final message) => AppError(
                message: message,
                onRetry: () => Injection.repoNotifier.listReleases(
                  widget.owner,
                  widget.repo,
                ),
              ),
              ReleasesLoaded(:final releases, :final hasMore) =>
                releases.isEmpty
                    ? EmptyState(
                        icon: FIcons.rocket,
                        title: widget.l10n.noReleases,
                      )
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 80),
                        children: [
                          AppSection(
                            title: '',
                            showHeader: false,
                            children: [
                              for (final release in releases)
                                _ReleaseRow(
                                  release: release,
                                  owner: widget.owner,
                                  repo: widget.repo,
                                  l10n: widget.l10n,
                                ),
                            ],
                          ),
                          if (hasMore)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Center(
                                child:
                                    Injection.repoNotifier.releasesLoadingMore
                                    ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: FCircularProgress(size: .xs),
                                      )
                                    : FButton(
                                        variant: .ghost,
                                        size: .sm,
                                        onPress: () => Injection.repoNotifier
                                            .loadMoreReleases(
                                              widget.owner,
                                              widget.repo,
                                            ),
                                        child: Text(widget.l10n.loadMore),
                                      ),
                              ),
                            ),
                        ],
                      ),
              _ => EmptyState(
                icon: FIcons.rocket,
                title: widget.l10n.noReleases,
              ),
            };
          },
        ),
        Positioned(
          right: UIConstants.md,
          bottom: UIConstants.md,
          child: _canCreateRelease()
              ? FButton(
                  prefix: const Icon(FIcons.plus),
                  onPress: _createRelease,
                  child: Text(widget.l10n.createRelease),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _ReleaseRow extends StatelessWidget {
  final Release release;
  final String owner;
  final String repo;
  final AppLocalizations l10n;

  const _ReleaseRow({
    required this.release,
    required this.owner,
    required this.repo,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final author = release.author?.login ?? release.author?.full_name ?? '';
    final date = release.published_at != null
        ? _formatDate(release.published_at!)
        : '';
    final title = release.name?.trim().isNotEmpty == true
        ? release.name!.trim()
        : (release.tag_name ?? '');

    return AppTile(
      leading: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: palette.brandSoft,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Icon(FIcons.rocket, size: 13, color: palette.brand),
      ),
      title: title,
      subtitle: [
        if (release.tag_name != null && release.tag_name != title)
          release.tag_name!,
        if (author.isNotEmpty) author,
        if (date.isNotEmpty) date,
      ].join(' · '),
      showChevron: false,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (release.prerelease == true) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: palette.warningSoft,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                l10n.preRelease,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: palette.warning,
                ),
              ),
            ),
            const SizedBox(width: 6),
          ],
          if (release.draft == true) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: palette.surfaceMuted,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                l10n.draft,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: palette.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: 6),
          ],
          Icon(
            FIcons.chevronRight,
            size: 13,
            color: palette.textSecondary.withValues(alpha: 0.7),
          ),
        ],
      ),
      onPress: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                ReleaseDetailPage(owner: owner, repo: repo, release: release),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 365) return l10n.ago('${diff.inDays ~/ 365}y');
    if (diff.inDays > 30) return l10n.ago('${diff.inDays ~/ 30}mo');
    if (diff.inDays > 0) return l10n.ago('${diff.inDays}d');
    if (diff.inHours > 0) return l10n.ago('${diff.inHours}h');
    if (diff.inMinutes > 0) return l10n.ago('${diff.inMinutes}m');
    return l10n.justNow;
  }
}

class _ReadmePreview extends StatefulWidget {
  final String owner;
  final String repo;
  final String? ref;
  final AppLocalizations l10n;

  const _ReadmePreview({
    required this.owner,
    required this.repo,
    required this.ref,
    required this.l10n,
  });

  @override
  State<_ReadmePreview> createState() => _ReadmePreviewState();
}

class _ReadmePreviewState extends State<_ReadmePreview> {
  String? _content;
  bool _loading = true;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await Injection.getRepoContentsUseCase(
      GetRepoContentsParams(
        owner: widget.owner,
        repo: widget.repo,
        path: 'README.md',
        ref: widget.ref,
      ),
    );
    if (!mounted) return;
    switch (result) {
      case Left<Failure, List<ContentsResponse>>():
        setState(() {
          _loading = false;
          _failed = true;
        });
      case Right<Failure, List<ContentsResponse>>(:final value):
        String? decoded;
        if (value.isNotEmpty && value.first.content != null) {
          try {
            final cleaned = value.first.content!.replaceAll(RegExp(r'\s'), '');
            decoded = utf8.decode(base64Decode(cleaned));
          } catch (_) {
            decoded = null;
          }
        }
        setState(() {
          _loading = false;
          _content = decoded;
          _failed = decoded == null;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_failed) return const SizedBox.shrink();
    final palette = context.palette;

    if (_loading) {
      return AppSurface(
        padding: const EdgeInsets.all(20),
        child: AppSkeleton(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SkeletonLine(widthFactor: 0.22, height: 10),
              SizedBox(height: 14),
              SkeletonLine(widthFactor: 0.7, height: 12),
              SizedBox(height: 8),
              SkeletonLine(widthFactor: 0.9, height: 9),
              SizedBox(height: 6),
              SkeletonLine(widthFactor: 0.8, height: 9),
              SizedBox(height: 6),
              SkeletonLine(widthFactor: 0.45, height: 9),
            ],
          ),
        ),
      );
    }

    final content = _content?.trim() ?? '';
    if (content.isEmpty) return const SizedBox.shrink();
    final preview = content.length > 2600
        ? '${content.substring(0, 2600)}\n\n…'
        : content;

    return AppSurface(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(FIcons.bookOpen, size: 13, color: palette.textSecondary),
              const SizedBox(width: 6),
              Text(
                'README.md',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                  color: palette.textSecondary,
                ),
              ),
              const Spacer(),
              FButton(
                variant: FButtonVariant.ghost,
                size: FButtonSizeVariant.sm,
                onPress: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => RepoFilePage(
                      owner: widget.owner,
                      repo: widget.repo,
                      path: 'README.md',
                      name: 'README.md',
                      ref: widget.ref,
                    ),
                  ),
                ),
                child: Text(widget.l10n.viewAll),
              ),
            ],
          ),
          const SizedBox(height: 8),
          AppMarkdown(data: preview),
        ],
      ),
    );
  }
}

class _SectionItem {
  final String id;
  final String title;
  final IconData icon;

  const _SectionItem({
    required this.id,
    required this.title,
    required this.icon,
  });
}

class _RepoSectionPage extends StatelessWidget {
  final String owner;
  final String repo;
  final String sectionId;
  final String? defaultBranch;

  const _RepoSectionPage({
    required this.owner,
    required this.repo,
    required this.sectionId,
    this.defaultBranch,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = _getTitle(l10n);

    return AppPage(
      title: title,
      subtitle: '$owner/$repo',
      child: _buildSection(l10n),
    );
  }

  String _getTitle(AppLocalizations l10n) {
    return switch (sectionId) {
      'code' => l10n.code,
      'issues' => l10n.issues,
      'milestones' => l10n.milestones,
      'pullRequests' => l10n.pullRequests,
      'releases' => l10n.releases,
      'commits' => l10n.commits,
      'branches' => l10n.branches,
      'tags' => l10n.tags,
      'wiki' => l10n.wiki,
      'webhooks' => l10n.webhooks,
      'collaborators' => l10n.collaborators,
      'branch_protection' => l10n.branchProtection,
      _ => '',
    };
  }

  Widget _buildSection(AppLocalizations l10n) {
    return switch (sectionId) {
      'code' => _CodeTab(
        owner: owner,
        repo: repo,
        defaultBranch: defaultBranch,
      ),
      'issues' => _IssuesTab(owner: owner, repo: repo, l10n: l10n),
      'milestones' => _MilestonesTab(owner: owner, repo: repo, l10n: l10n),
      'pullRequests' => _PullRequestsTab(owner: owner, repo: repo, l10n: l10n),
      'releases' => _ReleasesTab(owner: owner, repo: repo, l10n: l10n),
      'commits' => _CommitsTab(owner: owner, repo: repo, l10n: l10n),
      'branches' => _BranchesTab(
        owner: owner,
        repo: repo,
        defaultBranch: defaultBranch,
      ),
      'tags' => _TagsTab(owner: owner, repo: repo, l10n: l10n),
      'wiki' => WikiListPage(owner: owner, repo: repo),
      _ => Center(child: Text(l10n.unknownSection)),
    };
  }
}

class _CommitsTab extends StatefulWidget {
  final String owner;
  final String repo;
  final AppLocalizations l10n;

  const _CommitsTab({
    required this.owner,
    required this.repo,
    required this.l10n,
  });

  @override
  State<_CommitsTab> createState() => _CommitsTabState();
}

class _CommitsTabState extends State<_CommitsTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Injection.repoNotifier.listCommits(widget.owner, widget.repo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Injection.repoNotifier,
      builder: (context, _) {
        final state = Injection.repoNotifier.commitsState;
        return switch (state) {
          CommitsLoading() => const AppLoading(),
          CommitsError(:final message) => AppError(
            message: message,
            onRetry: () =>
                Injection.repoNotifier.listCommits(widget.owner, widget.repo),
          ),
          CommitsLoaded(:final commits) =>
            commits.isEmpty
                ? EmptyState(
                    icon: FIcons.gitCommitVertical,
                    title: widget.l10n.noCommits,
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                    children: [
                      AppSection(
                        title: '',
                        showHeader: false,
                        children: [
                          for (final commit in commits)
                            _CommitItem(
                              commit: commit,
                              owner: widget.owner,
                              repo: widget.repo,
                              l10n: widget.l10n,
                            ),
                        ],
                      ),
                    ],
                  ),
          _ => EmptyState(
            icon: FIcons.gitCommitVertical,
            title: widget.l10n.noCommits,
          ),
        };
      },
    );
  }
}

class _CommitItem extends StatelessWidget {
  final Commit commit;
  final String owner;
  final String repo;
  final AppLocalizations l10n;

  const _CommitItem({
    required this.commit,
    required this.owner,
    required this.repo,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final message = (commit.commit?.message ?? '').split('\n').first;
    final login = commit.author?.login ?? '';
    final date = commit.created != null ? _formatDate(commit.created!) : '';

    return AppTile(
      leading: commit.author != null
          ? UserAvatar(user: commit.author!, radius: 14)
          : Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: palette.surfaceMuted,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Icon(
                FIcons.gitCommitHorizontal,
                size: 14,
                color: palette.textSecondary,
              ),
            ),
      title: message,
      subtitle: [
        if (login.isNotEmpty) login,
        if (date.isNotEmpty) date,
      ].join(' · '),
      showChevron: false,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (commit.sha != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: palette.surfaceMuted,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: palette.border),
              ),
              child: Text(
                commit.sha!.substring(0, 7),
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: 'monospace',
                  color: palette.textSecondary,
                ),
              ),
            ),
          const SizedBox(width: 6),
          Icon(
            FIcons.chevronRight,
            size: 13,
            color: palette.textSecondary.withValues(alpha: 0.7),
          ),
        ],
      ),
      onPress: () {
        if (commit.sha != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) =>
                  CommitDetailPage(owner: owner, repo: repo, sha: commit.sha!),
            ),
          );
        }
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 365) return l10n.ago('${diff.inDays ~/ 365}y');
    if (diff.inDays > 30) return l10n.ago('${diff.inDays ~/ 30}mo');
    if (diff.inDays > 0) return l10n.ago('${diff.inDays}d');
    if (diff.inHours > 0) return l10n.ago('${diff.inHours}h');
    if (diff.inMinutes > 0) return l10n.ago('${diff.inMinutes}m');
    return l10n.justNow;
  }
}

class _BranchesTab extends StatefulWidget {
  final String owner;
  final String repo;
  final String? defaultBranch;

  const _BranchesTab({
    required this.owner,
    required this.repo,
    this.defaultBranch,
  });

  @override
  State<_BranchesTab> createState() => _BranchesTabState();
}

class _BranchesTabState extends State<_BranchesTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Injection.repoNotifier.listBranches(widget.owner, widget.repo);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListenableBuilder(
      listenable: Injection.repoNotifier,
      builder: (context, _) {
        final state = Injection.repoNotifier.branchesState;
        return switch (state) {
          BranchesLoading() => const AppLoading(),
          BranchesError(:final message) => AppError(
            message: message,
            onRetry: () =>
                Injection.repoNotifier.listBranches(widget.owner, widget.repo),
          ),
          BranchesLoaded(:final branches) =>
            branches.isEmpty
                ? EmptyState(icon: FIcons.gitBranch, title: l10n.noBranches)
                : ListView(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                    children: [
                      AppSection(
                        title: '',
                        showHeader: false,
                        children: [
                          for (final branch in branches)
                            _BranchRow(
                              branch: branch,
                              owner: widget.owner,
                              repo: widget.repo,
                              isDefault: branch.name == widget.defaultBranch,
                              l10n: l10n,
                            ),
                        ],
                      ),
                    ],
                  ),
          _ => EmptyState(icon: FIcons.gitBranch, title: l10n.noBranches),
        };
      },
    );
  }
}

class _BranchRow extends StatelessWidget {
  final Branch branch;
  final String owner;
  final String repo;
  final bool isDefault;
  final AppLocalizations l10n;

  const _BranchRow({
    required this.branch,
    required this.owner,
    required this.repo,
    required this.isDefault,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final commit = branch.commit;
    final message = (commit?.message ?? '').split('\n').first;
    final shortSha = commit?.id != null && commit!.id!.length >= 7
        ? commit.id!.substring(0, 7)
        : '';

    return AppTile(
      leading: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: isDefault ? palette.brandSoft : palette.surfaceMuted,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Icon(
          FIcons.gitBranch,
          size: 13,
          color: isDefault ? palette.brand : palette.textSecondary,
        ),
      ),
      title: branch.name ?? '',
      subtitle: message.isNotEmpty
          ? [if (shortSha.isNotEmpty) shortSha, message].join(' · ')
          : null,
      showChevron: false,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isDefault)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: palette.brandSoft,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                l10n.defaultBranch,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: palette.brand,
                ),
              ),
            ),
          if (branch.protected == true) ...[
            const SizedBox(width: 6),
            Icon(FIcons.shield, size: 12, color: palette.warning),
          ],
          const SizedBox(width: 6),
          Icon(
            FIcons.chevronRight,
            size: 13,
            color: palette.textSecondary.withValues(alpha: 0.7),
          ),
        ],
      ),
      onPress: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => _RepoSectionPage(
              owner: owner,
              repo: repo,
              sectionId: 'code',
              defaultBranch: branch.name,
            ),
          ),
        );
      },
    );
  }
}

class _MilestonesTab extends StatefulWidget {
  final String owner;
  final String repo;
  final AppLocalizations l10n;

  const _MilestonesTab({
    required this.owner,
    required this.repo,
    required this.l10n,
  });

  @override
  State<_MilestonesTab> createState() => _MilestonesTabState();
}

class _MilestonesTabState extends State<_MilestonesTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Injection.issueNotifier.listMilestones(widget.owner, widget.repo);
    });
  }

  Future<void> _createMilestone() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            CreateMilestonePage(owner: widget.owner, repo: widget.repo),
      ),
    );
    if (result == true) {
      Injection.issueNotifier.listMilestones(widget.owner, widget.repo);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListenableBuilder(
      listenable: Injection.issueNotifier,
      builder: (context, _) {
        final state = Injection.issueNotifier.state;
        return switch (state) {
          IssueLoading() => const AppLoading(),
          IssueError(:final message) => AppError(
            message: message,
            onRetry: () => Injection.issueNotifier.listMilestones(
              widget.owner,
              widget.repo,
            ),
          ),
          MilestonesLoaded(:final milestones) => _buildMilestonesList(
            milestones,
            theme,
          ),
          _ => EmptyState(icon: FIcons.flag, title: widget.l10n.noMilestones),
        };
      },
    );
  }

  Widget _buildMilestonesList(List<Milestone> milestones, ThemeData theme) {
    return Stack(
      children: [
        if (milestones.isEmpty)
          AppEmpty(icon: FIcons.flag, title: widget.l10n.noMilestones)
        else
          ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 80),
            children: [
              AppSection(
                title: '',
                showHeader: false,
                children: [
                  for (final milestone in milestones)
                    _MilestoneRow(
                      milestone: milestone,
                      dueText: milestone.due_on != null
                          ? _formatDate(milestone.due_on!)
                          : null,
                      overdue:
                          milestone.due_on?.isBefore(DateTime.now()) ?? false,
                      l10n: widget.l10n,
                      onPress: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => MilestoneDetailPage(
                              owner: widget.owner,
                              repo: widget.repo,
                              milestone: milestone,
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ],
          ),
        Positioned(
          right: 20,
          bottom: 20,
          child: FButton(
            prefix: const Icon(FIcons.plus, size: 14),
            onPress: _createMilestone,
            child: Text(widget.l10n.createMilestone),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 365) return widget.l10n.ago('${diff.inDays ~/ 365}y');
    if (diff.inDays > 30) return widget.l10n.ago('${diff.inDays ~/ 30}mo');
    if (diff.inDays > 0) return widget.l10n.ago('${diff.inDays}d');
    if (diff.inHours > 0) return widget.l10n.ago('${diff.inHours}h');
    return widget.l10n.justNow;
  }
}

class _MilestoneRow extends StatefulWidget {
  final Milestone milestone;
  final String? dueText;
  final bool overdue;
  final AppLocalizations l10n;
  final VoidCallback onPress;

  const _MilestoneRow({
    required this.milestone,
    required this.dueText,
    required this.overdue,
    required this.l10n,
    required this.onPress,
  });

  @override
  State<_MilestoneRow> createState() => _MilestoneRowState();
}

class _MilestoneRowState extends State<_MilestoneRow> {
  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final theme = Theme.of(context);
    final milestone = widget.milestone;
    final open = milestone.open_issues ?? 0;
    final closed = milestone.closed_issues ?? 0;
    final total = open + closed;
    final progress = total > 0 ? closed / total : 0.0;
    final done = total > 0 && closed == total;

    return AppHoverRegion(
      onTap: widget.onPress,
      hoverColor: palette.surfaceMuted.withValues(alpha: 0.55),
      borderRadius: BorderRadius.zero,
      semanticsLabel: milestone.title ?? '',
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  FIcons.flag,
                  size: 14,
                  color: done ? palette.success : palette.textSecondary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    milestone.title ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: palette.textPrimary,
                    ),
                  ),
                ),
                if (widget.dueText != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: widget.overdue
                          ? palette.dangerSoft
                          : palette.surfaceMuted,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          FIcons.calendarClock,
                          size: 10,
                          color: widget.overdue
                              ? palette.danger
                              : palette.textSecondary,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          widget.dueText!,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: widget.overdue
                                ? palette.danger
                                : palette.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                Icon(
                  FIcons.chevronRight,
                  size: 13,
                  color: palette.textSecondary.withValues(alpha: 0.7),
                ),
              ],
            ),
            const SizedBox(height: 9),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 5,
                backgroundColor: palette.surfaceMuted,
                valueColor: AlwaysStoppedAnimation(
                  done ? palette.success : palette.brand,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(
                  '${(progress * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    color: palette.textSecondary,
                  ),
                ),
                const Spacer(),
                Text(
                  '${widget.l10n.open} $open · ${widget.l10n.closed} $closed',
                  style: TextStyle(
                    fontSize: 10.5,
                    color: palette.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TagsTab extends StatefulWidget {
  final String owner;
  final String repo;
  final AppLocalizations l10n;

  const _TagsTab({required this.owner, required this.repo, required this.l10n});

  @override
  State<_TagsTab> createState() => _TagsTabState();
}

class _TagsTabState extends State<_TagsTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Injection.repoNotifier.listTags(widget.owner, widget.repo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Injection.repoNotifier,
      builder: (context, _) {
        final state = Injection.repoNotifier.tagsState;
        return switch (state) {
          TagsLoading() => const AppLoading(),
          TagsError(:final message) => AppError(
            message: message,
            onRetry: () =>
                Injection.repoNotifier.listTags(widget.owner, widget.repo),
          ),
          TagsLoaded(:final tags) =>
            tags.isEmpty
                ? EmptyState(icon: FIcons.tag, title: widget.l10n.noTags)
                : ListView(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                    children: [
                      AppSection(
                        title: '',
                        showHeader: false,
                        children: [
                          for (final tag in tags)
                            _TagRow(tag: tag, l10n: widget.l10n),
                        ],
                      ),
                    ],
                  ),
          _ => EmptyState(icon: FIcons.tag, title: widget.l10n.noTags),
        };
      },
    );
  }
}

class _TagRow extends StatelessWidget {
  final Tag tag;
  final AppLocalizations l10n;

  const _TagRow({required this.tag, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final sha = tag.commit?.sha;
    final hasDownloads = tag.tarball_url != null || tag.zipball_url != null;

    return AppTile(
      leading: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: palette.brandSoft,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Icon(FIcons.tag, size: 13, color: palette.brand),
      ),
      title: tag.name ?? '',
      subtitle: sha != null && sha.length >= 7 ? sha.substring(0, 7) : null,
      showChevron: false,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasDownloads)
            FPopoverMenu(
              menuAnchor: Alignment.topRight,
              childAnchor: Alignment.bottomRight,
              menuBuilder: (context, controller, _) => [
                FItemGroup(
                  children: [
                    if (tag.tarball_url != null)
                      FItem(
                        prefix: const Icon(FIcons.download, size: 14),
                        title: Text(l10n.downloadTarball),
                      ),
                    if (tag.zipball_url != null)
                      FItem(
                        prefix: const Icon(FIcons.download, size: 14),
                        title: Text(l10n.downloadZipball),
                      ),
                  ],
                ),
              ],
              builder: (context, controller, child) => FTappable(
                onPress: () => controller.toggle(),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Icon(
                    FIcons.ellipsisVertical,
                    size: 14,
                    color: palette.textSecondary,
                  ),
                ),
              ),
            ),
          const SizedBox(width: 2),
          Icon(
            FIcons.chevronRight,
            size: 13,
            color: palette.textSecondary.withValues(alpha: 0.7),
          ),
        ],
      ),
      onPress: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => TagDetailPage(tag: tag)));
      },
    );
  }
}

class _LanguageBar extends StatelessWidget {
  final Map<String, int> languages;

  const _LanguageBar({required this.languages});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final total = languages.values.fold<int>(0, (sum, v) => sum + v);
    if (total == 0) return const SizedBox.shrink();

    final sorted = languages.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top = sorted.take(6).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: SizedBox(
            height: 5,
            child: Row(
              children: top.map((e) {
                final ratio = e.value / total;
                final color = languageColor(
                  e.key,
                  fallback: palette.textSecondary,
                );
                return Expanded(
                  flex: (ratio * 1000).round(),
                  child: Container(
                    color: Color.lerp(color, palette.surface, 0.08),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 14,
          runSpacing: 5,
          children: top.map((e) {
            final ratio = e.value / total;
            final color = languageColor(e.key, fallback: palette.textSecondary);
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  e.key,
                  style: TextStyle(fontSize: 11, color: palette.textSecondary),
                ),
                const SizedBox(width: 4),
                Text(
                  '${(ratio * 100).toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 10.5,
                    color: palette.textSecondary.withValues(alpha: 0.75),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}

Future<void> showTopicEditDialog(
  BuildContext context,
  String owner,
  String repo,
  List<String> currentTopics,
) async {
  final topics = List<String>.from(currentTopics);
  final controller = TextEditingController();
  final l10n = AppLocalizations.of(context)!;
  final saved = await showFDialog<bool>(
    context: context,
    builder: (ctx, style, animation) =>
        _TopicEditDialog(topics: topics, controller: controller, l10n: l10n),
  );

  if (saved != true || context.mounted == false) return;

  final result = await Injection.replaceTopicsUseCase.call(owner, repo, topics);
  if (!context.mounted) return;

  switch (result) {
    case Left<Failure, void>(:final value):
      showFToast(
        context: context,
        variant: .destructive,
        title: Text('${l10n.error}: ${value.message}'),
      );
    case Right<Failure, void>():
      showFToast(context: context, title: Text(l10n.saved));
      Injection.repoNotifier.getRepo(owner, repo);
  }
}

class _TopicEditDialog extends StatefulWidget {
  final List<String> topics;
  final TextEditingController controller;
  final AppLocalizations l10n;

  const _TopicEditDialog({
    required this.topics,
    required this.controller,
    required this.l10n,
  });

  @override
  State<_TopicEditDialog> createState() => _TopicEditDialogState();
}

class _TopicEditDialogState extends State<_TopicEditDialog> {
  late List<String> _topics;

  @override
  void initState() {
    super.initState();
    _topics = List.from(widget.topics);
    widget.controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    widget.controller.dispose();
    super.dispose();
  }

  void _onChanged() => setState(() {});

  void _addTopic() {
    final text = widget.controller.text.trim();
    if (text.isEmpty || _topics.contains(text)) return;
    setState(() {
      _topics.add(text);
      widget.controller.clear();
    });
  }

  void _removeTopic(String topic) {
    setState(() => _topics.remove(topic));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FDialog(
      title: Text(widget.l10n.topics),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: FTextField(
                  control: FTextFieldControl.managed(
                    controller: widget.controller,
                  ),
                  hint: widget.l10n.addTopic,
                  onSubmit: (_) => _addTopic(),
                ),
              ),
              const SizedBox(width: 8),
              FButton(
                onPress: widget.controller.text.trim().isEmpty
                    ? null
                    : _addTopic,
                child: Text(widget.l10n.add),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_topics.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  widget.l10n.noTopics,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _topics
                  .map(
                    (t) => AppFilterChip(
                      label: t,
                      onRemove: () => _removeTopic(t),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
      actions: [
        FButton(
          variant: .outline,
          onPress: () => Navigator.pop(context, false),
          child: Text(widget.l10n.cancel),
        ),
        FButton(
          onPress: () => Navigator.pop(context, true),
          child: Text(widget.l10n.save),
        ),
      ],
    );
  }
}

class _SectionIcon extends StatelessWidget {
  const _SectionIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: palette.brandSoft,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 14, color: palette.brand),
    );
  }
}
