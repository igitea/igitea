import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/animations/animated_wrapper.dart';
import '../../core/di/injection.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../domain/entities/auth_state.dart';
import '../../domain/entities/issue_state.dart';
import '../../domain/usecases/issue_usecases.dart';
import '../../l10n/app_localizations.dart';
import '../../presentation/state/issue_notifier.dart';
import '../../presentation/state/user_notifier.dart';
import '../widgets/user_avatar.dart';
import 'edit_issue_page.dart';

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
  bool _isSubscribed = false;
  bool _subscriptionLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Injection.issueNotifier.getIssue(widget.owner, widget.repo, widget.index);
      Injection.issueNotifier.listComments(widget.owner, widget.repo, widget.index);
      _checkSubscription();
    });
  }

  Future<void> _checkSubscription() async {
    try {
      final result = await Injection.apiService.issueCheckSubscription(
        owner: widget.owner,
        repo: widget.repo,
        index: widget.index,
      );
      if (mounted) {
        setState(() {
          _isSubscribed = result['subscribed'] == true;
        });
      }
    } catch (_) {
      // Silently fail; default to not subscribed
    }
  }

  Future<void> _toggleSubscription() async {
    if (_subscriptionLoading) return;

    final l10n = AppLocalizations.of(context)!;
    final currentUser = Injection.authNotifier.state is AuthAuthenticated
        ? (Injection.authNotifier.state as AuthAuthenticated).user.login ?? ''
        : '';
    if (currentUser.isEmpty) return;

    setState(() => _subscriptionLoading = true);

    try {
      if (_isSubscribed) {
        await Injection.apiService.issueDeleteSubscription(
          owner: widget.owner,
          repo: widget.repo,
          index: widget.index,
          user: currentUser,
        );
      } else {
        await Injection.apiService.issueAddSubscription(
          owner: widget.owner,
          repo: widget.repo,
          index: widget.index,
          user: currentUser,
        );
      }
      if (mounted) {
        setState(() {
          _isSubscribed = !_isSubscribed;
          _subscriptionLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_isSubscribed ? l10n.subscribed : l10n.unsubscribed)),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _subscriptionLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.error}: $e')),
        );
      }
    }
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
              isSubscribed: _isSubscribed,
              subscriptionLoading: _subscriptionLoading,
              onToggleSubscription: _toggleSubscription,
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
  final bool isSubscribed;
  final bool subscriptionLoading;
  final VoidCallback onToggleSubscription;

  const _IssueContent({
    required this.issue,
    required this.owner,
    required this.repo,
    required this.index,
    required this.commentController,
    required this.isSubscribed,
    required this.subscriptionLoading,
    required this.onToggleSubscription,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isOpen = issue.state?.isOpen == true;

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
                  l10n.openedParams(_formatDate(issue.created_at, l10n)),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 16),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...(issue.labels ?? []).map((label) {
                return Chip(
                  label: Text(label.name ?? ''),
                  backgroundColor: _parseColor(label.color)?.withValues(alpha: 0.2) ?? theme.colorScheme.primaryContainer,
                  labelStyle: theme.textTheme.labelSmall?.copyWith(
                    color: _parseColor(label.color) ?? theme.colorScheme.onPrimaryContainer,
                  ),
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                );
              }),
              ActionChip(
                label: Text(l10n.edit),
                avatar: const Icon(Icons.edit, size: 16),
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => EditIssuePage(
                        owner: owner,
                        repo: repo,
                        index: index,
                        issue: issue,
                      ),
                    ),
                  );
                  Injection.issueNotifier.getIssue(owner, repo, index);
                  Injection.issueNotifier.listComments(owner, repo, index);
                },
              ),
              ActionChip(
                label: Text(isSubscribed ? l10n.unsubscribe : l10n.subscribe),
                avatar: Icon(
                  isSubscribed ? Icons.notifications_off_outlined : Icons.notifications_outlined,
                  size: 16,
                ),
                onPressed: subscriptionLoading ? null : onToggleSubscription,
              ),
            ],
          ),
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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(issue.milestone!.title ?? ''),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () => _showMilestoneEditor(context, issue),
                    child: Icon(Icons.edit, size: 16, color: theme.colorScheme.primary),
                  ),
                ],
              ),
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

          const SizedBox(height: 16),

          _DependenciesSection(owner: owner, repo: repo, index: index),
          const SizedBox(height: 16),
          _TimelineSection(owner: owner, repo: repo, index: index),

          const SizedBox(height: 16),

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
                l10n.updatedParams(_formatDate(issue.updated_at, l10n)),
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
      return SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final currentUserState = Injection.userNotifier.state;
    final currentUserId = currentUserState is UserLoaded ? currentUserState.user.id : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (comments.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12, top: 8),
              child: Row(
                children: [
                  Icon(Icons.chat_bubble_outline, size: 16, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: 6),
                  Text(
                    l10n.commentsParams(comments.length),
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
        ...comments.asMap().entries.map((entry) => FadeInWrapper(
          delay: Duration(milliseconds: entry.key * 30),
          child: _CommentItem(
            comment: entry.value,
            isCurrentUser: currentUserId != null && entry.value.user?.id == currentUserId,
            owner: owner,
            repo: repo,
            index: index,
          ),
        )),
      ],
    ));
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

  void _showMilestoneEditor(BuildContext context, Issue issue) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await Injection.listMilestonesUseCase.call(
      ListMilestonesParams(owner: owner, repo: repo),
    );
    final milestones = result is Right<Failure, List<Milestone>> ? result.value : <Milestone>[];
    int? selectedMilestoneId = issue.milestone?.id;

    if (!context.mounted) return;

    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return AlertDialog(
              title: Text(l10n.milestone),
              content: SizedBox(
                width: double.maxFinite,
                child: RadioGroup<int?>(
                  groupValue: selectedMilestoneId,
                  onChanged: (v) => setState(() => selectedMilestoneId = v),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: milestones.length + 1,
                    itemBuilder: (ctx, index) {
                      if (index == 0) {
                        return RadioListTile<int?>(
                          title: Text(l10n.noMilestones),
                          value: null,
                        );
                      }
                      final milestone = milestones[index - 1];
                      return RadioListTile<int?>(
                        title: Text(milestone.title ?? ''),
                        value: milestone.id,
                      );
                    },
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(l10n.cancel),
                ),
                FilledButton(
                  onPressed: () async {
                    Navigator.of(ctx).pop();
                    await Injection.issueNotifier.editIssue(
                      owner,
                      repo,
                      index,
                      {'milestone': selectedMilestoneId},
                    );
                    await Injection.issueNotifier.getIssue(owner, repo, index);
                  },
                  child: Text(l10n.save),
                ),
              ],
            );
          },
        );
      },
    );
  }

}

class _CommentItem extends StatefulWidget {
  final Comment comment;
  final bool isCurrentUser;
  final String owner;
  final String repo;
  final int index;

  const _CommentItem({
    required this.comment,
    required this.isCurrentUser,
    required this.owner,
    required this.repo,
    required this.index,
  });

  @override
  State<_CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<_CommentItem> {
  late TextEditingController _editController;
  bool _editing = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _editController = TextEditingController(text: widget.comment.body ?? '');
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  Future<void> _saveEdit() async {
    final l10n = AppLocalizations.of(context)!;
    final text = _editController.text.trim();
    if (text.isEmpty) return;

    setState(() => _saving = true);
    try {
      await Injection.apiService.issueEditComment(
        owner: widget.owner,
        repo: widget.repo,
        id: widget.comment.id ?? 0,
        body: {'body': text},
      );
      if (mounted) {
        setState(() { _editing = false; _saving = false; });
        Injection.issueNotifier.listComments(widget.owner, widget.repo, widget.index);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.error}: $e')),
        );
      }
    }
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteComment),
        content: Text(l10n.deleteCommentConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await Injection.apiService.issueDeleteComment(
        owner: widget.owner, repo: widget.repo, id: widget.comment.id ?? 0,
      );
      if (mounted) {
        Injection.issueNotifier.listComments(widget.owner, widget.repo, widget.index);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.error}: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isMe = widget.isCurrentUser;
    final bubbleColor = isMe
        ? theme.colorScheme.primaryContainer
        : theme.colorScheme.surfaceContainerHighest;
    final screenWidth = MediaQuery.of(context).size.width;
    final maxBubbleWidth = screenWidth > 600 ? 480.0 : screenWidth * 0.75;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: widget.comment.user != null
                  ? UserAvatar(user: widget.comment.user!, radius: 18)
                  : CircleAvatar(radius: 18, child: Icon(Icons.person, size: 18)),
            ),
          if (!isMe) const SizedBox(width: 10),
          Flexible(
            child: GestureDetector(
              onLongPress: isMe && !_editing
                  ? () {
                      final renderBox = context.findRenderObject() as RenderBox;
                      final offset = renderBox.localToGlobal(Offset.zero);
                      showMenu<String>(
                        context: context,
                        position: RelativeRect.fromLTRB(
                          offset.dx, offset.dy - 40,
                          offset.dx + renderBox.size.width, offset.dy,
                        ),
                        items: [
                          PopupMenuItem(value: 'edit', child: Text(l10n.edit)),
                          PopupMenuItem(value: 'delete', child: Text(l10n.delete)),
                        ],
                      ).then((v) {
                        if (v == 'edit') setState(() => _editing = true);
                        if (v == 'delete') _delete();
                      });
                    }
                  : null,
              child: IntrinsicWidth(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: maxBubbleWidth,
                      ),
                      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                      decoration: BoxDecoration(
                        color: bubbleColor,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(18),
                          topRight: const Radius.circular(18),
                          bottomLeft: Radius.circular(isMe ? 18 : 4),
                          bottomRight: Radius.circular(isMe ? 4 : 18),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          if (!isMe && widget.comment.user?.login != null)
                            Text(
                              widget.comment.user!.login!,
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          if (_editing)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                TextField(
                                  controller: _editController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                  ),
                                  maxLines: 5,
                                  minLines: 2,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextButton(
                                      onPressed: () => setState(() {
                                        _editing = false;
                                        _editController.text = widget.comment.body ?? '';
                                      }),
                                      child: Text(l10n.cancel),
                                    ),
                                    const SizedBox(width: 4),
                                    FilledButton(
                                      onPressed: _saving ? null : _saveEdit,
                                      child: _saving
                                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                                          : Text(l10n.save),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          else if (widget.comment.body != null && widget.comment.body!.isNotEmpty)
                            MarkdownBody(
                              data: widget.comment.body!,
                              selectable: true,
                              styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                                p: theme.textTheme.bodyMedium,
                              ),
                              onTapLink: (text, href, title) {
                                if (href != null) {
                                  launchUrl(Uri.parse(href), mode: LaunchMode.externalApplication);
                                }
                              },
                            ),
                          const SizedBox(height: 4),
                          Text(
                            _formatDate(widget.comment.created_at, AppLocalizations.of(context)!),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isMe && !_editing)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: PopupMenuButton<String>(
                          padding: EdgeInsets.zero,
                          icon: Icon(Icons.more_horiz, size: 14, color: theme.colorScheme.onSurfaceVariant),
                          onSelected: (v) {
                            if (v == 'edit') setState(() => _editing = true);
                            if (v == 'delete') _delete();
                          },
                          itemBuilder: (_) => [
                            PopupMenuItem(value: 'edit', child: Text(l10n.edit)),
                            PopupMenuItem(value: 'delete', child: Text(l10n.delete)),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 8),
            if (widget.comment.user != null)
              UserAvatar(user: widget.comment.user!, radius: 16)
            else
              CircleAvatar(radius: 16, child: Icon(Icons.person, size: 16)),
          ],
        ],
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

class _TimelineSection extends StatefulWidget {
  final String owner;
  final String repo;
  final int index;

  const _TimelineSection({required this.owner, required this.repo, required this.index});

  @override
  State<_TimelineSection> createState() => _TimelineSectionState();
}

class _TimelineSectionState extends State<_TimelineSection> {
  List<TimelineComment> _timeline = [];
  bool _loading = true;
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      _timeline = await Injection.apiService.issueGetTimeline(
        owner: widget.owner,
        repo: widget.repo,
        index: widget.index,
      );
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: ExpansionTile(
        leading: Icon(Icons.timeline, color: theme.colorScheme.primary),
        title: Text(l10n.timeline, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500)),
        subtitle: Text('${_timeline.length} ${l10n.events}', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        initiallyExpanded: _expanded,
        onExpansionChanged: (v) => setState(() => _expanded = v),
        children: [
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
            )
          else if (_timeline.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(l10n.noData, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            )
          else
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                children: _timeline.map((item) {
                  return _TimelineItem(timeline: item);
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final TimelineComment timeline;

  const _TimelineItem({required this.timeline});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final type = timeline.type ?? '';

    IconData icon;
    String text;
    switch (type) {
      case 'comment':
        icon = Icons.chat_bubble_outline;
        text = timeline.body ?? l10n.commented;
      case 'label':
        icon = Icons.label_outline;
        text = timeline.label?.name ?? l10n.labelUpdated;
      case 'milestone':
        icon = Icons.flag_outlined;
        text = timeline.milestone?.title ?? l10n.milestoneUpdated;
      case 'assignee':
        icon = Icons.person_outline;
        text = timeline.assignee?.login ?? l10n.assigneeUpdated;
      case 'close':
        icon = Icons.check_circle_outline;
        text = l10n.closed;
      case 'reopen':
        icon = Icons.refresh;
        text = l10n.reopened;
      case 'title':
        icon = Icons.title;
        text = '${timeline.old_title ?? ''} → ${timeline.new_title ?? ''}';
      default:
        icon = Icons.info_outline;
        text = type;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
                ),
                if (timeline.user?.login != null)
                  Text(
                    '${timeline.user!.login} · ${_formatTime(timeline.created_at, l10n)}',
                    style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime? date, AppLocalizations l10n) {
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

class _DependenciesSection extends StatefulWidget {
  final String owner;
  final String repo;
  final int index;

  const _DependenciesSection({required this.owner, required this.repo, required this.index});

  @override
  State<_DependenciesSection> createState() => _DependenciesSectionState();
}

class _DependenciesSectionState extends State<_DependenciesSection> {
  List<Issue> _dependencies = [];
  bool _loading = true;
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      _dependencies = await Injection.apiService.issueListDependencies(
        owner: widget.owner,
        repo: widget.repo,
        index: widget.index,
      );
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _add() async {
    final l10n = AppLocalizations.of(context)!;
    final ctrl = TextEditingController();
    final number = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.addDependency),
        content: TextField(
          controller: ctrl,
          decoration: InputDecoration(
            labelText: l10n.issueNumberHint,
            border: const OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
          FilledButton(
            onPressed: ctrl.text.trim().isEmpty ? null : () => Navigator.pop(ctx, ctrl.text.trim()),
            child: Text(l10n.add),
          ),
        ],
      ),
    );
    if (number != null && mounted) {
      final depIndex = int.tryParse(number);
      if (depIndex != null) {
        try {
          await Injection.apiService.issueCreateDependency(
            owner: widget.owner,
            repo: widget.repo,
            index: widget.index,
            dependencyIndex: depIndex,
          );
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.dependencyAdded)));
            _load();
          }
        } catch (_) {
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.error)));
        }
      }
    }
  }

  Future<void> _remove(Issue dep) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.removeDependency),
        content: Text(l10n.removeDependencyConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.delete)),
        ],
      ),
    );
    if (ok == true && dep.number != null && mounted) {
      try {
        await Injection.apiService.issueRemoveDependency(
          owner: widget.owner,
          repo: widget.repo,
          index: widget.index,
          dependencyIndex: dep.number!,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.dependencyRemoved)));
          _load();
        }
      } catch (_) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.error)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: ExpansionTile(
        leading: Icon(Icons.link, color: theme.colorScheme.primary),
        title: Text(l10n.dependencies, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500)),
        subtitle: Text('${_dependencies.length} ${l10n.items}', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        initiallyExpanded: _expanded,
        onExpansionChanged: (v) => setState(() => _expanded = v),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.add, size: 20),
              onPressed: _add,
            ),
            const Icon(Icons.expand_more),
          ],
        ),
        children: [
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
            )
          else if (_dependencies.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(l10n.noDependencies, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            )
          else
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                children: _dependencies.map((dep) {
                  return ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: dep.state?.value == 'open' ? Colors.green : Colors.purple,
                        shape: BoxShape.circle,
                      ),
                    ),
                    title: Text('#${dep.number} ${dep.title ?? ''}', style: theme.textTheme.bodySmall),
                    trailing: IconButton(
                      icon: const Icon(Icons.link_off, size: 18),
                      onPressed: () => _remove(dep),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
