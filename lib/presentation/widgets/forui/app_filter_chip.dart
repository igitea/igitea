import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// A compact, Forui-styled filter chip with an optional remove action.
///
/// Used for active issue/repo filters and saved filters.
class AppFilterChip extends StatelessWidget {
  final String label;
  final VoidCallback? onPress;
  final VoidCallback? onRemove;

  const AppFilterChip({
    super.key,
    required this.label,
    this.onPress,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final content = Container(
      padding: EdgeInsets.only(
        left: 10,
        right: onRemove == null ? 10 : 4,
        top: 5,
        bottom: 5,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colors.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (onRemove != null) ...[
            const SizedBox(width: 2),
            FTappable(
              onPress: onRemove,
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: Icon(FIcons.x, size: 12, color: colors.onSurfaceVariant),
              ),
            ),
          ],
        ],
      ),
    );

    if (onPress == null) return content;
    return FTappable(onPress: onPress, child: content);
  }
}
