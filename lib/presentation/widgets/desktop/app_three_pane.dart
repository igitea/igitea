import 'package:flutter/material.dart';

import '../../../core/platform/desktop_layout.dart';
import '../../theme/app_palette.dart';

/// A horizontal desktop workspace with an optional leading rail, a flexible
/// centre pane and an optional trailing context pane.
///
/// Panes are separated by hairline dividers and scroll independently; the
/// widget never changes its children's state when the window is resized.
class AppThreePane extends StatelessWidget {
  const AppThreePane({
    super.key,
    required this.leading,
    required this.center,
    this.trailing,
    this.leadingWidth = DesktopLayout.navRailWidth,
    this.trailingWidth = DesktopLayout.contextPaneWidth,
    this.leadingBackground,
    this.trailingBackground,
    this.centerBackground,
    this.showLeadingDivider = true,
    this.showTrailingDivider = true,
  });

  final Widget leading;
  final Widget center;
  final Widget? trailing;
  final double leadingWidth;
  final double trailingWidth;
  final Color? leadingBackground;
  final Color? trailingBackground;
  final Color? centerBackground;
  final bool showLeadingDivider;
  final bool showTrailingDivider;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final divider = Container(width: 1, color: palette.border);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: leadingWidth,
          child: ColoredBox(
            color: leadingBackground ?? palette.canvas,
            child: leading,
          ),
        ),
        if (showLeadingDivider) divider,
        Expanded(
          child: ColoredBox(
            color: centerBackground ?? palette.canvas,
            child: center,
          ),
        ),
        if (trailing != null) ...[
          if (showTrailingDivider) divider,
          SizedBox(
            width: trailingWidth,
            child: ColoredBox(
              color: trailingBackground ?? palette.canvas,
              child: trailing!,
            ),
          ),
        ],
      ],
    );
  }
}

/// A vertical divider used inside desktop panes.
class AppVDivider extends StatelessWidget {
  const AppVDivider({super.key, this.height});

  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: height, color: context.palette.border);
  }
}
