import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../theme/app_palette.dart';
import '../theme/app_theme.dart';

/// A shared, design-system-aware Markdown style.
///
/// Issue bodies, PR descriptions, wiki pages and file previews all read with
/// the same type scale, link color and code treatment.
MarkdownStyleSheet appMarkdownStyle(BuildContext context) {
  final palette = context.palette;
  final base = MarkdownStyleSheet.fromTheme(Theme.of(context));

  return base.copyWith(
    h1: TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      height: 1.3,
      color: palette.textPrimary,
    ),
    h2: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.3,
      height: 1.35,
      color: palette.textPrimary,
    ),
    h3: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.4,
      color: palette.textPrimary,
    ),
    h4: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.4,
      color: palette.textPrimary,
    ),
    p: TextStyle(fontSize: 13.5, height: 1.7, color: palette.textPrimary),
    a: TextStyle(
      fontSize: 13.5,
      height: 1.7,
      color: palette.brand,
      decoration: TextDecoration.underline,
      decorationColor: palette.brand.withValues(alpha: 0.4),
    ),
    em: TextStyle(fontStyle: FontStyle.italic, color: palette.textPrimary),
    strong: TextStyle(fontWeight: FontWeight.w600, color: palette.textPrimary),
    code: TextStyle(
      fontFamily: 'monospace',
      fontFamilyFallback: kMonoFontFallback,
      fontSize: 12,
      backgroundColor: Colors.transparent,
      color: palette.textPrimary,
    ),
    codeblockDecoration: BoxDecoration(
      color: palette.surfaceMuted,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: palette.border),
    ),
    codeblockPadding: const EdgeInsets.all(12),
    blockquoteDecoration: BoxDecoration(
      color: palette.surfaceMuted.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(8),
      border: Border(left: BorderSide(color: palette.brand, width: 3)),
    ),
    blockquotePadding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
    blockSpacing: 12,
    listIndent: 20,
    listBullet: TextStyle(
      fontSize: 13.5,
      height: 1.7,
      color: palette.textSecondary,
    ),
    horizontalRuleDecoration: BoxDecoration(
      border: Border(top: BorderSide(color: palette.border)),
    ),
    tableBorder: TableBorder.all(color: palette.border, width: 1),
    tableHead: TextStyle(
      fontWeight: FontWeight.w600,
      color: palette.textPrimary,
    ),
    tableBody: TextStyle(fontSize: 12.5, color: palette.textPrimary),
    tablePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
  );
}

/// Markdown rendered with [appMarkdownStyle].
class AppMarkdown extends StatelessWidget {
  const AppMarkdown({
    super.key,
    required this.data,
    this.selectable = true,
    this.onTapLink,
    this.shrinkWrap = false,
  });

  final String data;
  final bool selectable;
  final void Function(String text, String? href, String? title)? onTapLink;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: data,
      selectable: selectable,
      styleSheet: appMarkdownStyle(context),
      onTapLink: onTapLink,
      shrinkWrap: shrinkWrap,
    );
  }
}
