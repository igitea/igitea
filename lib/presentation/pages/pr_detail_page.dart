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
import '../../l10n/app_localizations.dart';
import '../../presentation/state/issue_notifier.dart';
import '../../presentation/state/repo_notifier.dart';
import '../widgets/user_avatar.dart';
import 'create_review_dialog.dart';

const _reactionEmojis = {
  '+1': '\u{1f44d}',
  '-1': '\u{1f44e}',
  'laugh': '\u{1f604}',
  'hooray': '\u{1f389}',
  'confused': '\u{1f615}',
  'heart': '\u{2764}\u{fe0f}',
  'eyes': '\u{1f440}',
};

const _defaultReactions = ['+1', '-1', 'laugh', 'hooray', 'confused', 'heart', 'eyes'];

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
  List<PullReview> _reviews = [];
  List<Reaction> _prReactions = [];
  bool _reactionsLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Injection.repoNotifier.getPullRequest(widget.owner, widget.repo, widget.index);
      Injection.issueNotifier.listComments(widget.owner, widget.repo, widget.index);
      _loadReviews();
      _loadPrReactions();
    });
  }

  Future<void> _loadPrReactions() async {
    setState(() => _reactionsLoading = true);
    final result = await Injection.getIssueReactionsUseCase(
      widget.owner, widget.repo, widget.index,
    );
    if (result is Right<Failure, List<Reaction>>) {
      _prReactions = result.value;
    }
    if (mounted) setState(() => _reactionsLoading = false);
  }

  Future<void> _togglePrReaction(String content) async {
    final currentUser = Injection.authNotifier.state is AuthAuthenticated
        ? (Injection.authNotifier.state as AuthAuthenticated).user.login
        : null;
    final existing = _prReactions.where(
      (r) => r.content == content && r.user?.login == currentUser,
    ).toList();
    if (existing.isNotEmpty) {
      await Injection.deleteIssueReactionUseCase(
        widget.owner, widget.repo, widget.index, content);
    } else {
      await Injection.addIssueReactionUseCase(
        widget.owner, widget.repo, widget.index, content);
    }
    _loadPrReactions();
  }

  Future<void> _loadReviews() async {
    final result = await Injection.listPullReviewsUseCase(
      widget.owner, widget.repo, widget.index,
    );
    if (mounted) {
      _reviews = result is Right<Failure, List<PullReview>> ? result.value : [];
      setState(() {});
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
                  await _loadReviews();
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
              prReactions: _prReactions,
              reactionsLoading: _reactionsLoading,
              onToggleReaction: _togglePrReaction,
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
  final List<PullReview> reviews;
  final List<Reaction> prReactions;
  final bool reactionsLoading;
  final Future<void> Function(String) onToggleReaction;

  const _PRContent({
    required this.pr,
    required this.owner,
    required this.repo,
    required this.index,
    required this.commentController,
    required this.reviews,
    required this.prReactions,
    required this.reactionsLoading,
    required this.onToggleReaction,
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

          if (!reactionsLoading)
            _buildReactionRow(context, prReactions, onToggleReaction),

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

  Widget _buildReactionRow(BuildContext context, List<Reaction> reactions, Future<void> Function(String) onToggle) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: _defaultReactions.map((content) {
          final count = reactions.where((r) => r.content == content).length;
          final currentUser = Injection.authNotifier.state is AuthAuthenticated
              ? (Injection.authNotifier.state as AuthAuthenticated).user.login
              : null;
          final userReacted = reactions.any(
            (r) => r.content == content && r.user?.login == currentUser,
          );
          return Material(
            color: userReacted ? theme.colorScheme.primaryContainer : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => onToggle(content),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  '${_reactionEmojis[content] ?? content} $count',
                  style: TextStyle(
                    fontSize: 14,
                    color: userReacted ? theme.colorScheme.onPrimaryContainer : null,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildReviewSection(AppLocalizations l10n, ThemeData theme) {
    if (reviews.isEmpty) return const SizedBox.shrink();
    final approved = reviews.where((r) => r.state?.value == 'APPROVED').length;
    final changes = reviews.where((r) => r.state?.value == 'REQUEST_CHANGES').length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
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
              const SizedBox(width: 8),
              if (approved > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
                  child: Text('+$approved', style: const TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              if (changes > 0) ...[
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
                  child: Text('-$changes', style: const TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ],
          ),
        ),
        ...reviews.map((r) => _buildReviewCard(r, l10n, theme)),
      ],
    );
  }

  Widget _buildReviewCard(PullReview review, AppLocalizations l10n, ThemeData theme) {
    final state = review.state?.value ?? 'comment';
    final body = review.body ?? '';
    final user = review.user;
    final submitted = review.submitted_at;
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
                if (user?.login != null)
                  Text(user!.login!, style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600)),
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
              Text(_formatDate(submitted, l10n),
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
          child: _CommentItem(
            comment: entry.value,
            owner: owner,
            repo: repo,
          ),
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

class _CommentItem extends StatefulWidget {
  final Comment comment;
  final String owner;
  final String repo;

  const _CommentItem({required this.comment, required this.owner, required this.repo});

  @override
  State<_CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<_CommentItem> {
  List<Reaction> _commentReactions = [];
  bool _commentReactionsLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCommentReactions();
  }

  Future<void> _loadCommentReactions() async {
    if (widget.comment.id == null) return;
    setState(() => _commentReactionsLoading = true);
    final result = await Injection.getCommentReactionsUseCase(
      widget.owner, widget.repo, widget.comment.id!,
    );
    if (result is Right<Failure, List<Reaction>>) {
      _commentReactions = result.value;
    }
    if (mounted) setState(() => _commentReactionsLoading = false);
  }

  Future<void> _toggleCommentReaction(String content) async {
    if (widget.comment.id == null) return;
    final currentUser = Injection.authNotifier.state is AuthAuthenticated
        ? (Injection.authNotifier.state as AuthAuthenticated).user.login
        : null;
    final existing = _commentReactions.where(
      (r) => r.content == content && r.user?.login == currentUser,
    ).toList();
    if (existing.isNotEmpty) {
      await Injection.deleteCommentReactionUseCase(
        widget.owner, widget.repo, widget.comment.id!, content);
    } else {
      await Injection.addCommentReactionUseCase(
        widget.owner, widget.repo, widget.comment.id!, content);
    }
    _loadCommentReactions();
  }

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
                if (widget.comment.user != null) ...[
                  UserAvatar(user: widget.comment.user!, radius: 14),
                  const SizedBox(width: 8),
                  Text(
                    widget.comment.user!.login ?? '',
                    style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
                const Spacer(),
                Text(
                  _formatDate(widget.comment.created_at, l10n),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (widget.comment.body != null && widget.comment.body!.isNotEmpty)
              MarkdownBody(
                data: widget.comment.body!,
                selectable: true,
                onTapLink: (text, href, title) {
                  if (href != null) {
                    launchUrl(Uri.parse(href), mode: LaunchMode.externalApplication);
                  }
                },
              ),
            if (!_commentReactionsLoading && widget.comment.id != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: SizedBox(
                  height: 28,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: _defaultReactions.map((content) {
                      final count = _commentReactions.where((r) => r.content == content).length;
                      final currentUser = Injection.authNotifier.state is AuthAuthenticated
                          ? (Injection.authNotifier.state as AuthAuthenticated).user.login
                          : null;
                      final userReacted = _commentReactions.any(
                        (r) => r.content == content && r.user?.login == currentUser,
                      );
                      return Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Material(
                          color: userReacted ? theme.colorScheme.primaryContainer : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => _toggleCommentReaction(content),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              child: Text(
                                '${_reactionEmojis[content] ?? content} $count',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: userReacted ? theme.colorScheme.onPrimaryContainer : null,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
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
