import 'package:flutter/material.dart';

import '../../../core/constants/ui_constants.dart';

/// 首页图标行：彩色图标块 + 主/副文案 + chevron。
///
/// 纯展示组件，不依赖 DI / Injection / l10n。
class HomeIconTile extends StatelessWidget {
  final Color iconBg;
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const HomeIconTile({
    super.key,
    required this.iconBg,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: UIConstants.md,
          vertical: 10,
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, color: Colors.white, size: UIConstants.iconSm),
            ),
            const SizedBox(width: UIConstants.iconTextSpacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.bodyLarge),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: UIConstants.iconSm,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
