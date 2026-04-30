import 'package:flutter/material.dart';

import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../l10n/app_localizations.dart';
import 'action_run_detail_page.dart';

int _toInt(dynamic value) => switch (value) { num n => n.toInt(), String s => int.tryParse(s) ?? 0, _ => 0 };

class ActionsListPage extends StatefulWidget {
  final String owner;
  final String repo;

  const ActionsListPage({super.key, required this.owner, required this.repo});

  @override
  State<ActionsListPage> createState() => _ActionsListPageState();
}

class _ActionsListPageState extends State<ActionsListPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<Map<String, dynamic>> _allRuns = [];
  List<Map<String, dynamic>> _workflows = [];
  bool _loading = true;
  bool _loadingMore = false;
  bool _hasMore = true;
  int _page = 1;
  static const _pageSize = 30;
  String? _error;

  String? _statusFilter;
  String? _actorFilter;
  final Set<String> _actors = {};

  @override
  void initState() {
    super.initState();
    _loadWorkflowsThenRuns();
  }

  Future<void> _loadWorkflowsThenRuns() async {
    setState(() { _loading = true; _error = null; });
    try {
      final wfResult = await Injection.apiService.repoListActionWorkflows(
        owner: widget.owner, repo: widget.repo,
      );
      if (mounted) {
        _workflows = (wfResult['workflows'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
      }
    } catch (_) {}
    await _loadRuns(reset: true);
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _loadRuns({bool reset = false, bool loadMore = false}) async {
    if (_loadingMore) return;
    if (loadMore && !_hasMore) return;
    if (loadMore) { _loadingMore = true; if (mounted) setState(() {}); }

    final page = reset ? 1 : (_page + 1);
    try {
      final result = await Injection.apiService.repoListActionRuns(
        owner: widget.owner, repo: widget.repo,
        status: _statusFilter, actor: _actorFilter,
        page: page, limit: _pageSize,
      );
      final newRuns = (result['workflow_runs'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
      final total = (result['total_count'] as num?)?.toInt() ?? newRuns.length;

      if (mounted) {
        for (final r in newRuns) {
          final actor = r['actor'] as Map<String, dynamic>?;
          if (actor?['login'] != null) _actors.add(actor!['login'] as String);
        }
        setState(() {
          if (reset) { _allRuns = newRuns; _page = 1; }
          else { _allRuns.addAll(newRuns); _page = page; }
          _hasMore = _allRuns.length < total;
          _loadingMore = false;
        });
      }
    } catch (e) {
      if (mounted) {
        if (reset) setState(() { _error = e.toString(); _loading = false; });
        setState(() => _loadingMore = false);
      }
    }
  }

  List<Map<String, dynamic>> get _filteredRuns {
    var runs = _allRuns;
    if (_statusFilter != null) runs = runs.where((r) {
      final s = (r['status'] as String? ?? '').toLowerCase();
      final c = (r['conclusion'] as String? ?? '').toLowerCase();
      return (c.isNotEmpty && c != 'null' ? c : s) == _statusFilter;
    }).toList();
    if (_actorFilter != null) runs = runs.where((r) {
      final actor = r['actor'] as Map<String, dynamic>?;
      return actor?['login'] == _actorFilter;
    }).toList();
    return runs;
  }

  Map<String, List<Map<String, dynamic>>> get _groupedRuns {
    final groups = <String, List<Map<String, dynamic>>>{};
    for (final r in _filteredRuns) {
      final path = r['path'] as String? ?? '_other_';
      groups.putIfAbsent(path, () => []).add(r);
    }
    return groups;
  }

  Future<void> _refresh() async {
    _actors.clear();
    await _loadWorkflowsThenRuns();
  }

  void _applyFilter(String? status, String? actor) {
    setState(() { _statusFilter = status; _actorFilter = actor; });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.actions),
        actions: [
          if (_actors.isNotEmpty)
            PopupMenuButton<String>(
              icon: const Icon(Icons.person_outline),
              tooltip: l10n.filterByActor,
              onSelected: (a) => _applyFilter(_statusFilter, a == 'all' ? null : a),
              itemBuilder: (_) => [
                PopupMenuItem(value: 'all', child: Text(l10n.all)),
                ..._actors.map((a) => PopupMenuItem(value: a, child: Text(a))),
              ],
            ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            tooltip: l10n.filterByStatus,
            onSelected: (s) => _applyFilter(s == 'all' ? null : s, _actorFilter),
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'all', child: Text('All')),
              for (final s in ['success', 'failure', 'in_progress', 'queued', 'cancelled', 'skipped'])
                PopupMenuItem(value: s, child: Text(s)),
            ],
          ),
        ],
      ),
      body: _buildBody(l10n),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('${l10n.error}: $_error'),
          const SizedBox(height: UIConstants.md),
          FilledButton(onPressed: _refresh, child: Text(l10n.retry)),
        ]),
      );
    }

    final filtered = _filteredRuns;
    if (filtered.isEmpty) {
      return Center(child: Text(_statusFilter != null || _actorFilter != null ? l10n.noResults : l10n.noActions));
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: NotificationListener<ScrollNotification>(
        onNotification: (n) {
          if (n is ScrollEndNotification && n.metrics.pixels >= n.metrics.maxScrollExtent - 300) {
            _loadRuns(loadMore: true);
          }
          return false;
        },
        child: _workflows.isNotEmpty ? _buildGroupedView() : _buildFlatView(),
      ),
    );
  }

  Widget _buildGroupedView() {
    final groups = _groupedRuns;
    final wfMap = {for (final w in _workflows) _toInt(w['id']): w};
    // Also collect runs with no matching workflow
    final orphanRuns = _filteredRuns.where((r) {
      final wfId = _toInt(r['workflow_id']);
      return !wfMap.containsKey(wfId) || wfId == 0;
    }).toList();

    final totalItems = groups.length + (orphanRuns.isNotEmpty ? 1 : 0) + (_loadingMore ? 1 : 0);
    return ListView.builder(
      padding: const EdgeInsets.all(UIConstants.md),
      itemCount: totalItems,
      itemBuilder: (context, index) {
        int groupIdx = index;
        if (groupIdx < groups.length) {
          final entry = groups.entries.elementAt(groupIdx);
          final wf = wfMap[entry.key];
          return _buildWorkflowGroup(wf, entry.value);
        }
        groupIdx -= groups.length;
        if (orphanRuns.isNotEmpty) {
          if (groupIdx == 0) return _buildOrphanGroup(orphanRuns);
          groupIdx--;
        }
        if (_loadingMore) return const Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        );
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildFlatView() {
    return ListView.builder(
      padding: const EdgeInsets.all(UIConstants.md),
      itemCount: _filteredRuns.length + (_loadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= _filteredRuns.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return _buildRunCard(_filteredRuns[index]);
      },
    );
  }

  Widget _buildWorkflowGroup(Map<String, dynamic>? workflow, List<Map<String, dynamic>> runs) {
    final theme = Theme.of(context);
    final wfName = workflow?['name'] as String? ?? workflow?['filename'] as String? ?? 'Workflow #${workflow?['id'] ?? ''}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: UIConstants.sm, bottom: UIConstants.xs),
          child: Row(
            children: [
              Icon(Icons.article_outlined, size: UIConstants.iconMd, color: theme.colorScheme.primary),
              const SizedBox(width: UIConstants.sm),
              Expanded(child: Text(wfName, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: UIConstants.sm, vertical: 1),
                decoration: BoxDecoration(color: theme.colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(UIConstants.badgeRadius)),
                child: Text('${runs.length}', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ),
            ],
          ),
        ),
        ...runs.map((r) => _buildRunCard(r)),
        const SizedBox(height: UIConstants.sm),
      ],
    );
  }

  Widget _buildOrphanGroup(List<Map<String, dynamic>> runs) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: UIConstants.sm, bottom: UIConstants.xs),
          child: Row(
            children: [
              Icon(Icons.help_outline, size: UIConstants.iconMd, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: UIConstants.sm),
              Text('Other', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: UIConstants.sm, vertical: 1),
                decoration: BoxDecoration(color: theme.colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(UIConstants.badgeRadius)),
                child: Text('${runs.length}', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ),
            ],
          ),
        ),
        ...runs.map((r) => _buildRunCard(r)),
        const SizedBox(height: UIConstants.sm),
      ],
    );
  }

  String _displayStatus(Map<String, dynamic> run) {
    final s = (run['status'] as String? ?? '').toLowerCase();
    final c = (run['conclusion'] as String? ?? '').toLowerCase();
    return c.isNotEmpty && c != 'null' ? c : s;
  }

  Widget _buildRunCard(Map<String, dynamic> run) {
    final theme = Theme.of(context);
    final ds = _displayStatus(run);
    final color = _statusColor(ds);
    final runNumber = run['run_number'] ?? run['id'] ?? 0;
    final actor = run['actor'] as Map<String, dynamic>?;

    return Card(
      margin: const EdgeInsets.only(bottom: UIConstants.xs),
      child: InkWell(
        borderRadius: BorderRadius.circular(UIConstants.cardRadius),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ActionRunDetailPage(
              owner: widget.owner, repo: widget.repo,
              runId: _toInt(run['id']), runData: run,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(UIConstants.sm),
          child: Row(
            children: [
              Icon(_statusIcon(ds), color: color, size: UIConstants.iconMd),
              const SizedBox(width: UIConstants.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(run['display_title'] as String? ?? 'Run #$runNumber',
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: UIConstants.xs),
                    Row(
                      children: [
                        _badge(ds, color),
                        if (actor?['login'] != null) ...[
                          const SizedBox(width: UIConstants.sm),
                          Icon(Icons.person, size: 12, color: theme.colorScheme.onSurfaceVariant),
                          const SizedBox(width: 2),
                          Text(actor!['login'] as String,
                            style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                        ],
                        if (run['head_branch'] != null) ...[
                          const SizedBox(width: UIConstants.sm),
                          Icon(Icons.call_split, size: 12, color: theme.colorScheme.onSurfaceVariant),
                          const SizedBox(width: 2),
                          Text(run['head_branch'] as String,
                            style: theme.textTheme.labelSmall?.copyWith(fontFamily: 'monospace', color: theme.colorScheme.onSurfaceVariant)),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, size: UIConstants.iconMd),
            ],
          ),
        ),
      ),
    );
  }

  Widget _badge(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: UIConstants.sm, vertical: 1),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(UIConstants.badgeRadius)),
      child: Text(status, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Color _statusColor(String s) => switch (s) {
    'success' => Colors.green,
    'failure' || 'cancelled' || 'canceling' || 'timed_out' => Colors.red,
    'in_progress' || 'queued' || 'pending' || 'waiting' => Colors.orange,
    'skipped' || 'neutral' => Colors.grey, _ => Colors.blue,
  };
  IconData _statusIcon(String s) => switch (s) {
    'success' => Icons.check_circle,
    'failure' || 'cancelled' || 'canceling' || 'timed_out' => Icons.cancel,
    'in_progress' || 'queued' || 'pending' || 'waiting' => Icons.hourglass_top,
    'skipped' || 'neutral' => Icons.skip_next, _ => Icons.help_outline,
  };
}
