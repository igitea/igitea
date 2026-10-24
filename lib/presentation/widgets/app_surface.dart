import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../core/animations/app_animations.dart';
import '../theme/app_palette.dart';

/// A flat, hairline-bordered surface used for cards, grouped rows and panels.
///
/// Hover lifts the border and shadow by a hair and never moves layout, which
/// keeps dense desktop lists calm. When [onPress] is provided the surface also
/// becomes a Forui tappable with keyboard focus and a hand cursor.
class AppSurface extends StatefulWidget {
  const AppSurface({
    super.key,
    required this.child,
    this.onPress,
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
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double radius;
  final bool elevated;
  final Color? background;
  final Color? borderColor;
  final String? semanticLabel;

  @override
  State<AppSurface> createState() => _AppSurfaceState();
}

class _AppSurfaceState extends State<AppSurface> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final interactive = widget.onPress != null;
    final radius = BorderRadius.circular(widget.radius);

    Widget surface = MouseRegion(
      onEnter: interactive ? (_) => setState(() => _hovered = true) : null,
      onExit: interactive ? (_) => setState(() => _hovered = false) : null,
      child: AnimatedContainer(
        duration: AppAnimations.effective(context, AppAnimations.fast),
        curve: AppAnimations.easeOut,
        decoration: BoxDecoration(
          color: widget.background ?? palette.surface,
          borderRadius: radius,
          border: Border.all(
            color:
                widget.borderColor ??
                (_hovered && interactive
                    ? palette.borderStrong
                    : palette.border),
          ),
          boxShadow: widget.elevated ? palette.cardShadow : null,
        ),
        child: ClipRRect(borderRadius: radius, child: _padded(context)),
      ),
    );

    if (widget.margin != null) {
      surface = Padding(padding: widget.margin!, child: surface);
    }
    return surface;
  }

  Widget _padded(BuildContext context) {
    final body = widget.padding == null
        ? widget.child
        : Padding(padding: widget.padding!, child: widget.child);
    if (widget.onPress == null) return body;
    return FTappable(
      onPress: widget.onPress,
      semanticsLabel: widget.semanticLabel,
      child: body,
    );
  }
}
