import 'package:flutter/material.dart';

import '../../core/animations/animated_wrapper.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../l10n/app_localizations.dart';
import 'pr_diff_viewer_page.dart';

class PrFilesPage extends StatefulWidget {
  final String owner;
  final String repo;
  final int index;

  const PrFilesPage({
    super.key,
    required this.owner,
    required this.repo,
    required this.index,
  });

  @override
  State<PrFilesPage> createState() => _PrFilesPageState();
}

class _PrFilesPageState extends State<PrFilesPage> {
  List<Map<String, dynamic>> _files = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final response = await Injection.apiService.repoGetPullRequestFiles(
        owner: widget.owner,
        repo: widget.repo,
        index: widget.index,
      );
      if (mounted) {
        setState(() {
          _files = response.cast<Map<String, dynamic>>();
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.filesChanged),
        actions: [
          if (_files.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.code),
              tooltip: l10n.viewDiff,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PrDiffViewerPage(
                      owner: widget.owner,
                      repo: widget.repo,
                      index: widget.index,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
      body: _buildBody(l10n, theme),
    );
  }

  Widget _buildBody(AppLocalizations l10n, ThemeData theme) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${l10n.error}: $_error'),
            const SizedBox(height: UIConstants.md),
            FilledButton(
              onPressed: _loadFiles,
              child: Text(l10n.retry),
            ),
          ],
        ),
      );
    }
    if (_files.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.folder_outlined, size: 64,
              color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(height: UIConstants.md),
            Text(l10n.noFilesChanged),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _loadFiles,
      child: ListView.builder(
        padding: const EdgeInsets.all(UIConstants.md),
        itemCount: _files.length,
        itemBuilder: (context, index) {
          final file = _files[index];
          final status = file['status'] as String? ?? 'modified';
          final additions = file['additions'] as int? ?? 0;
          final deletions = file['deletions'] as int? ?? 0;
          final filename = file['filename'] as String? ?? '';

          return FadeInWrapper(
            delay: Duration(milliseconds: index * 20),
            child: Card(
              margin: const EdgeInsets.only(bottom: UIConstants.sm),
              child: ListTile(
                leading: _StatusIcon(status: status),
                title: Text(
                  filename,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Row(
                  children: [
                    if (additions > 0) ...[
                      Text(
                        '+$additions',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: UIConstants.sm),
                    ],
                    if (deletions > 0) ...[
                      Text(
                        '-$deletions',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PrDiffViewerPage(
                        owner: widget.owner,
                        repo: widget.repo,
                        index: widget.index,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  final String status;

  const _StatusIcon({required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    switch (status.toLowerCase()) {
      case 'added':
        return Icon(Icons.add_circle, color: Colors.green, size: UIConstants.iconMd);
      case 'removed':
        return Icon(Icons.remove_circle, color: Colors.red, size: UIConstants.iconMd);
      case 'renamed':
        return Icon(Icons.drive_file_rename_outline, color: theme.colorScheme.primary, size: UIConstants.iconMd);
      default:
        return Icon(Icons.edit, color: theme.colorScheme.primary, size: UIConstants.iconMd);
    }
  }
}
