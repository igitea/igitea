import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../theme/app_palette.dart';

/// A single tappable row inside an [AppSection].
///
/// Uses [FTappable] so press/focus feedback matches Forui widgets, and adds a
/// restrained hover wash for desktop.
class AppTile extends StatefulWidget {
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
  State<AppTile> createState() => _AppTileState();
}

class _AppTileState extends State<AppTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final interactive = widget.onPress != null;

    final row = Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 12, 10),
      child: Row(
        children: [
          if (widget.leading != null) ...[
            widget.leading!,
            const SizedBox(width: 11),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: widget.destructive
                        ? palette.danger
                        : palette.textPrimary,
                  ),
                ),
                if (widget.subtitle != null && widget.subtitle!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Text(
                      widget.subtitle!,
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
          if (widget.trailing != null) ...[
            const SizedBox(width: 8),
            widget.trailing!,
          ] else if (widget.showChevron) ...[
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

    return FTappable(
      onPress: widget.onPress,
      semanticsLabel: widget.semanticsLabel,
      child: MouseRegion(
        onEnter: interactive ? (_) => setState(() => _hovered = true) : null,
        onExit: interactive ? (_) => setState(() => _hovered = false) : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOutCubic,
          color: _hovered
              ? palette.surfaceMuted.withValues(alpha: 0.55)
              : Colors.transparent,
          child: row,
        ),
      ),
    );
  }
}
