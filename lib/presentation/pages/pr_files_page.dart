import 'package:flutter/material.dart';
import '../../core/animations/animated_wrapper.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';

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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Files Changed')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Error: $_error'),
                      const SizedBox(height: UIConstants.md),
                      FilledButton(
                        onPressed: _loadFiles,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _files.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.folder_outlined, size: 64),
                          SizedBox(height: 16),
                          Text('No files changed'),
                        ],
                      ),
                    )
                  : RefreshIndicator(
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
                                      const SizedBox(width: 8),
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
                              ),
                            ),
                          );
                        },
                      ),
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
        return Icon(Icons.add_circle, color: Colors.green, size: 20);
      case 'removed':
        return Icon(Icons.remove_circle, color: Colors.red, size: 20);
      case 'renamed':
        return Icon(Icons.drive_file_rename_outline, color: theme.colorScheme.primary, size: 20);
      default:
        return Icon(Icons.edit, color: theme.colorScheme.primary, size: 20);
    }
  }
}
