import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../domain/usecases/issue_usecases.dart';
import '../../l10n/app_localizations.dart';
import '../state/repo_notifier.dart';
import '../state/issue_notifier.dart';
import '../widgets/empty_state.dart';
import '../widgets/premium_card.dart';
import '../widgets/user_avatar.dart';
import '../widgets/file_icon.dart';
import 'branch_detail_page.dart';
import 'commit_detail_page.dart';
import 'issue_detail_page.dart';
import 'milestone_detail_page.dart';
import 'pr_detail_page.dart';
import 'release_detail_page.dart';
import 'repo_file_page.dart';
import 'tag_detail_page.dart';

const _languageColors = <String, Color>{
  'Dart': Color(0xFF00B4AB),
  'TypeScript': Color(0xFF3178C6),
  'JavaScript': Color(0xFFF7DF1E),
  'Python': Color(0xFF3572A5),
  'Java': Color(0xFFB07219),
  'Go': Color(0xFF00ADD8),
  'Rust': Color(0xFFDEA584),
  'C': Color(0xFF555555),
  'C++': Color(0xFFF34B7D),
  'C#': Color(0xFF178600),
  'Ruby': Color(0xFFCC342D),
  'PHP': Color(0xFF4F5D95),
  'Swift': Color(0xFFF05138),
  'Kotlin': Color(0xFFA97BFF),
  'Shell': Color(0xFF89E051),
  'HTML': Color(0xFFE34C26),
  'CSS': Color(0xFF563D7C),
  'Lua': Color(0xFF000080),
  'Scala': Color(0xFFDC322F),
  'Vue': Color(0xFF41B883),
  'Objective-C': Color(0xFF438EFF),
  'Perl': Color(0xFF0298C3),
  'Haskell': Color(0xFF5E5086),
  'Elixir': Color(0xFF6E4A7E),
  'Clojure': Color(0xFFDB5855),
};

class RepoDetailPage extends StatefulWidget {
  final String owner;
  final String repo;

  const RepoDetailPage({super.key, required this.owner, required this.repo});

  @override
  State<RepoDetailPage> createState() => _RepoDetailPageState();
}

class _RepoDetailPageState extends State<RepoDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Injection.repoNotifier.getRepo(widget.owner, widget.repo);
      Injection.repoNotifier.checkStarred(widget.owner, widget.repo);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: ListenableBuilder(
        listenable: Injection.repoNotifier,
        builder: (context, _) {
          final state = Injection.repoNotifier.state;
          return switch (state) {
            RepoLoading() => const Center(child: CircularProgressIndicator()),
            RepoError(:final message) => _ErrorView(
                message: message,
                onRetry: () =>
                    Injection.repoNotifier.getRepo(widget.owner, widget.repo),
              ),
            RepoLoaded(:final repo) => _buildContent(context, repo, l10n),
            _ => const Center(child: CircularProgressIndicator()),
          };
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, Repository repo, AppLocalizations l10n) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            title: Text('${widget.owner}/${widget.repo}'),
            actions: [
              IconButton(
                icon: const Icon(Icons.fork_right),
                onPressed: () => _showForkDialog(context, l10n),
              ),
              ListenableBuilder(
                listenable: Injection.repoNotifier,
                builder: (context, _) {
                  final isStarred = Injection.repoNotifier.isStarred;
                  final starLoading = Injection.repoNotifier.starLoading;
                  return IconButton(
                    icon: Icon(
                      isStarred ? Icons.star : Icons.star_outline,
                      color: isStarred ? Colors.amber : null,
                    ),
                    onPressed: starLoading
                        ? null
                        : () => Injection.repoNotifier.toggleStar(widget.owner, widget.repo),
                  );
                },
              ),
            ],
            pinned: true,
            floating: true,
            forceElevated: innerBoxIsScrolled,
          ),
          SliverToBoxAdapter(
            child: _RepoHeader(repo: repo, l10n: l10n),
          ),
          SliverPersistentHeader(
            delegate: _SliverTabBarDelegate(
              TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                padding: const EdgeInsets.symmetric(horizontal: UIConstants.sm),
                labelPadding: const EdgeInsets.symmetric(horizontal: UIConstants.md, vertical: UIConstants.sm),
                indicator: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(UIConstants.cardRadius),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: Theme.of(context).colorScheme.onPrimaryContainer,
                unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
                splashFactory: NoSplash.splashFactory,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                tabs: [
                  Tab(icon: const Icon(Icons.code, size: UIConstants.iconMd), text: l10n.code),
                  Tab(icon: const Icon(Icons.bug_report_outlined, size: UIConstants.iconMd), text: l10n.issues),
                  Tab(icon: const Icon(Icons.flag, size: UIConstants.iconMd), text: l10n.milestones),
                  Tab(icon: const Icon(Icons.merge_type, size: UIConstants.iconMd), text: l10n.pullRequests),
                  Tab(icon: const Icon(Icons.new_releases_outlined, size: UIConstants.iconMd), text: l10n.releases),
                  Tab(icon: const Icon(Icons.commit, size: UIConstants.iconMd), text: l10n.commits),
                  Tab(icon: const Icon(Icons.call_split, size: UIConstants.iconMd), text: l10n.branches),
                  Tab(icon: const Icon(Icons.label, size: UIConstants.iconMd), text: l10n.tags),
                ],
              ),
            ),
            pinned: true,
          ),
        ];
      },
      body: TabBarView(
        controller: _tabController,
        children: [
          _CodeTab(
              owner: widget.owner,
              repo: widget.repo,
              defaultBranch: repo.default_branch),
          _IssuesTab(owner: widget.owner, repo: widget.repo, l10n: l10n),
          _MilestonesTab(owner: widget.owner, repo: widget.repo, l10n: l10n),
          _PullRequestsTab(owner: widget.owner, repo: widget.repo, l10n: l10n),
          _ReleasesTab(owner: widget.owner, repo: widget.repo, l10n: l10n),
          _CommitsTab(owner: widget.owner, repo: widget.repo, l10n: l10n),
          _BranchesTab(
              owner: widget.owner,
              repo: widget.repo,
              defaultBranch: repo.default_branch),
          _TagsTab(owner: widget.owner, repo: widget.repo, l10n: l10n),
        ],
      ),
    );
  }

  Future<void> _showForkDialog(BuildContext context, AppLocalizations l10n) async {
    final result = await Injection.repoNotifier.createFork(widget.owner, widget.repo);
    if (!context.mounted) return;
    switch (result) {
      case Left<Failure, Repository>(:final value):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.error}: ${value.message}')),
        );
      case Right<Failure, Repository>(:final value):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.forked}: ${value.full_name ?? value.name ?? ''}')),
        );
    }
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
      title: l10n.failedToLoadRepo,
      subtitle: message,
      action: FilledButton.icon(
        onPressed: onRetry,
        icon: const Icon(Icons.refresh),
        label: Text(l10n.retry),
      ),
    );
  }
}

class _RepoHeader extends StatelessWidget {
  final Repository repo;
  final AppLocalizations l10n;

  const _RepoHeader({required this.repo, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer.withValues(alpha: 0.3),
            colorScheme.surface,
          ],
        ),
      ),
      child: Padding(
        padding: UIConstants.pagePadding + const EdgeInsets.symmetric(vertical: UIConstants.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (repo.owner != null)
                  UserAvatar(user: repo.owner!, radius: UIConstants.avatarXl)
                else
                  CircleAvatar(
                    radius: UIConstants.avatarXl,
                    backgroundColor: colorScheme.primaryContainer,
                    child: Icon(Icons.source, color: colorScheme.onPrimaryContainer),
                  ),
                const SizedBox(width: UIConstants.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              repo.full_name ?? repo.name ?? '',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (repo.private == true) ...[
                            const SizedBox(width: UIConstants.sm),
                            _Badge(
                              label: l10n.private,
                              color: colorScheme.error,
                              backgroundColor: colorScheme.errorContainer,
                            ),
                          ],
                          if (repo.archived == true) ...[
                            const SizedBox(width: UIConstants.sm),
                            _Badge(
                              label: l10n.archived,
                              color: colorScheme.tertiary,
                              backgroundColor: colorScheme.tertiaryContainer,
                            ),
                          ],
                        ],
                      ),
                      if (repo.owner?.login != null) ...[
                        const SizedBox(height: UIConstants.xs),
                        Text(
                          '@${repo.owner!.login!}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (repo.description != null && repo.description!.isNotEmpty) ...[
              const SizedBox(height: UIConstants.sm),
              Text(
                repo.description!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: UIConstants.md),
            _StatsGrid(repo: repo),
            const SizedBox(height: UIConstants.sm),
            Wrap(
              spacing: UIConstants.sm,
              runSpacing: UIConstants.xs,
              children: [
                if (repo.language != null && repo.language!.isNotEmpty)
                  _LanguageBadge(language: repo.language!),
                if (repo.default_branch != null)
                  _Badge(
                    icon: Icons.call_split,
                    label: repo.default_branch!,
                    color: colorScheme.primary,
                    backgroundColor: colorScheme.primaryContainer,
                  ),
              ],
            ),
            if (repo.clone_url != null || repo.ssh_url != null) ...[
              const SizedBox(height: UIConstants.sm),
              _CloneUrls(repo: repo, l10n: l10n),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final Repository repo;

  const _StatsGrid({required this.repo});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.star_outline,
            value: '${repo.stars_count ?? 0}',
            label: 'Stars',
          ),
        ),
        const SizedBox(width: UIConstants.sm),
        Expanded(
          child: _StatCard(
            icon: Icons.fork_right,
            value: '${repo.forks_count ?? 0}',
            label: 'Forks',
          ),
        ),
        const SizedBox(width: UIConstants.sm),
        Expanded(
          child: _StatCard(
            icon: Icons.visibility_outlined,
            value: '${repo.watchers_count ?? 0}',
            label: 'Watchers',
          ),
        ),
        const SizedBox(width: UIConstants.sm),
        Expanded(
          child: _StatCard(
            icon: Icons.bug_report_outlined,
            value: '${repo.open_issues_count ?? 0}',
            label: 'Issues',
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatCard({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: UIConstants.sm, horizontal: UIConstants.xs),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(UIConstants.badgeRadius),
      ),
      child: Column(
        children: [
          Icon(icon, size: UIConstants.iconSm, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(height: UIConstants.xs),
          Text(
            value,
            style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageBadge extends StatelessWidget {
  final String language;

  const _LanguageBadge({required this.language});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _languageColors[language] ?? const Color(0xFF8B949E),
          ),
        ),
        const SizedBox(width: 4),
        Text(language, style: theme.textTheme.labelSmall),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  final Color backgroundColor;
  final IconData? icon;

  const _Badge({
    required this.label,
    required this.color,
    required this.backgroundColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(UIConstants.badgeRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _CloneUrls extends StatelessWidget {
  final Repository repo;
  final AppLocalizations l10n;

  const _CloneUrls({required this.repo, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (repo.clone_url != null)
          _UrlRow(label: 'HTTPS', url: repo.clone_url!, theme: theme, l10n: l10n),
        if (repo.ssh_url != null)
          _UrlRow(label: 'SSH', url: repo.ssh_url!, theme: theme, l10n: l10n),
      ],
    );
  }
}

class _UrlRow extends StatelessWidget {
  final String label;
  final String url;
  final ThemeData theme;
  final AppLocalizations l10n;

  const _UrlRow({
    required this.label,
    required this.url,
    required this.theme,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: UIConstants.xs),
      padding: const EdgeInsets.symmetric(horizontal: UIConstants.sm, vertical: UIConstants.xs),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(UIConstants.badgeRadius),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            child: Text(label, style: theme.textTheme.labelSmall),
          ),
          Expanded(
            child: Text(
              url,
              style: theme.textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy, size: UIConstants.iconSm),
            visualDensity: VisualDensity.compact,
            tooltip: 'Copy URL',
            onPressed: () {
              Clipboard.setData(ClipboardData(text: url));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.urlCopied)),
              );
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
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        if (_pathStack.isNotEmpty)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: UIConstants.md, vertical: UIConstants.sm),
            padding: const EdgeInsets.symmetric(horizontal: UIConstants.sm, vertical: UIConstants.xs),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(UIConstants.badgeRadius),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, size: UIConstants.iconMd),
                  onPressed: _navigateUp,
                  visualDensity: VisualDensity.compact,
                ),
                Expanded(
                  child: Text(
                    _breadcrumbText,
                    style: theme.textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
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
                ContentsLoading() => const Center(child: CircularProgressIndicator()),
                ContentsError(:final message) => Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${l10n.error}: $message'),
                        const SizedBox(height: UIConstants.md),
                        FilledButton(
                          onPressed: () => Injection.repoNotifier.loadContents(
                            widget.owner,
                            widget.repo,
                            path: _currentPath.isEmpty ? null : _currentPath,
                            ref: widget.defaultBranch,
                          ),
                          child: Text(l10n.retry),
                        ),
                      ],
                    ),
                  ),
                ContentsLoaded(:final contents) => _buildFileList(contents, theme, l10n),
                _ => const Center(child: CircularProgressIndicator()),
              };
            },
          ),
        ),
      ],
    );
  }

  String get _breadcrumbText {
    final parts = [widget.owner, widget.repo];
    if (_currentPath.isNotEmpty) {
      parts.addAll(_currentPath.split('/'));
    }
    return parts.join(' / ');
  }

  Widget _buildFileList(List<ContentsResponse> contents, ThemeData theme, AppLocalizations l10n) {
    if (contents.isEmpty) {
      return EmptyState(icon: Icons.folder_open, title: l10n.emptyDirectory);
    }
    final dirs = contents.where((c) => c.type == 'dir').toList();
    final files = contents.where((c) => c.type != 'dir').toList();
    final sorted = [...dirs, ...files];
    return ListView.builder(
      padding: UIConstants.pagePadding + const EdgeInsets.symmetric(vertical: UIConstants.sm),
      itemCount: sorted.length,
      itemBuilder: (context, index) {
        final item = sorted[index];
        return _FileItem(
          item: item,
          onTap: () {
            if (item.type == 'dir') {
              _navigateTo(item.path ?? item.name ?? '');
            } else {
              _openFile(item);
            }
          },
        );
      },
    );
  }
}

class _FileItem extends StatelessWidget {
  final ContentsResponse item;
  final VoidCallback onTap;

  const _FileItem({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDir = item.type == 'dir';
    return Container(
      margin: const EdgeInsets.only(bottom: UIConstants.xs),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(UIConstants.badgeRadius),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(
          isDir ? Icons.folder : fileIcon(item.type, item.name),
          size: UIConstants.iconMd,
          color: isDir ? Colors.blue : theme.colorScheme.onSurfaceVariant,
        ),
        title: Text(
          item.name ?? '',
          style: theme.textTheme.bodyMedium,
        ),
        trailing: item.size != null && !isDir
            ? Text(
                _formatSize(item.size!),
                style: theme.textTheme.labelSmall?.copyWith(
                  fontFamily: 'monospace',
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              )
            : null,
        onTap: onTap,
      ),
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

  const _IssuesTab({required this.owner, required this.repo, required this.l10n});

  @override
  State<_IssuesTab> createState() => _IssuesTabState();
}

class _IssuesTabState extends State<_IssuesTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Injection.issueNotifier.listIssues(
        ListIssuesParams(owner: widget.owner, repo: widget.repo),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Injection.issueNotifier,
      builder: (context, _) {
        final issuesState = Injection.issueNotifier.issuesListState;
        return switch (issuesState) {
          IssuesListLoading() => const Center(child: CircularProgressIndicator()),
          IssuesListError(:final message) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${widget.l10n.error}: $message'),
                  const SizedBox(height: UIConstants.md),
                  FilledButton(
                    onPressed: () => Injection.issueNotifier.listIssues(
                      ListIssuesParams(owner: widget.owner, repo: widget.repo),
                    ),
                    child: Text(widget.l10n.retry),
                  ),
                ],
              ),
            ),
          IssuesListLoaded(:final issues) => issues.isEmpty
              ? EmptyState(icon: Icons.bug_report_outlined, title: widget.l10n.noIssues)
              : ListView.builder(
                  padding: UIConstants.pagePadding + const EdgeInsets.symmetric(vertical: UIConstants.sm),
                  itemCount: issues.length,
                  itemBuilder: (context, index) {
                    final issue = issues[index];
                    return _IssueItem(
                      issue: issue,
                      owner: widget.owner,
                      repo: widget.repo,
                      l10n: widget.l10n,
                    );
                  },
                ),
          _ => EmptyState(icon: Icons.bug_report_outlined, title: widget.l10n.noIssues),
        };
      },
    );
  }
}

class _IssueItem extends StatelessWidget {
  final Issue issue;
  final String owner;
  final String repo;
  final AppLocalizations l10n;

  const _IssueItem({required this.issue, required this.owner, required this.repo, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final isOpen = issue.state?.value == 'open';
    final stateIcon = isOpen ? Icons.error_outline : Icons.check_circle;
    final stateColor = isOpen ? Colors.green : Colors.purple;

    return PremiumListCard(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => IssueDetailPage(
          owner: owner,
          repo: repo,
          index: issue.number ?? 0,
        ),
      )),
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
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: UIConstants.sm),
                    Text(
                      '#${issue.number ?? 0}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: UIConstants.xs),
                Row(
                  children: [
                    Icon(stateIcon, size: UIConstants.iconSm, color: stateColor),
                    const SizedBox(width: UIConstants.xs),
                    Text(
                      isOpen ? l10n.open : l10n.closed,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: stateColor,
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
}

class _PullRequestsTab extends StatefulWidget {
  final String owner;
  final String repo;
  final AppLocalizations l10n;

  const _PullRequestsTab({required this.owner, required this.repo, required this.l10n});

  @override
  State<_PullRequestsTab> createState() => _PullRequestsTabState();
}

class _PullRequestsTabState extends State<_PullRequestsTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Injection.repoNotifier.listPullRequests(widget.owner, widget.repo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Injection.repoNotifier,
      builder: (context, _) {
        final state = Injection.repoNotifier.pullRequestsState;
        return switch (state) {
          PullRequestsLoading() => const Center(child: CircularProgressIndicator()),
          PullRequestsError(:final message) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${widget.l10n.error}: $message'),
                  const SizedBox(height: UIConstants.md),
                  FilledButton(
                    onPressed: () => Injection.repoNotifier.listPullRequests(
                        widget.owner, widget.repo),
                    child: Text(widget.l10n.retry),
                  ),
                ],
              ),
            ),
          PullRequestsLoaded(:final pullRequests) => pullRequests.isEmpty
              ? EmptyState(icon: Icons.merge_type, title: widget.l10n.noPullRequests)
              : ListView.builder(
                  padding: UIConstants.pagePadding + const EdgeInsets.symmetric(vertical: UIConstants.sm),
                  itemCount: pullRequests.length,
                  itemBuilder: (context, index) {
                    final pr = pullRequests[index];
                    return _PRItem(
                      pr: pr,
                      owner: widget.owner,
                      repo: widget.repo,
                      l10n: widget.l10n,
                    );
                  },
                ),
          _ => EmptyState(icon: Icons.merge_type, title: widget.l10n.noPullRequests),
        };
      },
    );
  }
}

class _PRItem extends StatelessWidget {
  final PullRequest pr;
  final String owner;
  final String repo;
  final AppLocalizations l10n;

  const _PRItem({required this.pr, required this.owner, required this.repo, required this.l10n});

  @override
  Widget build(BuildContext context) {
    IconData stateIcon;
    Color stateColor;
    if (pr.merged == true) {
      stateIcon = Icons.merge_type;
      stateColor = Colors.purple;
    } else if (pr.draft == true) {
      stateIcon = Icons.edit_note;
      stateColor = Colors.grey;
    } else {
      stateIcon = Icons.merge_type;
      stateColor = Colors.green;
    }

    return PremiumListCard(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => PRDetailPage(
          owner: owner,
          repo: repo,
          index: pr.number ?? 0,
        ),
      )),
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
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: UIConstants.sm),
                    Text(
                      '#${pr.number ?? 0}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: UIConstants.xs),
                Row(
                  children: [
                    Icon(stateIcon, size: UIConstants.iconSm, color: stateColor),
                    const SizedBox(width: UIConstants.xs),
                    Text(
                      pr.merged == true ? 'Merged' : pr.draft == true ? 'Draft' : 'Open',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: stateColor,
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
}

class _ReleasesTab extends StatefulWidget {
  final String owner;
  final String repo;
  final AppLocalizations l10n;

  const _ReleasesTab({required this.owner, required this.repo, required this.l10n});

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

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Injection.repoNotifier,
      builder: (context, _) {
        final state = Injection.repoNotifier.releasesState;
        return switch (state) {
          ReleasesLoading() => const Center(child: CircularProgressIndicator()),
          ReleasesError(:final message) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${widget.l10n.error}: $message'),
                  const SizedBox(height: UIConstants.md),
                  FilledButton(
                    onPressed: () => Injection.repoNotifier.listReleases(
                        widget.owner, widget.repo),
                    child: Text(widget.l10n.retry),
                  ),
                ],
              ),
            ),
          ReleasesLoaded(:final releases) => releases.isEmpty
              ? EmptyState(icon: Icons.new_releases_outlined, title: widget.l10n.noReleases)
              : ListView.builder(
                  padding: UIConstants.pagePadding + const EdgeInsets.symmetric(vertical: UIConstants.sm),
                  itemCount: releases.length,
                  itemBuilder: (context, index) {
                    final release = releases[index];
                    return _ReleaseItem(release: release, l10n: widget.l10n);
                  },
                ),
          _ => EmptyState(icon: Icons.new_releases_outlined, title: widget.l10n.noReleases),
        };
      },
    );
  }
}

class _ReleaseItem extends StatelessWidget {
  final Release release;
  final AppLocalizations l10n;

  const _ReleaseItem({required this.release, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PremiumListCard(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ReleaseDetailPage(release: release),
          ),
        );
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(UIConstants.sm),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.new_releases_outlined,
              size: UIConstants.iconMd,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: UIConstants.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        release.tag_name ?? '',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (release.prerelease == true) ...[
                      const SizedBox(width: UIConstants.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(UIConstants.badgeRadius),
                        ),
                        child: Text(
                          l10n.preRelease,
                          style: theme.textTheme.labelSmall?.copyWith(color: Colors.orange),
                        ),
                      ),
                    ],
                  ],
                ),
                if (release.author != null) ...[
                  const SizedBox(height: UIConstants.xs),
                  Text(
                    release.author!.login ?? release.author!.full_name ?? '',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (release.published_at != null)
            Text(
              _formatDate(release.published_at!),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 365) return '${diff.inDays ~/ 365}y ago';
    if (diff.inDays > 30) return '${diff.inDays ~/ 30}mo ago';
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    return 'just now';
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _SliverTabBarDelegate oldDelegate) {
    return false;
  }
}

class _CommitsTab extends StatefulWidget {
  final String owner;
  final String repo;
  final AppLocalizations l10n;

  const _CommitsTab({required this.owner, required this.repo, required this.l10n});

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
          CommitsLoading() => const Center(child: CircularProgressIndicator()),
          CommitsError(:final message) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${widget.l10n.error}: $message'),
                  const SizedBox(height: UIConstants.md),
                  FilledButton(
                    onPressed: () => Injection.repoNotifier.listCommits(
                        widget.owner, widget.repo),
                    child: Text(widget.l10n.retry),
                  ),
                ],
              ),
            ),
          CommitsLoaded(:final commits) => commits.isEmpty
              ? EmptyState(icon: Icons.commit, title: widget.l10n.noCommits)
              : ListView.builder(
                  padding: UIConstants.pagePadding + const EdgeInsets.symmetric(vertical: UIConstants.sm),
                  itemCount: commits.length,
                  itemBuilder: (context, index) {
                    final commit = commits[index];
                    return _CommitItem(
                      commit: commit,
                      owner: widget.owner,
                      repo: widget.repo,
                      l10n: widget.l10n,
                    );
                  },
                ),
          _ => EmptyState(icon: Icons.commit, title: widget.l10n.noCommits),
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
    final theme = Theme.of(context);
    return PremiumListCard(
      onTap: () {
        if (commit.sha != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CommitDetailPage(
                owner: owner,
                repo: repo,
                sha: commit.sha!,
              ),
            ),
          );
        }
      },
      child: Row(
        children: [
          commit.author != null
              ? UserAvatar(user: commit.author!, radius: UIConstants.avatarMd)
              : Container(
                  padding: const EdgeInsets.all(UIConstants.xs),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.person_outline, size: UIConstants.iconMd),
                ),
          const SizedBox(width: UIConstants.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  commit.commit?.message ?? '',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: UIConstants.xs),
                Row(
                  children: [
                    if (commit.author?.login != null)
                      Text(
                        commit.author!.login!,
                        style: theme.textTheme.bodySmall,
                      ),
                    if (commit.created != null) ...[
                      const SizedBox(width: UIConstants.sm),
                      Text(
                        _formatDate(commit.created!),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (commit.sha != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(UIConstants.badgeRadius),
              ),
              child: Text(
                commit.sha!.substring(0, 7),
                style: theme.textTheme.labelSmall?.copyWith(
                  fontFamily: 'monospace',
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 365) return '${diff.inDays ~/ 365}y ago';
    if (diff.inDays > 30) return '${diff.inDays ~/ 30}mo ago';
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'just now';
  }
}

class _BranchesTab extends StatefulWidget {
  final String owner;
  final String repo;
  final String? defaultBranch;

  const _BranchesTab({required this.owner, required this.repo, this.defaultBranch});

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
          BranchesLoading() => const Center(child: CircularProgressIndicator()),
          BranchesError(:final message) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${l10n.error}: $message'),
                  const SizedBox(height: UIConstants.md),
                  FilledButton(
                    onPressed: () => Injection.repoNotifier.listBranches(
                        widget.owner, widget.repo),
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            ),
          BranchesLoaded(:final branches) => branches.isEmpty
              ? EmptyState(icon: Icons.call_split, title: l10n.noBranches)
              : ListView.builder(
                  padding: UIConstants.pagePadding + const EdgeInsets.symmetric(vertical: UIConstants.sm),
                  itemCount: branches.length,
                  itemBuilder: (context, index) {
                    final branch = branches[index];
                    final isDefault = branch.name == widget.defaultBranch;
                    return PremiumListCard(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => BranchDetailPage(branch: branch),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.call_split,
                            size: UIConstants.iconMd,
                            color: isDefault
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: UIConstants.md),
                          Expanded(
                            child: Text(
                              branch.name ?? '',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: isDefault ? FontWeight.w500 : null,
                              ),
                            ),
                          ),
                          if (isDefault)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(UIConstants.badgeRadius),
                              ),
                              child: Text(
                                l10n.defaultBranch,
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
          _ => EmptyState(icon: Icons.call_split, title: l10n.noBranches),
        };
      },
    );
  }
}

class _MilestonesTab extends StatefulWidget {
  final String owner;
  final String repo;
  final AppLocalizations l10n;

  const _MilestonesTab({required this.owner, required this.repo, required this.l10n});

  @override
  State<_MilestonesTab> createState() => _MilestonesTabState();
}

class _MilestonesTabState extends State<_MilestonesTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Injection.issueNotifier.listMilestones(
        widget.owner,
        widget.repo,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListenableBuilder(
      listenable: Injection.issueNotifier,
      builder: (context, _) {
        final state = Injection.issueNotifier.state;
        return switch (state) {
          IssueLoading() => const Center(child: CircularProgressIndicator()),
          IssueError(:final message) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${widget.l10n.error}: $message'),
                  const SizedBox(height: UIConstants.md),
                  FilledButton(
                    onPressed: () => Injection.issueNotifier.listMilestones(
                        widget.owner, widget.repo),
                    child: Text(widget.l10n.retry),
                  ),
                ],
              ),
            ),
          MilestonesLoaded(:final milestones) => milestones.isEmpty
              ? EmptyState(icon: Icons.flag, title: widget.l10n.noMilestones)
              : ListView.builder(
                  padding: UIConstants.pagePadding + const EdgeInsets.symmetric(vertical: UIConstants.sm),
                  itemCount: milestones.length,
                  itemBuilder: (context, index) {
                    final milestone = milestones[index];
                    final total = (milestone.open_issues ?? 0) + (milestone.closed_issues ?? 0);
                    final progress = total > 0 ? (milestone.closed_issues ?? 0) / total : 0.0;
                    return PremiumListCard(
                      onTap: () {
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  milestone.title ?? '',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              if (milestone.due_on != null)
                                Text(
                                  _formatDate(milestone.due_on!),
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: UIConstants.sm),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(UIConstants.badgeRadius),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 6,
                              backgroundColor: theme.colorScheme.surfaceContainerHighest,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                progress >= 1.0 ? Colors.green : theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(height: UIConstants.xs),
                          Row(
                            children: [
                              Text(
                                '${(progress * 100).toStringAsFixed(0)}%',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${milestone.open_issues ?? 0} ${widget.l10n.open} · ${milestone.closed_issues ?? 0} ${widget.l10n.closed}',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
          _ => EmptyState(icon: Icons.flag, title: widget.l10n.noMilestones),
        };
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 365) return '${diff.inDays ~/ 365}y ago';
    if (diff.inDays > 30) return '${diff.inDays ~/ 30}mo ago';
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    return 'just now';
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
          TagsLoading() => const Center(child: CircularProgressIndicator()),
          TagsError(:final message) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${widget.l10n.error}: $message'),
                  const SizedBox(height: UIConstants.md),
                  FilledButton(
                    onPressed: () => Injection.repoNotifier.listTags(
                        widget.owner, widget.repo),
                    child: Text(widget.l10n.retry),
                  ),
                ],
              ),
            ),
          TagsLoaded(:final tags) => tags.isEmpty
              ? EmptyState(icon: Icons.label, title: widget.l10n.noTags)
              : ListView.builder(
                  padding: UIConstants.pagePadding + const EdgeInsets.symmetric(vertical: UIConstants.sm),
                  itemCount: tags.length,
                  itemBuilder: (context, index) {
                    final tag = tags[index];
                    return PremiumListCard(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => TagDetailPage(tag: tag),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(UIConstants.sm),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.label,
                              size: UIConstants.iconMd,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: UIConstants.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tag.name ?? '',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (tag.commit?.sha != null) ...[
                                  const SizedBox(height: UIConstants.xs),
                                  Text(
                                    tag.commit!.sha!.substring(0, 7),
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontFamily: 'monospace',
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (tag.tarball_url != null || tag.zipball_url != null)
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert, size: UIConstants.iconMd),
                              itemBuilder: (context) => [
                                if (tag.tarball_url != null)
                                  PopupMenuItem(
                                    value: 'tarball',
                                    child: Text(widget.l10n.downloadTarball),
                                  ),
                                if (tag.zipball_url != null)
                                  PopupMenuItem(
                                    value: 'zipball',
                                    child: Text(widget.l10n.downloadZipball),
                                  ),
                              ],
                            ),
                        ],
                      ),
                    );
                  },
                ),
          _ => EmptyState(icon: Icons.label, title: widget.l10n.noTags),
        };
      },
    );
  }
}