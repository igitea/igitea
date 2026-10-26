import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../../l10n/app_localizations.dart';
import '../../theme/app_palette.dart';

/// The desktop shortcut cheat sheet, opened with `?` or from the top bar.
Future<void> showAppShortcutsDialog(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  final isMac = defaultTargetPlatform == TargetPlatform.macOS;
  final mod = isMac ? '⌘' : 'Ctrl';

  return showFDialog<void>(
    context: context,
    builder: (context, style, animation) => FDialog(
      title: Text(l10n.keyboardShortcuts),
      body: SizedBox(
        width: 440,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ShortcutGroup(
              label: l10n.navigation,
              rows: [
                (l10n.search, '$mod K'),
                (l10n.switchSection, '$mod 1 – $mod 4'),
                (l10n.toggleSidebar, '$mod B'),
                (l10n.settings, '$mod ,'),
                (l10n.showShortcutSheet, '?'),
              ],
            ),
            const SizedBox(height: 18),
            _ShortcutGroup(
              label: l10n.interaction,
              rows: [
                (l10n.activateItemHint, isMac ? '↩' : 'Enter'),
                (l10n.contextMenuHint, l10n.rightClick),
                (l10n.openInNewPage, l10n.doubleClick),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              l10n.desktopOnlyHint,
              style: TextStyle(
                fontSize: 11.5,
                height: 1.45,
                color: context.palette.textSecondary,
              ),
            ),
          ],
        ),
      ),
      actions: [
        FButton(
          variant: .outline,
          onPress: () => Navigator.of(context).pop(),
          child: Text(l10n.close),
        ),
      ],
    ),
  );
}

class _ShortcutGroup extends StatelessWidget {
  const _ShortcutGroup({required this.label, required this.rows});

  final String label;
  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            color: palette.textSecondary.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 8),
        for (final row in rows)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    row.$1,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: palette.textPrimary,
                    ),
                  ),
                ),
                _KeyHint(text: row.$2),
              ],
            ),
          ),
      ],
    );
  }
}

class _KeyHint extends StatelessWidget {
  const _KeyHint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: palette.surfaceMuted,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: palette.border),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
          color: palette.textSecondary,
        ),
      ),
    );
  }
}
