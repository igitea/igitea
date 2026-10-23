import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import '../../l10n/app_localizations.dart';
import '../models/repo_filter_state.dart';

class RepoFilterBottomSheet extends StatefulWidget {
  final RepoFilterState initialState;

  const RepoFilterBottomSheet({
    super.key,
    required this.initialState,
  });

  @override
  State<RepoFilterBottomSheet> createState() => _RepoFilterBottomSheetState();
}

class _RepoFilterBottomSheetState extends State<RepoFilterBottomSheet> {
  late RepoFilterState _state;

  static const _sortOptions = [
    (value: null, labelKey: 'relevance'),
    (value: 'alpha', labelKey: 'alphabetical'),
    (value: 'created', labelKey: 'newest'),
    (value: 'updated', labelKey: 'recentlyUpdated'),
    (value: 'stars', labelKey: 'mostStars'),
    (value: 'size', labelKey: 'largest'),
  ];

  @override
  void initState() {
    super.initState();
    _state = widget.initialState;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return SafeArea(
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              excludeSemantics: true,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 32,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                l10n.filters,
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionTitle(title: l10n.sort),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _sortOptions.map((option) {
                        final isSelected = _state.sort == option.value;
                        return FButton(
                          variant: isSelected ? .primary : .outline,
                          size: .xs,
                          mainAxisSize: .min,
                          onPress: () => setState(
                            () => _state = _state.copyWith(
                              sort: option.value,
                              clearSort: option.value == null,
                            ),
                          ),
                          child: Text(_getSortLabel(option.labelKey, l10n)),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    _SectionTitle(title: l10n.order),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        for (final (value, label) in [
                          (null, l10n.default_),
                          ('asc', l10n.ascending),
                          ('desc', l10n.descending),
                        ])
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 3),
                              child: FButton(
                                variant: _state.order == value ? .primary : .outline,
                                size: .sm,
                                onPress: () => setState(
                                  () => _state = _state.copyWith(
                                    order: value,
                                    clearOrder: value == null,
                                  ),
                                ),
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
                    const SizedBox(height: 16),
                    FCheckbox(
                      label: Text(l10n.privateReposOnly),
                      value: _state.private ?? false,
                      onChange: (v) => setState(
                        () => _state = _state.copyWith(private: v),
                      ),
                    ),
                    const SizedBox(height: 8),
                    FCheckbox(
                      label: Text(l10n.includeArchived),
                      value: _state.archived ?? false,
                      onChange: (v) => setState(
                        () => _state = _state.copyWith(archived: v),
                      ),
                    ),
                    const SizedBox(height: 8),
                    FCheckbox(
                      label: Text(l10n.templatesOnly),
                      value: _state.template ?? false,
                      onChange: (v) => setState(
                        () => _state = _state.copyWith(template: v),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: FButton(
                      variant: .outline,
                      onPress: () => Navigator.pop(
                        context,
                        const RepoFilterState(),
                      ),
                      child: Text(l10n.reset),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FButton(
                      onPress: () => Navigator.pop(context, _state),
                      child: Text(l10n.apply),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }

  String _getSortLabel(String key, AppLocalizations l10n) {
    return switch (key) {
      'relevance' => l10n.relevance,
      'alphabetical' => l10n.alphabetical,
      'newest' => l10n.newest,
      'recentlyUpdated' => l10n.recentlyUpdated,
      'mostStars' => l10n.mostStars,
      'largest' => l10n.largest,
      _ => key,
    };
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
