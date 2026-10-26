import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';

import '../../core/animations/app_animations.dart';
import '../../core/animations/page_transitions.dart';
import 'app_palette.dart';

/// Fallbacks for `fontFamily: 'monospace'`, which only resolves on Android and
/// Linux; Apple platforms and Windows need a named monospaced face.
const kMonoFontFallback = <String>[
  'Menlo',
  'SF Mono',
  'Consolas',
  'Courier New',
  'Courier',
];

/// iGitea's design system.
///
/// A single source of truth for color, typography and motion. Forui widgets and
/// the handful of Material widgets still in the app are both derived from the
/// same tokens, so the two never drift apart.
abstract final class AppTheme {
  /// Brand color, a deep verdigris that reads well on light surfaces.
  static const brand = Color(0xFF0F766E);

  /// Brand color for dark surfaces.
  static const brandDark = Color(0xFF2DD4BF);

  /// The palette for [brightness].
  static AppPalette palette(Brightness brightness) =>
      brightness == Brightness.light ? AppPalette.light : AppPalette.dark;

  /// Builds the Forui theme for the given [brightness].
  ///
  /// [touch] selects Forui's touch or desktop density; the app uses touch on
  /// phones/tablets and desktop on web/desktop platforms.
  static FThemeData forui(Brightness brightness, {required bool touch}) {
    final palette = AppTheme.palette(brightness);
    final colors = brightness == Brightness.light
        ? FColors(
            brightness: Brightness.light,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            barrier: const Color(0x33101814),
            background: palette.canvas,
            foreground: palette.textPrimary,
            primary: palette.brand,
            primaryForeground: Colors.white,
            secondary: palette.surfaceMuted,
            secondaryForeground: palette.textPrimary,
            muted: palette.surfaceMuted,
            mutedForeground: palette.textSecondary,
            destructive: palette.danger,
            destructiveForeground: Colors.white,
            error: palette.danger,
            errorForeground: Colors.white,
            card: palette.surface,
            border: palette.border,
          )
        : FColors(
            brightness: Brightness.dark,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            barrier: const Color(0x8C000000),
            background: palette.canvas,
            foreground: palette.textPrimary,
            primary: palette.brand,
            primaryForeground: const Color(0xFF04211D),
            secondary: palette.surfaceMuted,
            secondaryForeground: palette.textPrimary,
            muted: palette.surfaceMuted,
            mutedForeground: palette.textSecondary,
            destructive: palette.danger,
            destructiveForeground: const Color(0xFF200A09),
            error: palette.danger,
            errorForeground: const Color(0xFF200A09),
            card: palette.surface,
            border: palette.border,
          );

    return FThemeData(
      touch: touch,
      debugLabel: brightness == Brightness.light
          ? 'iGitea Light'
          : 'iGitea Dark',
      colors: colors,
      extensions: [palette],
    );
  }

  /// The Material theme approximating the Forui theme.
  ///
  /// Material is only kept for legacy widgets (pull-to-refresh, ink surfaces,
  /// text selection); it mirrors the Forui tokens instead of introducing a
  /// second look.
  static ThemeData material(Brightness brightness, {required bool touch}) {
    final forui = AppTheme.forui(brightness, touch: touch);
    final base = forui.toApproximateMaterialTheme();
    final palette = AppTheme.palette(brightness);

    final scheme = base.colorScheme.copyWith(
      primary: palette.brand,
      onPrimary: brightness == Brightness.light
          ? Colors.white
          : const Color(0xFF04211D),
      secondary: palette.surfaceMuted,
      onSecondary: palette.textPrimary,
      primaryContainer: palette.brandSoft,
      onPrimaryContainer: palette.brand,
      secondaryContainer: palette.brandSoft,
      onSecondaryContainer: palette.brand,
      tertiary: palette.purple,
      onTertiary: Colors.white,
      tertiaryContainer: palette.purpleSoft,
      onTertiaryContainer: palette.purple,
      surface: palette.canvas,
      onSurface: palette.textPrimary,
      surfaceContainerLowest: palette.surface,
      surfaceContainerLow: palette.surface,
      surfaceContainer: palette.surfaceMuted,
      surfaceContainerHigh: palette.surfaceMuted,
      surfaceContainerHighest: palette.surfaceMuted,
      onSurfaceVariant: palette.textSecondary,
      outline: palette.borderStrong,
      outlineVariant: palette.border,
      error: palette.danger,
      onError: Colors.white,
      errorContainer: palette.dangerSoft,
      onErrorContainer: palette.danger,
      surfaceTint: palette.brand,
    );

    return base.copyWith(
      colorScheme: scheme,
      extensions: [palette],
      scaffoldBackgroundColor: palette.canvas,
      canvasColor: palette.canvas,
      dividerColor: palette.border,
      textTheme: _textTheme(base.textTheme),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: AppPageTransitionsBuilder(),
          TargetPlatform.iOS: AppPageTransitionsBuilder(),
          TargetPlatform.macOS: AppPageTransitionsBuilder(),
          TargetPlatform.windows: AppPageTransitionsBuilder(),
          TargetPlatform.linux: AppPageTransitionsBuilder(),
          TargetPlatform.fuchsia: AppPageTransitionsBuilder(),
        },
      ),
      scrollbarTheme: ScrollbarThemeData(
        thickness: const WidgetStatePropertyAll(6),
        radius: const Radius.circular(3),
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.hovered)
              ? palette.borderStrong
              : palette.border,
        ),
        trackColor: const WidgetStatePropertyAll(Colors.transparent),
        crossAxisMargin: 2,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: palette.brand,
        selectionColor: palette.brand.withValues(alpha: 0.18),
        selectionHandleColor: palette.brand,
      ),
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      hoverColor: palette.surfaceMuted.withValues(alpha: 0.6),
      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  /// Material's text theme keeps Forui's Inter family and weights but restores
  /// comfortable line heights (Forui collapses heights for its own layout).
  static TextTheme _textTheme(TextTheme base) {
    return base.copyWith(
      headlineLarge: base.headlineLarge?.copyWith(
        height: 1.15,
        letterSpacing: -0.6,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        height: 1.18,
        letterSpacing: -0.5,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        height: 1.2,
        letterSpacing: -0.4,
      ),
      titleLarge: base.titleLarge?.copyWith(height: 1.3, letterSpacing: -0.2),
      titleMedium: base.titleMedium?.copyWith(
        height: 1.35,
        letterSpacing: -0.1,
      ),
      titleSmall: base.titleSmall?.copyWith(height: 1.35, letterSpacing: -0.05),
      bodyLarge: base.bodyLarge?.copyWith(height: 1.45, letterSpacing: -0.05),
      bodyMedium: base.bodyMedium?.copyWith(height: 1.45),
      bodySmall: base.bodySmall?.copyWith(height: 1.4),
      labelLarge: base.labelLarge?.copyWith(height: 1.2),
      labelMedium: base.labelMedium?.copyWith(height: 1.2),
      labelSmall: base.labelSmall?.copyWith(height: 1.2),
    );
  }

  /// Whether the current platform should use Forui's touch density.
  static bool touchFor(TargetPlatform platform) =>
      platform == TargetPlatform.android ||
      platform == TargetPlatform.iOS ||
      platform == TargetPlatform.fuchsia;

  /// The Forui theme for the current platform.
  static FThemeData current(Brightness brightness) =>
      forui(brightness, touch: touchFor(defaultTargetPlatform));

  /// Motion curve used for most transitions.
  static const Curve emphasized = AppAnimations.emphasized;

  /// Duration used for most transitions.
  static const Duration motion = AppAnimations.normal;
}
