import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../core/animations/animated_wrapper.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../domain/usecases/issue_usecases.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/empty_state.dart';
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
      await Injection.issueNotifier.listMilestones(
        widget.owner,
        widget.repo,
      );
      if (mounted) {
        setState(() {
          _milestone = widget.milestone;
        });
      }
    }
  }

  Future<void> _deleteMilestone() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteMilestone),
        content: Text(l10n.deleteMilestoneConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${l10n.error}: ${value.message}')),
          );
        case Right():
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.milestoneDeleted)),
          );
          Navigator.of(context).pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final total = (_milestone.open_issues ?? 0) + (_milestone.closed_issues ?? 0);
    final progress = total > 0 ? (_milestone.closed_issues ?? 0) / total : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(_milestone.title ?? l10n.untitled),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editMilestone,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _deleteMilestone,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadIssues,
        child: ListView(
          padding: const EdgeInsets.all(UIConstants.md),
          children: [
            PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(UIConstants.sm),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.flag,
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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _milestone.state?.value == 'open'
                              ? Colors.green.withValues(alpha: 0.2)
                              : Colors.purple.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(UIConstants.badgeRadius),
                        ),
                        child: Text(
                          _milestone.state?.value == 'open' ? l10n.open : l10n.closed,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: _milestone.state?.value == 'open' ? Colors.green : Colors.purple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_milestone.description != null && _milestone.description!.isNotEmpty) ...[
                    const SizedBox(height: UIConstants.md),
                    MarkdownBody(
                      data: _milestone.description!,
                      shrinkWrap: true,
                    ),
                  ],
                  const SizedBox(height: UIConstants.md),
                  Row(
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
                          label: 'Total',
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: UIConstants.sm),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(UIConstants.badgeRadius),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        progress >= 1.0 ? Colors.green : theme.colorScheme.primary,
                      ),
                    ),
                  ),
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
            const SizedBox(height: UIConstants.md),
            Text(
              l10n.issues,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: UIConstants.sm),
            if (_issuesLoading)
              const Center(child: CircularProgressIndicator())
            else if (_issues.isEmpty)
              EmptyState(
                icon: Icons.bug_report_outlined,
                title: l10n.noIssues,
              )
            else
              ..._issues.asMap().entries.map((entry) => FadeInWrapper(
                delay: Duration(milliseconds: entry.key * 30),
                child: _IssueItem(
                  issue: entry.value,
                  owner: widget.owner,
                  repo: widget.repo,
                  l10n: l10n,
                ),
              )),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month]} ${date.day}, ${date.year}';
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
    final isOpen = issue.state?.value == 'open';
    final stateIcon = isOpen ? Icons.error_outline : Icons.check_circle;
    final stateColor = isOpen ? Colors.green : Colors.purple;

    return PremiumListCard(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => IssueDetailPage(
          owner: owner,
          repo: repo,
          index: issue.number ?? 0,
        ),
      )),
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
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: UIConstants.xs),
                Row(
                  children: [
                    Icon(stateIcon, size: UIConstants.iconSm, color: stateColor),
                    const SizedBox(width: UIConstants.xs),
                    Text(
                      isOpen ? l10n.open : l10n.closed,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: stateColor,
                      ),
                    ),
                    const SizedBox(width: UIConstants.md),
                    Text(
                      '#${issue.number ?? 0}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
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
