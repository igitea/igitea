import 'package:flutter/material.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../presentation/state/issue_notifier.dart';
import '../../presentation/state/repo_notifier.dart';
import '../widgets/user_avatar.dart';
import 'issue_detail_page.dart';
import 'repo_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onSearch() {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;
    Injection.repoNotifier.searchRepos(q: query);
    Injection.issueNotifier.searchIssues(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.source), text: 'Repositories'),
            Tab(icon: Icon(Icons.bug_report), text: 'Issues'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Search...',
              leading: const Icon(Icons.search),
              onSubmitted: (_) => _onSearch(),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _RepoSearchResults(),
                _IssueSearchResults(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RepoSearchResults extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Injection.repoNotifier,
      builder: (context, _) {
        final state = Injection.repoNotifier.state;
        return switch (state) {
          RepoLoading() => const Center(child: CircularProgressIndicator()),
          SearchResultsLoaded(:final results) => _buildRepoList(context, results.data ?? []),
          RepoError(:final message) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Error: $message'),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => Injection.repoNotifier.searchRepos(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          _ => const Center(child: Text('Enter a search query to find repositories')),
        };
      },
    );
  }

  Widget _buildRepoList(BuildContext context, List<Repository> repos) {
    if (repos.isEmpty) {
      return const Center(child: Text('No repositories found.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: repos.length,
      itemBuilder: (context, index) {
        final repo = repos[index];
        return _SearchRepoCard(repo: repo);
      },
    );
  }
}

class _SearchRepoCard extends StatelessWidget {
  final Repository repo;

  const _SearchRepoCard({required this.repo});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => RepoDetailPage(
              owner: repo.owner?.login ?? '',
              repo: repo.name ?? '',
            ),
          ));
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (repo.owner != null)
                    UserAvatar(user: repo.owner!, radius: 14)
                  else
                    Icon(
                      repo.private == true ? Icons.lock : Icons.public,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      repo.full_name ?? repo.name ?? '',
                      style: theme.textTheme.titleSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (repo.private == true) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Private',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              if (repo.description != null && repo.description!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  repo.description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  if (repo.language != null) ...[
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(repo.language!, style: theme.textTheme.labelSmall),
                    const SizedBox(width: 12),
                  ],
                  Icon(Icons.star_outline, size: 14, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: 2),
                  Text('${repo.stars_count ?? 0}', style: theme.textTheme.labelSmall),
                  const SizedBox(width: 12),
                  Icon(Icons.call_split, size: 14, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: 2),
                  Text('${repo.forks_count ?? 0}', style: theme.textTheme.labelSmall),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IssueSearchResults extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Injection.issueNotifier,
      builder: (context, _) {
        final state = Injection.issueNotifier.state;
        return switch (state) {
          IssueLoading() => const Center(child: CircularProgressIndicator()),
          IssueListLoaded(:final issues) => _buildIssueList(context, issues),
          IssueError(:final message) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Error: $message'),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () {
                    final query = Injection.issueNotifier.lastSearchQuery ?? '';
                    Injection.issueNotifier.searchIssues(query);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          _ => const Center(child: Text('Enter a search query to find issues')),
        };
      },
    );
  }

  Widget _buildIssueList(BuildContext context, List<Issue> issues) {
    if (issues.isEmpty) {
      return const Center(child: Text('No issues found.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: issues.length,
      itemBuilder: (context, index) {
        final issue = issues[index];
        return _SearchIssueCard(issue: issue);
      },
    );
  }
}

class _SearchIssueCard extends StatelessWidget {
  final Issue issue;

  const _SearchIssueCard({required this.issue});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOpen = issue.state?.value == 'open';
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          final repoUrl = issue.repository?.full_name ?? '';
          final parts = repoUrl.split('/');
          final owner = parts.isNotEmpty ? parts.first : '';
          final repo = parts.length > 1 ? parts[1] : '';
          if (owner.isNotEmpty && repo.isNotEmpty && issue.number != null) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => IssueDetailPage(
                owner: owner,
                repo: repo,
                index: issue.number!,
              ),
            ));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isOpen ? Colors.green.withValues(alpha: 0.2) : Colors.purple.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isOpen ? 'Open' : 'Closed',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isOpen ? Colors.green : Colors.purple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      issue.title ?? 'Untitled',
                      style: theme.textTheme.titleSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  if (issue.user != null) ...[
                    UserAvatar(user: issue.user!, radius: 10),
                    const SizedBox(width: 4),
                    Text(issue.user!.login ?? '', style: theme.textTheme.labelSmall),
                  ],
                  const Spacer(),
                  if (issue.comments != null) ...[
                    Icon(Icons.comment_outlined, size: 14, color: theme.colorScheme.onSurfaceVariant),
                    const SizedBox(width: 2),
                    Text('${issue.comments}', style: theme.textTheme.labelSmall),
                  ],
                ],
              ),
              if (issue.repository?.full_name != null) ...[
                const SizedBox(height: 4),
                Text(
                  issue.repository!.full_name!,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}