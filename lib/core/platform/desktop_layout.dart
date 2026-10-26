import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Window-size and platform rules for the desktop workspace.
///
/// Layout decisions are based on the current window width, never on the
/// physical device type: desktop windows can be resized freely and the web
/// build runs on both large and small displays.
abstract final class DesktopLayout {
  DesktopLayout._();

  /// Below this width the app uses its phone/tablet composition.
  static const double compactBreakpoint = 760;

  /// At or above this width a desktop window gets the multi-pane workspace.
  static const double desktopBreakpoint = 1000;

  /// The repository workspace needs a little more room for three panes.
  static const double repositoryBreakpoint = 1080;

  /// At or above this width a workspace may show a third (context) pane.
  static const double wideBreakpoint = 1200;

  /// Sidebar width when expanded.
  static const double sidebarWidth = 256;

  /// Sidebar width when collapsed to an icon rail.
  static const double sidebarRailWidth = 76;

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

  /// Whether the current window is wide enough for the desktop workspace.
  ///
  /// Web is included because a browser window on a laptop behaves like a
  /// desktop window; phones fall below the breakpoint and keep the mobile
  /// composition.
  static bool isDesktop(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= desktopBreakpoint && (kIsWeb || isDesktopPlatform());
  }

  /// Whether the repository workspace should use its three-pane layout.
  static bool isRepositoryDesktop(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= repositoryBreakpoint && (kIsWeb || isDesktopPlatform());
  }

  /// Whether the window is wide enough for a third pane.
  static bool isWide(BuildContext context) =>
      isDesktop(context) && MediaQuery.sizeOf(context).width >= wideBreakpoint;

  /// Whether the window is in the phone/tablet range.
  static bool isCompact(BuildContext context) =>
      MediaQuery.sizeOf(context).width < compactBreakpoint;

  /// A short and testable form of [isDesktop] for callers without a context.
  static bool isDesktopWidth(double width, {TargetPlatform? platform}) =>
      width >= desktopBreakpoint &&
      (platform != null
          ? isDesktopPlatform(platform)
          : (kIsWeb || isDesktopPlatform()));
}
