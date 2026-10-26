import 'package:flutter/material.dart';

import '../theme/app_palette.dart';
import 'desktop/app_hover_region.dart';

/// A flat, hairline-bordered surface used for cards, grouped rows and panels.
///
/// Hover lifts the border by a hair and never moves layout, which keeps dense
/// desktop lists calm. When [onPress] is provided the surface also gets a hand
/// cursor, a focus ring and Enter/Space activation through [AppHoverRegion].
class AppSurface extends StatelessWidget {
  const AppSurface({
    super.key,
    required this.child,
    this.onPress,
    this.onDoubleTap,
    this.onSecondaryTap,
    this.onLongPress,
    this.contextMenuItems = const [],
    this.selected = false,
    this.selectedColor,
    this.padding,
    this.margin,
    this.radius = 14,
    this.elevated = true,
    this.background,
    this.borderColor,
    this.semanticLabel,
  });

  final Widget child;
  final VoidCallback? onPress;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onSecondaryTap;
  final VoidCallback? onLongPress;
  final List<AppMenuItem> contextMenuItems;
  final bool selected;
  final Color? selectedColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double radius;
  final bool elevated;
  final Color? background;
  final Color? borderColor;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final interactive = onPress != null;
    final borderRadius = BorderRadius.circular(radius);

    final body = DecoratedBox(
      decoration: BoxDecoration(
        color: selected
            ? (selectedColor ?? palette.brandSoft)
            : (background ?? palette.surface),
        borderRadius: borderRadius,
        border: interactive
            ? null
            : Border.all(color: borderColor ?? palette.border),
        boxShadow: elevated ? palette.cardShadow : null,
      ),
      child: ClipRRect(borderRadius: borderRadius, child: _padded()),
    );

    Widget surface;
    if (interactive) {
      surface = AppHoverRegion(
        onTap: onPress,
        onDoubleTap: onDoubleTap,
        onSecondaryTap: onSecondaryTap,
        onLongPress: onLongPress,
        contextMenuItems: contextMenuItems,
        selected: selected,
        selectedColor: Colors.transparent,
        semanticsLabel: semanticLabel,
        hoverColor: Colors.transparent,
        borderColor: selected
            ? palette.brand.withValues(alpha: 0.42)
            : (borderColor ?? palette.border),
        hoverBorderColor: selected
            ? palette.brand.withValues(alpha: 0.6)
            : (borderColor ?? palette.borderStrong),
        borderRadius: borderRadius,
        focusRingRadius: borderRadius,
        child: body,
      );
    } else {
      surface = body;
    }

    if (margin != null) {
      surface = Padding(padding: margin!, child: surface);
    }
    return surface;
  }

  Widget _padded() {
    if (padding == null) return child;
    return Padding(padding: padding!, child: child);
  }
}
