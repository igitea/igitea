import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// iGitea's Forui design system.
///
/// Every screen is themed through a single [FThemeData] so that Forui widgets
/// (and the approximate Material theme used by not-yet-migrated screens) share
/// the same colors, radii and typography.
abstract final class AppTheme {
  /// Brand color, a deep teal that reads well on light surfaces.
  static const brand = Color(0xFF0F766E);

  /// Brand color for dark surfaces.
  static const brandDark = Color(0xFF2DD4BF);

  /// Surface color used for cards on light backgrounds.
  static const _cardLight = Color(0xFFFFFFFF);

  /// Builds the Forui theme for the given [brightness].
  ///
  /// [touch] selects Forui's touch or desktop density; the app uses touch on
  /// phones/tablets and desktop on web/desktop platforms.
  static FThemeData forui(Brightness brightness, {required bool touch}) {
    final colors = brightness == Brightness.light
        ? FColors.zincLight.copyWith(
            primary: brand,
            primaryForeground: Colors.white,
            card: _cardLight,
          )
        : FColors.zincDark.copyWith(
            primary: brandDark,
            primaryForeground: const Color(0xFF042F2E),
          );

    return FThemeData(
      touch: touch,
      debugLabel: brightness == Brightness.light ? 'iGitea Light' : 'iGitea Dark',
      colors: colors,
    );
  }

  /// The Material theme approximating the Forui theme, used by screens that
  /// still rely on Material widgets.
  static ThemeData material(Brightness brightness, {required bool touch}) =>
      forui(brightness, touch: touch).toApproximateMaterialTheme();

  /// Whether the current platform should use Forui's touch density.
  static bool touchFor(TargetPlatform platform) =>
      platform == TargetPlatform.android ||
      platform == TargetPlatform.iOS ||
      platform == TargetPlatform.fuchsia;

  /// The Forui theme for the current platform.
  static FThemeData current(Brightness brightness) =>
      forui(brightness, touch: touchFor(defaultTargetPlatform));
}
