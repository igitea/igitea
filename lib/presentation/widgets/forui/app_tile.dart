import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../theme/app_palette.dart';
import '../desktop/app_hover_region.dart';

/// A single tappable row inside an [AppSection].
///
/// Uses [FTappable] so press/focus feedback matches Forui widgets, and adds a
/// restrained hover wash for desktop.
class AppTile extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onPress;
  final bool showChevron;
  final String? semanticsLabel;

  /// Renders the title in the destructive color (e.g. sign out).
  final bool destructive;

  const AppTile({
    super.key,
    required this.title,
    this.leading,
    this.subtitle,
    this.trailing,
    this.onPress,
    this.showChevron = true,
    this.semanticsLabel,
    this.destructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final interactive = onPress != null;

    final row = Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 12, 10),
      child: Row(
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 11)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: destructive ? palette.danger : palette.textPrimary,
                  ),
                ),
                if (subtitle != null && subtitle!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: palette.textSecondary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 8),
            trailing!,
          ] else if (showChevron) ...[
            const SizedBox(width: 8),
            Icon(
              FIcons.chevronRight,
              size: 14,
              color: palette.textSecondary.withValues(alpha: 0.7),
            ),
          ],
        ],
      ),
    );

    if (!interactive) return row;

    return AppHoverRegion(
      onTap: onPress,
      semanticsLabel: semanticsLabel ?? title,
      hoverColor: palette.surfaceMuted.withValues(alpha: 0.55),
      borderRadius: BorderRadius.circular(8),
      child: row,
    );
  }
}
