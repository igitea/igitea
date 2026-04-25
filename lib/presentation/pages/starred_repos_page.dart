import 'package:flutter/material.dart';

import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../state/user_notifier.dart';
import '../widgets/user_avatar.dart';
import 'repo_detail_page.dart';

class StarredReposPage extends StatefulWidget {
  const StarredReposPage({super.key});

  @override
  State<StarredReposPage> createState() => _StarredReposPageState();
}

class _StarredReposPageState extends State<StarredReposPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Injection.userNotifier.listStarredRepos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.starredRepos),
      ),
      body: ListenableBuilder(
        listenable: Injection.userNotifier,
        builder: (context, _) {
          final state = Injection.userNotifier.state;
          final starredRepos = Injection.userNotifier.starredRepos;
          return switch (state) {
            UserLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            UserError(:final message) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(message),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () =>
                          Injection.userNotifier.listStarredRepos(),
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
              ),
            _ => starredRepos.isEmpty
                ? Center(child: Text(l10n.noData))
                : RefreshIndicator(
                    onRefresh: () =>
                        Injection.userNotifier.listStarredRepos(),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: starredRepos.length,
                      itemBuilder: (context, index) {
                        final repo = starredRepos[index];
                        return _RepoCard(repo: repo);
                      },
                    ),
                  ),
          };
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 1),
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
              if (repo.description != null &&
                  repo.description!.isNotEmpty) ...[
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
                    Icons.call_split,
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
