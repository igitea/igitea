import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import 'app_chrome.dart';

/// A standard pushed page: Forui scaffold + the shared top bar with a back
/// action.
///
/// Centralising this keeps every secondary screen visually consistent and makes
/// new pages a one-liner. Content is centred and width-capped on large desktop
/// windows so forms and detail panes never stretch into unreadable lines.
class AppPage extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final List<Widget> actions;
  final Widget? footer;

  /// A full-width bar pinned under the content, such as a comment composer.
  /// Unlike [footer] it stays above the on-screen keyboard.
  final Widget? bottomBar;

  /// Whether the scaffold should apply its default padding around [child].
  final bool childPad;

  /// Whether to show the back button. Useful for root pages.
  final bool canPop;

  /// Max content width on wide windows; null keeps the content full-bleed.
  final double? maxContentWidth;

  const AppPage({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.actions = const [],
    this.footer,
    this.bottomBar,
    this.childPad = false,
    this.canPop = true,
    this.maxContentWidth = 1120,
  });

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: AppTopBar(
        topInset: windowTopInset(context),
        title: title,
        subtitle: subtitle,
        leading: canPop
            ? AppIconButton(
                icon: FIcons.chevronLeft,
                label: MaterialLocalizations.of(context).backButtonTooltip,
                onPress: () => Navigator.maybePop(context),
              )
            : null,
        actions: actions,
        height: 52,
      ),
      footer: footer,
      childPad: childPad,
      // A transparent Material ancestor keeps legacy Material widgets (InkWell,
      // ListTile, Chip, ...) working on pages that are not fully migrated yet.
      // The header already reserves the status-bar inset; leaving it in the
      // body makes every unpadded scroll view add a second, empty strip.
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Material(
          color: Colors.transparent,
          child: bottomBar == null
              ? _Constrained(maxWidth: maxContentWidth, child: child)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _Constrained(
                        maxWidth: maxContentWidth,
                        child: child,
                      ),
                    ),
                    bottomBar!,
                  ],
                ),
        ),
      ),
    );
  }
}

class _Constrained extends StatelessWidget {
  const _Constrained({required this.maxWidth, required this.child});

  final double? maxWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (maxWidth == null) return child;
    return LayoutBuilder(
      builder: (context, constraints) {
        final extra = constraints.maxWidth - maxWidth!;
        if (extra <= 0) return child;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: extra / 2),
          child: child,
        );
      },
    );
  }
}
