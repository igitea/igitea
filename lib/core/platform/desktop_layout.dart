import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Window-size and platform rules for the adaptive workspace.
///
/// Layout decisions are based on the current window width, never on the
/// device type: an iPad in landscape gets the same multi-pane workspace as a
/// laptop window of the same size. The platform only decides interaction
/// details — hit-target size, hover affordances and keyboard hints.
abstract final class DesktopLayout {
  DesktopLayout._();

  /// Below this width the app uses its phone composition.
  static const double compactBreakpoint = 760;

  /// At or above this width a window gets the multi-pane workspace.
  static const double desktopBreakpoint = 1000;

  /// The repository workspace needs a little more room for three panes.
  static const double repositoryBreakpoint = 1080;

  /// At or above this width a workspace may show a third (context) pane.
  static const double wideBreakpoint = 1200;

  /// Sidebar width when expanded.
  static const double sidebarWidth = 256;

  /// Sidebar width when collapsed to an icon rail.
  static const double sidebarRailWidth = 76;

  /// Rail width on touch screens, where items carry a caption under the icon.
  static const double touchRailWidth = 84;

  /// Navigation rail inside a detail page (repository sections).
  static const double navRailWidth = 232;

  /// Context pane on a repository or issue page.
  static const double contextPaneWidth = 288;

  /// List pane in a list-detail layout.
  static const double listPaneWidth = 384;

  /// Whether [platform] is a mouse-and-keyboard desktop platform.
  static bool isDesktopPlatform([TargetPlatform? platform]) {
    final target = platform ?? defaultTargetPlatform;
    return target == TargetPlatform.macOS ||
        target == TargetPlatform.windows ||
        target == TargetPlatform.linux;
  }

  /// Whether the app runs on a touch-first device (phone or tablet).
  ///
  /// Touch screens get larger hit targets and no hover-only or keyboard-only
  /// affordances. Web is treated as a pointer platform.
  static bool isTouch([TargetPlatform? platform]) =>
      !kIsWeb && !isDesktopPlatform(platform);

  /// Whether the window is wide enough for the multi-pane workspace.
  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= desktopBreakpoint;

  /// Whether the repository workspace should use its three-pane layout.
  static bool isRepositoryDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= repositoryBreakpoint;

  /// Whether the window is wide enough for a third pane.
  static bool isWide(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= wideBreakpoint;

  /// Whether the window is in the phone range.
  static bool isCompact(BuildContext context) =>
      MediaQuery.sizeOf(context).width < compactBreakpoint;

  /// Whether the app shell should collapse its sidebar to a rail because the
  /// window is tablet-sized (between compact and desktop widths).
  static bool prefersRail(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= compactBreakpoint && width < desktopBreakpoint;
  }
}
