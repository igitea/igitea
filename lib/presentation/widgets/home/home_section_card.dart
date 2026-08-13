import 'package:flutter/material.dart';

import '../../../core/constants/ui_constants.dart';

/// 首页区块卡片：可选标题 + 内部若干行（行间自动 1px Divider）。
///
/// 纯展示组件，不依赖 DI / Injection / l10n。
class HomeSectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final bool showHeader;
  final Widget? trailing;

  const HomeSectionCard({
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
        if (showHeader) ...[
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              ?trailing,
            ],
          ),
          const SizedBox(height: UIConstants.sm),
        ],
        Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(UIConstants.cardRadius),
            side: BorderSide(color: theme.colorScheme.outlineVariant),
          ),
          child: Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0) const Divider(height: 1),
                children[i],
              ],
            ],
          ),
        ),
      ],
    );
  }
}
