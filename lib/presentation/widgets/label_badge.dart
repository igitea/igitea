import 'package:flutter/material.dart';

import '../../data/models/generated/generated_models.dart';
import '../theme/app_palette.dart';

/// Parses a Gitea label color such as `#d73a4a` or `d73a4a`.
Color? parseLabelColor(String? hex) {
  if (hex == null || hex.isEmpty) return null;
  final h = hex.replaceFirst('#', '');
  if (h.length != 6) return null;
  final value = int.tryParse(h, radix: 16);
  return value == null ? null : Color(0xFF000000 | value);
}

double _contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final hi = la > lb ? la : lb;
  final lo = la > lb ? lb : la;
  return (hi + 0.05) / (lo + 0.05);
}

/// Shifts [color] toward black (light theme) or white (dark theme) until it
/// reads as text on [background].
///
/// Gitea labels use arbitrary user colors; pale ones such as `#a2eeef` would
/// otherwise vanish on a light surface.
Color readableOn(Color color, Color background, {double minContrast = 4.5}) {
  final target = background.computeLuminance() > 0.4
      ? Colors.black
      : Colors.white;
  var result = color;
  for (var t = 0.0; t <= 1.0; t += 0.06) {
    result = Color.lerp(color, target, t)!;
    if (_contrast(result, background) >= minContrast) break;
  }
  return result;
}

/// A rounded label pill with a tinted fill and contrast-safe text.
class LabelBadge extends StatelessWidget {
  const LabelBadge({super.key, required this.label, this.dense = false});

  final Label label;

  /// Smaller type and padding for list rows and side rails.
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final base = parseLabelColor(label.color) ?? palette.textSecondary;
    final fill = Color.alphaBlend(
      base.withValues(alpha: palette.isDark ? 0.22 : 0.16),
      palette.surface,
    );
    final text = readableOn(base, fill);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 7 : 9,
        vertical: dense ? 1.5 : 3,
      ),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: base.withValues(alpha: palette.isDark ? 0.45 : 0.38),
          width: 0.8,
        ),
      ),
      child: Text(
        label.name ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: dense ? 11 : 12,
          height: 1.25,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.05,
          color: text,
        ),
      ),
    );
  }
}

/// A wrapping row of [LabelBadge]s that collapses extras into a `+N` count.
class LabelRow extends StatelessWidget {
  const LabelRow({
    super.key,
    required this.labels,
    this.maxShow = 4,
    this.dense = true,
  });

  final List<Label> labels;
  final int maxShow;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final overflow = labels.length - maxShow;
    return Wrap(
      spacing: dense ? 4 : 6,
      runSpacing: dense ? 4 : 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final label in labels.take(maxShow))
          LabelBadge(label: label, dense: dense),
        if (overflow > 0)
          Text(
            '+$overflow',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: context.palette.textSecondary,
            ),
          ),
      ],
    );
  }
}
