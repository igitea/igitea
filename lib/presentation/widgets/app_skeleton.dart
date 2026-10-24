import 'package:flutter/material.dart';

import '../../core/animations/app_animations.dart';
import '../theme/app_palette.dart';

/// Wraps skeleton placeholders in a single moving sheen.
///
/// One controller drives the whole tree, so a screen full of placeholders costs
/// a single repaint rather than one animation per box.
class AppSkeleton extends StatefulWidget {
  const AppSkeleton({super.key, required this.child});

  final Widget child;

  @override
  State<AppSkeleton> createState() => _AppSkeletonState();
}

class _AppSkeletonState extends State<AppSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  );

  @override
  void initState() {
    super.initState();
    _controller.repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppAnimations.reduceMotion(context)) {
      _controller.stop();
      _controller.value = 1;
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final base = palette.surfaceMuted;
    final highlight = palette.isDark
        ? Color.lerp(palette.surfaceMuted, Colors.white, 0.09)!
        : Color.lerp(palette.surfaceMuted, Colors.white, 0.75)!;

    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        final t = _controller.value;
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            final dx = (t * 2) - 1;
            return LinearGradient(
              begin: Alignment(-1.6 + dx, 0),
              end: Alignment(-0.6 + dx, 0),
              colors: [base, highlight, base],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(bounds);
          },
          child: child,
        );
      },
    );
  }
}

/// A single rounded placeholder block.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({super.key, this.width, this.height = 12, this.radius = 6});

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: context.palette.surfaceMuted,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

/// A text-line placeholder that can vary its width to feel hand-written.
class SkeletonLine extends StatelessWidget {
  const SkeletonLine({super.key, this.widthFactor = 1, this.height = 10});

  final double widthFactor;
  final double height;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: widthFactor,
      child: SkeletonBox(height: height),
    );
  }
}
