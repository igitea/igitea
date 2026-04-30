import 'package:flutter/material.dart';

import '../../core/animations/animated_wrapper.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/empty_state.dart';
import 'action_run_detail_page.dart';

_toInt(dynamic value) => switch (value) { num n => n.toInt(), String s => int.tryParse(s) ?? 0, _ => 0 };

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

  List<Map<String, dynamic>> _workflows = [];
  Map<int, List<Map<String, dynamic>>> _workflowRuns = {};
  bool _loadingWorkflows = true;
  bool _loadingRuns = false;
  bool _hasMore = true;
  int _page = 1;
  static const _pageSize = 20;
  String? _error;

  String? _statusFilter;
  String? _actorFilter;
  Set<String> _actors = {};

  @override
  void initState() {
    super.initState();
    _loadWorkflows();
  }

  Future<void> _loadWorkflows() async {
    setState(() { _loadingWorkflows = true; _error = null; });
    try {
      final result = await Injection.apiService.repoListActionWorkflows(
        owner: widget.owner,
        repo: widget.repo,
      );
      final workflows = (result['workflows'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
      if (mounted) {
        setState(() {
          _workflows = workflows;
          _loadingWorkflows = false;
        });
        _loadAllRuns();
      }
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loadingWorkflows = false; });
    }
  }

  Future<void> _loadAllRuns({bool loadMore = false}) async {
    if (_loadingRuns) return;
    if (loadMore && !_hasMore) return;

    setState(() => _loadingRuns = true);
    final page = loadMore ? _page + 1 : 1;

    try {
      final result = await Injection.apiService.repoListActionRuns(
        owner: widget.owner,
        repo: widget.repo,
        status: _statusFilter,
        actor: _actorFilter,
        page: page,
        limit: _pageSize,
      );
      final newRuns = (result['runs'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
      final total = (result['total_count'] as num?)?.toInt() ?? newRuns.length;

      if (mounted) {
        final allRuns = loadMore ? [..._allRuns, ...newRuns] : newRuns;
        _allRuns = allRuns;
        _hasMore = allRuns.length < total;
        _page = page;

        // Collect unique actors
        for (final r in allRuns) {
          final actor = r['actor'] as Map<String, dynamic>?;
          if (actor?['login'] != null) _actors.add(actor!['login'] as String);
        }

        // Group runs by workflow
        _workflowRuns = {};
        for (final r in allRuns) {
          final wfId = _toInt(r['workflow_id']);
          _workflowRuns.putIfAbsent(wfId, () => []).add(r);
        }

        setState(() => _loadingRuns = false);
      }
    } catch (_) {
      if (mounted) setState(() => _loadingRuns = false);
    }
  }

  List<Map<String, dynamic>> _allRuns = [];

  void _setFilter(String? status, String? actor) {
    setState(() {
      _statusFilter = status;
      _actorFilter = actor;
      _allRuns = [];
      _workflowRuns = {};
      _page = 1;
      _hasMore = true;
    });
    _loadAllRuns();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.actions)),
      body: Column(
        children: [
          _buildFilters(l10n),
          Expanded(child: _buildBody(l10n)),
        ],
      ),
    );
  }

  Widget _buildFilters(AppLocalizations l10n) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: UIConstants.md, vertical: UIConstants.sm),
      child: Row(
        children: [
          _filterChip(l10n.all, _statusFilter == null && _actorFilter == null, () => _setFilter(null, null)),
          const SizedBox(width: UIConstants.sm),
          ...['success', 'failure', 'in_progress', 'queued', 'cancelled', 'skipped'].map((s) =>
            _filterChip(s, _statusFilter == s, () => _setFilter(s, _actorFilter)),
          ),
          const SizedBox(width: UIConstants.sm),
          ..._actors.map((a) =>
            _filterChip('@$a', _actorFilter == a, () => _setFilter(_statusFilter, a)),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, bool selected, VoidCallback onTap) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_loadingWorkflows) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('${l10n.error}: $_error'),
          const SizedBox(height: UIConstants.md),
          FilledButton(onPressed: _loadWorkflows, child: Text(l10n.retry)),
        ]),
      );
    }
    if (_allRuns.isEmpty && !_loadingRuns) {
      return Center(child: Text(_statusFilter != null || _actorFilter != null ? l10n.noResults : l10n.noActions));
    }

    return RefreshIndicator(
      onRefresh: () async { _page = 1; _hasMore = true; _allRuns = []; _workflowRuns = {}; await _loadAllRuns(); },
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollEndNotification && notification.metrics.pixels >= notification.metrics.maxScrollExtent - 200) {
            _loadAllRuns(loadMore: true);
          }
          return false;
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(UIConstants.md),
          itemCount: _workflows.length + (_loadingRuns && _hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= _workflows.length) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final wf = _workflows[index];
            final wfId = _toInt(wf['id']);
            final runs = _workflowRuns[wfId] ?? [];
            if (runs.isEmpty) return const SizedBox.shrink();
            return _buildWorkflowGroup(wf, runs, l10n);
          },
        ),
      ),
    );
  }

  Widget _buildWorkflowGroup(Map<String, dynamic> workflow, List<Map<String, dynamic>> runs, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final wfName = workflow['name'] as String? ?? workflow['filename'] as String? ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: UIConstants.sm),
          child: Row(
            children: [
              Icon(Icons.article_outlined, size: UIConstants.iconMd, color: theme.colorScheme.primary),
              const SizedBox(width: UIConstants.sm),
              Text(wfName, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(width: UIConstants.sm),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: UIConstants.sm, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(UIConstants.badgeRadius),
                ),
                child: Text('${runs.length}', style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                )),
              ),
            ],
          ),
        ),
        ...runs.map((run) => _buildRunCard(run, l10n)),
        const SizedBox(height: UIConstants.sm),
      ],
    );
  }

  Widget _buildRunCard(Map<String, dynamic> run, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final status = (run['status'] as String? ?? 'unknown').toLowerCase();
    final conclusion = (run['conclusion'] as String? ?? '').toLowerCase();
    final displayStatus = conclusion.isNotEmpty && conclusion != 'null' ? conclusion : status;
    final color = _statusColor(displayStatus);
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
              Icon(_statusIcon(displayStatus), color: color, size: UIConstants.iconMd),
              const SizedBox(width: UIConstants.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      run['title'] as String? ?? '$l10n.run #$runNumber',
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: UIConstants.xs),
                    Row(
                      children: [
                        _badge(displayStatus, color),
                        if (actor?['login'] != null) ...[
                          const SizedBox(width: UIConstants.sm),
                          Icon(Icons.person, size: 12, color: theme.colorScheme.onSurfaceVariant),
                          const SizedBox(width: 2),
                          Text(actor!['login'] as String, style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          )),
                        ],
                        if (run['branch'] != null) ...[
                          const SizedBox(width: UIConstants.sm),
                          Icon(Icons.call_split, size: 12, color: theme.colorScheme.onSurfaceVariant),
                          const SizedBox(width: 2),
                          Text(run['branch'] as String, style: theme.textTheme.labelSmall?.copyWith(
                            fontFamily: 'monospace', color: theme.colorScheme.onSurfaceVariant,
                          )),
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
    'skipped' || 'neutral' => Colors.grey,
    _ => Colors.blue,
  };
  IconData _statusIcon(String s) => switch (s) {
    'success' => Icons.check_circle,
    'failure' || 'cancelled' || 'canceling' || 'timed_out' => Icons.cancel,
    'in_progress' || 'queued' || 'pending' || 'waiting' => Icons.hourglass_top,
    'skipped' || 'neutral' => Icons.skip_next,
    _ => Icons.help_outline,
  };
}
