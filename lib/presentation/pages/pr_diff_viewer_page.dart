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
  bool _loading = true;
  String? _error;
  bool _splitView = false;

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
      if (mounted) {
        setState(() {
          _files = DiffParser.parse(raw);
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diff Viewer'),
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
      return const Center(child: Text('No changes'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(UIConstants.md),
      itemCount: _files.length,
      itemBuilder: (context, index) {
        final file = _files[index];
        return Card(
          margin: const EdgeInsets.only(bottom: UIConstants.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFileHeader(file, l10n),
              ...file.hunks.expand((hunk) => [
                _buildHunkHeader(hunk),
                ...hunk.lines.map((line) => _buildDiffLine(line)),
              ]),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFileHeader(DiffFile file, AppLocalizations l10n) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(UIConstants.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(UIConstants.cardRadius),
          topRight: Radius.circular(UIConstants.cardRadius),
        ),
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
