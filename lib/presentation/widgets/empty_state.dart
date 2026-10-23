import 'package:flutter/material.dart';

import 'forui/app_state_views.dart';

/// The app-wide empty state.
///
/// Delegates to [AppEmpty] so every empty surface shares the Forui look while
/// keeping the original API used across the app.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return AppEmpty(
      icon: icon,
      title: title,
      subtitle: subtitle,
      action: action,
    );
  }
}
