import 'dart:async';

import 'package:flutter/material.dart';
import '../../core/animations/animated_wrapper.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../domain/entities/issue_state.dart';
import '../../l10n/app_localizations.dart';
import '../../presentation/state/issue_notifier.dart';
import '../models/issue_filter_state.dart';
import '../widgets/empty_state.dart';
import '../widgets/issue_filter_bottom_sheet.dart';
import '../widgets/premium_card.dart';
import '../widgets/user_avatar.dart';
import 'issue_detail_page.dart';
import '../../domain/services/saved_filter_service.dart';
import '../../domain/models/saved_filter.dart';

class IssueListPage extends StatefulWidget {
  final IssueFilterState? initialFilter;

  const IssueListPage({super.key, this.initialFilter});

  @override
  State<IssueListPage> createState() => _IssueListPageState();
}

class _IssueListPageState extends State<IssueListPage> {
  String _searchQuery = '';
  final _searchController = TextEditingController();
  bool _isNavigating = false;
  bool _isFilterSheetOpen = false;
  final SavedFilterService _savedFilterService = SavedFilterService();
  List<SavedFilter> _savedFilters = [];
  bool _savedFiltersExpanded = false;
  bool _filtersLoaded = false;
  Timer? _searchDebounceTimer;
  final ValueNotifier<IssueFilterState> _filterState = ValueNotifier(const IssueFilterState());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = Injection.issueNotifier;
      if (widget.initialFilter != null) {
        _filterState.value = widget.initialFilter!;
      }
      if (notifier.issuesListState is! IssuesListLoaded) {
        notifier.searchIssues(
          '',
          state: notifier.issuesListFilter ?? 'open',
          filters: _filterState.value,
        );
      }
    });
    _loadSavedFilters();
  }

  @override
  void dispose() {
    _searchDebounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _forceReload() {
    final notifier = Injection.issueNotifier;
    notifier.searchIssues(
      _searchQuery,
      state: notifier.issuesListFilter ?? 'open',
      filters: _filterState.value,
    );
  }

  Future<void> _showFilterSheet() async {
    if (_isFilterSheetOpen) return;
    _isFilterSheetOpen = true;

    final notifier = Injection.issueNotifier;
    final issuesState = notifier.issuesListState;

    final Set<String> labels = {};
    final Set<String> milestones = {};
    if (issuesState is IssuesListLoaded) {
      for (final issue in issuesState.issues) {
        if (issue.labels != null) {
          for (final label in issue.labels!) {
            if (label.name != null) labels.add(label.name!);
          }
        }
        if (issue.milestone?.title != null) {
          milestones.add(issue.milestone!.title!);
        }
      }
    }

    try {
      final result = await showModalBottomSheet<IssueFilterState>(
        context: context,
        isScrollControlled: true,
        builder: (_) => IssueFilterBottomSheet(
          initialState: _filterState.value,
          availableLabels: labels.toList()..sort(),
          availableMilestones: milestones.toList()..sort(),
        ),
      );

      if (result != null) {
        _filterState.value = result;
        _forceReload();
      }
    } finally {
      _isFilterSheetOpen = false;
    }
  }

  void _navigateToIssue(String owner, String repo, int index) {
    if (_isNavigating) return;
    _isNavigating = true;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => IssueDetailPage(owner: owner, repo: repo, index: index),
    )).then((_) => _isNavigating = false);
  }

  void _onSearch(String query) {
    setState(() => _searchQuery = query);
    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(const Duration(milliseconds: 300), _forceReload);
  }

  Future<void> _loadSavedFilters() async {
    final filters = await _savedFilterService.loadFilters();
    if (mounted) {
      setState(() {
        _savedFilters = filters;
        _filtersLoaded = true;
      });
    }
  }

  void _applyFilter(SavedFilter filter) {
    final notifier = Injection.issueNotifier;
    notifier.searchIssues(
      filter.query ?? '',
      state: filter.state,
    );
    setState(() {});
  }

  Future<void> _saveCurrentFilter() async {
    final notifier = Injection.issueNotifier;
    final l10n = AppLocalizations.of(context)!;
    final filterState = notifier.issuesListFilter ?? 'open';
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.saveFilter),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: l10n.filterName),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, controller.text), child: Text(l10n.save)),
        ],
      ),
    );
    controller.dispose();
    if (name != null && name.trim().isNotEmpty) {
      await _savedFilterService.addFilter(
        name.trim(), filterState,
        query: _searchQuery.isNotEmpty ? _searchQuery : null,
      );
      _loadSavedFilters();
    }
  }

  Future<void> _deleteSavedFilter(SavedFilter filter) async {
    await _savedFilterService.deleteFilter(filter.id);
    _loadSavedFilters();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.issues)),
      body: Column(
        children: [
          FadeInWrapper(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: UIConstants.md, vertical: UIConstants.sm),
              child: SearchBar(
                controller: _searchController,
                hintText: l10n.searchIssues,
                leading: const Icon(Icons.search),
                trailing: [
                  if (_searchQuery.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _onSearch('');
                      },
                    ),
                ],
                onChanged: _onSearch,
                padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: UIConstants.md),
                ),
              ),
            ),
          ),
          FadeInWrapper(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: UIConstants.md, vertical: UIConstants.sm),
              child: Row(
                children: [
                  Expanded(
                    child: _FilterChips(
                      selectedState: Injection.issueNotifier.issuesListFilter ?? 'open',
                      onSelected: (state) {
                        setState(() {});
                        Injection.issueNotifier.searchIssues(
                          _searchQuery,
                          state: state,
                          filters: _filterState.value,
                        );
                      },
                      l10n: l10n,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    tooltip: l10n.moreFilters,
                    onPressed: _showFilterSheet,
                  ),
                ],
              ),
            ),
          ),
          ValueListenableBuilder<IssueFilterState>(
            valueListenable: _filterState,
            builder: (context, filter, _) {
              if (!filter.hasFilters) return const SizedBox.shrink();
              return FadeInWrapper(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: UIConstants.md, vertical: UIConstants.sm),
                  child: Wrap(
                    spacing: UIConstants.sm,
                    runSpacing: UIConstants.sm,
                    children: [
                      ...filter.labels.map((label) => Chip(
                        label: Text(label),
                        onDeleted: () {
                          _filterState.value = filter.copyWith(
                            labels: filter.labels.difference({label}),
                          );
                          _forceReload();
                        },
                      )),
                      ...filter.milestones.map((m) => Chip(
                        label: Text(m),
                        onDeleted: () {
                          _filterState.value = filter.copyWith(
                            milestones: filter.milestones.difference({m}),
                          );
                          _forceReload();
                        },
                      )),
                      if (filter.type != null)
                        Chip(
                          label: Text(filter.type!),
                          onDeleted: () {
                            _filterState.value = filter.copyWith(clearType: true);
                            _forceReload();
                          },
                        ),
                      if (filter.assignedToMe)
                        Chip(
                          label: Text(l10n.assignedToMe),
                          onDeleted: () {
                            _filterState.value = filter.copyWith(assignedToMe: false);
                            _forceReload();
                          },
                        ),
                      if (filter.createdByMe)
                        Chip(
                          label: Text(l10n.createdByMe),
                          onDeleted: () {
                            _filterState.value = filter.copyWith(createdByMe: false);
                            _forceReload();
                          },
                        ),
                      if (filter.mentionedMe)
                        Chip(
                          label: Text(l10n.mentionedMe),
                          onDeleted: () {
                            _filterState.value = filter.copyWith(mentionedMe: false);
                            _forceReload();
                          },
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          if (_filtersLoaded && _savedFilters.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: UIConstants.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () => setState(() => _savedFiltersExpanded = !_savedFiltersExpanded),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: UIConstants.xs),
                      child: Row(
                        children: [
                          Icon(
                            _savedFiltersExpanded ? Icons.expand_less : Icons.expand_more,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text('Saved Filters (${_savedFilters.length})',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_savedFiltersExpanded)
                    SizedBox(
                      height: 36,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _savedFilters.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 4),
                        itemBuilder: (context, i) {
                          final f = _savedFilters[i];
                          return InputChip(
                            label: Text(f.name, style: const TextStyle(fontSize: 12)),
                            onPressed: () => _applyFilter(f),
                            onDeleted: () => _deleteSavedFilter(f),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          if (_filtersLoaded && (_searchQuery.isNotEmpty || Injection.issueNotifier.issuesListFilter != null))
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: UIConstants.md),
                child: TextButton.icon(
                  icon: const Icon(Icons.save_outlined, size: 16),
                  label: const Text('Save filter', style: TextStyle(fontSize: 12)),
                  onPressed: _saveCurrentFilter,
                ),
              ),
            ),
          Expanded(
            child: ListenableBuilder(
              listenable: Injection.issueNotifier,
              builder: (context, _) {
                final issuesState = Injection.issueNotifier.issuesListState;
                return switch (issuesState) {
                  IssuesListLoading() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  IssuesListError(:final message) => Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${l10n.error}: $message'),
                        const SizedBox(height: UIConstants.md),
                        FilledButton(
                          onPressed: () => _forceReload(),
                          child: Text(l10n.retry),
                        ),
                      ],
                    ),
                  ),
                  IssuesListLoaded(:final issues, :final hasMore) => _IssueList(
                    issues: issues,
                    hasMore: hasMore,
                    loadingMore: Injection.issueNotifier.loadingMore,
                    onRefresh: _forceReload,
                    onLoadMore: () => Injection.issueNotifier.loadMoreIssues(),
                    onIssueTap: _navigateToIssue,
                    l10n: l10n,
                  ),
                  _ => const Center(
                    child: CircularProgressIndicator(),
                  ),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  final String? selectedState;
  final ValueChanged<String?> onSelected;
  final AppLocalizations l10n;

  const _FilterChips({required this.selectedState, required this.onSelected, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: UIConstants.sm,
      children: [
        FilterChip(
          label: Text(l10n.open),
          selected: selectedState == 'open',
          onSelected: (_) => onSelected('open'),
        ),
        FilterChip(
          label: Text(l10n.closed),
          selected: selectedState == 'closed',
          onSelected: (_) => onSelected('closed'),
        ),
        FilterChip(
          label: Text(l10n.all),
          selected: selectedState == 'all',
          onSelected: (_) => onSelected('all'),
        ),
      ],
    );
  }
}

class _IssueList extends StatefulWidget {
  final List<Issue> issues;
  final bool hasMore;
  final bool loadingMore;
  final VoidCallback onRefresh;
  final VoidCallback onLoadMore;
  final void Function(String owner, String repo, int index) onIssueTap;
  final AppLocalizations l10n;

  const _IssueList({
    required this.issues,
    required this.hasMore,
    required this.loadingMore,
    required this.onRefresh,
    required this.onLoadMore,
    required this.onIssueTap,
    required this.l10n,
  });

  @override
  State<_IssueList> createState() => _IssueListState();
}

class _IssueListState extends State<_IssueList> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (widget.hasMore && !widget.loadingMore) {
        widget.onLoadMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.issues.isEmpty && !widget.loadingMore) {
      return EmptyState(icon: Icons.bug_report_outlined, title: widget.l10n.noIssuesFound);
    }
    return RefreshIndicator(
      onRefresh: () async => widget.onRefresh(),
      child: ListView.builder(
        controller: _scrollController,
        padding: UIConstants.pagePadding + const EdgeInsets.symmetric(vertical: UIConstants.sm),
        itemCount: widget.issues.length + (widget.hasMore || widget.loadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= widget.issues.length) {
            return const _LoadingIndicator();
          }
          final issue = widget.issues[index];
          return FadeInWrapper(
            delay: Duration(milliseconds: (index * 40).clamp(0, 300)),
            child: _IssueCard(issue: issue, l10n: widget.l10n, onTap: () {
              final owner = issue.repository?.owner ?? '';
              final repo = issue.repository?.name ?? '';
              if (owner.isNotEmpty && repo.isNotEmpty && issue.number != null) {
                widget.onIssueTap(owner, repo, issue.number!);
              }
            }),
          );
        },
      ),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}

class _IssueCard extends StatelessWidget {
  final Issue issue;
  final AppLocalizations l10n;
  final VoidCallback onTap;

  const _IssueCard({required this.issue, required this.l10n, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOpen = issue.state?.isOpen == true;
    final stateIcon = isOpen ? Icons.error_outline : Icons.check_circle;
    final stateColor = isOpen ? Colors.green : Colors.purple;

    final repoFullName = issue.repository?.full_name ?? '';
    final owner = issue.repository?.owner ?? '';
    final repo = issue.repository?.name ?? '';
    final canNavigate = owner.isNotEmpty && repo.isNotEmpty && issue.number != null;

    return PremiumListCard(
      onTap: canNavigate ? onTap : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(stateIcon, size: UIConstants.iconSm, color: stateColor),
              const SizedBox(width: UIConstants.sm),
              Expanded(
                child: Text(
                  issue.title ?? l10n.untitled,
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (issue.number != null)
                Text(
                  '#${issue.number}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
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
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              const Spacer(),
              if (repoFullName.isNotEmpty) ...[
                Text(
                  repoFullName,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
          if (issue.labels != null && issue.labels!.isNotEmpty) ...[
            const SizedBox(height: UIConstants.sm),
            _LabelRow(labels: issue.labels!),
          ],
          const SizedBox(height: UIConstants.sm),
          Row(
            children: [
              if (issue.comments != null) ...[
                Icon(Icons.comment_outlined, size: UIConstants.iconXs, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: UIConstants.xs),
                Text(
                  '${issue.comments}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(width: UIConstants.md),
              ],
              if (issue.updated_at != null) ...[
                Text(
                  _formatDate(issue.updated_at!, l10n),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date, AppLocalizations l10n) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 365) return l10n.yearsAgo('${diff.inDays ~/ 365}');
    if (diff.inDays > 30) return l10n.monthsAgo('${diff.inDays ~/ 30}');
    if (diff.inDays > 0) return l10n.daysAgo('${diff.inDays}');
    if (diff.inHours > 0) return l10n.hoursAgo('${diff.inHours}');
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
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: c, height: 1.2),
            ),
          );
        }),
        if (overflow > 0)
          Text(
            '+$overflow',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: theme.colorScheme.onSurfaceVariant),
          ),
      ],
    );
  }
}
