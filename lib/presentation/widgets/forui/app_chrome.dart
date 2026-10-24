import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../../core/animations/app_animations.dart';
import '../../theme/app_palette.dart';

/// Height reserved for the macOS traffic lights when the Flutter view extends
/// under a transparent title bar.
const double kMacWindowInset = 30;

/// The top inset content must leave for the OS window chrome.
double windowTopInset(BuildContext context) {
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.macOS) {
    return kMacWindowInset;
  }
  return MediaQuery.paddingOf(context).top;
}

/// The brand mark: a soft teal tile with the Lucide code glyph.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 28, this.iconSize = 15});

  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final end = Color.lerp(palette.brand, palette.success, 0.42)!;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [palette.brand, end],
        ),
        borderRadius: BorderRadius.circular(size * 0.3),
        boxShadow: [
          BoxShadow(
            color: palette.brand.withValues(alpha: 0.28),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(
        FIcons.squareCode,
        size: iconSize,
        color: palette.isDark ? const Color(0xFF05201C) : Colors.white,
      ),
    );
  }
}

/// A compact icon button with a hover wash and an optional tooltip.
class AppIconButton extends StatefulWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.label,
    this.onPress,
    this.size = 32,
    this.iconSize = 17,
    this.selected = false,
    this.badge = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPress;
  final double size;
  final double iconSize;
  final bool selected;
  final bool badge;

  @override
  State<AppIconButton> createState() => _AppIconButtonState();
}

class _AppIconButtonState extends State<AppIconButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final foreground = widget.selected || _hovered
        ? palette.textPrimary
        : palette.textSecondary;

    Widget button = FTappable(
      onPress: widget.onPress,
      semanticsLabel: widget.label,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: AppAnimations.effective(context, AppAnimations.fast),
          curve: AppAnimations.easeOut,
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: widget.selected
                ? palette.brandSoft
                : _hovered
                ? palette.surfaceMuted
                : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedSwitcher(
                duration: AppAnimations.effective(context, AppAnimations.fast),
                switchInCurve: AppAnimations.easeOut,
                switchOutCurve: AppAnimations.easeIn,
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: Tween<double>(
                      begin: 0.92,
                      end: 1,
                    ).animate(animation),
                    child: child,
                  ),
                ),
                child: Icon(
                  widget.icon,
                  key: ValueKey(widget.icon),
                  size: widget.iconSize,
                  color: foreground,
                ),
              ),
              if (widget.badge)
                Positioned(
                  right: 8,
                  top: 7,
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: palette.brand,
                      shape: BoxShape.circle,
                      border: Border.all(color: palette.canvas, width: 1),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    if (widget.label.isNotEmpty) {
      button = FTooltip(
        tipBuilder: (context, controller) => Text(widget.label),
        child: button,
      );
    }
    return button;
  }
}

/// A small keyboard hint such as `⌘K`.
class KbdHint extends StatelessWidget {
  const KbdHint({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: palette.surfaceMuted,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: palette.border),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          height: 1.1,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.2,
          color: palette.textSecondary,
        ),
      ),
    );
  }
}

/// A pill-shaped search affordance for the header. Tapping it focuses the
/// Explore tab's search field.
class AppSearchPrompt extends StatefulWidget {
  const AppSearchPrompt({
    super.key,
    required this.label,
    required this.hint,
    required this.onPress,
    this.width = 220,
  });

  final String label;
  final String hint;
  final VoidCallback onPress;
  final double width;

  @override
  State<AppSearchPrompt> createState() => _AppSearchPromptState();
}

class _AppSearchPromptState extends State<AppSearchPrompt> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return FTappable(
      onPress: widget.onPress,
      semanticsLabel: widget.label,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: AppAnimations.effective(context, AppAnimations.fast),
          curve: AppAnimations.easeOut,
          width: widget.width,
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: _hovered
                ? palette.surface
                : palette.surface.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(9),
            border: Border.all(
              color: _hovered ? palette.borderStrong : palette.border,
            ),
          ),
          child: Row(
            children: [
              Icon(FIcons.search, size: 14, color: palette.textSecondary),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  widget.label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: palette.textSecondary,
                  ),
                ),
              ),
              KbdHint(text: widget.hint),
            ],
          ),
        ),
      ),
    );
  }
}

/// The header shared by the app shell and every pushed page.
class AppTopBar extends StatelessWidget {
  const AppTopBar({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions = const [],
    this.topInset = 0,
    this.showBorder = true,
    this.height = 56,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget> actions;
  final double topInset;
  final bool showBorder;
  final double height;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final theme = Theme.of(context);

    return Container(
      height: topInset + height,
      padding: EdgeInsets.only(top: topInset, left: 20, right: 14),
      decoration: showBorder
          ? BoxDecoration(
              border: Border(bottom: BorderSide(color: palette.border)),
              color: palette.canvas,
            )
          : null,
      child: Row(
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 8)],
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                    color: palette.textPrimary,
                  ),
                ),
                if (subtitle != null && subtitle!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: palette.textSecondary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          if (actions.isNotEmpty)
            FHeaderData(
              // Pushed pages still pass FHeaderAction widgets; giving them a
              // matching action style keeps those pages working under the
              // custom top bar.
              actionStyle: FHeaderActionStyle.inherit(
                colors: FTheme.of(context).colors,
                style: FTheme.of(context).style,
                size: 18,
                padding: const EdgeInsets.all(7),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final action in actions) ...[
                    action,
                    const SizedBox(width: 2),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// One row in the desktop sidebar.
class SidebarNavItem extends StatefulWidget {
  const SidebarNavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onPress,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onPress;
  final Widget? trailing;

  @override
  State<SidebarNavItem> createState() => _SidebarNavItemState();
}

class _SidebarNavItemState extends State<SidebarNavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final foreground = widget.selected ? palette.brand : palette.textSecondary;

    return FTappable(
      onPress: widget.onPress,
      semanticsLabel: widget.label,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: AppAnimations.effective(context, AppAnimations.fast),
          curve: AppAnimations.easeOut,
          height: 36,
          margin: const EdgeInsets.symmetric(vertical: 1),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: widget.selected
                ? palette.brandSoft
                : _hovered
                ? palette.surfaceMuted
                : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: AppAnimations.effective(context, AppAnimations.fast),
                width: 3,
                height: widget.selected ? 15 : 0,
                margin: EdgeInsets.only(right: widget.selected ? 8 : 0),
                decoration: BoxDecoration(
                  color: palette.brand,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Icon(widget.icon, size: 17, color: foreground),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  widget.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: widget.selected
                        ? FontWeight.w600
                        : FontWeight.w500,
                    color: widget.selected
                        ? palette.brand
                        : palette.textPrimary,
                  ),
                ),
              ),
              if (widget.trailing != null) widget.trailing!,
            ],
          ),
        ),
      ),
    );
  }
}

/// A small uppercase-ish group label in the sidebar.
class SidebarLabel extends StatelessWidget {
  const SidebarLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 14, 10, 6),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
          color: context.palette.textSecondary.withValues(alpha: 0.8),
        ),
      ),
    );
  }
}

/// A compact segmented control used for mode switches (search scope, auth
/// method, filters).
class AppSegmentedControl extends StatelessWidget {
  const AppSegmentedControl({
    super.key,
    required this.index,
    required this.labels,
    required this.onChanged,
  });

  final int index;
  final List<String> labels;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      height: 34,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: palette.surfaceMuted,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: FTappable(
                onPress: () => onChanged(i),
                semanticsLabel: labels[i],
                child: AnimatedContainer(
                  duration: AppAnimations.effective(
                    context,
                    AppAnimations.fast,
                  ),
                  curve: AppAnimations.easeOut,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: i == index ? palette.surface : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: i == index ? palette.border : Colors.transparent,
                    ),
                    boxShadow: i == index
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    labels[i],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: i == index
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: i == index
                          ? palette.textPrimary
                          : palette.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
