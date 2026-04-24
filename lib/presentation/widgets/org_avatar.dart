import 'package:flutter/material.dart';
import '../../data/models/generated/generated_models.dart';

class OrgAvatar extends StatelessWidget {
  final Organization org;
  final double radius;

  const OrgAvatar({super.key, required this.org, this.radius = 24});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final avatarUrl = org.avatar_url;
    final fallbackInitial = (org.username ?? '?')[0].toUpperCase();

    if (avatarUrl == null || avatarUrl.isEmpty) {
      return _buildFallback(theme, fallbackInitial);
    }

    return ClipOval(
      child: Image.network(
        avatarUrl,
        width: radius * 2,
        height: radius * 2,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallback(theme, fallbackInitial);
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildFallback(theme, fallbackInitial);
        },
      ),
    );
  }

  Widget _buildFallback(ThemeData theme, String initial) {
    return CircleAvatar(
      radius: radius,
      child: Text(
        initial,
        style: TextStyle(
          fontSize: radius * 0.9,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}