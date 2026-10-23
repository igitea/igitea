import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../core/constants/ui_constants.dart';

/// A Forui-styled card used for grouped content.
///
/// Keeps the historical API (padding/margin) so pages can migrate gradually
/// while every card instantly adopts the Forui border, radius and typography.
class PremiumCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  /// Kept for API compatibility. Cards now always use the theme surface color.
  final Color? color;

  /// Kept for API compatibility. Forui cards are flat by design.
  final double? elevation;

  const PremiumCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.color,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final body = Padding(
      padding: padding ?? UIConstants.cardPadding,
      child: child,
    );

    return Padding(
      padding: margin ?? UIConstants.cardMargin,
      child: FCard.raw(
        child: onTap == null ? body : FTappable(onPress: onTap, child: body),
      ),
    );
  }
}

/// A card used as a row in a list.
class PremiumListCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const PremiumListCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final body = Padding(
      padding: padding ?? UIConstants.cardPadding,
      child: child,
    );

    return Padding(
      padding: margin ?? UIConstants.cardMargin,
      child: FCard.raw(
        child: onTap == null ? body : FTappable(onPress: onTap, child: body),
      ),
    );
  }
}
