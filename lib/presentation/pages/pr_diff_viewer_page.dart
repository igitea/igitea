import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../core/utils/diff_parser.dart';
import '../../l10n/app_localizations.dart';

class PrDiffViewerPage extends StatefulWidget {
  final String owner;
  final String repo;
  final int index;

  const PrDiffViewerPage({
    super.key,
    required this.owner,
    required this.repo,
    required this.index,
  });

  @override
  State<PrDiffViewerPage> createState() => _PrDiffViewerPageState();
}

class _PrDiffViewerPageState extends State<PrDiffViewerPage> {
  List<DiffFile> _files = [];
  List<DiffRow> _rows = const [];
  bool _loading = true;
  String? _error;
  bool _splitView = false;
  bool _showAll = false;

  @override
  void initState() {
    super.initState();
    _loadDiff();
  }

  Future<void> _loadDiff() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final raw = await Injection.apiService.repoGetPullRequestDiff(
        owner: widget.owner,
        repo: widget.repo,
        index: widget.index,
      );
      // Parse on a background isolate — large diffs would otherwise
      // block the UI thread when the response arrives.
      final files = await compute(DiffParser.parse, raw);
      if (mounted) {
        setState(() {
          _files = files;
          _rows = flattenDiffRows(files, showAll: _showAll);
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

  void _expandAll() {
    setState(() {
      _showAll = true;
      _rows = flattenDiffRows(_files, showAll: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.diffView),
        actions: [
          IconButton(
            icon: Icon(_splitView ? Icons.view_column : Icons.view_stream),
            tooltip: _splitView ? l10n.unifiedView : l10n.splitView,
            onPressed: () => setState(() => _splitView = !_splitView),
          ),
        ],
      ),
      body: _buildBody(l10n),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
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
              onPressed: _loadDiff,
              child: Text(l10n.retry),
            ),
          ],
        ),
      );
    }
    if (_files.isEmpty) {
      return Center(child: Text(l10n.noChanges));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(UIConstants.md),
      itemCount: _rows.length,
      itemBuilder: (context, index) {
        return switch (_rows[index]) {
          DiffFileHeaderRow(:final file) => _buildFileHeader(file, l10n),
          DiffHunkHeaderRow(:final hunk) => _buildHunkHeader(hunk),
          DiffLineRow(:final line) => _buildDiffLine(line),
          DiffTruncatedRow(:final hiddenLineCount) => _buildTruncated(
              hiddenLineCount, l10n),
        };
      },
    );
  }

  Widget _buildTruncated(int hiddenLineCount, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: UIConstants.sm),
      child: Center(
        child: OutlinedButton.icon(
          onPressed: _expandAll,
          icon: const Icon(Icons.unfold_more),
          label: Text(
            '${l10n.showEntireDiff} (+$hiddenLineCount)',
          ),
        ),
      ),
    );
  }

  Widget _buildFileHeader(DiffFile file, AppLocalizations l10n) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(
        top: UIConstants.sm,
        bottom: UIConstants.xs,
      ),
      padding: const EdgeInsets.all(UIConstants.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(UIConstants.cardRadius),
      ),
      child: Row(
        children: [
          Icon(
            file.status == 'added'
                ? Icons.add_circle
                : file.status == 'removed'
                    ? Icons.remove_circle
                    : Icons.edit,
            size: UIConstants.iconSm,
            color: file.status == 'added'
                ? Colors.green
                : file.status == 'removed'
                    ? Colors.red
                    : theme.colorScheme.primary,
          ),
          const SizedBox(width: UIConstants.sm),
          Expanded(
            child: Text(
              file.newPath.isNotEmpty ? file.newPath : file.oldPath,
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHunkHeader(DiffHunk hunk) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: UIConstants.sm,
        vertical: UIConstants.xs,
      ),
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Text(
        hunk.header,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          fontFamily: 'monospace',
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildDiffLine(DiffLine line) {
    final theme = Theme.of(context);
    final bgColor = switch (line.type) {
      DiffLineType.added => Colors.green.withValues(alpha: 0.12),
      DiffLineType.removed => Colors.red.withValues(alpha: 0.12),
      _ => null,
    };

    final prefix = switch (line.type) {
      DiffLineType.added => '+',
      DiffLineType.removed => '-',
      _ => ' ',
    };

    final lineNum = '${line.oldLineNum?.toString().padLeft(4) ?? ''}'
        ' ${line.newLineNum?.toString().padLeft(4) ?? ''}';

    return Container(
      width: double.infinity,
      color: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: UIConstants.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lineNum,
            style: theme.textTheme.labelSmall?.copyWith(
              fontFamily: 'monospace',
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(width: UIConstants.xs),
          Text(
            prefix,
            style: theme.textTheme.bodySmall?.copyWith(
              fontFamily: 'monospace',
              fontWeight: FontWeight.w700,
              color: line.type == DiffLineType.added
                  ? Colors.green
                  : line.type == DiffLineType.removed
                      ? Colors.red
                      : null,
            ),
          ),
          const SizedBox(width: UIConstants.xs),
          Expanded(
            child: Text(
              line.content,
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
