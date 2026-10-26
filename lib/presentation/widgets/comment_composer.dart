import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';

import '../../core/platform/desktop_layout.dart';
import '../../l10n/app_localizations.dart';
import '../theme/app_palette.dart';
import 'desktop/app_hover_region.dart';
import 'forui/app_chrome.dart';

/// A comment field pinned to the bottom of a conversation.
///
/// It stays put while the thread scrolls, grows to a few lines while typing,
/// rides above the on-screen keyboard and clears the home indicator. On
/// keyboard platforms ⌘/Ctrl + Enter sends.
class CommentComposer extends StatefulWidget {
  const CommentComposer({
    super.key,
    required this.controller,
    required this.onSend,
  });

  final TextEditingController controller;

  /// Posts the trimmed comment body; the field clears once it completes.
  final Future<void> Function(String body) onSend;

  @override
  State<CommentComposer> createState() => _CommentComposerState();
}

class _CommentComposerState extends State<CommentComposer> {
  bool _sending = false;

  bool get _canSend => !_sending && widget.controller.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
  }

  @override
  void didUpdateWidget(covariant CommentComposer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onChanged);
      widget.controller.addListener(_onChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() => setState(() {});

  Future<void> _send() async {
    if (!_canSend) return;
    final body = widget.controller.text.trim();
    setState(() => _sending = true);
    try {
      await widget.onSend(body);
      widget.controller.clear();
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = context.palette;
    final touch = DesktopLayout.isTouch();
    final isMac = defaultTargetPlatform == TargetPlatform.macOS;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.canvas,
        border: Border(top: BorderSide(color: palette.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: CallbackShortcuts(
                  bindings: {
                    const SingleActivator(LogicalKeyboardKey.enter, meta: true):
                        _send,
                    const SingleActivator(
                      LogicalKeyboardKey.enter,
                      control: true,
                    ): _send,
                  },
                  child: FTextField(
                    control: FTextFieldControl.managed(
                      controller: widget.controller,
                    ),
                    hint: l10n.writeComment,
                    textCapitalization: TextCapitalization.sentences,
                    minLines: 1,
                    maxLines: 6,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (!touch && _canSend) ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: 11),
                  child: KbdHint(text: isMac ? '⌘↩' : 'Ctrl ↩'),
                ),
                const SizedBox(width: 6),
              ],
              _SendButton(
                enabled: _canSend,
                sending: _sending,
                label: l10n.comment,
                size: touch ? 44 : 38,
                onPress: _send,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({
    required this.enabled,
    required this.sending,
    required this.label,
    required this.size,
    required this.onPress,
  });

  final bool enabled;
  final bool sending;
  final String label;
  final double size;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final foreground = palette.isDark ? const Color(0xFF04211D) : Colors.white;
    return AppHoverRegion(
      onTap: enabled ? onPress : null,
      semanticsLabel: label,
      tooltip: DesktopLayout.isTouch() ? null : label,
      hoverColor: Colors.transparent,
      borderRadius: BorderRadius.circular(size / 2),
      contentBuilder: (context, hovered, focused) => AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: enabled
              ? (hovered
                    ? Color.lerp(palette.brand, Colors.black, 0.08)
                    : palette.brand)
              : palette.surfaceMuted,
        ),
        child: Center(
          child: sending
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: foreground,
                  ),
                )
              : Icon(
                  FIcons.arrowUp,
                  size: size * 0.45,
                  color: enabled ? foreground : palette.textSecondary,
                ),
        ),
      ),
    );
  }
}
