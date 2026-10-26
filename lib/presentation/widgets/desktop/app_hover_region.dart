import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';

import '../../../core/animations/app_animations.dart';
import '../../theme/app_palette.dart';

/// One entry in an [AppHoverRegion]'s right-click menu.
class AppMenuItem {
  const AppMenuItem({
    required this.label,
    required this.onSelected,
    this.icon,
    this.shortcut,
    this.destructive = false,
    this.enabled = true,
  });

  final String label;
  final VoidCallback onSelected;
  final IconData? icon;
  final String? shortcut;
  final bool destructive;
  final bool enabled;
}

/// A pointer- and keyboard-aware interaction surface used by every dense
/// desktop row, card and icon button.
///
/// Two behaviours matter on a desktop:
/// * hover intent — a short enter/exit debounce so sweeping the pointer across
///   a list does not strobe every row it crosses;
/// * a single highlight layer — the background is painted behind the child so
///   hovering never rebuilds or re-lays-out the content.
///
/// The region also supports double click (open), secondary click (context
/// menu), Enter/Space activation, a focus ring and a hand cursor.
class AppHoverRegion extends StatefulWidget {
  const AppHoverRegion({
    super.key,
    this.child,
    this.onTap,
    this.onDoubleTap,
    this.onSecondaryTap,
    this.onLongPress,
    this.contextMenuItems = const [],
    this.selected = false,
    this.enabled = true,
    this.hoverColor,
    this.selectedColor,
    this.borderColor,
    this.hoverBorderColor,
    this.focusColor,
    this.borderRadius,
    this.padding,
    this.margin,
    this.cursor = SystemMouseCursors.click,
    this.focusNode,
    this.semanticsLabel,
    this.tooltip,
    this.enterDelay = const Duration(milliseconds: 30),
    this.exitDelay = const Duration(milliseconds: 60),
    this.animationDuration = const Duration(milliseconds: 110),
    this.contentBuilder,
    this.showFocusRing = true,
    this.focusRingRadius,
    this.onHoverChanged,
  });

  final Widget? child;

  /// Rebuilds the content for foreground changes (icon or text color).
  ///
  /// Prefer leaving this null: the hover wash is painted behind [child], so a
  /// plain child is never rebuilt on hover.
  final Widget Function(BuildContext context, bool hovered, bool focused)?
  contentBuilder;

  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onSecondaryTap;
  final VoidCallback? onLongPress;
  final List<AppMenuItem> contextMenuItems;
  final bool selected;
  final bool enabled;
  final Color? hoverColor;
  final Color? selectedColor;
  final Color? borderColor;
  final Color? hoverBorderColor;
  final Color? focusColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final MouseCursor cursor;
  final FocusNode? focusNode;
  final String? semanticsLabel;
  final String? tooltip;
  final Duration enterDelay;
  final Duration exitDelay;
  final Duration animationDuration;
  final bool showFocusRing;
  final BorderRadius? focusRingRadius;
  final ValueChanged<bool>? onHoverChanged;

  @override
  State<AppHoverRegion> createState() => _AppHoverRegionState();
}

class _AppHoverRegionState extends State<AppHoverRegion> {
  final MenuController _menuController = MenuController();
  Timer? _hoverTimer;
  bool _hovered = false;
  bool _focused = false;

  bool get _interactive =>
      widget.enabled &&
      (widget.onTap != null ||
          widget.onDoubleTap != null ||
          widget.onSecondaryTap != null ||
          widget.contextMenuItems.isNotEmpty);

  @override
  void dispose() {
    _hoverTimer?.cancel();
    _menuController.close();
    super.dispose();
  }

  void _onHover(bool value) {
    if (!_interactive) return;
    _hoverTimer?.cancel();
    final delay = value ? widget.enterDelay : widget.exitDelay;
    if (delay == Duration.zero) {
      if (_hovered != value) {
        setState(() => _hovered = value);
        widget.onHoverChanged?.call(value);
      }
      return;
    }
    _hoverTimer = Timer(delay, () {
      if (!mounted || _hovered == value) return;
      setState(() => _hovered = value);
      widget.onHoverChanged?.call(value);
    });
  }

  void _openContextMenu(TapDownDetails details) {
    if (widget.onSecondaryTap != null) {
      widget.onSecondaryTap!();
      return;
    }
    if (widget.contextMenuItems.isEmpty) return;
    final renderBox = context.findRenderObject();
    final offset = renderBox is RenderBox
        ? renderBox.globalToLocal(details.globalPosition)
        : details.localPosition;
    _menuController.open(position: offset);
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final radius = widget.borderRadius ?? BorderRadius.circular(10);
    final duration = AppAnimations.effective(context, widget.animationDuration);
    final focusColor = widget.focusColor ?? palette.brand;

    // Never animate to/from Colors.transparent: its RGB is black, so a color
    // lerp to a light hover wash passes through a dark grey frame. Use the
    // same colour at alpha 0 so only the alpha channel animates.
    final baseHover = widget.hoverColor ?? palette.surfaceMuted;
    final overlayTarget = widget.selected
        ? (widget.selectedColor ?? palette.brandSoft)
        : _hovered
        ? baseHover
        : null;
    final overlayColor = overlayTarget ?? baseHover.withValues(alpha: 0);

    final baseBorder = widget.borderColor ?? Colors.transparent;
    final hoverBorder =
        widget.hoverBorderColor ?? widget.borderColor ?? Colors.transparent;
    final offBorder = baseBorder.a == 0 && hoverBorder.a > 0
        ? hoverBorder.withValues(alpha: 0)
        : baseBorder;
    final borderColor = _hovered ? hoverBorder : offBorder;
    final showBorder = baseBorder.a > 0 || hoverBorder.a > 0;

    final content = widget.contentBuilder != null
        ? widget.contentBuilder!(context, _hovered, _focused)
        : (widget.child ?? const SizedBox.shrink());

    final body = Stack(
      children: [
        // Wash behind the content so the content itself never rebuilds.
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedContainer(
              duration: duration,
              curve: AppAnimations.easeOut,
              decoration: BoxDecoration(
                color: overlayColor,
                borderRadius: radius,
              ),
            ),
          ),
        ),
        Padding(padding: widget.padding ?? EdgeInsets.zero, child: content),
        // Border above the content: opaque card backgrounds must not hide it.
        if (showBorder)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedContainer(
                duration: duration,
                curve: AppAnimations.easeOut,
                decoration: BoxDecoration(
                  borderRadius: radius,
                  border: Border.all(color: borderColor),
                ),
              ),
            ),
          ),
        if (widget.showFocusRing)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedOpacity(
                duration: duration,
                opacity: _focused && widget.enabled ? 1 : 0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: widget.focusRingRadius ?? radius,
                    border: Border.all(
                      color: focusColor.withValues(alpha: 0.55),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );

    final interactive = FocusableActionDetector(
      enabled: _interactive,
      focusNode: widget.focusNode,
      mouseCursor: widget.enabled ? widget.cursor : MouseCursor.defer,
      onShowHoverHighlight: _onHover,
      onShowFocusHighlight: (value) {
        if (!mounted || _focused == value) return;
        setState(() => _focused = value);
      },
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
        SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
      },
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            widget.onTap?.call();
            return null;
          },
        ),
      },
      child: Listener(
        // A double-click recognizer delays GestureDetector.onTap until the
        // double-tap window closes. Fire selection on pointer down instead so
        // single clicks stay instant while double click still opens the full
        // page.
        onPointerDown: widget.onDoubleTap != null && widget.onTap != null
            ? (event) {
                if (event.buttons == kPrimaryButton) widget.onTap!();
              }
            : null,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onDoubleTap == null ? widget.onTap : null,
          onDoubleTap: widget.onDoubleTap,
          onSecondaryTapDown: _openContextMenu,
          onLongPress: widget.onLongPress,
          child: widget.margin == null
              ? body
              : Padding(padding: widget.margin!, child: body),
        ),
      ),
    );

    Widget anchor = interactive;
    if (widget.contextMenuItems.isNotEmpty) {
      anchor = MenuAnchor(
        controller: _menuController,
        style: _menuStyle(palette),
        menuChildren: [
          for (final item in widget.contextMenuItems)
            MenuItemButton(
              onPressed: item.enabled ? item.onSelected : null,
              style: _menuItemStyle(palette, item.destructive),
              leadingIcon: item.icon == null
                  ? null
                  : Icon(
                      item.icon,
                      size: 15,
                      color: item.destructive
                          ? palette.danger
                          : palette.textSecondary,
                    ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: item.enabled
                            ? (item.destructive
                                  ? palette.danger
                                  : palette.textPrimary)
                            : palette.textSecondary.withValues(alpha: 0.55),
                      ),
                    ),
                  ),
                  if (item.shortcut != null) ...[
                    const SizedBox(width: 16),
                    Text(
                      item.shortcut!,
                      style: TextStyle(
                        fontSize: 10.5,
                        color: palette.textSecondary,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ],
              ),
            ),
        ],
        builder: (context, controller, _) => interactive,
      );
    }

    anchor = Semantics(
      button: _interactive,
      label: widget.semanticsLabel,
      child: anchor,
    );

    if (widget.tooltip != null && widget.tooltip!.isNotEmpty) {
      anchor = FTooltip(
        tipBuilder: (context, controller) => Text(widget.tooltip!),
        child: anchor,
      );
    }
    return anchor;
  }

  MenuStyle _menuStyle(AppPalette palette) {
    return MenuStyle(
      backgroundColor: WidgetStatePropertyAll(palette.surface),
      elevation: const WidgetStatePropertyAll(10),
      padding: const WidgetStatePropertyAll(EdgeInsets.all(5)),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: palette.border),
        ),
      ),
      minimumSize: const WidgetStatePropertyAll(Size(196, 0)),
    );
  }

  ButtonStyle _menuItemStyle(AppPalette palette, bool destructive) {
    return ButtonStyle(
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      ),
      overlayColor: WidgetStatePropertyAll(
        destructive
            ? palette.dangerSoft
            : palette.surfaceMuted.withValues(alpha: 0.9),
      ),
      minimumSize: const WidgetStatePropertyAll(Size(0, 30)),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
