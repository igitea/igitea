import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../theme/app_palette.dart';

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
    'auto_merge_pull_request' => l10n.activityMergedPr,
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
    'auto_merge_pull_request' => FIcons.gitMerge,
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
  return ref.replaceFirst('refs/heads/', '').replaceFirst('refs/tags/', '');
}

/// One row in an activity feed: op-type icon + action text + repo + time.
class ActivityTile extends StatefulWidget {
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
  State<ActivityTile> createState() => _ActivityTileState();
}

class _ActivityTileState extends State<ActivityTile> {
  bool _hovered = false;

  Color _color(AppPalette palette) {
    return switch (widget.activity.op_type) {
      'create_issue' || 'approve_pull_request' => palette.success,
      'create_pull_request' ||
      'merge_pull_request' ||
      'rebase_merge_pull_request' ||
      'squash_merge_pull_request' ||
      'auto_merge_pull_request' => palette.purple,
      'comment_issue' || 'comment_pull' => palette.info,
      'publish_release' || 'star_repo' => palette.warning,
      'reject_pull_request' => palette.danger,
      'create_branch' || 'delete_branch' || 'create_repo' => palette.brand,
      _ => palette.textSecondary,
    };
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = AppLocalizations.of(context)!;
    final repoName = widget.activity.repo?.full_name ?? '';
    final ref = shortRefName(widget.activity.ref_name);
    final action = describeActivity(widget.activity, l10n);
    final color = _color(palette);

    return FTappable(
      onPress: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          color: _hovered
              ? palette.surfaceMuted.withValues(alpha: 0.55)
              : Colors.transparent,
          padding: const EdgeInsets.fromLTRB(14, 9, 12, 9),
          child: Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: palette.isDark ? 0.16 : 0.09),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  activityIcon(widget.activity),
                  size: 13,
                  color: color,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      ref.isNotEmpty ? '$action · $ref' : action,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: palette.textPrimary,
                      ),
                    ),
                    if (repoName.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 1),
                        child: Text(
                          repoName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color: palette.textSecondary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                widget.timeText,
                style: TextStyle(
                  fontSize: 10.5,
                  color: palette.textSecondary.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
