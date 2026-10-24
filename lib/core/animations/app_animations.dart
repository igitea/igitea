import 'package:flutter/material.dart';

/// Motion tokens shared by the whole app.
///
/// Durations are short enough to feel immediate on desktop and long enough to
/// read as motion on touch devices. Curves follow the Material 3 "emphasized
/// decelerate" family: quick to start moving, soft to settle.
abstract final class AppAnimations {
  static const Duration instant = Duration(milliseconds: 90);
  static const Duration fast = Duration(milliseconds: 140);
  static const Duration normal = Duration(milliseconds: 200);
  static const Duration slow = Duration(milliseconds: 280);
  static const Duration slower = Duration(milliseconds: 360);

  static const Curve easeOut = Cubic(0.22, 1, 0.36, 1);
  static const Curve easeIn = Cubic(0.4, 0, 1, 1);
  static const Curve emphasized = Cubic(0.2, 0, 0, 1);
  static const Curve emphasizedDecelerate = Cubic(0.05, 0.7, 0.1, 1);
  static const Curve standard = Cubic(0.2, 0, 0, 1);
  static const Curve elastic = Curves.easeOutBack;

  static const Duration staggerDelay = Duration(milliseconds: 26);

  /// Whether the platform asks for reduced motion.
  ///
  /// Widgets that drive decorative motion should read this and skip to the
  /// final frame when it is true.
  static bool reduceMotion(BuildContext context) {
    final media = MediaQuery.maybeOf(context);
    return media?.disableAnimations ?? false;
  }

  /// A duration that collapses to zero when reduced motion is requested.
  static Duration effective(BuildContext context, Duration duration) =>
      reduceMotion(context) ? Duration.zero : duration;
}
