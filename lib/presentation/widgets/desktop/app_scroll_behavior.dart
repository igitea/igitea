import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Desktop scroll behaviour: scrollbars in the platform style, no overscroll
/// glow, and trackpad-friendly physics.
///
/// Mouse-button drag scrolling is deliberately left off so text selection and
/// drag gestures inside editors keep working; the wheel and trackpad already
/// cover scrolling on desktop.
class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => const {
    PointerDeviceKind.touch,
    PointerDeviceKind.stylus,
    PointerDeviceKind.invertedStylus,
    PointerDeviceKind.trackpad,
  };

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    final platform = Theme.of(context).platform;
    if (platform == TargetPlatform.macOS ||
        platform == TargetPlatform.windows ||
        platform == TargetPlatform.linux) {
      return const ClampingScrollPhysics();
    }
    return super.getScrollPhysics(context);
  }

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    final platform = Theme.of(context).platform;
    if (platform == TargetPlatform.android ||
        platform == TargetPlatform.iOS ||
        platform == TargetPlatform.fuchsia) {
      return child;
    }
    return Scrollbar(
      controller: details.controller,
      thumbVisibility: false,
      radius: const Radius.circular(6),
      thickness: 6,
      child: child,
    );
  }
}
