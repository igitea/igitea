import 'package:flutter/material.dart';

import '../../core/animations/animated_wrapper.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/empty_state.dart';
import 'action_run_detail_page.dart';

class ActionsListPage extends StatefulWidget {
  final String owner;
  final String repo;

  const ActionsListPage({super.key, required this.owner, required this.repo});

  @override
  State<ActionsListPage> createState() => _ActionsListPageState();
}

class _ActionsListPageState extends State<ActionsListPage> {
  List<Map<String, dynamic>> _runs = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadRuns();
  }

  Future<void> _loadRuns() async {
    setState(() { _loading = true; _error = null; });
    try {
      final result = await Injection.apiService.repoListActionRuns(
        owner: widget.owner,
        repo: widget.repo,
      );
      if (mounted) {
        setState(() {
          _runs = (result['runs'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.actions)),
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
          FilledButton(onPressed: _loadRuns, child: Text(l10n.retry)),
        ]),
      );
    }
    if (_runs.isEmpty) {
      return EmptyState(icon: Icons.play_circle_outline, title: l10n.noActions);
    }
    return RefreshIndicator(
      onRefresh: _loadRuns,
      child: ListView.builder(
        padding: const EdgeInsets.all(UIConstants.md),
        itemCount: _runs.length,
        itemBuilder: (context, index) {
          final run = _runs[index];
          return FadeInWrapper(
            delay: Duration(milliseconds: index * 20),
            child: _buildRunCard(run, l10n),
          );
        },
      ),
    );
  }

  Widget _buildRunCard(Map<String, dynamic> run, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final status = (run['status'] as String? ?? 'unknown').toLowerCase();
    final conclusion = (run['conclusion'] as String? ?? '').toLowerCase();
    final displayStatus = conclusion.isNotEmpty && conclusion != 'null' ? conclusion : status;
    final color = _statusColor(displayStatus);
    final runNumber = run['run_number'] ?? run['id'] ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: UIConstants.sm),
      child: InkWell(
        borderRadius: BorderRadius.circular(UIConstants.cardRadius),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ActionRunDetailPage(
              owner: widget.owner,
              repo: widget.repo,
              runId: (run['id'] as num).toInt(),
              runData: run,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(UIConstants.md),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(UIConstants.sm),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.15), shape: BoxShape.circle),
                child: Icon(_statusIcon(displayStatus), color: color, size: UIConstants.iconMd),
              ),
              const SizedBox(width: UIConstants.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      run['title'] as String? ?? '$l10n.run #$runNumber',
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: UIConstants.xs),
                    Row(
                      children: [
                        _buildBadge(displayStatus, color),
                        const SizedBox(width: UIConstants.sm),
                        if (run['branch'] != null)
                          Text(
                            run['branch'] as String,
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontFamily: 'monospace',
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: UIConstants.sm, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(UIConstants.badgeRadius),
      ),
      child: Text(status, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  Color _statusColor(String status) {
    return switch (status) {
      'success' => Colors.green,
      'failure' || 'cancelled' => Colors.red,
      'in_progress' || 'queued' || 'pending' => Colors.orange,
      'skipped' => Colors.grey,
      _ => Colors.blue,
    };
  }

  IconData _statusIcon(String status) {
    return switch (status) {
      'success' => Icons.check_circle,
      'failure' || 'cancelled' => Icons.cancel,
      'in_progress' || 'queued' || 'pending' => Icons.hourglass_top,
      'skipped' => Icons.skip_next,
      _ => Icons.help_outline,
    };
  }
}
