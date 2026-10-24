import 'dart:async';

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../core/animations/animated_wrapper.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../domain/entities/issue_state.dart';
import '../../l10n/app_localizations.dart';
import '../../presentation/state/issue_notifier.dart';
import '../models/issue_filter_state.dart';
import '../theme/app_palette.dart';
import '../widgets/forui/app_chrome.dart';
import '../widgets/forui/app_filter_chip.dart';
import '../widgets/forui/app_page.dart';
import '../widgets/forui/app_state_views.dart';
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
  final ValueNotifier<IssueFilterState> _filterState = ValueNotifier(
    const IssueFilterState(),
  );

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
      final result = await showFSheet<IssueFilterState>(
        context: context,
        side: FLayout.btt,
        mainAxisMaxRatio: 0.85,
        constraints: const BoxConstraints(maxWidth: 560),
        useSafeArea: true,
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
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) =>
                IssueDetailPage(owner: owner, repo: repo, index: index),
          ),
        )
        .then((_) => _isNavigating = false);
  }

  void _onSearch(String query) {
    setState(() => _searchQuery = query);
    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(
      const Duration(milliseconds: 300),
      _forceReload,
    );
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
    notifier.searchIssues(filter.query ?? '', state: filter.state);
    setState(() {});
  }

  Future<void> _saveCurrentFilter() async {
    final notifier = Injection.issueNotifier;
    final l10n = AppLocalizations.of(context)!;
    final filterState = notifier.issuesListFilter ?? 'open';
    final controller = TextEditingController();
    final name = await showFDialog<String>(
      context: context,
      builder: (ctx, style, animation) => FDialog(
        title: Text(l10n.saveFilter),
        body: FTextField(
          control: FTextFieldControl.managed(controller: controller),
          hint: l10n.filterName,
          autofocus: true,
        ),
        actions: [
          FButton(
            variant: .outline,
            onPress: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FButton(
            onPress: () => Navigator.pop(ctx, controller.text),
            child: Text(l10n.save),
          ),
        ],
      ),
    );
    controller.dispose();
    if (name != null && name.trim().isNotEmpty) {
      await _savedFilterService.addFilter(
        name.trim(),
        filterState,
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
    return AppPage(
      title: l10n.issues,
      maxContentWidth: 980,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 4),
            child: FTextField(
              control: FTextFieldControl.managed(
                controller: _searchController,
                onChange: (value) => _onSearch(value.text),
              ),
              hint: l10n.searchIssues,
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
          FadeInWrapper(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 6),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final options = [
                    ('open', l10n.open),
                    ('closed', l10n.closed),
                    ('all', l10n.all),
                  ];
                  final selected =
                      Injection.issueNotifier.issuesListFilter ?? 'open';
                  final index = options.indexWhere(
                    (option) => option.$1 == selected,
                  );
                  return Row(
                    children: [
                      SizedBox(
                        width: (constraints.maxWidth - 48).clamp(180, 260),
                        child: AppSegmentedControl(
                          index: index < 0 ? 0 : index,
                          labels: [for (final option in options) option.$2],
                          onChanged: (i) {
                            setState(() {});
                            Injection.issueNotifier.searchIssues(
                              _searchQuery,
                              state: options[i].$1,
                              filters: _filterState.value,
                            );
                          },
                        ),
                      ),
                      const Spacer(),
                      AppIconButton(
                        icon: FIcons.listFilter,
                        label: l10n.moreFilters,
                        selected: _filterState.value.hasFilters,
                        onPress: _showFilterSheet,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          ValueListenableBuilder<IssueFilterState>(
            valueListenable: _filterState,
            builder: (context, filter, _) {
              if (!filter.hasFilters) return const SizedBox.shrink();
              return FadeInWrapper(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: UIConstants.md,
                    vertical: UIConstants.sm,
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
                              labels: filter.labels.difference({label}),
                            );
                            _forceReload();
                          },
                        ),
                      ),
                      ...filter.milestones.map(
                        (m) => AppFilterChip(
                          label: m,
                          onRemove: () {
                            _filterState.value = filter.copyWith(
                              milestones: filter.milestones.difference({m}),
                            );
                            _forceReload();
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
                            _forceReload();
                          },
                        ),
                      if (filter.assignedToMe)
                        AppFilterChip(
                          label: l10n.assignedToMe,
                          onRemove: () {
                            _filterState.value = filter.copyWith(
                              assignedToMe: false,
                            );
                            _forceReload();
                          },
                        ),
                      if (filter.createdByMe)
                        AppFilterChip(
                          label: l10n.createdByMe,
                          onRemove: () {
                            _filterState.value = filter.copyWith(
                              createdByMe: false,
                            );
                            _forceReload();
                          },
                        ),
                      if (filter.mentionedMe)
                        AppFilterChip(
                          label: l10n.mentionedMe,
                          onRemove: () {
                            _filterState.value = filter.copyWith(
                              mentionedMe: false,
                            );
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
                  FTappable(
                    onPress: () => setState(
                      () => _savedFiltersExpanded = !_savedFiltersExpanded,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Icon(
                            _savedFiltersExpanded
                                ? FIcons.chevronUp
                                : FIcons.chevronDown,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${l10n.savedFilters} (${_savedFilters.length})',
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
                          return AppFilterChip(
                            label: f.name,
                            onPress: () => _applyFilter(f),
                            onRemove: () => _deleteSavedFilter(f),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          if (_filtersLoaded &&
              (_searchQuery.isNotEmpty ||
                  Injection.issueNotifier.issuesListFilter != null))
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: UIConstants.md),
                child: FButton(
                  variant: .ghost,
                  size: .xs,
                  mainAxisSize: .min,
                  prefix: const Icon(FIcons.bookmarkPlus, size: 14),
                  onPress: _saveCurrentFilter,
                  child: Text(l10n.saveFilter),
                ),
              ),
            ),
          Expanded(
            child: ListenableBuilder(
              listenable: Injection.issueNotifier,
              builder: (context, _) {
                final issuesState = Injection.issueNotifier.issuesListState;
                return switch (issuesState) {
                  IssuesListLoading() => const AppLoading(),
                  IssuesListError(:final message) => AppError(
                    message: message,
                    onRetry: _forceReload,
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
                  _ => const AppLoading(),
                };
              },
            ),
          ),
        ],
      ),
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
      return AppEmpty(icon: FIcons.circleDot, title: widget.l10n.noIssuesFound);
    }
    return RefreshIndicator(
      onRefresh: () async => widget.onRefresh(),
      child: ListView.builder(
        controller: _scrollController,
        padding:
            UIConstants.pagePadding +
            const EdgeInsets.symmetric(vertical: UIConstants.sm),
        itemCount:
            widget.issues.length +
            (widget.hasMore || widget.loadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= widget.issues.length) {
            return const _LoadingIndicator();
          }
          final issue = widget.issues[index];
          return FadeInWrapper(
            delay: Duration(milliseconds: (index * 40).clamp(0, 300)),
            child: _IssueCard(
              issue: issue,
              l10n: widget.l10n,
              onTap: () {
                final owner = issue.repository?.owner ?? '';
                final repo = issue.repository?.name ?? '';
                if (owner.isNotEmpty &&
                    repo.isNotEmpty &&
                    issue.number != null) {
                  widget.onIssueTap(owner, repo, issue.number!);
                }
              },
            ),
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
      child: Center(child: FCircularProgress(size: .sm)),
    );
  }
}

class _IssueCard extends StatelessWidget {
  final Issue issue;
  final AppLocalizations l10n;
  final VoidCallback onTap;

  const _IssueCard({
    required this.issue,
    required this.l10n,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isOpen = issue.state?.isOpen == true;
    final stateIcon = isOpen ? FIcons.circleDot : FIcons.circleCheck;
    final stateColor = isOpen ? palette.success : palette.purple;

    final repoFullName = issue.repository?.full_name ?? '';
    final owner = issue.repository?.owner ?? '';
    final repo = issue.repository?.name ?? '';
    final canNavigate =
        owner.isNotEmpty && repo.isNotEmpty && issue.number != null;

    return PremiumListCard(
      onTap: canNavigate ? onTap : null,
      padding: const EdgeInsets.fromLTRB(14, 11, 12, 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(stateIcon, size: 16, color: stateColor),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            issue.title ?? l10n.untitled,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: palette.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (issue.number != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              '#${issue.number}',
                              style: TextStyle(
                                fontSize: 11,
                                color: palette.textSecondary,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        if (issue.user != null) ...[
                          UserAvatar(user: issue.user!, radius: 9),
                          const SizedBox(width: 5),
                          Text(
                            issue.user!.login ?? '',
                            style: TextStyle(
                              fontSize: 11,
                              color: palette.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        if (repoFullName.isNotEmpty) ...[
                          Flexible(
                            child: Text(
                              repoFullName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                color: palette.textSecondary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        if (issue.updated_at != null)
                          Text(
                            _formatDate(issue.updated_at!, l10n),
                            style: TextStyle(
                              fontSize: 11,
                              color: palette.textSecondary.withValues(
                                alpha: 0.8,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              if ((issue.comments ?? 0) > 0)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      FIcons.messageSquare,
                      size: 12,
                      color: palette.textSecondary,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '${issue.comments}',
                      style: TextStyle(
                        fontSize: 11,
                        color: palette.textSecondary,
                      ),
                    ),
                  ],
                )
              else
                Icon(
                  FIcons.chevronRight,
                  size: 14,
                  color: palette.textSecondary.withValues(alpha: 0.7),
                ),
            ],
          ),
          if (issue.labels != null && issue.labels!.isNotEmpty) ...[
            const SizedBox(height: 7),
            Padding(
              padding: const EdgeInsets.only(left: 26),
              child: _LabelRow(labels: issue.labels!),
            ),
          ],
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
          final raw = _color(label.color);
          final c = Theme.of(context).brightness == Brightness.dark
              ? Color.lerp(raw, Colors.white, 0.28)!
              : raw;
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
