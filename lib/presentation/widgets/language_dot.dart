import 'package:flutter/material.dart';

import '../theme/app_palette.dart';

/// GitHub-style language colors, used by small dots next to repository names.
const Map<String, Color> _languageColors = {
  'dart': Color(0xFF00B4AB),
  'javascript': Color(0xFFF1E05A),
  'typescript': Color(0xFF3178C6),
  'python': Color(0xFF3572A5),
  'go': Color(0xFF00ADD8),
  'rust': Color(0xFFDEA584),
  'java': Color(0xFFB07219),
  'c': Color(0xFF555555),
  'c++': Color(0xFFF34B7D),
  'c#': Color(0xFF178600),
  'ruby': Color(0xFF701516),
  'php': Color(0xFF4F5D95),
  'swift': Color(0xFFF05138),
  'kotlin': Color(0xFFA97BFF),
  'shell': Color(0xFF89E051),
  'html': Color(0xFFE34C26),
  'css': Color(0xFF563D7C),
  'vue': Color(0xFF41B883),
  'svelte': Color(0xFFFF3E00),
  'objective-c': Color(0xFF438EFF),
  'lua': Color(0xFF000080),
  'zig': Color(0xFFEC915C),
  'elixir': Color(0xFF6E4A7E),
  'haskell': Color(0xFF5E5086),
  'scala': Color(0xFFC22D40),
  'clojure': Color(0xFFDB5855),
  'r': Color(0xFF198CE7),
  'jupyter notebook': Color(0xFFDA5B0B),
  'makefile': Color(0xFF427819),
};

/// A colored dot plus the language name.
class LanguageDot extends StatelessWidget {
  const LanguageDot({super.key, required this.language, this.fontSize = 11.5});

  final String? language;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final name = language?.trim() ?? '';
    if (name.isEmpty) return const SizedBox.shrink();
    final palette = context.palette;
    final color = _languageColors[name.toLowerCase()] ?? palette.brand;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          name,
          style: TextStyle(fontSize: fontSize, color: palette.textSecondary),
        ),
      ],
    );
  }
}

/// Resolves a GitHub-style color for [language], with a neutral fallback.
Color languageColor(
  String? language, {
  Color fallback = const Color(0xFF8B949E),
}) {
  final key = language?.trim().toLowerCase() ?? '';
  return _languageColors[key] ?? fallback;
}
