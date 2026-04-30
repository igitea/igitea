import 'package:flutter/material.dart';

import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../core/utils/diff_parser.dart';
import '../../l10n/app_localizations.dart';

class FileComparePage extends StatefulWidget {
  final String owner;
  final String repo;
  final String path;

  const FileComparePage({
    super.key,
    required this.owner,
    required this.repo,
    required this.path,
  });

  @override
  State<FileComparePage> createState() => _FileComparePageState();
}

class _FileComparePageState extends State<FileComparePage> {
  final _baseRefController = TextEditingController();
  final _headRefController = TextEditingController(text: 'HEAD');
  List<DiffFile> _files = [];
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _baseRefController.dispose();
    _headRefController.dispose();
    super.dispose();
  }

  Future<void> _compare() async {
    final base = _baseRefController.text.trim();
    final head = _headRefController.text.trim();
    if (base.isEmpty || head.isEmpty) return;

    setState(() {
      _loading = true;
      _error = null;
      _files = [];
    });

    try {
      final result = await Injection.apiService.repoCompareDiff(
        owner: widget.owner,
        repo: widget.repo,
        basehead: '$base...$head',
      );
      final rawFiles = result['files'] as List<dynamic>? ?? [];
      final matched = rawFiles
          .where((f) => (f['filename'] as String? ?? '') == widget.path)
          .toList();
      if (matched.isEmpty) {
        final rawDiff = result['diff'] as String? ?? '';
        if (rawDiff.isNotEmpty) {
          final allFiles = DiffParser.parse(rawDiff);
          setState(() {
            _files = allFiles.where((f) =>
              f.newPath == widget.path || f.oldPath == widget.path
            ).toList();
            _loading = false;
          });
        } else {
          setState(() {
            _error = 'No changes found for this file';
            _loading = false;
          });
        }
      } else {
        setState(() => _loading = false);
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.compareVersions)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(UIConstants.md),
        child: Column(
          children: [
            TextField(
              controller: _baseRefController,
              decoration: InputDecoration(
                labelText: l10n.baseRef,
                hintText: 'main~1, abc1234',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: UIConstants.sm),
            TextField(
              controller: _headRefController,
              decoration: InputDecoration(
                labelText: l10n.headRef,
                hintText: 'main, HEAD',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: UIConstants.md),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _loading ? null : _compare,
                icon: _loading
                    ? const SizedBox(
                        width: 18, height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.compare_arrows),
                label: Text(l10n.compare),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: UIConstants.md),
              Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
            ],
            if (_files.isNotEmpty) ...[
              const SizedBox(height: UIConstants.md),
              const Divider(),
              ..._files.expand((file) => [
                _buildFileHeader(file, l10n),
                ...file.hunks.expand((hunk) => [
                  _buildHunkHeader(hunk),
                  ...hunk.lines.map(_buildDiffLine),
                ]),
              ]),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFileHeader(DiffFile file, AppLocalizations l10n) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(UIConstants.sm),
      color: theme.colorScheme.surfaceContainerHighest,
      child: Row(
        children: [
          Icon(
            file.status == 'added' ? Icons.add_circle :
            file.status == 'removed' ? Icons.remove_circle : Icons.edit,
            size: UIConstants.iconSm,
            color: file.status == 'added' ? Colors.green :
                   file.status == 'removed' ? Colors.red :
                   theme.colorScheme.primary,
          ),
          const SizedBox(width: UIConstants.sm),
          Text(file.newPath, style: theme.textTheme.bodySmall?.copyWith(
            fontFamily: 'monospace', fontWeight: FontWeight.w600,
          )),
        ],
      ),
    );
  }

  Widget _buildHunkHeader(DiffHunk hunk) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: UIConstants.sm, vertical: UIConstants.xs),
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Text(hunk.header, style: Theme.of(context).textTheme.labelSmall?.copyWith(
        fontFamily: 'monospace', color: Theme.of(context).colorScheme.primary,
      )),
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

    return Container(
      width: double.infinity,
      color: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: UIConstants.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${line.oldLineNum?.toString().padLeft(4) ?? '    '} ${line.newLineNum?.toString().padLeft(4) ?? '    '}',
            style: theme.textTheme.labelSmall?.copyWith(fontFamily: 'monospace',
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
          ),
          const SizedBox(width: UIConstants.xs),
          Text(prefix, style: theme.textTheme.bodySmall?.copyWith(fontFamily: 'monospace',
            fontWeight: FontWeight.w700,
            color: line.type == DiffLineType.added ? Colors.green :
                   line.type == DiffLineType.removed ? Colors.red : null)),
          const SizedBox(width: UIConstants.xs),
          Expanded(child: Text(line.content, style: theme.textTheme.bodySmall?.copyWith(fontFamily: 'monospace'))),
        ],
      ),
    );
  }
}
