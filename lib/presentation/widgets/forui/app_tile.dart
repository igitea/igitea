import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// A single tappable row inside an [AppSection].
///
/// Uses [FTappable] so press/hover/focus feedback matches Forui widgets.
class AppTile extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onPress;
  final bool showChevron;
  final String? semanticsLabel;

  /// Renders the title in the destructive color (e.g. sign out).
  final bool destructive;

  const AppTile({
    super.key,
    required this.title,
    this.leading,
    this.subtitle,
    this.trailing,
    this.onPress,
    this.showChevron = true,
    this.semanticsLabel,
    this.destructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;

    return FTappable(
      onPress: onPress,
      semanticsLabel: semanticsLabel,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 12)],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: destructive
                          ? theme.colorScheme.error
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  if (subtitle != null && subtitle!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: muted,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 8),
              trailing!,
            ] else if (showChevron) ...[
              const SizedBox(width: 8),
              Icon(FIcons.chevronRight, size: 16, color: muted),
            ],
          ],
        ),
      ),
    );
  }
}
