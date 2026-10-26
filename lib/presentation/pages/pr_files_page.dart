import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../core/animations/animated_wrapper.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/forui/app_page.dart';
import '../widgets/forui/app_state_views.dart';
import 'pr_diff_viewer_page.dart';
import '../theme/app_theme.dart';

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

    return AppPage(
      title: l10n.filesChanged,
      actions: [
        if (_files.isNotEmpty)
          FHeaderAction(
            icon: const Icon(FIcons.code),
            semanticsLabel: l10n.viewDiff,
            onPress: _openDiffViewer,
          ),
      ],
      child: _buildBody(l10n),
    );
  }

  void _openDiffViewer() {
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
  }

  Widget _buildBody(AppLocalizations l10n) {
    final theme = Theme.of(context);
    if (_loading) {
      return const AppLoading();
    }
    if (_error != null) {
      return AppError(message: _error!, onRetry: _loadFiles);
    }
    if (_files.isEmpty) {
      return AppEmpty(icon: FIcons.folder, title: l10n.noFilesChanged);
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
            child: Padding(
              padding: const EdgeInsets.only(bottom: UIConstants.sm),
              child: FCard.raw(
                child: FTappable(
                  onPress: _openDiffViewer,
                  child: Padding(
                    padding: const EdgeInsets.all(UIConstants.md),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _StatusIcon(status: status),
                        const SizedBox(width: UIConstants.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                filename,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontFamily: 'monospace',
                                  fontFamilyFallback: kMonoFontFallback,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (additions > 0 || deletions > 0) ...[
                                const SizedBox(height: UIConstants.xs),
                                Row(
                                  children: [
                                    if (additions > 0) ...[
                                      Text(
                                        '+$additions',
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: Colors.green,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      const SizedBox(width: UIConstants.sm),
                                    ],
                                    if (deletions > 0)
                                      Text(
                                        '-$deletions',
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: Colors.red,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: UIConstants.sm),
                        Icon(
                          FIcons.chevronRight,
                          size: UIConstants.iconMd,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ),
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
        return Icon(
          FIcons.circlePlus,
          color: Colors.green,
          size: UIConstants.iconMd,
        );
      case 'removed':
        return Icon(
          FIcons.circleMinus,
          color: Colors.red,
          size: UIConstants.iconMd,
        );
      case 'renamed':
        return Icon(
          FIcons.filePen,
          color: theme.colorScheme.primary,
          size: UIConstants.iconMd,
        );
      default:
        return Icon(
          FIcons.penLine,
          color: theme.colorScheme.primary,
          size: UIConstants.iconMd,
        );
    }
  }
}
