import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/animations/animated_wrapper.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../domain/entities/issue_state.dart';
import '../../l10n/app_localizations.dart';
import '../../presentation/state/issue_notifier.dart';
import '../../presentation/state/repo_notifier.dart';
import '../widgets/user_avatar.dart';
import 'create_review_dialog.dart';

class PRDetailPage extends StatefulWidget {
  final String owner;
  final String repo;
  final int index;

  const PRDetailPage({
    super.key,
    required this.owner,
    required this.repo,
    required this.index,
  });

  @override
  State<PRDetailPage> createState() => _PRDetailPageState();
}

class _PRDetailPageState extends State<PRDetailPage> {
  final _commentController = TextEditingController();
  List<Map<String, dynamic>> _reviews = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Injection.repoNotifier.getPullRequest(widget.owner, widget.repo, widget.index);
      Injection.issueNotifier.listComments(widget.owner, widget.repo, widget.index);
      _loadReviews();
    });
  }

  Future<void> _loadReviews() async {
    try {
      final result = await Injection.apiService.repoListPullReviews(
        owner: widget.owner, repo: widget.repo, index: widget.index,
      );
      if (mounted) setState(() => _reviews = result.cast<Map<String, dynamic>>());
    } catch (_) {}
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.pullRequestNumber(widget.index)),
        actions: [
          if (Injection.repoNotifier.pullRequestDetailState is PullRequestDetailDataLoaded) ...[
            IconButton(
              icon: const Icon(Icons.rate_review_outlined),
              tooltip: AppLocalizations.of(context)!.reviewChanges,
              onPressed: () async {
                final result = await showDialog<bool>(
                  context: context,
                  builder: (_) => CreateReviewDialog(
                    owner: widget.owner, repo: widget.repo, index: widget.index,
                  ),
                );
                if (result == true) {
                  final r = await Injection.apiService.repoListPullReviews(
                    owner: widget.owner, repo: widget.repo, index: widget.index,
                  );
                  if (mounted) setState(() => _reviews = r.cast<Map<String, dynamic>>());
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.open_in_new),
              onPressed: () {
                final state = Injection.repoNotifier.pullRequestDetailState as PullRequestDetailDataLoaded;
                if (state.pullRequest.html_url != null) {
                  launchUrl(
                    Uri.parse(state.pullRequest.html_url!),
                    mode: LaunchMode.externalApplication,
                  );
                }
              },
            ),
          ],
        ],
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([Injection.repoNotifier, Injection.issueNotifier]),
        builder: (context, _) {
          final state = Injection.repoNotifier.pullRequestDetailState;
          return switch (state) {
            PullRequestDetailLoading() => const Center(child: CircularProgressIndicator()),
            PullRequestDetailError(:final message) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${l10n.error}: $message'),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => Injection.repoNotifier.getPullRequest(
                      widget.owner,
                      widget.repo,
                      widget.index,
                    ),
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            ),
            PullRequestDetailDataLoaded(:final pullRequest) => _PRContent(
              pr: pullRequest,
              owner: widget.owner,
              repo: widget.repo,
              index: widget.index,
              commentController: _commentController,
              reviews: _reviews,
            ),
            _ => const Center(child: CircularProgressIndicator()),
          };
        },
      ),
    );
  }
}

class _PRContent extends StatelessWidget {
  final PullRequest pr;
  final String owner;
  final String repo;
  final int index;
  final TextEditingController commentController;
  final List<Map<String, dynamic>> reviews;

  const _PRContent({
    required this.pr,
    required this.owner,
    required this.repo,
    required this.index,
    required this.commentController,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final (stateText, stateColor) = _getStateInfo(l10n);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: stateColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  stateText,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: stateColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  pr.title ?? l10n.untitled,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (pr.user != null)
            Row(
              children: [
                UserAvatar(user: pr.user!, radius: 16),
                const SizedBox(width: 8),
                Text(
                  pr.user!.login ?? '',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                   l10n.openedParams(_formatDate(pr.created_at, l10n)),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 16),

          if (pr.state?.isOpen == true && pr.mergeable == true && pr.merged != true)
            Row(
              children: [
                FilledButton(
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(l10n.mergePullRequest),
                        content: Text(l10n.mergeConfirmMessage),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(false),
                            child: Text(l10n.cancel),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.of(ctx).pop(true),
                            child: Text(l10n.merge),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true) {
                      Injection.repoNotifier.mergePullRequest(owner, repo, index);
                    }
                  },
                  child: Text(l10n.mergePullRequest),
                ),
              ],
            ),
          if (pr.state?.isOpen == true && pr.mergeable == true && pr.merged != true)
            const SizedBox(height: 16),
          if (pr.head != null && pr.base_ != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.call_split, size: 18, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${pr.head!.label ?? pr.head!.ref ?? ''} → ${pr.base_!.label ?? pr.base_!.ref ?? ''}',
                      style: theme.textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),

          if (pr.additions != null || pr.deletions != null || pr.changed_files != null)
            Row(
              children: [
                if (pr.additions != null) ...[
                  Icon(Icons.add, size: 16, color: Colors.green),
                  Text('${pr.additions}', style: theme.textTheme.bodySmall?.copyWith(color: Colors.green)),
                  const SizedBox(width: 12),
                ],
                if (pr.deletions != null) ...[
                  Icon(Icons.remove, size: 16, color: Colors.red),
                  Text('${pr.deletions}', style: theme.textTheme.bodySmall?.copyWith(color: Colors.red)),
                  const SizedBox(width: 12),
                ],
                if (pr.changed_files != null) ...[
                  Icon(Icons.insert_drive_file_outlined, size: 16, color: theme.colorScheme.onSurfaceVariant),
                  Text('${pr.changed_files} ${l10n.files}', style: theme.textTheme.bodySmall),
                ],
              ],
            ),
          if (pr.additions != null || pr.deletions != null || pr.changed_files != null)
            const SizedBox(height: 16),

          if (pr.labels != null && pr.labels!.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: pr.labels!.map((label) {
                return Chip(
                  label: Text(label.name ?? ''),
                  backgroundColor: _parseColor(label.color)?.withValues(alpha: 0.2) ?? theme.colorScheme.primaryContainer,
                  labelStyle: theme.textTheme.labelSmall?.copyWith(
                    color: _parseColor(label.color) ?? theme.colorScheme.onPrimaryContainer,
                  ),
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                );
              }).toList(),
            ),
          if (pr.labels != null && pr.labels!.isNotEmpty)
            const SizedBox(height: 16),

          if (pr.mergeable != null)
            _buildInfoRow(
              context,
              icon: pr.mergeable! ? Icons.check_circle_outline : Icons.error_outline,
              label: l10n.mergeable,
              child: Text(
                pr.mergeable! ? l10n.yes : l10n.no,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: pr.mergeable! ? Colors.green : Colors.red,
                ),
              ),
            ),

          const Divider(height: 32),

          if (pr.body != null && pr.body!.isNotEmpty)
            MarkdownBody(
              data: pr.body!,
              selectable: true,
              onTapLink: (text, href, title) {
                if (href != null) {
                  launchUrl(Uri.parse(href), mode: LaunchMode.externalApplication);
                }
              },
            )
          else
            Text(
              l10n.noDescriptionProvided,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),

          const Divider(height: 32),

          ListenableBuilder(
            listenable: Injection.issueNotifier,
            builder: (context, _) {
              final commentsState = Injection.issueNotifier.commentsState;
              return switch (commentsState) {
                CommentsLoading() => const Center(child: CircularProgressIndicator()),
                CommentsError(:final message) => Column(
                  children: [
                    Text('${l10n.failedToLoadComments}: $message'),
                    TextButton(
                      onPressed: () => Injection.issueNotifier.listComments(owner, repo, index),
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
                CommentsLoaded(:final comments) => _buildCommentsList(context, comments, l10n),
                _ => const SizedBox.shrink(),
              };
            },
          ),

          const SizedBox(height: 16),
          TextField(
            controller: commentController,
            decoration: InputDecoration(
              hintText: l10n.writeComment,
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  final text = commentController.text.trim();
                  if (text.isNotEmpty) {
                    Injection.issueNotifier.createComment(
                      owner,
                      repo,
                      index,
                      {'body': text},
                    );
                    commentController.clear();
                  }
                },
              ),
            ),
            maxLines: 3,
            minLines: 1,
          ),

          const SizedBox(height: 16),
          _buildReviewSection(l10n, theme),

          const SizedBox(height: 16),

          Row(
            children: [
              Icon(Icons.comment_outlined, size: 16, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: 4),
              Text(
                l10n.commentsCountParams(pr.comments ?? 0),
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(width: 16),
              Icon(Icons.update, size: 16, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: 4),
              Text(
                l10n.updatedParams(_formatDate(pr.updated_at, l10n)),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewSection(AppLocalizations l10n, ThemeData theme) {
    if (reviews.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.rate_review_outlined, size: 16, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 4),
            Text(l10n.reviews, style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            )),
            const SizedBox(width: 4),
            Text('(${reviews.length})', style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            )),
          ],
        ),
        const SizedBox(height: 8),
        ...reviews.map((r) => _buildReviewCard(r, l10n, theme)),
      ],
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review, AppLocalizations l10n, ThemeData theme) {
    final state = review['state'] as String? ?? l10n.comment;
    final body = review['body'] as String? ?? '';
    final user = review['user'] as Map<String, dynamic>?;
    final submitted = review['submitted_at'] as String?;
    final color = switch (state) {
      'APPROVED' => Colors.green,
      'REQUEST_CHANGES' => Colors.red,
      _ => theme.colorScheme.primary,
    };
    final icon = switch (state) {
      'APPROVED' => Icons.check_circle,
      'REQUEST_CHANGES' => Icons.cancel,
      _ => Icons.comment,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                if (user?['login'] != null)
                  Text(user!['login'] as String, style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
                  child: Text(state, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            if (body.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(body, style: theme.textTheme.bodyMedium),
            ],
            if (submitted != null) ...[
              const SizedBox(height: 4),
              Text(_formatDate(DateTime.tryParse(submitted) ?? DateTime.now(), l10n),
                style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCommentsList(BuildContext context, List<Comment> comments, AppLocalizations l10n) {
    if (comments.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(l10n.noComments),
      );
    }

    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.commentsParams(comments.length),
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...comments.asMap().entries.map((entry) => FadeInWrapper(
          delay: Duration(milliseconds: entry.key * 30),
          child: _CommentItem(comment: entry.value),
        )),
      ],
    );
  }

  (String, Color) _getStateInfo(AppLocalizations l10n) {
    if (pr.merged == true) {
      return (l10n.merged, Colors.purple);
    } else if (pr.draft == true) {
      return (l10n.draft, Colors.grey);
    } else if (pr.state?.isClosed == true) {
      return (l10n.closed, Colors.red);
    } else {
      return (l10n.open, Colors.green);
    }
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          child,
        ],
      ),
    );
  }

  String _formatDate(DateTime? date, AppLocalizations l10n) {
    if (date == null) return l10n.unknown;
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 365) return l10n.ago('${diff.inDays ~/ 365}y');
    if (diff.inDays > 30) return l10n.ago('${diff.inDays ~/ 30}mo');
    if (diff.inDays > 0) return l10n.ago('${diff.inDays}d');
    if (diff.inHours > 0) return l10n.ago('${diff.inHours}h');
    if (diff.inMinutes > 0) return l10n.ago('${diff.inMinutes}m');
    return l10n.justNow;
  }

  Color? _parseColor(String? colorStr) {
    if (colorStr == null || colorStr.isEmpty) return null;
    try {
      return Color(int.parse(colorStr.replaceFirst('#', ''), radix: 16) + 0xFF000000);
    } catch (_) {
      return null;
    }
  }
}

class _CommentItem extends StatelessWidget {
  final Comment comment;

  const _CommentItem({required this.comment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (comment.user != null) ...[
                  UserAvatar(user: comment.user!, radius: 14),
                  const SizedBox(width: 8),
                  Text(
                    comment.user!.login ?? '',
                    style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
                const Spacer(),
                Text(
                  _formatDate(comment.created_at, l10n),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (comment.body != null && comment.body!.isNotEmpty)
              MarkdownBody(
                data: comment.body!,
                selectable: true,
                onTapLink: (text, href, title) {
                  if (href != null) {
                    launchUrl(Uri.parse(href), mode: LaunchMode.externalApplication);
                  }
                },
              ),
          ],
        ),
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
