import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/animations/animated_wrapper.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/empty_state.dart';

int _toInt(dynamic value) => switch (value) { num n => n.toInt(), String s => int.tryParse(s) ?? 0, _ => 0 };

class ActionRunDetailPage extends StatefulWidget {
  final String owner;
  final String repo;
  final int runId;
  final Map<String, dynamic> runData;

  const ActionRunDetailPage({
    super.key,
    required this.owner,
    required this.repo,
    required this.runId,
    required this.runData,
  });

  @override
  State<ActionRunDetailPage> createState() => _ActionRunDetailPageState();
}

class _ActionRunDetailPageState extends State<ActionRunDetailPage> {
  List<Map<String, dynamic>> _jobs = [];
  List<Map<String, dynamic>> _artifacts = [];
  Map<int, String> _logs = {};
  Set<int> _expandedJobs = {};
  bool _loadingJobs = false;
  Timer? _pollTimer;
  bool _hasIncompleteJobs = true;

  @override
  void initState() {
    super.initState();
    _loadJobs();
    _loadArtifacts();
    _startPolling();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (_hasIncompleteJobs) {
        _refreshJobs();
      }
    });
  }

  bool _isComplete(Map<String, dynamic> job) {
    final s = (job['status'] as String? ?? '').toLowerCase();
    return s == 'completed' || s == 'success' || s == 'failure' ||
           s == 'cancelled' || s == 'skipped' || s == 'canceling';
  }

  Future<void> _refreshJobs() async {
    try {
      final result = await Injection.apiService.repoListActionJobs(
        owner: widget.owner, repo: widget.repo, run: widget.runId,
      );
      if (!mounted) return;
      final newJobs = (result['jobs'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
      final allComplete = newJobs.every(_isComplete);
      final reloadedLogs = <int, String>{};

      // Re-fetch logs for expanded jobs that are still running
      for (final j in newJobs) {
        final jId = _toInt(j['id']);
        if (_expandedJobs.contains(jId)) {
          try {
            reloadedLogs[jId] = await Injection.apiService.repoGetActionJobLogs(
              owner: widget.owner, repo: widget.repo, jobId: jId,
            );
          } catch (_) {
            reloadedLogs[jId] = _logs[jId] ?? '';
          }
        }
      }

      if (mounted) {
        setState(() {
          _jobs = newJobs;
          _hasIncompleteJobs = !allComplete;
          if (reloadedLogs.isNotEmpty) _logs.addAll(reloadedLogs);
        });
      }

      if (allComplete) _pollTimer?.cancel();
    } catch (_) {}
  }

  Future<void> _loadJobs() async {
    setState(() => _loadingJobs = true);
    try {
      final result = await Injection.apiService.repoListActionJobs(
        owner: widget.owner, repo: widget.repo, run: widget.runId,
      );
      if (mounted) {
        final jobs = (result['jobs'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
        final incomplete = jobs.any((j) => !_isComplete(j));
        // Auto-expand in-progress jobs
        final expand = <int>{};
        for (final j in jobs) {
          final jId = _toInt(j['id']);
          if (!_isComplete(j)) expand.add(jId);
        }
        setState(() {
          _jobs = jobs;
          _loadingJobs = false;
          _hasIncompleteJobs = incomplete;
          _expandedJobs.addAll(expand);
        });
        // Auto-load logs for expanded jobs
        for (final jId in expand) {
          _refreshLog(jId);
        }
      }
    } catch (_) {
      if (mounted) setState(() => _loadingJobs = false);
    }
  }

  Future<void> _refreshLog(int jobId) async {
    try {
      final logs = await Injection.apiService.repoGetActionJobLogs(
        owner: widget.owner, repo: widget.repo, jobId: jobId,
      );
      if (mounted) setState(() => _logs[jobId] = logs);
    } catch (_) {}
  }

  Future<void> _loadArtifacts() async {
    try {
      final result = await Injection.apiService.repoListActionArtifacts(
        owner: widget.owner,
        repo: widget.repo,
      );
      if (mounted) {
        final all = (result['artifacts'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
        final filtered = all.where((a) => _toInt(a['run_id']) == widget.runId).toList();
        setState(() { _artifacts = filtered; });
      }
    } catch (_) {}
  }

  Future<void> _loadLogs(int jobId) async {
    if (_logs.containsKey(jobId)) {
      setState(() {
        if (_expandedJobs.contains(jobId)) {
          _expandedJobs.remove(jobId);
        } else {
          _expandedJobs.add(jobId);
          // Refresh if job may still be running
          final job = _jobs.where((j) => _toInt(j['id']) == jobId).firstOrNull;
          if (job != null && !_isComplete(job)) _refreshLog(jobId);
        }
      });
      return;
    }
    setState(() => _expandedJobs.add(jobId));
    await _refreshLog(jobId);
  }

  String _runStatus(Map<String, dynamic> run) {
    final status = (run['status'] as String? ?? '').toLowerCase();
    final conclusion = (run['conclusion'] as String? ?? '').toLowerCase();
    return conclusion.isNotEmpty && conclusion != 'null' && conclusion != 'none' ? conclusion : status;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final status = _runStatus(widget.runData);
    final color = _statusColor(status);
    final runNum = widget.runData['run_number'] ?? widget.runId;

    return Scaffold(
      appBar: AppBar(title: Text('$l10n.run #$runNum')),
      body: ListView(
        padding: const EdgeInsets.all(UIConstants.md),
        children: [
          // Run info header
          Card(
            child: Padding(
              padding: const EdgeInsets.all(UIConstants.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(_statusIcon(status), color: color, size: 28),
                      const SizedBox(width: UIConstants.sm),
                      Expanded(
                        child: Text(
                          widget.runData['display_title'] as String? ?? '$l10n.run #$runNum',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: UIConstants.sm),
                  Wrap(
                    spacing: UIConstants.sm,
                    runSpacing: UIConstants.xs,
                    children: [
                      _infoChip(l10n.status, status, color),
                      if (widget.runData['head_branch'] != null)
                        _infoChip(l10n.branch, widget.runData['head_branch'] as String, theme.colorScheme.primary),
                      if (widget.runData['actor']?['login'] != null)
                        _infoChip(l10n.author, widget.runData['actor']['login'] as String, theme.colorScheme.primary),
                    ],
                  ),
                  if (widget.runData['display_title'] != null) ...[
                    const SizedBox(height: UIConstants.sm),
                    Text(
                      widget.runData['display_title'] as String,
                      style: theme.textTheme.bodySmall,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: UIConstants.md),

          // Jobs section
          Text(l10n.jobs, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: UIConstants.sm),
          if (_loadingJobs)
            const Center(child: CircularProgressIndicator())
          else if (_jobs.isEmpty)
            EmptyState(icon: Icons.assignment, title: l10n.noJobs)
          else
            ..._jobs.asMap().entries.map((entry) => FadeInWrapper(
              delay: Duration(milliseconds: entry.key * 20),
              child: _buildJobCard(entry.value, l10n),
            )),

          // Artifacts section
          if (_artifacts.isNotEmpty) ...[
            const SizedBox(height: UIConstants.md),
            Text(l10n.artifacts, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: UIConstants.sm),
            ..._artifacts.map((a) => Card(
              margin: const EdgeInsets.only(bottom: UIConstants.sm),
              child: ListTile(
                leading: const Icon(Icons.archive_outlined),
                title: Text(a['name'] as String? ?? ''),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_formatSize((a['size'] as num?)?.toInt() ?? 0),
                      style: theme.textTheme.bodySmall),
                    IconButton(
                      icon: const Icon(Icons.download, size: UIConstants.iconMd),
                      tooltip: l10n.download,
                      onPressed: () => _downloadArtifact(a),
                    ),
                  ],
                ),
              ),
            )),
          ],
        ],
      ),
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final jobId = _toInt(job['id']);
    final status = (job['status'] as String? ?? 'unknown').toLowerCase();
    final conclusion = (job['conclusion'] as String? ?? '').toLowerCase();
    final displayStatus = conclusion.isNotEmpty && conclusion != 'null' ? conclusion : status;
    final color = _statusColor(displayStatus);
    final expanded = _expandedJobs.contains(jobId);

    return Card(
      margin: const EdgeInsets.only(bottom: UIConstants.sm),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: () => _loadLogs(jobId),
            child: Padding(
              padding: const EdgeInsets.all(UIConstants.md),
              child: Row(
                children: [
                  Icon(_statusIcon(displayStatus), color: color, size: UIConstants.iconMd),
                  const SizedBox(width: UIConstants.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(job['name'] as String? ?? '', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                        const SizedBox(height: UIConstants.xs),
                        Row(
                          children: [
                            _buildBadge(displayStatus, color),
                            if (job['started_at'] != null) ...[
                              const SizedBox(width: UIConstants.sm),
                              Text(_formatDuration(job), style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              )),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(expanded ? Icons.expand_less : Icons.expand_more),
                ],
              ),
            ),
          ),
          if (expanded)
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxHeight: 400),
              color: theme.colorScheme.surfaceContainerHighest,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(UIConstants.sm),
                child: _logs.containsKey(jobId)
                    ? SelectableText(
                        _logs[jobId]!,
                        style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }

  Widget _infoChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: UIConstants.sm, vertical: UIConstants.xs),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(UIConstants.badgeRadius),
      ),
      child: Text('$label: $value', style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500)),
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
      'failure' || 'cancelled' || 'canceling' || 'timed_out' => Colors.red,
      'in_progress' || 'queued' || 'pending' || 'waiting' => Colors.orange,
      'skipped' || 'neutral' => Colors.grey,
      _ => Colors.blue,
    };
  }

  IconData _statusIcon(String status) {
    return switch (status) {
      'success' => Icons.check_circle,
      'failure' || 'cancelled' || 'canceling' || 'timed_out' => Icons.cancel,
      'in_progress' || 'queued' || 'pending' || 'waiting' => Icons.hourglass_top,
      'skipped' || 'neutral' => Icons.skip_next,
      _ => Icons.help_outline,
    };
  }

  String _formatDuration(Map<String, dynamic> job) {
    final started = job['started_at'] as String?;
    final completed = job['completed_at'] as String?;
    if (started == null) return '';
    final start = DateTime.tryParse(started);
    if (start == null) return '';
    final end = completed != null ? (DateTime.tryParse(completed) ?? DateTime.now()) : DateTime.now();
    final diff = end.difference(start);
    if (diff.inHours > 0) return '${diff.inHours}h ${diff.inMinutes % 60}m';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ${diff.inSeconds % 60}s';
    return '${diff.inSeconds}s';
  }

  Future<void> _downloadArtifact(Map<String, dynamic> artifact) async {
    final l10n = AppLocalizations.of(context)!;
    final name = artifact['name'] as String? ?? 'artifact.zip';
    try {
      final bytes = await Injection.apiService.repoDownloadArtifact(
        owner: widget.owner, repo: widget.repo,
        artifactId: _toInt(artifact['id']),
      );
      // Use path_provider to save to downloads
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$name.zip');
      await file.writeAsBytes(bytes);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$l10n.saved: ${file.path}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.error}: $e')),
        );
      }
    }
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
