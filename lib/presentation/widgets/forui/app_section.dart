import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// A titled group of rows rendered as a Forui card.
///
/// Replaces the legacy [Card]-based section so every list surface in the app
/// shares the same radius, border and divider treatment.
class AppSection extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final List<Widget> children;
  final bool showHeader;

  const AppSection({
    super.key,
    required this.title,
    required this.children,
    this.showHeader = true,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showHeader && title.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                ?trailing,
              ],
            ),
          ),
        ],
        FCard.raw(
          child: Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0) const FDivider(),
                children[i],
              ],
            ],
          ),
        ),
      ],
    );
  }
}
