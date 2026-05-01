import 'package:flutter/material.dart';

import '../../core/animations/animated_wrapper.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../state/repo_notifier.dart';
import '../widgets/empty_state.dart';
import '../widgets/user_avatar.dart';
import 'commit_detail_page.dart';

class FileHistoryPage extends StatefulWidget {
  final String owner;
  final String repo;
  final String path;
  final String? ref;

  const FileHistoryPage({
    super.key,
    required this.owner,
    required this.repo,
    required this.path,
    this.ref,
  });

  @override
  State<FileHistoryPage> createState() => _FileHistoryPageState();
}

class _FileHistoryPageState extends State<FileHistoryPage> {
  List<Commit> _commits = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    await Injection.repoNotifier.listCommits(
      widget.owner,
      widget.repo,
      sha: widget.ref,
      path: widget.path,
    );

    if (mounted) {
      final state = Injection.repoNotifier.commitsState;
      switch (state) {
        case CommitsLoaded(:final commits):
          setState(() {
            _commits = commits;
            _loading = false;
          });
        case CommitsError(:final message):
          setState(() {
            _error = message;
            _loading = false;
          });
        default:
          setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.commitHistory)),
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
              onPressed: _loadHistory,
              child: Text(l10n.retry),
            ),
          ],
        ),
      );
    }
    if (_commits.isEmpty) {
      return EmptyState(
        icon: Icons.history,
        title: l10n.noCommits,
      );
    }
    return RefreshIndicator(
      onRefresh: _loadHistory,
      child: ListView.builder(
        padding: const EdgeInsets.all(UIConstants.md),
        itemCount: _commits.length,
        itemBuilder: (context, index) {
          final commit = _commits[index];
          return FadeInWrapper(
            delay: Duration(milliseconds: index * 20),
            child: Card(
              margin: const EdgeInsets.only(bottom: UIConstants.sm),
              child: InkWell(
                borderRadius: BorderRadius.circular(UIConstants.cardRadius),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CommitDetailPage(
                        owner: widget.owner,
                        repo: widget.repo,
                        sha: commit.sha ?? '',
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(UIConstants.md),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (commit.author != null)
                        UserAvatar(
                          user: commit.author!,
                          radius: UIConstants.avatarMd,
                        )
                      else
                        const CircleAvatar(
                          radius: 16,
                          child: Icon(Icons.person, size: 16),
                        ),
                      const SizedBox(width: UIConstants.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              commit.commit?.message?.split('\n').first ?? '',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: UIConstants.xs),
                            Row(
                              children: [
                                Text(
                                  commit.author?.login ?? commit.commit?.author?.name ?? '',
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(width: UIConstants.sm),
                                Text(
                                  _formatDate(commit.created, l10n),
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: UIConstants.xs),
                            Text(
                              commit.sha?.substring(0, 7) ?? '',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                fontFamily: 'monospace',
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime? date, AppLocalizations l10n) {
    if (date == null) return '';
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 365) return l10n.ago('${diff.inDays ~/ 365}y');
    if (diff.inDays > 30) return l10n.ago('${diff.inDays ~/ 30}mo');
    if (diff.inDays > 0) return l10n.ago('${diff.inDays}d');
    if (diff.inHours > 0) return l10n.ago('${diff.inHours}h');
    if (diff.inMinutes > 0) return l10n.ago('${diff.inMinutes}m');
    return l10n.justNow;
  }
}
