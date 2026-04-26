import 'package:flutter/material.dart';
import '../../core/animations/animated_wrapper.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../../presentation/state/issue_notifier.dart';
import '../../presentation/state/repo_notifier.dart';
import '../widgets/empty_state.dart';
import '../widgets/premium_card.dart';
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.search),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: const Icon(Icons.source), text: l10n.repositories),
            Tab(icon: const Icon(Icons.bug_report), text: l10n.issues),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(UIConstants.md),
            child: SearchBar(
              controller: _searchController,
              hintText: l10n.search,
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
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: Injection.repoNotifier,
      builder: (context, _) {
        final state = Injection.repoNotifier.state;
        return switch (state) {
          RepoLoading() => const Center(child: CircularProgressIndicator()),
          SearchResultsLoaded(:final results) => _buildRepoList(context, results.data ?? [], l10n),
          RepoError(:final message) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${l10n.error}: $message'),
                const SizedBox(height: UIConstants.md),
                FilledButton(
                  onPressed: () => Injection.repoNotifier.searchRepos(),
                  child: Text(l10n.retry),
                ),
              ],
            ),
          ),
          _ => EmptyState(icon: Icons.search, title: l10n.enterSearchQueryRepos),
        };
      },
    );
  }

  Widget _buildRepoList(BuildContext context, List<Repository> repos, AppLocalizations l10n) {
    if (repos.isEmpty) {
      return EmptyState(icon: Icons.source, title: l10n.noRepositoriesFound);
    }
    return ListView.builder(
      padding: UIConstants.pagePadding + const EdgeInsets.symmetric(vertical: UIConstants.sm),
      itemCount: repos.length,
      itemBuilder: (context, index) {
        final repo = repos[index];
        return FadeInWrapper(
          delay: Duration(milliseconds: index * 30),
          child: _SearchRepoCard(repo: repo),
        );
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
    final l10n = AppLocalizations.of(context)!;

    return PremiumListCard(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => RepoDetailPage(
            owner: repo.owner?.login ?? '',
            repo: repo.name ?? '',
          ),
        ));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (repo.owner != null)
                UserAvatar(user: repo.owner!, radius: UIConstants.avatarSm)
              else
                Icon(
                  repo.private == true ? Icons.lock : Icons.public,
                  size: UIConstants.iconMd,
                  color: theme.colorScheme.primary,
                ),
              const SizedBox(width: UIConstants.sm),
              Expanded(
                child: Text(
                  repo.full_name ?? repo.name ?? '',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (repo.private == true) ...[
                const SizedBox(width: UIConstants.sm),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(UIConstants.badgeRadius),
                  ),
                  child: Text(
                    l10n.private,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (repo.description != null && repo.description!.isNotEmpty) ...[
            const SizedBox(height: UIConstants.sm),
            Text(
              repo.description!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: UIConstants.sm),
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
                const SizedBox(width: UIConstants.xs),
                Text(repo.language!, style: theme.textTheme.labelSmall),
                const SizedBox(width: UIConstants.md),
              ],
              Icon(Icons.star_outline, size: UIConstants.iconSm, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: UIConstants.xs),
              Text('${repo.stars_count ?? 0}', style: theme.textTheme.labelSmall),
              const SizedBox(width: UIConstants.md),
              Icon(Icons.call_split, size: UIConstants.iconSm, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: UIConstants.xs),
              Text('${repo.forks_count ?? 0}', style: theme.textTheme.labelSmall),
            ],
          ),
        ],
      ),
    );
  }
}

class _IssueSearchResults extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: Injection.issueNotifier,
      builder: (context, _) {
        final issuesState = Injection.issueNotifier.issuesListState;
        return switch (issuesState) {
          IssuesListLoading() => const Center(child: CircularProgressIndicator()),
          IssuesListLoaded(:final issues) => _buildIssueList(context, issues, l10n),
          IssuesListError(:final message) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${l10n.error}: $message'),
                const SizedBox(height: UIConstants.md),
                FilledButton(
                  onPressed: () {
                    final query = Injection.issueNotifier.lastSearchQuery ?? '';
                    Injection.issueNotifier.searchIssues(query);
                  },
                  child: Text(l10n.retry),
                ),
              ],
            ),
          ),
          _ => EmptyState(icon: Icons.search, title: l10n.enterSearchQueryIssues),
        };
      },
    );
  }

  Widget _buildIssueList(BuildContext context, List<Issue> issues, AppLocalizations l10n) {
    if (issues.isEmpty) {
      return EmptyState(icon: Icons.bug_report_outlined, title: l10n.noIssuesFound);
    }
    return ListView.builder(
      padding: UIConstants.pagePadding + const EdgeInsets.symmetric(vertical: UIConstants.sm),
      itemCount: issues.length,
      itemBuilder: (context, index) {
        final issue = issues[index];
        return FadeInWrapper(
          delay: Duration(milliseconds: index * 30),
          child: _SearchIssueCard(issue: issue),
        );
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
    final l10n = AppLocalizations.of(context)!;
    final isOpen = issue.state?.value == 'open';

    return PremiumListCard(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isOpen ? Colors.green.withValues(alpha: 0.2) : Colors.purple.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(UIConstants.chipRadius),
                ),
                child: Text(
                  isOpen ? l10n.open : l10n.closed,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isOpen ? Colors.green : Colors.purple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: UIConstants.sm),
              Expanded(
                child: Text(
                  issue.title ?? l10n.untitled,
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: UIConstants.sm),
          Row(
            children: [
              if (issue.user != null) ...[
                UserAvatar(user: issue.user!, radius: UIConstants.avatarXs),
                const SizedBox(width: UIConstants.xs),
                Text(issue.user!.login ?? '', style: theme.textTheme.labelSmall),
              ],
              const Spacer(),
              if (issue.comments != null) ...[
                Icon(Icons.comment_outlined, size: UIConstants.iconXs, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: UIConstants.xs),
                Text('${issue.comments}', style: theme.textTheme.labelSmall),
              ],
            ],
          ),
          if (issue.repository?.full_name != null) ...[
            const SizedBox(height: UIConstants.sm),
            Text(
              issue.repository!.full_name!,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
