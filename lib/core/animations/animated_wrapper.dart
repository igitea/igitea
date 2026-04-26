import 'package:flutter/material.dart';
import 'app_animations.dart';

class FadeInWrapper extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;

  const FadeInWrapper({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = AppAnimations.normal,
  });

  @override
  State<FadeInWrapper> createState() => _FadeInWrapperState();
}

class _FadeInWrapperState extends State<FadeInWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: AppAnimations.easeOut),
    );

    _offset = Tween<Offset>(
      begin: const Offset(0, 0.02),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: AppAnimations.easeOut),
    );

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _offset,
        child: widget.child,
      ),
    );
  }
}

class StaggeredFadeIn extends StatelessWidget {
  final List<Widget> children;
  final Duration baseDelay;
  final Duration staggerDelay;
  final EdgeInsetsGeometry? padding;

  const StaggeredFadeIn({
    super.key,
    required this.children,
    this.baseDelay = Duration.zero,
    this.staggerDelay = AppAnimations.staggerDelay,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: padding,
      children: children.asMap().entries.map((entry) {
        return FadeInWrapper(
          delay: baseDelay + Duration(milliseconds: entry.key * staggerDelay.inMilliseconds),
          child: entry.value,
        );
      }).toList(),
    );
  }
}
