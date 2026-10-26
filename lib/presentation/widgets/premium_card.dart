import 'package:flutter/material.dart';

import '../../core/constants/ui_constants.dart';
import 'app_surface.dart';
import 'desktop/app_hover_region.dart';

/// A card used for grouped content.
///
/// Keeps the historical API (padding/margin) so pages can migrate gradually
/// while every card instantly adopts the shared surface, border and hover
/// treatment.
class PremiumCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onSecondaryTap;
  final List<AppMenuItem> contextMenuItems;
  final bool selected;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  /// Kept for API compatibility. Cards always use the theme surface color.
  final Color? color;

  /// Kept for API compatibility. Cards are flat surfaces with a hairline.
  final double? elevation;

  const PremiumCard({
    super.key,
    required this.child,
    this.onTap,
    this.onDoubleTap,
    this.onSecondaryTap,
    this.contextMenuItems = const [],
    this.selected = false,
    this.padding,
    this.margin,
    this.color,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return AppSurface(
      onPress: onTap,
      onDoubleTap: onDoubleTap,
      onSecondaryTap: onSecondaryTap,
      contextMenuItems: contextMenuItems,
      selected: selected,
      padding: padding ?? UIConstants.cardPadding,
      margin: margin ?? UIConstants.cardMargin,
      child: child,
    );
  }
}

/// A card used as a row in a list.
class PremiumListCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onSecondaryTap;
  final List<AppMenuItem> contextMenuItems;
  final bool selected;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const PremiumListCard({
    super.key,
    required this.child,
    this.onTap,
    this.onDoubleTap,
    this.onSecondaryTap,
    this.contextMenuItems = const [],
    this.selected = false,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return AppSurface(
      onPress: onTap,
      onDoubleTap: onDoubleTap,
      onSecondaryTap: onSecondaryTap,
      contextMenuItems: contextMenuItems,
      selected: selected,
      padding: padding ?? UIConstants.cardPadding,
      margin: margin ?? UIConstants.cardMargin,
      child: child,
    );
  }
}
