import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// A standard pushed page: Forui scaffold + nested header with a back action.
///
/// Centralising this keeps every secondary screen visually consistent and makes
/// new pages a one-liner.
class AppPage extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget> actions;
  final Widget? footer;

  /// Whether the scaffold should apply its default padding around [child].
  final bool childPad;

  /// Whether to show the back button. Useful for root pages.
  final bool canPop;

  const AppPage({
    super.key,
    required this.title,
    required this.child,
    this.actions = const [],
    this.footer,
    this.childPad = false,
    this.canPop = true,
  });

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        titleAlignment: Alignment.centerLeft,
        prefixes: [
          if (canPop)
            FHeaderAction.back(onPress: () => Navigator.maybePop(context)),
        ],
        title: Text(title),
        suffixes: actions,
      ),
      footer: footer,
      childPad: childPad,
      child: child,
    );
  }
}
