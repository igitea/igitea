import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../theme/app_palette.dart';
import '../app_surface.dart';
import '../desktop/app_hover_region.dart';

/// A titled group of rows rendered as one surface card.
///
/// Every list surface in the app shares the same radius, hairline border and
/// inset dividers, so sections feel like parts of one system rather than a
/// collection of cards.
class AppSection extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final List<Widget> children;
  final bool showHeader;

  /// Optional padding applied inside the card; rows normally bring their own.
  final EdgeInsetsGeometry? padding;

  const AppSection({
    super.key,
    required this.title,
    required this.children,
    this.showHeader = true,
    this.trailing,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    final palette = context.palette;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showHeader && title.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 0, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.4,
                      color: palette.textSecondary,
                    ),
                  ),
                ),
                ?trailing,
              ],
            ),
          ),
        ],
        AppSurface(
          padding: padding,
          child: Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0) _SectionDivider(color: palette.border),
                children[i],
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 14),
      color: color,
    );
  }
}

/// A quiet text link for a section header, such as "View all".
class AppSectionAction extends StatelessWidget {
  const AppSectionAction({
    super.key,
    required this.label,
    required this.onPress,
  });

  final String label;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return AppHoverRegion(
      onTap: onPress,
      semanticsLabel: label,
      hoverColor: palette.brandSoft,
      borderRadius: BorderRadius.circular(6),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      contentBuilder: (context, hovered, focused) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: palette.brand,
            ),
          ),
          const SizedBox(width: 2),
          Icon(FIcons.chevronRight, size: 13, color: palette.brand),
        ],
      ),
    );
  }
}
