import 'dart:async';

import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// Full-screen loading indicator that surfaces a "network seems slow"
/// hint after [hintDelay], so a slow request reads as "still working"
/// instead of a frozen UI.
class SlowLoadingIndicator extends StatefulWidget {
  final Duration hintDelay;

  const SlowLoadingIndicator({super.key, this.hintDelay = const Duration(seconds: 10)});

  @override
  State<SlowLoadingIndicator> createState() => _SlowLoadingIndicatorState();
}

class _SlowLoadingIndicatorState extends State<SlowLoadingIndicator> {
  bool _showHint = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.hintDelay, () {
      if (mounted) setState(() => _showHint = true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          if (_showHint) ...[
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                AppLocalizations.of(context)!.stillLoading,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
