import 'package:flutter/material.dart';

/// The app's semantic color palette.
///
/// Forui's [FColors] only exposes a small set of neutrals; the Git-specific and
/// status colors below give every screen a shared vocabulary for icons, charts
/// and badges. Both themes are defined here so a color is never hard-coded in a
/// widget.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.canvas,
    required this.surface,
    required this.surfaceMuted,
    required this.border,
    required this.borderStrong,
    required this.textPrimary,
    required this.textSecondary,
    required this.brand,
    required this.brandSoft,
    required this.info,
    required this.infoSoft,
    required this.success,
    required this.successSoft,
    required this.warning,
    required this.warningSoft,
    required this.danger,
    required this.dangerSoft,
    required this.purple,
    required this.purpleSoft,
  });

  /// The window background, a barely-tinted paper that lets white cards sit
  /// forward without heavy shadows.
  final Color canvas;

  /// Card and popover background.
  final Color surface;

  /// Muted background used for hover states, skeletons and inline code.
  final Color surfaceMuted;

  /// Hairline border.
  final Color border;

  /// Border used when an element is hovered or focused.
  final Color borderStrong;

  /// Primary text.
  final Color textPrimary;

  /// Secondary text and icons.
  final Color textSecondary;

  /// Brand color (verdigris teal).
  final Color brand;

  /// Brand tint used for selected navigation and soft badges.
  final Color brandSoft;

  /// Informational blue, e.g. pull requests.
  final Color info;
  final Color infoSoft;

  /// Success green, e.g. open issues.
  final Color success;
  final Color successSoft;

  /// Attention amber, e.g. stars and organisations.
  final Color warning;
  final Color warningSoft;

  /// Destructive red, e.g. closed issues.
  final Color danger;
  final Color dangerSoft;

  /// Violet, e.g. merged pull requests.
  final Color purple;
  final Color purpleSoft;

  bool get isDark => brightness == Brightness.dark;

  Brightness get brightness =>
      canvas.computeLuminance() < 0.2 ? Brightness.dark : Brightness.light;

  /// A soft, diffuse shadow used for cards in light mode.
  List<BoxShadow> get cardShadow => isDark
      ? const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ]
      : const [
          BoxShadow(
            color: Color(0x0A1B2B24),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
          BoxShadow(
            color: Color(0x061B2B24),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ];

  static const light = AppPalette(
    canvas: Color(0xFFF6F8F7),
    surface: Color(0xFFFFFFFF),
    surfaceMuted: Color(0xFFEFF3F1),
    border: Color(0xFFE4E9E6),
    borderStrong: Color(0xFFD3DDD8),
    textPrimary: Color(0xFF121715),
    textSecondary: Color(0xFF66706B),
    brand: Color(0xFF0F766E),
    brandSoft: Color(0xFFE6F2EF),
    info: Color(0xFF0969DA),
    infoSoft: Color(0xFFE8F0FC),
    success: Color(0xFF1A7F37),
    successSoft: Color(0xFFE7F5EC),
    warning: Color(0xFF9A6700),
    warningSoft: Color(0xFFFAF1DD),
    danger: Color(0xFFCF222E),
    dangerSoft: Color(0xFFFCEBEC),
    purple: Color(0xFF8250DF),
    purpleSoft: Color(0xFFF1EAFC),
  );

  static const dark = AppPalette(
    canvas: Color(0xFF0B0F0E),
    surface: Color(0xFF121817),
    surfaceMuted: Color(0xFF1A211F),
    border: Color(0xFF252E2A),
    borderStrong: Color(0xFF35403B),
    textPrimary: Color(0xFFE8EEEB),
    textSecondary: Color(0xFF98A49E),
    brand: Color(0xFF2DD4BF),
    brandSoft: Color(0xFF10302B),
    info: Color(0xFF58A6FF),
    infoSoft: Color(0xFF102237),
    success: Color(0xFF3FB950),
    successSoft: Color(0xFF10281A),
    warning: Color(0xFFD29922),
    warningSoft: Color(0xFF2A2110),
    danger: Color(0xFFF85149),
    dangerSoft: Color(0xFF2E1616),
    purple: Color(0xFFBC8CFF),
    purpleSoft: Color(0xFF241A3A),
  );

  @override
  AppPalette copyWith({
    Color? canvas,
    Color? surface,
    Color? surfaceMuted,
    Color? border,
    Color? borderStrong,
    Color? textPrimary,
    Color? textSecondary,
    Color? brand,
    Color? brandSoft,
    Color? info,
    Color? infoSoft,
    Color? success,
    Color? successSoft,
    Color? warning,
    Color? warningSoft,
    Color? danger,
    Color? dangerSoft,
    Color? purple,
    Color? purpleSoft,
  }) {
    return AppPalette(
      canvas: canvas ?? this.canvas,
      surface: surface ?? this.surface,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      brand: brand ?? this.brand,
      brandSoft: brandSoft ?? this.brandSoft,
      info: info ?? this.info,
      infoSoft: infoSoft ?? this.infoSoft,
      success: success ?? this.success,
      successSoft: successSoft ?? this.successSoft,
      warning: warning ?? this.warning,
      warningSoft: warningSoft ?? this.warningSoft,
      danger: danger ?? this.danger,
      dangerSoft: dangerSoft ?? this.dangerSoft,
      purple: purple ?? this.purple,
      purpleSoft: purpleSoft ?? this.purpleSoft,
    );
  }

  @override
  AppPalette lerp(covariant AppPalette? other, double t) {
    if (other == null) return this;
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppPalette(
      canvas: mix(canvas, other.canvas),
      surface: mix(surface, other.surface),
      surfaceMuted: mix(surfaceMuted, other.surfaceMuted),
      border: mix(border, other.border),
      borderStrong: mix(borderStrong, other.borderStrong),
      textPrimary: mix(textPrimary, other.textPrimary),
      textSecondary: mix(textSecondary, other.textSecondary),
      brand: mix(brand, other.brand),
      brandSoft: mix(brandSoft, other.brandSoft),
      info: mix(info, other.info),
      infoSoft: mix(infoSoft, other.infoSoft),
      success: mix(success, other.success),
      successSoft: mix(successSoft, other.successSoft),
      warning: mix(warning, other.warning),
      warningSoft: mix(warningSoft, other.warningSoft),
      danger: mix(danger, other.danger),
      dangerSoft: mix(dangerSoft, other.dangerSoft),
      purple: mix(purple, other.purple),
      purpleSoft: mix(purpleSoft, other.purpleSoft),
    );
  }
}

extension AppPaletteContext on BuildContext {
  /// The nearest [AppPalette], falling back to the light palette.
  AppPalette get palette =>
      Theme.of(this).extension<AppPalette>() ?? AppPalette.light;
}
