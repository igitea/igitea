import 'package:flutter/material.dart';

import 'app_animations.dart';

/// Keeps every tab mounted (preserving scroll offsets and state) while
/// cross-fading between them.
///
/// A plain [IndexedStack] switches instantly; replacing it with an
/// [AnimatedSwitcher] would throw state away. This widget keeps all layers in a
/// stack and animates opacity plus a 6px rise, so tab changes feel continuous
/// without losing state.
class AnimatedTabStack extends StatelessWidget {
  const AnimatedTabStack({
    super.key,
    required this.index,
    required this.children,
    this.enterDuration = const Duration(milliseconds: 260),
    this.exitDuration = const Duration(milliseconds: 120),
  });

  final int index;
  final List<Widget> children;
  final Duration enterDuration;
  final Duration exitDuration;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        for (var i = 0; i < children.length; i++)
          _TabLayer(
            key: ValueKey(i),
            active: i == index,
            enterDuration: AppAnimations.effective(context, enterDuration),
            exitDuration: AppAnimations.effective(context, exitDuration),
            child: children[i],
          ),
      ],
    );
  }
}

class _TabLayer extends StatefulWidget {
  const _TabLayer({
    super.key,
    required this.active,
    required this.enterDuration,
    required this.exitDuration,
    required this.child,
  });

  final bool active;
  final Duration enterDuration;
  final Duration exitDuration;
  final Widget child;

  @override
  State<_TabLayer> createState() => _TabLayerState();
}

class _TabLayerState extends State<_TabLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.enterDuration,
    reverseDuration: widget.exitDuration,
    value: widget.active ? 1 : 0,
  );

  late final Animation<double> _opacity = CurvedAnimation(
    parent: _controller,
    curve: AppAnimations.emphasizedDecelerate,
    reverseCurve: AppAnimations.easeIn,
  );

  late final Animation<Offset> _offset =
      Tween<Offset>(begin: const Offset(0, 0.008), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _controller,
          curve: AppAnimations.emphasizedDecelerate,
          reverseCurve: AppAnimations.easeIn,
        ),
      );

  @override
  void didUpdateWidget(covariant _TabLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.active == widget.active) return;
    if (widget.active) {
      _controller.forward(from: 0);
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !widget.active,
      child: ExcludeSemantics(
        excluding: !widget.active,
        child: TickerMode(
          enabled: widget.active,
          child: RepaintBoundary(
            child: FadeTransition(
              opacity: _opacity,
              child: SlideTransition(position: _offset, child: widget.child),
            ),
          ),
        ),
      ),
    );
  }
}
