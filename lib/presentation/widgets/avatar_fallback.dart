import 'package:flutter/material.dart';

import '../theme/app_palette.dart';

/// The initial shown when an avatar has no image, on a soft accent tint chosen
/// from the name so the same account always gets the same color.
class AvatarFallback extends StatelessWidget {
  const AvatarFallback({
    super.key,
    required this.name,
    required this.size,
    this.borderRadius,
  });

  final String name;
  final double size;

  /// Null draws a circle.
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final tones = [
      (palette.brand, palette.brandSoft),
      (palette.info, palette.infoSoft),
      (palette.purple, palette.purpleSoft),
      (palette.warning, palette.warningSoft),
      (palette.success, palette.successSoft),
      (palette.danger, palette.dangerSoft),
    ];
    final key = name.toLowerCase();
    var hash = 0;
    for (final unit in key.codeUnits) {
      hash = (hash * 31 + unit) & 0x7fffffff;
    }
    final (fg, bg) = tones[hash % tones.length];
    final initial = key.isEmpty ? '?' : name.characters.first.toUpperCase();

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        shape: borderRadius == null ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: borderRadius,
        border: Border.all(color: fg.withValues(alpha: 0.16)),
      ),
      child: Text(
        initial,
        style: TextStyle(
          fontSize: size * 0.42,
          height: 1,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}
