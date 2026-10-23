import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../core/animations/animated_wrapper.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../domain/entities/issue_state.dart';
import '../../l10n/app_localizations.dart';
import '../../presentation/state/issue_notifier.dart';
import '../../presentation/state/repo_notifier.dart';
import '../models/issue_filter_state.dart';
import '../models/repo_filter_state.dart';
import '../widgets/forui/app_state_views.dart';
import '../widgets/issue_filter_bottom_sheet.dart';
import '../widgets/premium_card.dart';
import '../widgets/repo_filter_bottom_sheet.dart';
import '../widgets/user_avatar.dart';
import 'issue_detail_page.dart';
import 'repo_detail_page.dart';
import 'user_profile_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  int _tabIndex = 0;
  final ValueNotifier<RepoFilterState> _repoFilterState = ValueNotifier(
    const RepoFilterState(),
  );
  final ValueNotifier<IssueFilterState> _issueFilterState = ValueNotifier(
    const IssueFilterState(),
  );
  bool _isRepoFilterSheetOpen = false;
  bool _isIssueFilterSheetOpen = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;
    final repoFilter = _repoFilterState.value;
    Injection.repoNotifier.searchRepos(
      q: query,
      sort: repoFilter.sort,
      order: repoFilter.order,
      private: repoFilter.private,
      archived: repoFilter.archived,
      template: repoFilter.template,
    );
    Injection.issueNotifier.searchIssues(
      query,
      filters: _issueFilterState.value,
    );
    Injection.userNotifier.searchUsers(query);
  }

  Future<void> _showRepoFilterSheet() async {
    if (_isRepoFilterSheetOpen) return;
    _isRepoFilterSheetOpen = true;

    try {
      final result = await showFSheet<RepoFilterState>(
        context: context,
        side: FLayout.btt,
        mainAxisMaxRatio: 0.85,
        builder: (_) =>
            RepoFilterBottomSheet(initialState: _repoFilterState.value),
      );

      if (result != null) {
        _repoFilterState.value = result;
        _onSearch();
      }
    } finally {
      _isRepoFilterSheetOpen = false;
    }
  }

  Future<void> _showIssueFilterSheet() async {
    if (_isIssueFilterSheetOpen) return;
    _isIssueFilterSheetOpen = true;

    try {
      final result = await showFSheet<IssueFilterState>(
        context: context,
        side: FLayout.btt,
        mainAxisMaxRatio: 0.85,
        builder: (_) => IssueFilterBottomSheet(
          initialState: _issueFilterState.value,
          availableLabels: const [],
          availableMilestones: const [],
        ),
      );

      if (result != null) {
        _issueFilterState.value = result;
        _onSearch();
      }
    } finally {
      _isIssueFilterSheetOpen = false;
    }
  }

  void _showFilterSheet() {
    switch (_tabIndex) {
      case 0:
        _showRepoFilterSheet();
        break;
      case 1:
        _showIssueFilterSheet();
        break;
      case 2:
      default:
        break;
    }
  }

  bool get _hasActiveFilters {
    return switch (_tabIndex) {
      0 => _repoFilterState.value.hasFilters,
      1 => _issueFilterState.value.hasFilters,
      _ => false,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            children: [
              for (final (index, label) in [
                (0, l10n.repositories),
                (1, l10n.issues),
                (2, l10n.users),
              ])
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: FButton(
                      variant: _tabIndex == index ? .primary : .outline,
                      size: .sm,
                      onPress: () => setState(() => _tabIndex = index),
                      child: Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(label, maxLines: 1),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            children: [
              Expanded(
                child: FTextField(
                  control: FTextFieldControl.managed(
                    controller: _searchController,
                  ),
                  hint: l10n.search,
                  textInputAction: TextInputAction.search,
                  onSubmit: (_) {
                    _onSearch();
                    FocusScope.of(context).unfocus();
                  },
                  clearable: (value) => value.text.isNotEmpty,
                ),
              ),
              const SizedBox(width: 8),
              if (_tabIndex != 2)
                FTappable(
                  onPress: _showFilterSheet,
                  semanticsLabel: l10n.moreFilters,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(FIcons.listFilter, size: 18),
                      ),
                      if (_hasActiveFilters)
                        Positioned(
                          right: 5,
                          top: 5,
                          child: Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        if (_tabIndex == 0)
          ValueListenableBuilder<RepoFilterState>(
            valueListenable: _repoFilterState,
            builder: (context, filter, _) {
              if (!filter.hasFilters) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: UIConstants.md),
                child: Wrap(
                  spacing: UIConstants.sm,
                  runSpacing: UIConstants.sm,
                  children: [
                    if (filter.sort != null)
                      Chip(
                        label: Text(filter.sort!),
                        onDeleted: () {
                          _repoFilterState.value = filter.copyWith(
                            clearSort: true,
                          );
                          _onSearch();
                        },
                      ),
                    if (filter.order != null)
                      Chip(
                        label: Text(filter.order!),
                        onDeleted: () {
                          _repoFilterState.value = filter.copyWith(
                            clearOrder: true,
                          );
                          _onSearch();
                        },
                      ),
                    if (filter.private == true)
                      Chip(
                        label: Text(l10n.privateReposOnly),
                        onDeleted: () {
                          _repoFilterState.value = filter.copyWith(
                            private: false,
                          );
                          _onSearch();
                        },
                      ),
                    if (filter.archived == true)
                      Chip(
                        label: Text(l10n.includeArchived),
                        onDeleted: () {
                          _repoFilterState.value = filter.copyWith(
                            archived: false,
                          );
                          _onSearch();
                        },
                      ),
                    if (filter.template == true)
                      Chip(
                        label: Text(l10n.templatesOnly),
                        onDeleted: () {
                          _repoFilterState.value = filter.copyWith(
                            template: false,
                          );
                          _onSearch();
                        },
                      ),
                  ],
                ),
              );
            },
          )
        else if (_tabIndex == 1)
          ValueListenableBuilder<IssueFilterState>(
            valueListenable: _issueFilterState,
            builder: (context, filter, _) {
              if (!filter.hasFilters) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: UIConstants.md),
                child: Wrap(
                  spacing: UIConstants.sm,
                  runSpacing: UIConstants.sm,
                  children: [
                    ...filter.labels.map(
                      (label) => Chip(
                        label: Text(label),
                        onDeleted: () {
                          _issueFilterState.value = filter.copyWith(
                            labels: filter.labels.difference({label}),
                          );
                          _onSearch();
                        },
                      ),
                    ),
                    ...filter.milestones.map(
                      (m) => Chip(
                        label: Text(m),
                        onDeleted: () {
                          _issueFilterState.value = filter.copyWith(
                            milestones: filter.milestones.difference({m}),
                          );
                          _onSearch();
                        },
                      ),
                    ),
                    if (filter.type != null)
                      Chip(
                        label: Text(filter.type!),
                        onDeleted: () {
                          _issueFilterState.value = filter.copyWith(
                            clearType: true,
                          );
                          _onSearch();
                        },
                      ),
                    if (filter.assignedToMe)
                      Chip(
                        label: Text(l10n.assignedToMe),
                        onDeleted: () {
                          _issueFilterState.value = filter.copyWith(
                            assignedToMe: false,
                          );
                          _onSearch();
                        },
                      ),
                    if (filter.createdByMe)
                      Chip(
                        label: Text(l10n.createdByMe),
                        onDeleted: () {
                          _issueFilterState.value = filter.copyWith(
                            createdByMe: false,
                          );
                          _onSearch();
                        },
                      ),
                    if (filter.mentionedMe)
                      Chip(
                        label: Text(l10n.mentionedMe),
                        onDeleted: () {
                          _issueFilterState.value = filter.copyWith(
                            mentionedMe: false,
                          );
                          _onSearch();
                        },
                      ),
                  ],
                ),
              );
            },
          ),
        Expanded(
          child: switch (_tabIndex) {
            1 => _IssueSearchResults(),
            2 => _UserSearchResults(
              currentQuery: _searchController.text.trim(),
            ),
            _ => _RepoSearchResults(),
          },
        ),
      ],
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
          RepoLoading() => const AppLoading(),
          SearchResultsLoaded(:final results) => _buildRepoList(
            context,
            results.data ?? [],
            l10n,
          ),
          RepoError(:final message) => AppError(
            message: message,
            onRetry: () => Injection.repoNotifier.searchRepos(),
          ),
          _ => AppEmpty(icon: FIcons.search, title: l10n.enterSearchQueryRepos),
        };
      },
    );
  }

  Widget _buildRepoList(
    BuildContext context,
    List<Repository> repos,
    AppLocalizations l10n,
  ) {
    if (repos.isEmpty) {
      return AppEmpty(icon: FIcons.folderGit, title: l10n.noRepositoriesFound);
    }
    return ListView.builder(
      padding:
          UIConstants.pagePadding +
          const EdgeInsets.symmetric(vertical: UIConstants.sm),
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

class _SearchRepoCard extends StatefulWidget {
  final Repository repo;

  const _SearchRepoCard({required this.repo});

  @override
  State<_SearchRepoCard> createState() => _SearchRepoCardState();
}

class _SearchRepoCardState extends State<_SearchRepoCard> {
  bool _navigating = false;

  @override
  Widget build(BuildContext context) {
    final repo = widget.repo;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return PremiumListCard(
      onTap: () {
        if (_navigating) return;
        _navigating = true;
        Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder: (_) => RepoDetailPage(
                  owner: repo.owner?.login ?? '',
                  repo: repo.name ?? '',
                ),
              ),
            )
            .then((_) => _navigating = false);
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
                  repo.private == true ? FIcons.lock : FIcons.globe,
                  size: UIConstants.iconMd,
                  color: theme.colorScheme.primary,
                ),
              const SizedBox(width: UIConstants.sm),
              Expanded(
                child: Text(
                  repo.full_name ?? repo.name ?? '',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (repo.private == true) ...[
                const SizedBox(width: UIConstants.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(
                      UIConstants.badgeRadius,
                    ),
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
              Icon(
                FIcons.star,
                size: UIConstants.iconSm,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: UIConstants.xs),
              Text(
                '${repo.stars_count ?? 0}',
                style: theme.textTheme.labelSmall,
              ),
              const SizedBox(width: UIConstants.md),
              Icon(
                FIcons.gitFork,
                size: UIConstants.iconSm,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: UIConstants.xs),
              Text(
                '${repo.forks_count ?? 0}',
                style: theme.textTheme.labelSmall,
              ),
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
          IssuesListLoading() => const AppLoading(),
          IssuesListLoaded(:final issues) => _buildIssueList(
            context,
            issues,
            l10n,
          ),
          IssuesListError(:final message) => AppError(
            message: message,
            onRetry: () {
              final query = Injection.issueNotifier.lastSearchQuery ?? '';
              Injection.issueNotifier.searchIssues(query);
            },
          ),
          _ => AppEmpty(
            icon: FIcons.search,
            title: l10n.enterSearchQueryIssues,
          ),
        };
      },
    );
  }

  Widget _buildIssueList(
    BuildContext context,
    List<Issue> issues,
    AppLocalizations l10n,
  ) {
    if (issues.isEmpty) {
      return AppEmpty(icon: FIcons.circleDot, title: l10n.noIssuesFound);
    }
    return ListView.builder(
      padding:
          UIConstants.pagePadding +
          const EdgeInsets.symmetric(vertical: UIConstants.sm),
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

class _SearchIssueCard extends StatefulWidget {
  final Issue issue;

  const _SearchIssueCard({required this.issue});

  @override
  State<_SearchIssueCard> createState() => _SearchIssueCardState();
}

class _SearchIssueCardState extends State<_SearchIssueCard> {
  bool _navigating = false;

  @override
  Widget build(BuildContext context) {
    final issue = widget.issue;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isOpen = issue.state?.isOpen == true;

    return PremiumListCard(
      onTap: () {
        if (_navigating) return;
        final repoUrl = issue.repository?.full_name ?? '';
        final parts = repoUrl.split('/');
        final owner = parts.isNotEmpty ? parts.first : '';
        final repo = parts.length > 1 ? parts[1] : '';
        if (owner.isNotEmpty && repo.isNotEmpty && issue.number != null) {
          _navigating = true;
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (_) => IssueDetailPage(
                    owner: owner,
                    repo: repo,
                    index: issue.number!,
                  ),
                ),
              )
              .then((_) => _navigating = false);
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
                  color: isOpen
                      ? Colors.green.withValues(alpha: 0.2)
                      : Colors.purple.withValues(alpha: 0.2),
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
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
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
                Text(
                  issue.user!.login ?? '',
                  style: theme.textTheme.labelSmall,
                ),
              ],
              const Spacer(),
              if (issue.comments != null) ...[
                Icon(
                  FIcons.messageSquare,
                  size: UIConstants.iconXs,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
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

class _UserSearchResults extends StatelessWidget {
  final String currentQuery;

  const _UserSearchResults({required this.currentQuery});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: Injection.userNotifier,
      builder: (context, _) {
        final loading = Injection.userNotifier.searchUsersLoading;
        final users = Injection.userNotifier.searchedUsers;
        final error = Injection.userNotifier.searchUsersError;

        if (loading) {
          return const AppLoading();
        }
        if (error != null) {
          return AppError(
            message: error,
            onRetry: () => Injection.userNotifier.searchUsers(currentQuery),
          );
        }
        if (users.isEmpty) {
          return AppEmpty(
            icon: FIcons.search,
            title: l10n.enterSearchQueryUsers,
          );
        }
        return ListView.builder(
          padding:
              UIConstants.pagePadding +
              const EdgeInsets.symmetric(vertical: UIConstants.sm),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return FadeInWrapper(
              delay: Duration(milliseconds: index * 30),
              child: _SearchUserCard(user: user),
            );
          },
        );
      },
    );
  }
}

class _SearchUserCard extends StatefulWidget {
  final User user;

  const _SearchUserCard({required this.user});

  @override
  State<_SearchUserCard> createState() => _SearchUserCardState();
}

class _SearchUserCardState extends State<_SearchUserCard> {
  bool _navigating = false;

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final theme = Theme.of(context);

    return PremiumListCard(
      onTap: () {
        if (_navigating) return;
        final username = user.login ?? '';
        if (username.isNotEmpty) {
          _navigating = true;
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (_) => UserProfilePage(username: username),
                ),
              )
              .then((_) => _navigating = false);
        }
      },
      child: Row(
        children: [
          UserAvatar(user: user, radius: UIConstants.avatarMd),
          const SizedBox(width: UIConstants.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.full_name ?? user.login ?? '',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (user.login != null) ...[
                  const SizedBox(height: UIConstants.xs),
                  Text(
                    '@${user.login}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 18),
        ],
      ),
    );
  }
}
