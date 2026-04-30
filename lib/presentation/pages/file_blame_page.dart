import 'dart:convert';

import 'package:flutter/material.dart';

import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../state/repo_notifier.dart';
import '../widgets/user_avatar.dart';
import 'commit_detail_page.dart';

class _BlameRange {
  final int startLine;
  final int endLine;
  final Commit? commit;
  final String sha;

  const _BlameRange({
    required this.startLine,
    required this.endLine,
    this.commit,
    required this.sha,
  });
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
  List<String> _lines = [];
  List<_BlameRange> _ranges = [];
  bool _loading = true;
  String? _error;
  bool _blameApiSupported = true;

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
      final ref = widget.ref ?? 'HEAD';

      // Try blame API first
      final blameResult = await Injection.apiService.repoGetBlame(
        owner: widget.owner,
        repo: widget.repo,
        ref: ref,
        path: widget.path,
      );

      final rangeList = blameResult['ranges'] as List<dynamic>? ?? [];
      final commitsMap = blameResult['commits'] as Map<String, dynamic>? ?? {};

      // Parse commit map
      final commitBySha = <String, Commit>{};
      for (final entry in commitsMap.entries) {
        commitBySha[entry.key] = Commit.fromJson(
          entry.value as Map<String, dynamic>,
        );
      }

      final parsedRanges = rangeList.map((r) {
        final map = r as Map<String, dynamic>;
        final sha = map['commit_sha'] as String? ?? '';
        return _BlameRange(
          startLine: (map['starting_line'] as num?)?.toInt() ?? 1,
          endLine: (map['ending_line'] as num?)?.toInt() ?? 1,
          sha: sha,
          commit: commitBySha[sha],
        );
      }).toList();

      // Get file content to display
      await Injection.repoNotifier.loadContents(
        widget.owner,
        widget.repo,
        path: widget.path,
        ref: ref,
      );

      final cs = Injection.repoNotifier.contentsState;
      String content = '';
      if (cs is ContentsLoaded && cs.contents.isNotEmpty) {
        final file = cs.contents.first;
        if (file.content != null && file.encoding == 'base64') {
          content = utf8.decode(base64Decode(file.content!));
        } else {
          content = file.content ?? '';
        }
      }

      if (mounted) {
        setState(() {
          _ranges = parsedRanges;
          _lines = content.split('\n');
          _loading = false;
        });
      }
    } catch (_) {
      // Blame API not supported - fallback to simple line view
      _blameApiSupported = false;
      try {
        await Injection.repoNotifier.loadContents(
          widget.owner,
          widget.repo,
          path: widget.path,
          ref: widget.ref,
        );

        if (mounted) {
          final cs = Injection.repoNotifier.contentsState;
          if (cs is ContentsLoaded && cs.contents.isNotEmpty) {
            final file = cs.contents.first;
            String content;
            if (file.content != null && file.encoding == 'base64') {
              content = utf8.decode(base64Decode(file.content!));
            } else {
              content = file.content ?? '';
            }
            if (mounted) {
              setState(() {
                _lines = content.split('\n');
                _loading = false;
              });
            }
          } else if (cs is ContentsError) {
            setState(() {
              _error = cs.message;
              _loading = false;
            });
          } else {
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
  }

  Commit? _commitForLine(int lineNum) {
    for (final range in _ranges) {
      if (lineNum >= range.startLine && lineNum <= range.endLine) {
        return range.commit;
      }
    }
    return null;
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
    if (_blameApiSupported && _ranges.isNotEmpty) {
      return _buildBlameView(l10n);
    }
    return _buildSimpleView();
  }

  Widget _buildBlameView(AppLocalizations l10n) {
    final uniqueShas = <String>{};
    return ListView.builder(
      itemCount: _lines.length,
      itemBuilder: (context, index) {
        final lineNum = index + 1;
        final commit = _commitForLine(lineNum);
        final sha = commit?.sha ?? '';
        final isFirstInRange = sha.isNotEmpty && !uniqueShas.contains(sha);
        if (sha.isNotEmpty) uniqueShas.add(sha);

        return Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
                width: 0.5,
              ),
            ),
          ),
          child: InkWell(
            onTap: sha.isNotEmpty
                ? () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CommitDetailPage(
                        owner: widget.owner,
                        repo: widget.repo,
                        sha: sha,
                      ),
                    ),
                  )
                : null,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                  child: commit != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: UIConstants.xs,
                            vertical: UIConstants.xs,
                          ),
                          child: Row(
                            children: [
                              if (commit.author != null)
                                UserAvatar(
                                  user: commit.author!,
                                  radius: UIConstants.avatarXs,
                                ),
                              const SizedBox(width: UIConstants.xs),
                              Expanded(
                                child: Text(
                                  commit.sha?.substring(0, 7) ?? '',
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    fontFamily: 'monospace',
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        )
                      : null,
                ),
                Container(
                  width: 1,
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
                SizedBox(
                  width: 40,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: UIConstants.xs,
                      vertical: UIConstants.xs,
                    ),
                    child: Text(
                      '$lineNum',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontFamily: 'monospace',
                        color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: UIConstants.xs,
                      vertical: UIConstants.xs,
                    ),
                    child: Text(
                      _lines[index],
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSimpleView() {
    return ListView.builder(
      itemCount: _lines.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: UIConstants.xs),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 48,
                child: Text(
                  '${index + 1}',
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
                  _lines[index],
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
