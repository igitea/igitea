import 'dart:convert';

import 'package:flutter/material.dart';

import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../l10n/app_localizations.dart';
import '../state/repo_notifier.dart';

class _BlameLine {
  final String content;
  final int lineNum;

  const _BlameLine({required this.content, required this.lineNum});
}

class FileBlamePage extends StatefulWidget {
  final String owner;
  final String repo;
  final String path;
  final String? ref;

  const FileBlamePage({
    super.key,
    required this.owner,
    required this.repo,
    required this.path,
    this.ref,
  });

  @override
  State<FileBlamePage> createState() => _FileBlamePageState();
}

class _FileBlamePageState extends State<FileBlamePage> {
  List<_BlameLine> _lines = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadBlame();
  }

  Future<void> _loadBlame() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await Injection.repoNotifier.loadContents(
        widget.owner,
        widget.repo,
        path: widget.path,
        ref: widget.ref,
      );
      if (mounted) {
        final cs = Injection.repoNotifier.contentsState;
        switch (cs) {
          case ContentsError(:final message):
            setState(() {
              _error = message;
              _loading = false;
            });
            return;
          case ContentsLoaded(:final contents):
            if (contents.isEmpty) {
              setState(() => _loading = false);
              return;
            }

            final file = contents.first;
            String content;
            if (file.content != null && file.encoding == 'base64') {
              content = utf8.decode(base64Decode(file.content!));
            } else {
              content = file.content ?? '';
            }

            final textLines = content.split('\n');
            final blameLines = textLines.asMap().entries.map((e) =>
              _BlameLine(content: e.value, lineNum: e.key + 1)
            ).toList();

            setState(() {
              _lines = blameLines;
              _loading = false;
            });
            return;
          default:
            setState(() => _loading = false);
        }
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
      appBar: AppBar(title: const Text('Blame')),
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
              onPressed: _loadBlame,
              child: Text(l10n.retry),
            ),
          ],
        ),
      );
    }
    if (_lines.isEmpty) {
      return Center(child: Text(l10n.noContent));
    }
    return ListView.builder(
      itemCount: _lines.length,
      itemBuilder: (context, index) {
        final line = _lines[index];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: UIConstants.xs),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 48,
                child: Text(
                  '${line.lineNum}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontFamily: 'monospace',
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              Container(
                width: 1,
                height: 18,
                margin: const EdgeInsets.symmetric(horizontal: UIConstants.xs),
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              Expanded(
                child: Text(
                  line.content,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
