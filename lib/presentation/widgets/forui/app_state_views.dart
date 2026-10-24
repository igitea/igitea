import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../../l10n/app_localizations.dart';
import '../../theme/app_palette.dart';

/// Turns low-level transport failures into a short, human sentence.
String friendlyErrorMessage(BuildContext context, String message) {
  final l10n = AppLocalizations.of(context)!;
  final lower = message.toLowerCase();
  if (lower.contains('timed out') || lower.contains('timeout')) {
    return l10n.requestTimedOut;
  }
  if (lower.contains('network') ||
      lower.contains('connection') ||
      lower.contains('socket') ||
      lower.contains('failed host lookup')) {
    return l10n.networkError;
  }
  return message;
}

/// A centered loading indicator used while a page's first data load runs.
class AppLoading extends StatelessWidget {
  const AppLoading({super.key, this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const FCircularProgress(),
          if (label != null) ...[
            const SizedBox(height: 12),
            Text(
              label!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// A centered empty state with an optional action.
class AppEmpty extends StatelessWidget {
  const AppEmpty({
    super.key,
    required this.title,
    this.icon = FIcons.inbox,
    this.subtitle,
    this.action,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;

    final palette = context.palette;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: palette.surfaceMuted,
                shape: BoxShape.circle,
                border: Border.all(color: palette.border),
              ),
              child: Icon(icon, size: 20, color: muted),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: palette.textPrimary,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 340),
                child: Text(
                  subtitle!,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 12,
                    color: muted,
                  ),
                ),
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: 18),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 240),
                child: action!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A centered error state with a retry button.
class AppError extends StatelessWidget {
  const AppError({super.key, required this.message, this.onRetry, this.title});

  final String message;
  final VoidCallback? onRetry;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final palette = context.palette;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: palette.dangerSoft,
                shape: BoxShape.circle,
              ),
              child: Icon(FIcons.circleAlert, size: 20, color: palette.danger),
            ),
            const SizedBox(height: 14),
            Text(
              title ?? l10n.error,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Text(
                friendlyErrorMessage(context, message),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              FButton(
                variant: .outline,
                size: .sm,
                mainAxisSize: .min,
                onPress: onRetry,
                child: Text(l10n.retry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// An inline placeholder row used inside home sections.
class AppSectionPlaceholder extends StatelessWidget {
  const AppSectionPlaceholder({
    super.key,
    this.text,
    this.showProgress = false,
    this.onRetry,
  });

  final String? text;
  final bool showProgress;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (showProgress) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: FCircularProgress(size: .sm)),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text ?? '',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          if (onRetry != null)
            FButton(
              variant: .ghost,
              size: .sm,
              onPress: onRetry,
              child: Text(AppLocalizations.of(context)!.retry),
            ),
        ],
      ),
    );
  }
}
