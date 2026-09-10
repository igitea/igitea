import 'package:flutter/material.dart';

import '../../core/constants/ui_constants.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';

/// Map an Activity op_type to a human-readable action text.
String describeActivity(Activity activity, AppLocalizations l10n) {
  return switch (activity.op_type) {
    'create_repo' => l10n.activityCreatedRepo,
    'push' || 'commit_repo' => l10n.activityPushed,
    'create_issue' => l10n.activityOpenedIssue,
    'create_pull_request' => l10n.activityOpenedPr,
    'merge_pull_request' ||
    'rebase_merge_pull_request' ||
    'squash_merge_pull_request' ||
    'auto_merge_pull_request' =>
      l10n.activityMergedPr,
    'comment_issue' => l10n.activityCommentedIssue,
    'comment_pull' => l10n.activityCommentedPr,
    'publish_release' => l10n.activityPublishedRelease,
    'create_branch' => l10n.activityCreatedBranch,
    'delete_branch' => l10n.activityDeletedBranch,
    'star_repo' => l10n.activityStarred,
    'fork_repo' => l10n.activityForked,
    'approve_pull_request' => l10n.activityApprovedPr,
    'reject_pull_request' => l10n.activityRequestedChanges,
    _ => (activity.op_type ?? '').replaceAll('_', ' '),
  };
}

IconData activityIcon(Activity activity) {
  return switch (activity.op_type) {
    'create_repo' => Icons.add_circle_outline,
    'push' || 'commit_repo' => Icons.commit,
    'create_issue' => Icons.bug_report_outlined,
    'create_pull_request' => Icons.merge_type,
    'merge_pull_request' ||
    'rebase_merge_pull_request' ||
    'squash_merge_pull_request' ||
    'auto_merge_pull_request' =>
      Icons.call_merge,
    'comment_issue' || 'comment_pull' => Icons.comment_outlined,
    'publish_release' => Icons.rocket_launch_outlined,
    'create_branch' => Icons.account_tree_outlined,
    'delete_branch' => Icons.delete_outline,
    'star_repo' => Icons.star_outline,
    'fork_repo' => Icons.call_split,
    'approve_pull_request' => Icons.check_circle_outline,
    'reject_pull_request' => Icons.cancel_outlined,
    _ => Icons.bolt_outlined,
  };
}

/// Strip the refs/heads/ or refs/tags/ prefix from a ref name.
String shortRefName(String? ref) {
  if (ref == null || ref.isEmpty) return '';
  return ref
      .replaceFirst('refs/heads/', '')
      .replaceFirst('refs/tags/', '');
}

/// One row in an activity feed: op-type icon + action text + repo + time.
class ActivityTile extends StatelessWidget {
  final Activity activity;
  final String timeText;
  final VoidCallback? onTap;

  const ActivityTile({
    super.key,
    required this.activity,
    required this.timeText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final repoName = activity.repo?.full_name ?? '';
    final ref = shortRefName(activity.ref_name);
    final action = describeActivity(activity, l10n);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: UIConstants.md,
          vertical: 10,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              activityIcon(activity),
              size: UIConstants.iconMd,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: UIConstants.iconTextSpacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ref.isNotEmpty ? '$action · $ref' : action,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (repoName.isNotEmpty)
                    Text(
                      repoName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: UIConstants.sm),
            Text(
              timeText,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
