import 'package:flutter/material.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../state/repo_notifier.dart';
import '../widgets/user_avatar.dart';
import 'repo_detail_page.dart';

class RepoListPage extends StatefulWidget {
  const RepoListPage({super.key});

  @override
  State<RepoListPage> createState() => _RepoListPageState();
}

class _RepoListPageState extends State<RepoListPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Injection.repoNotifier.searchRepos();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    Injection.repoNotifier.searchRepos(q: query.isEmpty ? null : query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Repositories')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Search repositories...',
              leading: const Icon(Icons.search),
              onChanged: _onSearch,
            ),
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: Injection.repoNotifier,
              builder: (context, _) {
                final state = Injection.repoNotifier.state;
                return switch (state) {
                  RepoLoading() => const Center(
                    child: CircularProgressIndicator(),
                  ),
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
                  SearchResultsLoaded(:final results) => _RepoList(
                    repos: results.data ?? [],
                  ),
                  RepoInitial() => const Center(
                    child: Text('Search for repositories'),
                  ),
                  _ => const Center(child: Text('Search for repositories')),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RepoList extends StatelessWidget {
  final List<Repository> repos;

  const _RepoList({required this.repos});

  @override
  Widget build(BuildContext context) {
    if (repos.isEmpty) {
      return const Center(child: Text('No repositories found.'));
    }
    return RefreshIndicator(
      onRefresh: () => Injection.repoNotifier.searchRepos(),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: repos.length,
        itemBuilder: (context, index) {
          final repo = repos[index];
          return _RepoCard(repo: repo);
        },
      ),
    );
  }
}

class _RepoCard extends StatelessWidget {
  final Repository repo;

  const _RepoCard({required this.repo});

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
                    child: Row(
                      children: [
                        Flexible(
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
                  ),
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
                  Icon(
                    Icons.star_outline,
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${repo.stars_count ?? 0}',
                    style: theme.textTheme.labelSmall,
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    GitHubFork.icon,
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${repo.forks_count ?? 0}',
                    style: theme.textTheme.labelSmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GitHubFork {
  static IconData get icon => Icons.call_split;
}
