import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../../presentation/state/issue_notifier.dart';
import '../widgets/user_avatar.dart';

class IssueDetailPage extends StatefulWidget {
  final String owner;
  final String repo;
  final int index;

  const IssueDetailPage({
    super.key,
    required this.owner,
    required this.repo,
    required this.index,
  });

  @override
  State<IssueDetailPage> createState() => _IssueDetailPageState();
}

class _IssueDetailPageState extends State<IssueDetailPage> {
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Injection.issueNotifier.getIssue(widget.owner, widget.repo, widget.index);
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.issueNumber(widget.index)),
        actions: [
          if (Injection.issueNotifier.state is IssueDetailLoaded)
            IconButton(
              icon: const Icon(Icons.open_in_new),
              onPressed: () {
                final state = Injection.issueNotifier.state as IssueDetailLoaded;
                if (state.issue.html_url != null) {
                  launchUrl(
                    Uri.parse(state.issue.html_url!),
                    mode: LaunchMode.externalApplication,
                  );
                }
              },
            ),
        ],
      ),
      body: ListenableBuilder(
        listenable: Injection.issueNotifier,
        builder: (context, _) {
          final state = Injection.issueNotifier.state;
          return switch (state) {
            IssueLoading() => const Center(child: CircularProgressIndicator()),
            IssueError(:final message) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${l10n.error}: $message'),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => Injection.issueNotifier.getIssue(
                      widget.owner,
                      widget.repo,
                      widget.index,
                    ),
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            ),
            IssueDetailLoaded(:final issue) => _IssueContent(
              issue: issue,
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

class _IssueContent extends StatelessWidget {
  final Issue issue;
  final String owner;
  final String repo;
  final int index;
  final TextEditingController commentController;

  const _IssueContent({
    required this.issue,
    required this.owner,
    required this.repo,
    required this.index,
    required this.commentController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isOpen = issue.state?.value == 'open';

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
                  color: isOpen ? Colors.green.withValues(alpha: 0.2) : Colors.purple.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isOpen ? l10n.open : l10n.closed,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isOpen ? Colors.green : Colors.purple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  issue.title ?? l10n.untitled,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (issue.user != null)
            Row(
              children: [
                UserAvatar(user: issue.user!, radius: 16),
                const SizedBox(width: 8),
                Text(
                  issue.user!.login ?? '',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.openedParams(_formatDate(issue.created_at)),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 16),

          if (issue.labels != null && issue.labels!.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: issue.labels!.map((label) {
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
          if (issue.labels != null && issue.labels!.isNotEmpty)
            const SizedBox(height: 16),

          if (issue.assignee != null)
            _buildInfoRow(
              context,
              icon: Icons.person_outline,
              label: l10n.assignee,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  UserAvatar(user: issue.assignee!, radius: 12),
                  const SizedBox(width: 6),
                  Text(issue.assignee!.login ?? ''),
                ],
              ),
            ),

          if (issue.milestone != null)
            _buildInfoRow(
              context,
              icon: Icons.flag_outlined,
              label: l10n.milestone,
              child: Text(issue.milestone!.title ?? ''),
            ),

          const SizedBox(height: 8),
          Row(
            children: [
              FilledButton.tonal(
                onPressed: () {
                  Injection.issueNotifier.editIssue(
                    owner,
                    repo,
                    index,
                    {'state': isOpen ? 'closed' : 'open'},
                  );
                },
                child: Text(isOpen ? l10n.closeIssue : l10n.reopenIssue),
              ),
            ],
          ),

          const Divider(height: 32),

          if (issue.body != null && issue.body!.isNotEmpty)
            MarkdownBody(
              data: issue.body!,
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

          Row(
            children: [
              Icon(Icons.comment_outlined, size: 16, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: 4),
              Text(
                l10n.commentsCountParams(issue.comments ?? 0),
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(width: 16),
              Icon(Icons.update, size: 16, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: 4),
              Text(
                l10n.updatedParams(_formatDate(issue.updated_at)),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ],
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
        ...comments.map((comment) => _CommentItem(comment: comment)),
      ],
    );
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
