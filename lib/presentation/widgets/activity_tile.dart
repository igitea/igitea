import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

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
    'create_repo' => FIcons.circlePlus,
    'push' || 'commit_repo' => FIcons.gitCommitHorizontal,
    'create_issue' => FIcons.circleDot,
    'create_pull_request' => FIcons.gitPullRequest,
    'merge_pull_request' ||
    'rebase_merge_pull_request' ||
    'squash_merge_pull_request' ||
    'auto_merge_pull_request' =>
      FIcons.gitMerge,
    'comment_issue' || 'comment_pull' => FIcons.messageSquare,
    'publish_release' => FIcons.rocket,
    'create_branch' => FIcons.gitBranchPlus,
    'delete_branch' => FIcons.gitBranchMinus,
    'star_repo' => FIcons.star,
    'fork_repo' => FIcons.gitFork,
    'approve_pull_request' => FIcons.circleCheck,
    'reject_pull_request' => FIcons.circleX,
    _ => FIcons.zap,
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

    return FTappable(
      onPress: onTap,
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
