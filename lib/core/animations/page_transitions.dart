import 'package:flutter/material.dart';

import 'app_animations.dart';

/// A quiet "fade through" page transition for pushed routes.
///
/// The incoming page fades in while drifting up a few pixels and scaling from
/// 99.4% to 100%; the outgoing page recedes very slightly. The result reads as
/// depth rather than as a slide, which suits a desktop workspace.
class AppPageTransitionsBuilder extends PageTransitionsBuilder {
  const AppPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (route.isFirst || AppAnimations.reduceMotion(context)) {
      return child;
    }

    final enter = CurvedAnimation(
      parent: animation,
      curve: AppAnimations.emphasizedDecelerate,
      reverseCurve: AppAnimations.easeIn,
    );
    final fade = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.06, 1, curve: AppAnimations.easeOut),
      reverseCurve: AppAnimations.easeIn,
    );
    final exit = CurvedAnimation(
      parent: secondaryAnimation,
      curve: AppAnimations.emphasized,
    );

    final enterFade = Tween<double>(begin: 0, end: 1).animate(fade);
    final enterSlide = Tween<Offset>(
      begin: const Offset(0, 0.012),
      end: Offset.zero,
    ).animate(enter);
    final enterScale = Tween<double>(begin: 0.994, end: 1).animate(enter);

    final exitFade = Tween<double>(begin: 1, end: 0.94).animate(exit);
    final exitScale = Tween<double>(begin: 1, end: 0.998).animate(exit);

    return FadeTransition(
      opacity: exitFade,
      child: ScaleTransition(
        scale: exitScale,
        child: FadeTransition(
          opacity: enterFade,
          child: SlideTransition(
            position: enterSlide,
            child: ScaleTransition(scale: enterScale, child: child),
          ),
        ),
      ),
    );
  }
}
