import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../domain/usecases/issue_usecases.dart';
import '../../l10n/app_localizations.dart';
import '../state/repo_notifier.dart';
import '../state/issue_notifier.dart';
import '../widgets/user_avatar.dart';
import '../widgets/file_icon.dart';
import 'branch_detail_page.dart';
import 'commit_detail_page.dart';
import 'issue_detail_page.dart';
import 'pr_detail_page.dart';
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
    _tabController = TabController(length: 7, vsync: this);
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
                tabs: [
                  Tab(icon: Icon(Icons.code), text: l10n.code),
                  Tab(icon: Icon(Icons.bug_report_outlined), text: l10n.issues),
                  Tab(icon: Icon(Icons.merge_type), text: l10n.pullRequests),
                  Tab(icon: Icon(Icons.new_releases_outlined), text: l10n.releases),
                  Tab(icon: Icon(Icons.commit), text: l10n.commits),
                  Tab(icon: Icon(Icons.call_split), text: l10n.branches),
                  Tab(icon: Icon(Icons.label), text: l10n.tags),
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
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline,
              size: 48, color: Theme.of(context).colorScheme.error),
          const SizedBox(height: 16),
          Text(l10n.failedToLoadRepo,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: Text(l10n.retry),
          ),
        ],
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (repo.owner != null)
                UserAvatar(user: repo.owner!, radius: 20)
              else
                const CircleAvatar(
                    radius: 20, child: Icon(Icons.source)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            repo.full_name ?? repo.name ?? '',
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (repo.private == true) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.errorContainer,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(l10n.private,
                                style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.onErrorContainer)),
                          ),
                        ],
                        if (repo.archived == true) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.tertiaryContainer,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(l10n.archived,
                                style: theme.textTheme.labelSmall?.copyWith(
                                    color:
                                        theme.colorScheme.onTertiaryContainer)),
                          ),
                        ],
                      ],
                    ),
                    if (repo.owner?.login != null) ...[
                      const SizedBox(height: 2),
                      Text('@${repo.owner!.login!}',
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant)),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (repo.description != null && repo.description!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(repo.description!, style: theme.textTheme.bodyMedium),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 4,
            children: [
              _StatChip(
                  icon: Icons.star_outline,
                  label: '${repo.stars_count ?? 0}'),
              _StatChip(
                  icon: Icons.fork_right,
                  label: '${repo.forks_count ?? 0}'),
              _StatChip(
                  icon: Icons.visibility_outlined,
                  label: '${repo.watchers_count ?? 0}'),
              _StatChip(
                  icon: Icons.bug_report_outlined,
                  label: '${repo.open_issues_count ?? 0}'),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              if (repo.language != null && repo.language!.isNotEmpty)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _languageColors[repo.language!] ??
                            const Color(0xFF8B949E),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(repo.language!, style: theme.textTheme.labelSmall),
                  ],
                ),
              if (repo.default_branch != null)
                _Badge(
                    icon: Icons.call_split,
                    label: repo.default_branch!,
                    color: theme.colorScheme.primary),
            ],
          ),
          if (repo.clone_url != null || repo.ssh_url != null) ...[
            const SizedBox(height: 8),
            _CloneUrls(repo: repo, l10n: l10n),
          ],
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(label, style: theme.textTheme.labelMedium),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _Badge(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(label,
              style: theme.textTheme.labelSmall?.copyWith(color: color)),
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
          _UrlRow(
              label: 'HTTPS', url: repo.clone_url!, theme: theme, context: context, l10n: l10n),
        if (repo.ssh_url != null)
          _UrlRow(
              label: 'SSH', url: repo.ssh_url!, theme: theme, context: context, l10n: l10n),
      ],
    );
  }
}

class _UrlRow extends StatelessWidget {
  final String label;
  final String url;
  final ThemeData theme;
  final BuildContext context;
  final AppLocalizations l10n;

  const _UrlRow({
    required this.label,
    required this.url,
    required this.theme,
    required this.context,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            child: Text(label, style: theme.textTheme.labelSmall),
          ),
          Expanded(
            child: Text(url,
                style: theme.textTheme.bodySmall, overflow: TextOverflow.ellipsis),
          ),
          IconButton(
            icon: const Icon(Icons.copy, size: 16),
            visualDensity: VisualDensity.compact,
            tooltip: 'Copy URL',
            onPressed: () {
              Clipboard.setData(ClipboardData(text: url));
              ScaffoldMessenger.of(this.context).showSnackBar(
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

  const _CodeTab(
      {required this.owner, required this.repo, this.defaultBranch});

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, size: 20),
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
                ContentsLoading() =>
                  const Center(child: CircularProgressIndicator()),
                ContentsError(:final message) => Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${l10n.error}: $message'),
                        const SizedBox(height: 16),
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
      return Center(child: Text(l10n.emptyDirectory));
    }
    final dirs = contents.where((c) => c.type == 'dir').toList();
    final files = contents.where((c) => c.type != 'dir').toList();
    final sorted = [...dirs, ...files];
    return ListView.builder(
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
    return ListTile(
      dense: true,
      leading: Icon(
        isDir ? Icons.folder : fileIcon(item.type, item.name),
        size: 20,
        color: isDir ? Colors.blue : null,
      ),
      title: Text(item.name ?? '', style: theme.textTheme.bodyMedium),
      trailing: item.size != null && !isDir
          ? Text(_formatSize(item.size!),
              style: theme.textTheme.labelSmall)
          : null,
      onTap: onTap,
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
                  const SizedBox(height: 16),
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
              ? Center(child: Text(widget.l10n.noIssues))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
          _ => Center(child: Text(widget.l10n.noIssues)),
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

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: issue.user != null
            ? UserAvatar(user: issue.user!, radius: 16)
            : Icon(stateIcon, color: stateColor),
        title: Text(
          issue.title ?? l10n.untitled,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text('#${issue.number ?? 0}'),
        trailing: Icon(stateIcon, color: stateColor, size: 16),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => IssueDetailPage(
            owner: owner,
            repo: repo,
            index: issue.number ?? 0,
          ),
        )),
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
          PullRequestsLoading() =>
            const Center(child: CircularProgressIndicator()),
          PullRequestsError(:final message) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${widget.l10n.error}: $message'),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => Injection.repoNotifier.listPullRequests(
                        widget.owner, widget.repo),
                    child: Text(widget.l10n.retry),
                  ),
                ],
              ),
            ),
          PullRequestsLoaded(:final pullRequests) => pullRequests.isEmpty
              ? Center(child: Text(widget.l10n.noPullRequests))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
          _ => Center(child: Text(widget.l10n.noPullRequests)),
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

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: pr.user != null
            ? UserAvatar(user: pr.user!, radius: 16)
            : Icon(stateIcon, color: stateColor),
        title: Text(
          pr.title ?? l10n.untitled,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text('#${pr.number ?? 0}'),
        trailing: Icon(stateIcon, color: stateColor, size: 16),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => PRDetailPage(
            owner: owner,
            repo: repo,
            index: pr.number ?? 0,
          ),
        )),
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
          ReleasesLoading() =>
            const Center(child: CircularProgressIndicator()),
          ReleasesError(:final message) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${widget.l10n.error}: $message'),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => Injection.repoNotifier.listReleases(
                        widget.owner, widget.repo),
                    child: Text(widget.l10n.retry),
                  ),
                ],
              ),
            ),
          ReleasesLoaded(:final releases) => releases.isEmpty
              ? Center(child: Text(widget.l10n.noReleases))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: releases.length,
                  itemBuilder: (context, index) {
                    final release = releases[index];
                    return _ReleaseItem(release: release, l10n: widget.l10n);
                  },
                ),
          _ => Center(child: Text(widget.l10n.noReleases)),
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
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.new_releases_outlined),
        title: Row(
          children: [
            Text(release.tag_name ?? '',
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            if (release.prerelease == true) ...[
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(l10n.preRelease,
                    style: theme.textTheme.labelSmall
                        ?.copyWith(color: Colors.orange)),
              ),
            ],
          ],
        ),
        subtitle: release.author != null
            ? Text(release.author!.login ?? release.author!.full_name ?? '',
                style: theme.textTheme.bodySmall)
            : null,
        trailing: release.published_at != null
            ? Text(_formatDate(release.published_at!),
                style: theme.textTheme.labelSmall)
            : null,
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

class _BranchesTab extends StatefulWidget {
  final String owner;
  final String repo;
  final String? defaultBranch;

  const _BranchesTab(
      {required this.owner, required this.repo, this.defaultBranch});

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
        final state = Injection.repoNotifier.state;
        if (state is BranchesLoaded) {
          final branches = state.branches;
          if (branches.isEmpty) {
            return Center(child: Text(l10n.noBranches));
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: branches.length,
            itemBuilder: (context, index) {
              final branch = branches[index];
              final isDefault = branch.name == widget.defaultBranch;
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Icon(Icons.call_split,
                      color: isDefault
                          ? Theme.of(context).colorScheme.primary
                          : null),
                  title: Row(
                    children: [
                      Flexible(child: Text(branch.name ?? '')),
                      if (isDefault) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primaryContainer,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(l10n.defaultBranch,
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer)),
                        ),
                      ],
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BranchDetailPage(branch: branch),
                      ),
                    );
                  },
                ),
              );
            },
          );
        }
        if (state is RepoError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${l10n.error}: ${state.message}'),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => Injection.repoNotifier.listBranches(
                      widget.owner, widget.repo),
                  child: Text(l10n.retry),
                ),
              ],
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
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

  const _CommitsTab(
      {required this.owner, required this.repo, required this.l10n});

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
        final state = Injection.repoNotifier.state;
        if (state is CommitsLoaded) {
          final commits = state.commits;
          if (commits.isEmpty) {
            return Center(child: Text(widget.l10n.noCommits));
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
          );
        }
        if (state is RepoError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${widget.l10n.error}: ${state.message}'),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => Injection.repoNotifier.listCommits(
                      widget.owner, widget.repo),
                  child: Text(widget.l10n.retry),
                ),
              ],
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
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
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: commit.author != null
            ? UserAvatar(user: commit.author!, radius: 16)
            : const Icon(Icons.person_outline),
        title: Text(
          commit.commit?.message ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Row(
          children: [
            if (commit.author?.login != null)
              Text(
                commit.author!.login!,
                style: theme.textTheme.bodySmall,
              ),
            if (commit.created != null) ...[
              const SizedBox(width: 8),
              Text(
                _formatDate(commit.created!),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
        trailing: commit.sha != null
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  commit.sha!.substring(0, 7),
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontFamily: 'monospace',
                  ),
                ),
              )
            : null,
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

class _TagsTab extends StatefulWidget {
  final String owner;
  final String repo;
  final AppLocalizations l10n;

  const _TagsTab(
      {required this.owner, required this.repo, required this.l10n});

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
        final state = Injection.repoNotifier.state;
        if (state is TagsLoaded) {
          final tags = state.tags;
          if (tags.isEmpty) {
            return Center(child: Text(widget.l10n.noTags));
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: tags.length,
            itemBuilder: (context, index) {
              final tag = tags[index];
              return _TagItem(tag: tag, l10n: widget.l10n);
            },
          );
        }
        if (state is RepoError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${widget.l10n.error}: ${state.message}'),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => Injection.repoNotifier.listTags(
                      widget.owner, widget.repo),
                  child: Text(widget.l10n.retry),
                ),
              ],
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _TagItem extends StatelessWidget {
  final Tag tag;
  final AppLocalizations l10n;

  const _TagItem({required this.tag, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(Icons.label, color: theme.colorScheme.primary),
        title: Text(tag.name ?? ''),
        subtitle: tag.commit?.sha != null
            ? Text(
                tag.commit!.sha!.substring(0, 7),
                style: theme.textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                ),
              )
            : null,
        trailing: tag.tarball_url != null || tag.zipball_url != null
            ? PopupMenuButton<String>(
                itemBuilder: (context) => [
                  if (tag.tarball_url != null)
                    PopupMenuItem(
                      value: 'tarball',
                      child: Text(l10n.downloadTarball),
                    ),
                  if (tag.zipball_url != null)
                    PopupMenuItem(
                      value: 'zipball',
                      child: Text(l10n.downloadZipball),
                    ),
                ],
              )
            : null,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => TagDetailPage(tag: tag),
            ),
          );
        },
      ),
    );
  }
}
