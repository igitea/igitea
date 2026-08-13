import 'package:flutter/material.dart';

import '../../../data/models/generated/generated_models.dart';
import '../../../core/constants/ui_constants.dart';

/// 首页最近动态行：绿点 + 仓库/编号 + 标题（未读蓝点）+ 时间/状态。
///
/// 纯展示组件，不依赖 DI / Injection / l10n。
class HomeRecentTile extends StatelessWidget {
  final NotificationThread thread;
  final String timeText;
  final String statusText;
  final VoidCallback onTap;

  const HomeRecentTile({
    super.key,
    required this.thread,
    required this.timeText,
    required this.statusText,
    required this.onTap,
  });

  /// 从 subject.url 提取末尾数字段作为 Issue/PR 编号。
  String get _issueNumber {
    final match = RegExp(r'(\d+)$').firstMatch(thread.subject?.url ?? '');
    return match?.group(1) ?? '';
  }

  String _headerText(String repoName) {
    final number = _issueNumber;
    if (repoName.isEmpty) return number.isEmpty ? '' : '#$number';
    return number.isEmpty ? repoName : '$repoName #$number';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final repoName = thread.repository?.full_name ?? '';

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
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFF2EA043),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: UIConstants.iconTextSpacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _headerText(repoName),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      if (thread.unread == true) ...[
                        const SizedBox(width: UIConstants.xs),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    thread.subject?.title ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: UIConstants.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  timeText,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.7,
                    ),
                  ),
                ),
                Text(
                  statusText,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
