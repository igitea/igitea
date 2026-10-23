import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:forui/forui.dart';

import '../../core/animations/animated_wrapper.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../domain/usecases/issue_usecases.dart';
import '../../domain/entities/issue_state.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/forui/app_page.dart';
import '../widgets/forui/app_state_views.dart';
import '../widgets/premium_card.dart';
import '../widgets/user_avatar.dart';
import 'edit_milestone_page.dart';
import 'issue_detail_page.dart';

class MilestoneDetailPage extends StatefulWidget {
  final String owner;
  final String repo;
  final Milestone milestone;

  const MilestoneDetailPage({
    super.key,
    required this.owner,
    required this.repo,
    required this.milestone,
  });

  @override
  State<MilestoneDetailPage> createState() => _MilestoneDetailPageState();
}

class _MilestoneDetailPageState extends State<MilestoneDetailPage> {
  late Milestone _milestone;
  List<Issue> _issues = [];
  bool _issuesLoading = false;

  @override
  void initState() {
    super.initState();
    _milestone = widget.milestone;
    _loadIssues();
  }

  Future<void> _loadIssues() async {
    setState(() => _issuesLoading = true);
    final result = await Injection.listIssuesUseCase(
      ListIssuesParams(
        owner: widget.owner,
        repo: widget.repo,
        milestones: _milestone.id?.toString(),
      ),
    );
    if (mounted) {
      setState(() => _issuesLoading = false);
      switch (result) {
        case Right<Failure, List<Issue>>(:final value):
          setState(() => _issues = value);
        case Left<Failure, List<Issue>>():
          break;
      }
    }
  }

  Future<void> _editMilestone() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditMilestonePage(
          owner: widget.owner,
          repo: widget.repo,
          milestone: _milestone,
        ),
      ),
    );
    if (result == true) {
      await Injection.issueNotifier.listMilestones(widget.owner, widget.repo);
      if (mounted) {
        setState(() {
          _milestone = widget.milestone;
        });
      }
    }
  }

  Future<void> _deleteMilestone() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showFDialog<bool>(
      context: context,
      builder: (ctx, style, animation) => FDialog(
        title: Text(l10n.deleteMilestone),
        body: Text(l10n.deleteMilestoneConfirm),
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

    final result = await Injection.issueNotifier.deleteMilestone(
      widget.owner,
      widget.repo,
      _milestone.id ?? 0,
    );

    if (mounted) {
      switch (result) {
        case Left(:final value):
          showFToast(
            context: context,
            variant: .destructive,
            title: Text('${l10n.error}: ${value.message}'),
          );
        case Right():
          showFToast(context: context, title: Text(l10n.milestoneDeleted));
          Navigator.of(context).pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppPage(
      title: _milestone.title ?? l10n.untitled,
      actions: [
        FHeaderAction(
          icon: const Icon(FIcons.pencil),
          semanticsLabel: l10n.edit,
          onPress: _editMilestone,
        ),
        FHeaderAction(
          icon: const Icon(FIcons.trash2),
          semanticsLabel: l10n.delete,
          onPress: _deleteMilestone,
        ),
      ],
      child: RefreshIndicator(
        onRefresh: _loadIssues,
        child: ListView.builder(
          padding: const EdgeInsets.all(UIConstants.md),
          itemCount: 1 + _issues.length,
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildMilestoneInfo(l10n);
            }
            return _buildIssueItem(_issues[index - 1], index - 1, l10n);
          },
        ),
      ),
    );
  }

  Widget _buildMilestoneInfo(AppLocalizations l10n) {
    final theme = Theme.of(context);
    final total =
        (_milestone.open_issues ?? 0) + (_milestone.closed_issues ?? 0);
    final progress = total > 0 ? (_milestone.closed_issues ?? 0) / total : 0.0;
    final isOpen = _milestone.state?.isOpen == true;

    return Column(
      children: [
        FadeInWrapper(
          child: PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(UIConstants.sm),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer.withValues(
                          alpha: 0.5,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        FIcons.flag,
                        size: UIConstants.iconLg,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: UIConstants.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _milestone.title ?? l10n.untitled,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (_milestone.due_on != null)
                            Text(
                              '${l10n.dueDate}: ${_formatDate(_milestone.due_on!)}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                        ],
                      ),
                    ),
                    _buildStateBadge(isOpen, l10n),
                  ],
                ),
                if (_milestone.description != null &&
                    _milestone.description!.isNotEmpty) ...[
                  const SizedBox(height: UIConstants.md),
                  MarkdownBody(data: _milestone.description!, shrinkWrap: true),
                ],
                const SizedBox(height: UIConstants.md),
                _buildStatRow(l10n, total, progress),
                const SizedBox(height: UIConstants.sm),
                _buildProgressBar(theme, progress),
                const SizedBox(height: UIConstants.xs),
                Text(
                  '${(progress * 100).toStringAsFixed(0)}% ${l10n.complete}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: UIConstants.md),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            l10n.issues,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: UIConstants.sm),
        if (_issuesLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(child: FCircularProgress(size: .sm)),
          )
        else if (_issues.isEmpty)
          AppEmpty(icon: FIcons.bug, title: l10n.noIssues)
        else
          const SizedBox.shrink(),
      ],
    );
  }

  Widget _buildStateBadge(bool isOpen, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final color = isOpen ? Colors.green : Colors.purple;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(UIConstants.badgeRadius),
      ),
      child: Text(
        isOpen ? l10n.open : l10n.closed,
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatRow(AppLocalizations l10n, int total, double progress) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: _StatItem(
            value: '${_milestone.open_issues ?? 0}',
            label: l10n.open,
            color: Colors.green,
          ),
        ),
        Expanded(
          child: _StatItem(
            value: '${_milestone.closed_issues ?? 0}',
            label: l10n.closed,
            color: Colors.purple,
          ),
        ),
        Expanded(
          child: _StatItem(
            value: '$total',
            label: l10n.total,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(ThemeData theme, double progress) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(UIConstants.badgeRadius),
      child: LinearProgressIndicator(
        value: progress,
        minHeight: 8,
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        valueColor: AlwaysStoppedAnimation<Color>(
          progress >= 1.0 ? Colors.green : theme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildIssueItem(Issue issue, int index, AppLocalizations l10n) {
    return FadeInWrapper(
      delay: Duration(milliseconds: index * 30),
      child: _IssueItem(
        issue: issue,
        owner: widget.owner,
        repo: widget.repo,
        l10n: l10n,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _IssueItem extends StatelessWidget {
  final Issue issue;
  final String owner;
  final String repo;
  final AppLocalizations l10n;

  const _IssueItem({
    required this.issue,
    required this.owner,
    required this.repo,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOpen = issue.state?.isOpen == true;
    final stateIcon = isOpen ? FIcons.circleAlert : FIcons.circleCheck;
    final stateColor = isOpen ? Colors.green : Colors.purple;

    return PremiumListCard(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => IssueDetailPage(
            owner: owner,
            repo: repo,
            index: issue.number ?? 0,
          ),
        ),
      ),
      child: Row(
        children: [
          issue.user != null
              ? UserAvatar(user: issue.user!, radius: UIConstants.avatarMd)
              : Icon(stateIcon, color: stateColor, size: UIConstants.iconLg),
          const SizedBox(width: UIConstants.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  issue.title ?? l10n.untitled,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: UIConstants.xs),
                Row(
                  children: [
                    Icon(
                      stateIcon,
                      size: UIConstants.iconSm,
                      color: stateColor,
                    ),
                    const SizedBox(width: UIConstants.xs),
                    Text(
                      isOpen ? l10n.open : l10n.closed,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: stateColor,
                      ),
                    ),
                    const SizedBox(width: UIConstants.md),
                    Text(
                      '#${issue.number ?? 0}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
