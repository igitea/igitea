import 'dart:async';

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../domain/entities/issue_state.dart';
import '../../l10n/app_localizations.dart';
import '../../presentation/state/issue_notifier.dart';
import '../../presentation/state/repo_notifier.dart';
import '../models/issue_filter_state.dart';
import '../models/repo_filter_state.dart';
import '../widgets/forui/app_filter_chip.dart';
import '../widgets/forui/app_state_views.dart';
import '../widgets/forui/app_tile.dart';
import '../widgets/issue_filter_bottom_sheet.dart';
import '../theme/app_palette.dart';
import '../widgets/forui/app_chrome.dart';
import '../widgets/forui/app_section.dart';
import '../widgets/language_dot.dart';
import '../widgets/repo_filter_bottom_sheet.dart';
import '../widgets/user_avatar.dart';
import 'issue_detail_page.dart';
import 'repo_detail_page.dart';
import 'user_profile_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  /// Shared focus node so the shell's ⌘K shortcut and header prompt can focus
  /// the search field.
  static final FocusNode searchFocusNode = FocusNode();

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  Timer? _searchDebounce;
  String _query = '';
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
    _searchDebounce?.cancel();
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
        constraints: const BoxConstraints(maxWidth: 560),
        useSafeArea: true,
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
        constraints: const BoxConstraints(maxWidth: 560),
        useSafeArea: true,
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final tabWidth = (constraints.maxWidth - 46)
                  .clamp(180.0, 420.0)
                  .toDouble();
              return Row(
                children: [
                  SizedBox(
                    width: tabWidth,
                    child: AppSegmentedControl(
                      index: _tabIndex,
                      labels: [l10n.repositories, l10n.issues, l10n.users],
                      onChanged: (index) {
                        setState(() => _tabIndex = index);
                        if (_searchController.text.trim().isNotEmpty) {
                          _onSearch();
                        }
                      },
                    ),
                  ),
                  const Spacer(),
                  if (_tabIndex != 2)
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        AppIconButton(
                          icon: FIcons.listFilter,
                          label: l10n.moreFilters,
                          selected: _hasActiveFilters,
                          onPress: _showFilterSheet,
                        ),
                        if (_hasActiveFilters)
                          Positioned(
                            right: 7,
                            top: 6,
                            child: Container(
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                color: context.palette.brand,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
          child: FTextField(
            control: FTextFieldControl.managed(
              controller: _searchController,
              onChange: (value) {
                _searchDebounce?.cancel();
                final query = value.text.trim();
                setState(() => _query = query);
                if (query.isEmpty) return;
                _searchDebounce = Timer(
                  const Duration(milliseconds: 400),
                  _onSearch,
                );
              },
            ),
            focusNode: SearchPage.searchFocusNode,
            hint: l10n.search,
            textInputAction: TextInputAction.search,
            onSubmit: (_) {
              _onSearch();
              FocusScope.of(context).unfocus();
            },
            clearable: (value) => value.text.isNotEmpty,
            prefixBuilder: (context, style, variants) =>
                FTextField.prefixIconBuilder(
                  context,
                  style,
                  variants,
                  const Icon(FIcons.search, size: 16),
                ),
          ),
        ),
        if (_tabIndex == 0)
          ValueListenableBuilder<RepoFilterState>(
            valueListenable: _repoFilterState,
            builder: (context, filter, _) {
              if (!filter.hasFilters) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Wrap(
                  spacing: UIConstants.sm,
                  runSpacing: UIConstants.sm,
                  children: [
                    if (filter.sort != null)
                      AppFilterChip(
                        label: filter.sort!,
                        onRemove: () {
                          _repoFilterState.value = filter.copyWith(
                            clearSort: true,
                          );
                          _onSearch();
                        },
                      ),
                    if (filter.order != null)
                      AppFilterChip(
                        label: filter.order!,
                        onRemove: () {
                          _repoFilterState.value = filter.copyWith(
                            clearOrder: true,
                          );
                          _onSearch();
                        },
                      ),
                    if (filter.private == true)
                      AppFilterChip(
                        label: l10n.privateReposOnly,
                        onRemove: () {
                          _repoFilterState.value = filter.copyWith(
                            private: false,
                          );
                          _onSearch();
                        },
                      ),
                    if (filter.archived == true)
                      AppFilterChip(
                        label: l10n.includeArchived,
                        onRemove: () {
                          _repoFilterState.value = filter.copyWith(
                            archived: false,
                          );
                          _onSearch();
                        },
                      ),
                    if (filter.template == true)
                      AppFilterChip(
                        label: l10n.templatesOnly,
                        onRemove: () {
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Wrap(
                  spacing: UIConstants.sm,
                  runSpacing: UIConstants.sm,
                  children: [
                    ...filter.labels.map(
                      (label) => AppFilterChip(
                        label: label,
                        onRemove: () {
                          _issueFilterState.value = filter.copyWith(
                            labels: filter.labels.difference({label}),
                          );
                          _onSearch();
                        },
                      ),
                    ),
                    ...filter.milestones.map(
                      (m) => AppFilterChip(
                        label: m,
                        onRemove: () {
                          _issueFilterState.value = filter.copyWith(
                            milestones: filter.milestones.difference({m}),
                          );
                          _onSearch();
                        },
                      ),
                    ),
                    if (filter.type != null)
                      AppFilterChip(
                        label: filter.type!,
                        onRemove: () {
                          _issueFilterState.value = filter.copyWith(
                            clearType: true,
                          );
                          _onSearch();
                        },
                      ),
                    if (filter.assignedToMe)
                      AppFilterChip(
                        label: l10n.assignedToMe,
                        onRemove: () {
                          _issueFilterState.value = filter.copyWith(
                            assignedToMe: false,
                          );
                          _onSearch();
                        },
                      ),
                    if (filter.createdByMe)
                      AppFilterChip(
                        label: l10n.createdByMe,
                        onRemove: () {
                          _issueFilterState.value = filter.copyWith(
                            createdByMe: false,
                          );
                          _onSearch();
                        },
                      ),
                    if (filter.mentionedMe)
                      AppFilterChip(
                        label: l10n.mentionedMe,
                        onRemove: () {
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
          child: _query.isEmpty
              ? AppEmpty(
                  icon: FIcons.search,
                  title: switch (_tabIndex) {
                    1 => l10n.enterSearchQueryIssues,
                    2 => l10n.enterSearchQueryUsers,
                    _ => l10n.enterSearchQueryRepos,
                  },
                )
              : switch (_tabIndex) {
                  1 => _IssueSearchResults(),
                  2 => _UserSearchResults(currentQuery: _query),
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
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      children: [
        AppSection(
          title: '',
          showHeader: false,
          children: [for (final repo in repos) _SearchRepoRow(repo: repo)],
        ),
      ],
    );
  }
}

class _SearchRepoRow extends StatefulWidget {
  final Repository repo;

  const _SearchRepoRow({required this.repo});

  @override
  State<_SearchRepoRow> createState() => _SearchRepoRowState();
}

class _SearchRepoRowState extends State<_SearchRepoRow> {
  bool _navigating = false;

  @override
  Widget build(BuildContext context) {
    final repo = widget.repo;
    final palette = context.palette;
    final description = repo.description?.trim() ?? '';
    final owner = repo.owner?.login ?? '';

    return AppTile(
      leading: repo.owner != null
          ? UserAvatar(user: repo.owner!, radius: 14)
          : Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: palette.brandSoft,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Icon(
                repo.private == true ? FIcons.lock : FIcons.folderGit,
                size: 13,
                color: palette.brand,
              ),
            ),
      title: repo.full_name ?? repo.name ?? '',
      subtitle: description.isNotEmpty ? description : owner,
      showChevron: false,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (repo.private == true) ...[
            Icon(FIcons.lock, size: 11, color: palette.textSecondary),
            const SizedBox(width: 8),
          ],
          if (repo.language != null) LanguageDot(language: repo.language),
          if (repo.language != null) const SizedBox(width: 10),
          Icon(FIcons.star, size: 11, color: palette.textSecondary),
          const SizedBox(width: 3),
          Text(
            '${repo.stars_count ?? 0}',
            style: TextStyle(fontSize: 10.5, color: palette.textSecondary),
          ),
          const SizedBox(width: 10),
          Icon(FIcons.gitFork, size: 11, color: palette.textSecondary),
          const SizedBox(width: 3),
          Text(
            '${repo.forks_count ?? 0}',
            style: TextStyle(fontSize: 10.5, color: palette.textSecondary),
          ),
          const SizedBox(width: 4),
          Icon(
            FIcons.chevronRight,
            size: 13,
            color: palette.textSecondary.withValues(alpha: 0.7),
          ),
        ],
      ),
      onPress: () {
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
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      children: [
        AppSection(
          title: '',
          showHeader: false,
          children: [for (final issue in issues) _SearchIssueRow(issue: issue)],
        ),
      ],
    );
  }
}

class _SearchIssueRow extends StatefulWidget {
  final Issue issue;

  const _SearchIssueRow({required this.issue});

  @override
  State<_SearchIssueRow> createState() => _SearchIssueRowState();
}

class _SearchIssueRowState extends State<_SearchIssueRow> {
  bool _navigating = false;

  @override
  Widget build(BuildContext context) {
    final issue = widget.issue;
    final palette = context.palette;
    final l10n = AppLocalizations.of(context)!;
    final isOpen = issue.state?.isOpen == true;
    final repoFullName = issue.repository?.full_name ?? '';

    return AppTile(
      leading: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: isOpen ? palette.successSoft : palette.purpleSoft,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Icon(
          isOpen ? FIcons.circleDot : FIcons.circleCheck,
          size: 13,
          color: isOpen ? palette.success : palette.purple,
        ),
      ),
      title: issue.title ?? l10n.untitled,
      subtitle: [
        if (repoFullName.isNotEmpty) repoFullName,
        if (issue.number != null) '#${issue.number}',
        if (issue.user?.login != null) issue.user!.login!,
      ].join(' · '),
      showChevron: false,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if ((issue.comments ?? 0) > 0) ...[
            Icon(FIcons.messageSquare, size: 11, color: palette.textSecondary),
            const SizedBox(width: 3),
            Text(
              '${issue.comments}',
              style: TextStyle(fontSize: 10.5, color: palette.textSecondary),
            ),
            const SizedBox(width: 8),
          ],
          Icon(
            FIcons.chevronRight,
            size: 13,
            color: palette.textSecondary.withValues(alpha: 0.7),
          ),
        ],
      ),
      onPress: () {
        if (_navigating) return;
        final parts = repoFullName.split('/');
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
          if (currentQuery.isEmpty) {
            return AppEmpty(
              icon: FIcons.search,
              title: l10n.enterSearchQueryUsers,
            );
          }
          return AppEmpty(icon: FIcons.userX, title: l10n.noUsersFound);
        }
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          children: [
            AppSection(
              title: '',
              showHeader: false,
              children: [for (final user in users) _SearchUserRow(user: user)],
            ),
          ],
        );
      },
    );
  }
}

class _SearchUserRow extends StatefulWidget {
  final User user;

  const _SearchUserRow({required this.user});

  @override
  State<_SearchUserRow> createState() => _SearchUserRowState();
}

class _SearchUserRowState extends State<_SearchUserRow> {
  bool _navigating = false;

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    return AppTile(
      leading: UserAvatar(user: user, radius: 14),
      title: user.full_name?.isNotEmpty == true
          ? user.full_name!
          : user.login ?? '',
      subtitle: user.login != null ? '@${user.login}' : null,
      showChevron: false,
      trailing: Icon(
        FIcons.chevronRight,
        size: 13,
        color: context.palette.textSecondary.withValues(alpha: 0.7),
      ),
      onPress: () {
        if (_navigating) return;
        final username = user.login ?? '';
        if (username.isEmpty) return;
        _navigating = true;
        Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder: (_) => UserProfilePage(username: username),
              ),
            )
            .then((_) => _navigating = false);
      },
    );
  }
}
