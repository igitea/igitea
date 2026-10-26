import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';
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
import '../../presentation/state/repo_notifier.dart';
import '../../presentation/state/user_notifier.dart';
import '../widgets/app_markdown.dart';
import '../widgets/app_surface.dart';
import '../widgets/desktop/app_hover_region.dart';
import '../widgets/forui/app_chrome.dart';
import '../theme/app_palette.dart';
import '../widgets/forui/app_page.dart';
import '../widgets/forui/app_state_views.dart';
import '../widgets/forui/app_tile.dart';
import '../widgets/slow_loading_indicator.dart';
import '../widgets/user_avatar.dart';
import 'edit_issue_page.dart';
import '../widgets/comment_composer.dart';
import '../widgets/label_badge.dart';

const _reactionEmojis = {
  '+1': '\u{1f44d}',
  '-1': '\u{1f44e}',
  'laugh': '\u{1f604}',
  'hooray': '\u{1f389}',
  'confused': '\u{1f615}',
  'heart': '\u{2764}\u{fe0f}',
  'eyes': '\u{1f440}',
};

const _defaultReactions = [
  '+1',
  '-1',
  'laugh',
  'hooray',
  'confused',
  'heart',
  'eyes',
];

class IssueDetailPage extends StatefulWidget {
  final String owner;
  final String repo;
  final int index;

  /// Renders without the [AppPage] scaffold so the issue can sit inside a
  /// desktop list-detail pane.
  final bool embedded;

  const IssueDetailPage({
    super.key,
    required this.owner,
    required this.repo,
    required this.index,
    this.embedded = false,
  });

  @override
  State<IssueDetailPage> createState() => _IssueDetailPageState();
}

class _IssueDetailPageState extends State<IssueDetailPage> {
  final _commentController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isSubscribed = false;
  bool _subscriptionLoading = false;
  List<Reaction> _issueReactions = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadDetail());
  }

  @override
  void didUpdateWidget(covariant IssueDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.owner != widget.owner ||
        oldWidget.repo != widget.repo ||
        oldWidget.index != widget.index) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadDetail());
    }
  }

  Future<void> _loadDetail() async {
    Injection.issueNotifier.getIssue(widget.owner, widget.repo, widget.index);
    Injection.issueNotifier.listComments(
      widget.owner,
      widget.repo,
      widget.index,
    );
    Injection.repoNotifier.getRepo(widget.owner, widget.repo);
    await _checkSubscription();
    await _refreshIssueReactions();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll >= maxScroll - 200) {
      Injection.issueNotifier.loadMoreComments(
        widget.owner,
        widget.repo,
        widget.index,
      );
    }
  }

  Future<void> _refreshIssueReactions() async {
    final result = await Injection.getIssueReactionsUseCase(
      widget.owner,
      widget.repo,
      widget.index,
    );
    if (result is Right<Failure, List<Reaction>>) {
      _issueReactions = result.value;
    }
    if (mounted) setState(() {});
  }

  Future<void> _toggleIssueReaction(String content) async {
    final currentUser = Injection.authNotifier.state is AuthAuthenticated
        ? (Injection.authNotifier.state as AuthAuthenticated).user.login
        : null;
    final existing = _issueReactions
        .where((r) => r.content == content && r.user?.login == currentUser)
        .toList();

    _issueReactions = List.from(_issueReactions);
    if (existing.isNotEmpty) {
      _issueReactions.removeWhere(
        (r) => r.content == content && r.user?.login == currentUser,
      );
      if (mounted) setState(() {});
      await Injection.deleteIssueReactionUseCase(
        widget.owner,
        widget.repo,
        widget.index,
        content,
      );
    } else {
      _issueReactions.add(
        Reaction(
          content: content,
          user: User(login: currentUser),
        ),
      );
      if (mounted) setState(() {});
      await Injection.addIssueReactionUseCase(
        widget.owner,
        widget.repo,
        widget.index,
        content,
      );
    }
    await _refreshIssueReactions();
  }

  Future<void> _checkSubscription() async {
    final result = await Injection.checkIssueSubscriptionUseCase(
      widget.owner,
      widget.repo,
      widget.index,
    );
    if (mounted) {
      setState(() {
        _isSubscribed = result is Right<Failure, bool> && result.value;
      });
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
        await Injection.deleteIssueSubscriptionUseCase(
          widget.owner,
          widget.repo,
          widget.index,
          currentUser,
        );
      } else {
        await Injection.addIssueSubscriptionUseCase(
          widget.owner,
          widget.repo,
          widget.index,
          currentUser,
        );
      }
      if (mounted) {
        setState(() {
          _isSubscribed = !_isSubscribed;
          _subscriptionLoading = false;
        });
        showFToast(
          context: context,
          title: Text(_isSubscribed ? l10n.subscribed : l10n.unsubscribed),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _subscriptionLoading = false);
        showFToast(
          context: context,
          variant: .destructive,
          title: Text('${l10n.error}: $e'),
        );
      }
    }
  }

  Future<void> _confirmDeleteIssue() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showFDialog<bool>(
      context: context,
      builder: (ctx, style, animation) => FDialog(
        title: Text(l10n.deleteIssue),
        body: Text(l10n.deleteIssueConfirm),
        actions: [
          FButton(
            variant: .outline,
            onPress: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FButton(
            variant: .destructive,
            onPress: () => Navigator.pop(ctx, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final result = await Injection.issueNotifier.deleteIssue(
      widget.owner,
      widget.repo,
      widget.index,
    );
    if (!mounted) return;
    switch (result) {
      case Left<Failure, void>(:final value):
        showFToast(
          context: context,
          variant: .destructive,
          title: Text('${l10n.error}: ${value.message}'),
        );
      case Right<Failure, void>():
        Navigator.of(context).pop();
        showFToast(context: context, title: Text(l10n.issueDeleted));
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  bool _canEdit() {
    final repoState = Injection.repoNotifier.state;
    if (repoState is RepoLoaded) {
      final p = repoState.repo.permissions;
      return p?.push == true || p?.admin == true;
    }
    return false;
  }

  Future<void> _onRefresh() async {
    await Future.wait([
      Injection.issueNotifier.getIssue(widget.owner, widget.repo, widget.index),
      Injection.issueNotifier.listComments(
        widget.owner,
        widget.repo,
        widget.index,
      ),
      Injection.repoNotifier.getRepo(widget.owner, widget.repo),
    ]);
    await _checkSubscription();
    await _refreshIssueReactions();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (widget.embedded) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _EmbeddedIssueHeader(
            owner: widget.owner,
            repo: widget.repo,
            index: widget.index,
            onRefresh: () => _onRefresh(),
            onOpenBrowser: _openInBrowser,
            onEdit: _openEditor,
          ),
          Expanded(child: _buildThread(l10n)),
          _buildComposer(),
        ],
      );
    }
    return AppPage(
      title: l10n.issueNumber(widget.index),
      subtitle: '${widget.owner}/${widget.repo}',
      maxContentWidth: 980,
      actions: [
        if (Injection.issueNotifier.state is IssueDetailLoaded)
          FHeaderAction(
            icon: const Icon(FIcons.externalLink),
            semanticsLabel: l10n.openInBrowser,
            onPress: _openInBrowser,
          ),
        if (Injection.issueNotifier.state is IssueDetailLoaded)
          FHeaderAction(
            icon: const Icon(FIcons.trash2),
            semanticsLabel: l10n.delete,
            onPress: _confirmDeleteIssue,
          ),
      ],
      bottomBar: _buildComposer(maxWidth: 980),
      child: _buildThread(l10n),
    );
  }

  void _openInBrowser() {
    final state = Injection.issueNotifier.state;
    if (state is! IssueDetailLoaded) return;
    final url = state.issue.html_url;
    if (url == null) return;
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  void _openEditor(Issue issue) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => EditIssuePage(
              owner: widget.owner,
              repo: widget.repo,
              index: widget.index,
              issue: issue,
            ),
          ),
        )
        .then((_) {
          if (mounted) _onRefresh();
        });
  }

  Widget _buildComposer({double? maxWidth}) {
    return ListenableBuilder(
      listenable: Injection.issueNotifier,
      builder: (context, _) {
        final state = Injection.issueNotifier.state;
        final loaded =
            state is IssueDetailLoaded && state.issue.number == widget.index;
        if (!loaded) return const SizedBox.shrink();
        return CommentComposer(
          controller: _commentController,
          onSend: _sendComment,
          maxWidth: maxWidth,
        );
      },
    );
  }

  Future<void> _sendComment(String body) async {
    await Injection.issueNotifier.createComment(
      widget.owner,
      widget.repo,
      widget.index,
      {'body': body},
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    });
  }

  Widget _buildThread(AppLocalizations l10n) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListenableBuilder(
        listenable: Injection.issueNotifier,
        builder: (context, _) {
          final state = Injection.issueNotifier.state;
          return switch (state) {
            IssueLoading() => const SlowLoadingIndicator(),
            IssueError(:final message) => AppError(
              message: message,
              onRetry: () => Injection.issueNotifier.getIssue(
                widget.owner,
                widget.repo,
                widget.index,
              ),
            ),
            IssueDetailLoaded(:final issue) when issue.number == widget.index =>
              _IssueContent(
                issue: issue,
                owner: widget.owner,
                repo: widget.repo,
                index: widget.index,
                scrollController: _scrollController,
                isSubscribed: _isSubscribed,
                subscriptionLoading: _subscriptionLoading,
                onToggleSubscription: _toggleSubscription,
                issueReactions: _issueReactions,
                onToggleReaction: _toggleIssueReaction,
                canEdit: _canEdit(),
              ),
            IssueDetailLoaded() => const SlowLoadingIndicator(),
            _ => const Center(child: FCircularProgress(size: .sm)),
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
  final ScrollController scrollController;
  final bool isSubscribed;
  final bool subscriptionLoading;
  final VoidCallback onToggleSubscription;
  final List<Reaction> issueReactions;
  final Future<void> Function(String) onToggleReaction;
  final bool canEdit;

  const _IssueContent({
    required this.issue,
    required this.owner,
    required this.repo,
    required this.index,
    required this.scrollController,
    required this.isSubscribed,
    required this.subscriptionLoading,
    required this.onToggleSubscription,
    required this.issueReactions,
    required this.onToggleReaction,
    required this.canEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isOpen = issue.state?.isOpen == true;

    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isOpen
                      ? context.palette.successSoft
                      : context.palette.purpleSoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isOpen ? l10n.open : l10n.closed,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isOpen
                        ? context.palette.success
                        : context.palette.purple,
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

          if (issue.labels?.isNotEmpty == true) ...[
            LabelRow(labels: issue.labels!, maxShow: 12, dense: false),
            const SizedBox(height: 12),
          ],
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (canEdit)
                FButton(
                  variant: .outline,
                  size: .xs,
                  mainAxisSize: .min,
                  prefix: const Icon(FIcons.pencilLine, size: 16),
                  onPress: () async {
                    final edited = await Navigator.of(context).push<bool>(
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
                    if (edited == true && context.mounted) {
                      Navigator.pop(context, true);
                    }
                  },
                  child: Text(l10n.edit),
                ),
              FButton(
                variant: .outline,
                size: .xs,
                mainAxisSize: .min,
                prefix: Icon(
                  isSubscribed ? FIcons.bellOff : FIcons.bell,
                  size: 16,
                ),
                onPress: subscriptionLoading ? null : onToggleSubscription,
                child: Text(isSubscribed ? l10n.unsubscribe : l10n.subscribe),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (issue.assignee != null)
            _buildInfoRow(
              context,
              icon: FIcons.userRound,
              label: l10n.assignee,
              semanticsLabel:
                  '${l10n.assignee}: ${issue.assignee!.login ?? ''}',
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
              icon: FIcons.flag,
              label: l10n.milestone,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(issue.milestone!.title ?? ''),
                  if (canEdit) ...[
                    const SizedBox(width: 8),
                    FTappable(
                      onPress: () => _showMilestoneEditor(context, issue),
                      semanticsLabel: l10n.editMilestone,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Icon(
                          FIcons.pencilLine,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

          if (issue.due_date != null || canEdit)
            _buildInfoRow(
              context,
              icon: FIcons.calendarDays,
              label: l10n.dueDate,
              child: issue.due_date != null
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          issue.due_date!.toLocal().toString().split(' ')[0],
                          style: _isOverdue(issue)
                              ? TextStyle(
                                  color: theme.colorScheme.error,
                                  fontWeight: FontWeight.w600,
                                )
                              : null,
                        ),
                        if (_isOverdue(issue)) ...[
                          const SizedBox(width: 4),
                          Icon(
                            FIcons.triangleAlert,
                            size: 14,
                            color: theme.colorScheme.error,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            l10n.overdue,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.error,
                            ),
                          ),
                        ],
                        if (canEdit) ...[
                          const SizedBox(width: 8),
                          FTappable(
                            onPress: () => _editDueDate(context, issue),
                            semanticsLabel: l10n.editDueDate,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Icon(
                                FIcons.pencilLine,
                                size: 16,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          FTappable(
                            onPress: () => _clearDueDate(),
                            semanticsLabel: l10n.clearDueDate,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Icon(
                                FIcons.x,
                                size: 16,
                                color: theme.colorScheme.error,
                              ),
                            ),
                          ),
                        ],
                      ],
                    )
                  : canEdit
                  ? FTappable(
                      onPress: () => _editDueDate(context, issue),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l10n.setDueDate,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

          const SizedBox(height: 8),
          Row(
            children: [
              FButton(
                onPress: () {
                  Injection.issueNotifier.editIssue(owner, repo, index, {
                    'state': isOpen ? 'closed' : 'open',
                  });
                },
                child: Text(isOpen ? l10n.closeIssue : l10n.reopenIssue),
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: FDivider(),
          ),

          if (issue.body != null && issue.body!.isNotEmpty)
            AppMarkdown(
              data: issue.body!,
              selectable: true,
              onTapLink: (text, href, title) {
                if (href != null) {
                  launchUrl(
                    Uri.parse(href),
                    mode: LaunchMode.externalApplication,
                  );
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

          _buildReactionRow(context, issueReactions, onToggleReaction),

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
                CommentsLoading() => const Center(
                  child: FCircularProgress(size: .sm),
                ),
                CommentsError(:final message) => Column(
                  children: [
                    Text(
                      '${l10n.failedToLoadComments}\n${friendlyErrorMessage(context, message)}',
                      textAlign: TextAlign.center,
                    ),
                    FButton(
                      variant: .ghost,
                      size: .sm,
                      onPress: () => Injection.issueNotifier.listComments(
                        owner,
                        repo,
                        index,
                      ),
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
                CommentsLoaded(:final comments, :final hasMore) =>
                  _buildCommentsList(
                    context,
                    comments,
                    hasMore: hasMore,
                    l10n: l10n,
                  ),
                _ => const SizedBox.shrink(),
              };
            },
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Icon(
                FIcons.messageCircle,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                l10n.commentsCountParams(issue.comments ?? 0),
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(width: 16),
              Icon(
                FIcons.history,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
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

  Widget _buildReactionRow(
    BuildContext context,
    List<Reaction> reactions,
    Future<void> Function(String) onToggle,
  ) {
    final activeReactions = _defaultReactions.where((content) {
      return reactions.any((r) => r.content == content);
    }).toList();
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildPickReactionButton(context, reactions, onToggle),
            if (activeReactions.isNotEmpty) const SizedBox(width: 4),
            ...activeReactions.map((content) {
              return Padding(
                padding: const EdgeInsets.only(right: 4),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
                  child: _buildReactionChip(
                    context,
                    reactions,
                    content,
                    onToggle,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPickReactionButton(
    BuildContext context,
    List<Reaction> reactions,
    Future<void> Function(String) onToggle,
  ) {
    final theme = Theme.of(context);
    return Builder(
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withAlpha(128),
            borderRadius: BorderRadius.circular(16),
          ),
          child: FTappable(
            onPress: () {
              final renderBox = ctx.findRenderObject() as RenderBox?;
              if (renderBox == null) return;
              final position = renderBox.localToGlobal(Offset.zero);
              final size = renderBox.size;
              late OverlayEntry overlay;
              overlay = OverlayEntry(
                builder: (ctx) => GestureDetector(
                  onTap: () => overlay.remove(),
                  behavior: HitTestBehavior.translucent,
                  child: Stack(
                    children: [
                      Positioned(
                        left: position.dx,
                        top: position.dy + size.height + 4,
                        child: Material(
                          elevation: 8,
                          borderRadius: BorderRadius.circular(12),
                          color: theme.colorScheme.surfaceContainerHigh,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Wrap(
                              spacing: 2,
                              runSpacing: 2,
                              children: _defaultReactions.map((content) {
                                final currentUser =
                                    Injection.authNotifier.state
                                        is AuthAuthenticated
                                    ? (Injection.authNotifier.state
                                              as AuthAuthenticated)
                                          .user
                                          .login
                                    : null;
                                final userReacted = reactions.any(
                                  (r) =>
                                      r.content == content &&
                                      r.user?.login == currentUser,
                                );
                                return Container(
                                  decoration: BoxDecoration(
                                    color: userReacted
                                        ? theme.colorScheme.primaryContainer
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: FTappable(
                                    onPress: () {
                                      overlay.remove();
                                      onToggle(content);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        _reactionEmojis[content] ?? content,
                                        style: const TextStyle(fontSize: 22),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
              Overlay.of(context).insert(overlay);
            },
            child: Semantics(
              label: 'Add reaction',
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(FIcons.smile, size: 18),
                    SizedBox(width: 1),
                    Icon(FIcons.plus, size: 10),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildReactionChip(
    BuildContext context,
    List<Reaction> reactions,
    String content,
    Future<void> Function(String) onToggle,
  ) {
    final theme = Theme.of(context);
    final count = reactions.where((r) => r.content == content).length;
    final currentUser = Injection.authNotifier.state is AuthAuthenticated
        ? (Injection.authNotifier.state as AuthAuthenticated).user.login
        : null;
    final userReacted = reactions.any(
      (r) => r.content == content && r.user?.login == currentUser,
    );
    return Container(
      key: ValueKey(content),
      decoration: BoxDecoration(
        color: userReacted
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.surfaceContainerHighest.withAlpha(128),
        borderRadius: BorderRadius.circular(16),
      ),
      child: FTappable(
        onPress: () => onToggle(content),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
  }

  Widget _buildCommentsList(
    BuildContext context,
    List<Comment> comments, {
    bool hasMore = false,
    required AppLocalizations l10n,
  }) {
    if (comments.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final currentUserState = Injection.userNotifier.state;
    final currentUserId = currentUserState is UserLoaded
        ? currentUserState.user.id
        : null;

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
                  Icon(
                    FIcons.messageSquare,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    l10n.commentsParams(comments.length),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: comments.length + (hasMore ? 1 : 0),
            itemBuilder: (context, i) {
              if (hasMore && i == comments.length) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Center(
                    child: Injection.issueNotifier.commentLoadingMore
                        ? const FCircularProgress(size: .sm)
                        : FButton(
                            variant: .ghost,
                            size: .sm,
                            onPress: () => Injection.issueNotifier
                                .loadMoreComments(owner, repo, index),
                            child: const Text('Load more comments'),
                          ),
                  ),
                );
              }
              return FadeInWrapper(
                delay: Duration(milliseconds: i * 30),
                child: _CommentItem(
                  comment: comments[i],
                  isCurrentUser:
                      currentUserId != null &&
                      comments[i].user?.id == currentUserId,
                  owner: owner,
                  repo: repo,
                  index: index,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Widget child,
    String? semanticsLabel,
  }) {
    final theme = Theme.of(context);
    final row = Padding(
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
    if (semanticsLabel != null) {
      return Semantics(label: semanticsLabel, child: row);
    }
    return row;
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

  bool _isOverdue(Issue issue) {
    if (issue.due_date == null) return false;
    return issue.state?.isOpen == true &&
        issue.due_date!.isBefore(DateTime.now());
  }

  void _showMilestoneEditor(BuildContext context, Issue issue) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await Injection.listMilestonesUseCase.call(
      ListMilestonesParams(owner: owner, repo: repo),
    );
    final milestones = result is Right<Failure, List<Milestone>>
        ? result.value
        : <Milestone>[];
    int? selectedMilestoneId = issue.milestone?.id;

    if (!context.mounted) return;

    await showFDialog<void>(
      context: context,
      builder: (ctx, style, animation) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return FDialog(
              title: Text(l10n.milestone),
              body: SizedBox(
                width: double.maxFinite,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 320),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppTile(
                          title: l10n.noMilestones,
                          showChevron: false,
                          trailing: selectedMilestoneId == null
                              ? const Icon(FIcons.check, size: 16)
                              : null,
                          onPress: () =>
                              setDialogState(() => selectedMilestoneId = null),
                        ),
                        for (final milestone in milestones)
                          AppTile(
                            title: milestone.title ?? '',
                            showChevron: false,
                            trailing: selectedMilestoneId == milestone.id
                                ? const Icon(FIcons.check, size: 16)
                                : null,
                            onPress: () => setDialogState(
                              () => selectedMilestoneId = milestone.id,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                FButton(
                  variant: .outline,
                  onPress: () => Navigator.of(ctx).pop(),
                  child: Text(l10n.cancel),
                ),
                FButton(
                  onPress: () async {
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

  Future<void> _editDueDate(BuildContext context, Issue issue) async {
    final date = await showDatePicker(
      context: context,
      initialDate: issue.due_date ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (!context.mounted) return;

    if (date != null) {
      final result = await Injection.editIssueDeadlineUseCase(
        owner,
        repo,
        index,
        {'due_date': date.toUtc().toIso8601String()},
      );
      switch (result) {
        case Right<Failure, void>():
          Injection.issueNotifier.reloadIssue(owner, repo, index);
        case Left<Failure, void>():
          break;
      }
    }
  }

  Future<void> _clearDueDate() async {
    final result = await Injection.editIssueUseCase(
      EditIssueParams(
        owner: owner,
        repo: repo,
        index: index,
        body: {'due_date': null},
      ),
    );
    if (result is Right<Failure, Issue>) {
      Injection.issueNotifier.reloadIssue(owner, repo, index);
    }
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
  List<Reaction> _commentReactions = [];

  @override
  void initState() {
    super.initState();
    _editController = TextEditingController(text: widget.comment.body ?? '');
    _refreshCommentReactions();
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  Future<void> _refreshCommentReactions() async {
    if (widget.comment.id == null) return;
    final result = await Injection.getCommentReactionsUseCase(
      widget.owner,
      widget.repo,
      widget.comment.id!,
    );
    if (result is Right<Failure, List<Reaction>>) {
      _commentReactions = result.value;
    }
    if (mounted) setState(() {});
  }

  // ignore: unused_element
  Future<void> _toggleCommentReaction(String content) async {
    if (widget.comment.id == null) return;
    final currentUser = Injection.authNotifier.state is AuthAuthenticated
        ? (Injection.authNotifier.state as AuthAuthenticated).user.login
        : null;
    final existing = _commentReactions
        .where((r) => r.content == content && r.user?.login == currentUser)
        .toList();

    _commentReactions = List.from(_commentReactions);
    if (existing.isNotEmpty) {
      _commentReactions.removeWhere(
        (r) => r.content == content && r.user?.login == currentUser,
      );
      if (mounted) setState(() {});
      await Injection.deleteCommentReactionUseCase(
        widget.owner,
        widget.repo,
        widget.comment.id!,
        content,
      );
    } else {
      _commentReactions.add(
        Reaction(
          content: content,
          user: User(login: currentUser),
        ),
      );
      if (mounted) setState(() {});
      await Injection.addCommentReactionUseCase(
        widget.owner,
        widget.repo,
        widget.comment.id!,
        content,
      );
    }
    await _refreshCommentReactions();
  }

  Future<void> _saveEdit() async {
    final l10n = AppLocalizations.of(context)!;
    final text = _editController.text.trim();
    if (text.isEmpty) return;

    setState(() => _saving = true);
    try {
      await Injection.editCommentUseCase(
        widget.owner,
        widget.repo,
        widget.comment.id ?? 0,
        {'body': text},
      );
      if (mounted) {
        setState(() {
          _editing = false;
          _saving = false;
        });
        Injection.issueNotifier.listComments(
          widget.owner,
          widget.repo,
          widget.index,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        showFToast(
          context: context,
          variant: .destructive,
          title: Text('${l10n.error}: $e'),
        );
      }
    }
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showFDialog<bool>(
      context: context,
      builder: (ctx, style, animation) => FDialog(
        title: Text(l10n.deleteComment),
        body: Text(l10n.deleteCommentConfirm),
        actions: [
          FButton(
            variant: .outline,
            onPress: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FButton(
            variant: .destructive,
            onPress: () => Navigator.pop(ctx, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await Injection.deleteCommentUseCase(
        widget.owner,
        widget.repo,
        widget.comment.id ?? 0,
      );
      if (mounted) {
        Injection.issueNotifier.listComments(
          widget.owner,
          widget.repo,
          widget.index,
        );
      }
    } catch (e) {
      if (mounted) {
        showFToast(
          context: context,
          variant: .destructive,
          title: Text('${l10n.error}: $e'),
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
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isMe)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: widget.comment.user != null
                  ? UserAvatar(user: widget.comment.user!, radius: 18)
                  : CircleAvatar(
                      radius: 18,
                      child: Icon(FIcons.user, size: 18),
                    ),
            ),
          if (!isMe) const SizedBox(width: 10),
          Flexible(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onLongPress: isMe && !_editing
                  ? () {
                      final renderBox = context.findRenderObject() as RenderBox;
                      final offset = renderBox.localToGlobal(Offset.zero);
                      showMenu<String>(
                        context: context,
                        position: RelativeRect.fromLTRB(
                          offset.dx,
                          offset.dy - 40,
                          offset.dx + renderBox.size.width,
                          offset.dy,
                        ),
                        items: [
                          PopupMenuItem(value: 'edit', child: Text(l10n.edit)),
                          PopupMenuItem(
                            value: 'delete',
                            child: Text(l10n.delete),
                          ),
                        ],
                      ).then((v) {
                        if (v == 'edit') setState(() => _editing = true);
                        if (v == 'delete') _delete();
                      });
                    }
                  : null,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: maxBubbleWidth),
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
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
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
                              FTextField(
                                control: FTextFieldControl.managed(
                                  controller: _editController,
                                ),
                                textInputAction: TextInputAction.done,
                                maxLines: 5,
                                minLines: 2,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FButton(
                                    variant: .ghost,
                                    size: .sm,
                                    onPress: () => setState(() {
                                      _editing = false;
                                      _editController.text =
                                          widget.comment.body ?? '';
                                    }),
                                    child: Text(l10n.cancel),
                                  ),
                                  const SizedBox(width: 4),
                                  FButton(
                                    size: .sm,
                                    onPress: _saving ? null : _saveEdit,
                                    child: _saving
                                        ? const FCircularProgress(size: .xs)
                                        : Text(l10n.save),
                                  ),
                                ],
                              ),
                            ],
                          )
                        else if (widget.comment.body != null &&
                            widget.comment.body!.isNotEmpty)
                          AppMarkdown(
                            data: widget.comment.body!,
                            selectable: true,
                            onTapLink: (text, href, title) {
                              if (href != null) {
                                launchUrl(
                                  Uri.parse(href),
                                  mode: LaunchMode.externalApplication,
                                );
                              }
                            },
                          ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(
                            widget.comment.created_at,
                            AppLocalizations.of(context)!,
                          ),
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
                        icon: Icon(
                          FIcons.ellipsis,
                          size: 14,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        onSelected: (v) {
                          if (v == 'edit') setState(() => _editing = true);
                          if (v == 'delete') _delete();
                        },
                        itemBuilder: (_) => [
                          PopupMenuItem(value: 'edit', child: Text(l10n.edit)),
                          PopupMenuItem(
                            value: 'delete',
                            child: Text(l10n.delete),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 8),
            if (widget.comment.user != null)
              UserAvatar(user: widget.comment.user!, radius: 16)
            else
              CircleAvatar(radius: 16, child: Icon(FIcons.user, size: 16)),
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

  const _TimelineSection({
    required this.owner,
    required this.repo,
    required this.index,
  });

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
    final result = await Injection.getIssueTimelineUseCase(
      widget.owner,
      widget.repo,
      widget.index,
    );
    if (mounted) {
      _timeline = result is Right<Failure, List<TimelineComment>>
          ? result.value.where((t) => t.type != 'comment').toList()
          : [];
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return FCard.raw(
      child: Column(
        children: [
          AppTile(
            leading: Icon(
              FIcons.listTree,
              size: 18,
              color: theme.colorScheme.primary,
            ),
            title: l10n.timeline,
            subtitle: '${_timeline.length} ${l10n.events}',
            showChevron: false,
            trailing: Icon(
              _expanded ? FIcons.chevronUp : FIcons.chevronDown,
              size: 16,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            onPress: () => setState(() => _expanded = !_expanded),
          ),
          if (_expanded) ...[
            const FDivider(),
            if (_loading)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: FCircularProgress(size: .sm)),
              )
            else if (_timeline.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  l10n.noData,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
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
        icon = FIcons.messageSquare;
        text = timeline.body ?? l10n.commented;
      case 'label':
        icon = FIcons.tag;
        text = timeline.label?.name ?? l10n.labelUpdated;
      case 'milestone':
        icon = FIcons.flag;
        text = timeline.milestone?.title ?? l10n.milestoneUpdated;
      case 'assignee':
        icon = FIcons.userRound;
        text = timeline.assignee?.login ?? l10n.assigneeUpdated;
      case 'close':
        icon = FIcons.circleCheck;
        text = l10n.closed;
      case 'reopen':
        icon = FIcons.refreshCw;
        text = l10n.reopened;
      case 'title':
        icon = FIcons.textCursorInput;
        text = '${timeline.old_title ?? ''} → ${timeline.new_title ?? ''}';
      default:
        icon = FIcons.info;
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
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (timeline.user?.login != null)
                  Text(
                    '${timeline.user!.login} · ${_formatTime(timeline.created_at, l10n)}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
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

  const _DependenciesSection({
    required this.owner,
    required this.repo,
    required this.index,
  });

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
    final result = await Injection.listIssueDependenciesUseCase(
      widget.owner,
      widget.repo,
      widget.index,
    );
    if (mounted) {
      _dependencies = result is Right<Failure, List<Issue>> ? result.value : [];
      setState(() => _loading = false);
    }
  }

  Future<void> _add() async {
    final l10n = AppLocalizations.of(context)!;
    final ctrl = TextEditingController();
    final number = await showFDialog<String>(
      context: context,
      builder: (ctx, style, animation) => StatefulBuilder(
        builder: (ctx, setDialogState) => FDialog(
          title: Text(l10n.addDependency),
          body: FTextField(
            control: FTextFieldControl.managed(
              controller: ctrl,
              onChange: (_) => setDialogState(() {}),
            ),
            label: Text(l10n.issueNumberHint),
            keyboardType: TextInputType.number,
          ),
          actions: [
            FButton(
              variant: .outline,
              onPress: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
            FButton(
              onPress: ctrl.text.trim().isEmpty
                  ? null
                  : () => Navigator.pop(ctx, ctrl.text.trim()),
              child: Text(l10n.add),
            ),
          ],
        ),
      ),
    );
    if (number != null && mounted) {
      final depIndex = int.tryParse(number);
      if (depIndex != null) {
        final result = await Injection.createIssueDependencyUseCase(
          widget.owner,
          widget.repo,
          widget.index,
          depIndex,
        );
        if (mounted) {
          if (result is Right<Failure, void>) {
            showFToast(context: context, title: Text(l10n.dependencyAdded));
            _load();
          } else {
            showFToast(
              context: context,
              variant: .destructive,
              title: Text(l10n.error),
            );
          }
        }
      }
    }
  }

  Future<void> _remove(Issue dep) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await showFDialog<bool>(
      context: context,
      builder: (ctx, style, animation) => FDialog(
        title: Text(l10n.removeDependency),
        body: Text(l10n.removeDependencyConfirm),
        actions: [
          FButton(
            variant: .outline,
            onPress: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FButton(
            variant: .destructive,
            onPress: () => Navigator.pop(ctx, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (ok == true && dep.number != null && mounted) {
      final result = await Injection.removeIssueDependencyUseCase(
        widget.owner,
        widget.repo,
        widget.index,
        dep.number!,
      );
      if (mounted) {
        if (result is Right<Failure, void>) {
          showFToast(context: context, title: Text(l10n.dependencyRemoved));
          _load();
        } else {
          showFToast(
            context: context,
            variant: .destructive,
            title: Text(l10n.error),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return FCard.raw(
      child: Column(
        children: [
          AppTile(
            leading: Icon(
              FIcons.link2,
              size: 18,
              color: theme.colorScheme.primary,
            ),
            title: l10n.dependencies,
            subtitle: '${_dependencies.length} ${l10n.items}',
            showChevron: false,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FTappable(
                  onPress: _add,
                  semanticsLabel: l10n.addDependency,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      FIcons.plus,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  _expanded ? FIcons.chevronUp : FIcons.chevronDown,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
            onPress: () => setState(() => _expanded = !_expanded),
          ),
          if (_expanded) ...[
            const FDivider(),
            if (_loading)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: FCircularProgress(size: .sm)),
              )
            else if (_dependencies.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  l10n.noDependencies,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 12),
                child: Column(
                  children: _dependencies.map((dep) {
                    return AppTile(
                      leading: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: dep.state?.value == 'open'
                              ? Colors.green
                              : Colors.purple,
                          shape: BoxShape.circle,
                        ),
                      ),
                      title: '#${dep.number} ${dep.title ?? ''}',
                      showChevron: false,
                      onPress: dep.number != null
                          ? () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => IssueDetailPage(
                                  owner: dep.repository?.owner ?? widget.owner,
                                  repo: dep.repository?.name ?? widget.repo,
                                  index: dep.number!,
                                ),
                              ),
                            )
                          : null,
                      trailing: FTappable(
                        onPress: () => _remove(dep),
                        semanticsLabel: l10n.removeDependency,
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            FIcons.unlink,
                            size: 18,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _EmbeddedIssueHeader extends StatelessWidget {
  const _EmbeddedIssueHeader({
    required this.owner,
    required this.repo,
    required this.index,
    required this.onRefresh,
    required this.onOpenBrowser,
    required this.onEdit,
  });

  final String owner;
  final String repo;
  final int index;
  final VoidCallback onRefresh;
  final VoidCallback onOpenBrowser;
  final ValueChanged<Issue> onEdit;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: Injection.issueNotifier,
      builder: (context, _) {
        final state = Injection.issueNotifier.state;
        final issue = state is IssueDetailLoaded && state.issue.number == index
            ? state.issue
            : null;
        final isOpen = issue?.state?.isOpen ?? true;

        return Container(
          height: 46,
          padding: const EdgeInsets.only(left: 16, right: 8),
          decoration: BoxDecoration(
            color: palette.canvas,
            border: Border(bottom: BorderSide(color: palette.border)),
          ),
          child: Row(
            children: [
              Icon(
                isOpen ? FIcons.circleDot : FIcons.circleCheck,
                size: 14,
                color: isOpen ? palette.success : palette.purple,
              ),
              const SizedBox(width: 7),
              Flexible(
                child: Text(
                  '$owner/$repo',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: palette.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '#$index',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: palette.textPrimary,
                ),
              ),
              const Spacer(),
              AppIconButton(
                icon: FIcons.refreshCw,
                label: l10n.refresh,
                size: 30,
                iconSize: 15,
                onPress: onRefresh,
              ),
              if (issue?.html_url != null)
                AppIconButton(
                  icon: FIcons.externalLink,
                  label: l10n.openInBrowser,
                  size: 30,
                  iconSize: 15,
                  onPress: onOpenBrowser,
                ),
              if (issue != null)
                AppIconButton(
                  icon: FIcons.pencil,
                  label: l10n.edit,
                  size: 30,
                  iconSize: 15,
                  onPress: () => onEdit(issue),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// The metadata rail shown beside an issue in the desktop list-detail layout.
class IssueDetailMetaRail extends StatelessWidget {
  const IssueDetailMetaRail({
    super.key,
    required this.owner,
    required this.repo,
    required this.index,
  });

  final String owner;
  final String repo;
  final int index;

  String? _issueUrl(Issue? issue) {
    if (issue?.html_url != null) return issue!.html_url;
    final auth = Injection.authNotifier.state;
    if (auth is AuthAuthenticated) {
      return '${auth.baseUrl}/$owner/$repo/issues/$index';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: Injection.issueNotifier,
      builder: (context, _) {
        final state = Injection.issueNotifier.state;
        final loaded = state is IssueDetailLoaded ? state.issue : null;
        final repoMeta = loaded?.repository;
        final sameRepo =
            repoMeta == null ||
            ((repoMeta.name == null || repoMeta.name == repo) &&
                (repoMeta.owner == null || repoMeta.owner == owner));
        final issue = loaded != null && loaded.number == index && sameRepo
            ? loaded
            : null;
        final url = _issueUrl(issue);

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
          children: [
            Text(
              l10n.details.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: palette.textSecondary.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 8),
            if (issue == null)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 28),
                child: Center(child: FCircularProgress(size: .sm)),
              )
            else
              AppSurface(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _MetaField(
                      label: l10n.status,
                      child: Row(
                        children: [
                          Icon(
                            issue.state?.isOpen == true
                                ? FIcons.circleDot
                                : FIcons.circleCheck,
                            size: 13,
                            color: issue.state?.isOpen == true
                                ? palette.success
                                : palette.purple,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            issue.state?.isOpen == true
                                ? l10n.open
                                : l10n.closed,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: issue.state?.isOpen == true
                                  ? palette.success
                                  : palette.purple,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (issue.user != null)
                      _MetaField(
                        label: l10n.author,
                        child: Row(
                          children: [
                            UserAvatar(user: issue.user!, radius: 10),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                issue.user!.login ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (issue.assignees != null && issue.assignees!.isNotEmpty)
                      _MetaField(
                        label: l10n.assignees,
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            for (final assignee in issue.assignees!)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  UserAvatar(user: assignee, radius: 9),
                                  const SizedBox(width: 4),
                                  Text(
                                    assignee.login ?? '',
                                    style: const TextStyle(fontSize: 11.5),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    if (issue.labels != null && issue.labels!.isNotEmpty)
                      _MetaField(
                        label: l10n.labels,
                        child: Wrap(
                          spacing: 5,
                          runSpacing: 5,
                          children: [
                            for (final label in issue.labels!)
                              LabelBadge(dense: true, label: label),
                          ],
                        ),
                      ),
                    if (issue.milestone?.title != null)
                      _MetaField(
                        label: l10n.milestone,
                        child: Row(
                          children: [
                            Icon(
                              FIcons.flag,
                              size: 12,
                              color: palette.textSecondary,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                issue.milestone!.title!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if ((issue.comments ?? 0) > 0)
                      _MetaField(
                        label: l10n.comments,
                        child: Text(
                          '${issue.comments}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    if (issue.created_at != null)
                      _MetaField(
                        label: l10n.createdAt,
                        child: Text(
                          MaterialLocalizations.of(
                            context,
                          ).formatShortDate(issue.created_at!),
                          style: TextStyle(
                            fontSize: 12,
                            color: palette.textSecondary,
                          ),
                        ),
                      ),
                    if (issue.updated_at != null)
                      _MetaField(
                        label: l10n.updatedAt,
                        child: Text(
                          MaterialLocalizations.of(
                            context,
                          ).formatShortDate(issue.updated_at!),
                          style: TextStyle(
                            fontSize: 12,
                            color: palette.textSecondary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            const SizedBox(height: 18),
            Text(
              l10n.quickActions.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: palette.textSecondary.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 8),
            AppSurface(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  if (url != null)
                    _MetaAction(
                      icon: FIcons.copy,
                      label: l10n.copyLink,
                      onPress: () async {
                        await Clipboard.setData(ClipboardData(text: url));
                        if (context.mounted) {
                          showFToast(
                            context: context,
                            title: Text(l10n.copied),
                          );
                        }
                      },
                    ),
                  if (url != null)
                    _MetaAction(
                      icon: FIcons.externalLink,
                      label: l10n.openInBrowser,
                      onPress: () => launchUrl(
                        Uri.parse(url),
                        mode: LaunchMode.externalApplication,
                      ),
                    ),
                  if (issue != null)
                    _MetaAction(
                      icon: FIcons.pencil,
                      label: l10n.edit,
                      onPress: () => Navigator.of(context)
                          .push(
                            MaterialPageRoute(
                              builder: (_) => EditIssuePage(
                                owner: owner,
                                repo: repo,
                                index: index,
                                issue: issue,
                              ),
                            ),
                          )
                          .then((_) {
                            if (context.mounted) {
                              Injection.issueNotifier.getIssue(
                                owner,
                                repo,
                                index,
                              );
                            }
                          }),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MetaField extends StatelessWidget {
  const _MetaField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: context.palette.textSecondary.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 4),
          child,
        ],
      ),
    );
  }
}

class _MetaAction extends StatelessWidget {
  const _MetaAction({
    required this.icon,
    required this.label,
    required this.onPress,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return AppHoverRegion(
      onTap: onPress,
      semanticsLabel: label,
      hoverColor: palette.surfaceMuted,
      borderRadius: BorderRadius.circular(7),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 14, color: palette.textSecondary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(fontSize: 12, color: palette.textPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
