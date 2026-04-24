import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../presentation/state/issue_notifier.dart';
import '../../presentation/state/repo_notifier.dart';
import '../widgets/user_avatar.dart';

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Injection.repoNotifier.getPullRequest(widget.owner, widget.repo, widget.index);
      Injection.issueNotifier.listComments(widget.owner, widget.repo, widget.index);
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PR #${widget.index}'),
        actions: [
          if (Injection.repoNotifier.state is PullRequestDetailLoaded)
            IconButton(
              icon: const Icon(Icons.open_in_new),
              onPressed: () {
                final state = Injection.repoNotifier.state as PullRequestDetailLoaded;
                if (state.pullRequest.html_url != null) {
                  launchUrl(
                    Uri.parse(state.pullRequest.html_url!),
                    mode: LaunchMode.externalApplication,
                  );
                }
              },
            ),
        ],
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([Injection.repoNotifier, Injection.issueNotifier]),
        builder: (context, _) {
          final state = Injection.repoNotifier.state;
          return switch (state) {
            RepoLoading() => const Center(child: CircularProgressIndicator()),
            RepoError(:final message) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Error: $message'),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => Injection.repoNotifier.getPullRequest(
                      widget.owner,
                      widget.repo,
                      widget.index,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            PullRequestDetailLoaded(:final pullRequest) => _PRContent(
              pr: pullRequest,
              owner: widget.owner,
              repo: widget.repo,
              index: widget.index,
              commentController: _commentController,
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

  const _PRContent({
    required this.pr,
    required this.owner,
    required this.repo,
    required this.index,
    required this.commentController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (stateText, stateColor) = _getStateInfo();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // State badge + Title
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
                  pr.title ?? 'Untitled',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Author info
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
                  'opened ${_formatDate(pr.created_at)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 16),

          // Branch info
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

          // Stats
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
                  Text('${pr.changed_files} files', style: theme.textTheme.bodySmall),
                ],
              ],
            ),
          if (pr.additions != null || pr.deletions != null || pr.changed_files != null)
            const SizedBox(height: 16),

          // Labels
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

          // Merge status
          if (pr.mergeable != null)
            _buildInfoRow(
              context,
              icon: pr.mergeable! ? Icons.check_circle_outline : Icons.error_outline,
              label: 'Mergeable',
              child: Text(
                pr.mergeable! ? 'Yes' : 'No',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: pr.mergeable! ? Colors.green : Colors.red,
                ),
              ),
            ),

          const Divider(height: 32),

          // Body
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
              'No description provided.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),

          const Divider(height: 32),

          // Comments
          ListenableBuilder(
            listenable: Injection.issueNotifier,
            builder: (context, _) {
              final commentsState = Injection.issueNotifier.commentsState;
              return switch (commentsState) {
                CommentsLoading() => const Center(child: CircularProgressIndicator()),
                CommentsError(:final message) => Column(
                  children: [
                    Text('Failed to load comments: $message'),
                    TextButton(
                      onPressed: () => Injection.issueNotifier.listComments(owner, repo, index),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
                CommentsLoaded(:final comments) => _buildCommentsList(context, comments),
                _ => const SizedBox.shrink(),
              };
            },
          ),

          // Comment input
          const SizedBox(height: 16),
          TextField(
            controller: commentController,
            decoration: InputDecoration(
              hintText: 'Write a comment...',
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

          // Footer
          Row(
            children: [
              Icon(Icons.comment_outlined, size: 16, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: 4),
              Text(
                '${pr.comments ?? 0} comments',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(width: 16),
              Icon(Icons.update, size: 16, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: 4),
              Text(
                'Updated ${_formatDate(pr.updated_at)}',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsList(BuildContext context, List<Comment> comments) {
    if (comments.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Text('No comments yet.'),
      );
    }

    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Comments (${comments.length})',
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...comments.map((comment) => _CommentItem(comment: comment)),
      ],
    );
  }

  (String, Color) _getStateInfo() {
    if (pr.merged == true) {
      return ('Merged', Colors.purple);
    } else if (pr.draft == true) {
      return ('Draft', Colors.grey);
    } else if (pr.state?.value == 'closed') {
      return ('Closed', Colors.red);
    } else {
      return ('Open', Colors.green);
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

  String _formatDate(DateTime? date) {
    if (date == null) return 'unknown';
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 365) return '${diff.inDays ~/ 365}y ago';
    if (diff.inDays > 30) return '${diff.inDays ~/ 30}mo ago';
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'just now';
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
                  _formatDate(comment.created_at),
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

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 365) return '${diff.inDays ~/ 365}y ago';
    if (diff.inDays > 30) return '${diff.inDays ~/ 30}mo ago';
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'just now';
  }
}