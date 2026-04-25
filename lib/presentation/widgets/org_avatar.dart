import 'package:flutter/material.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';

class OrgAvatar extends StatelessWidget {
  final Organization org;
  final double radius;

  const OrgAvatar({super.key, required this.org, this.radius = 24});

  String get _resolvedUrl {
    final url = org.avatar_url;
    if (url == null || url.isEmpty) return '';
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    final baseUrl = Injection.apiClient.baseUrl;
    if (baseUrl.isEmpty) return url;
    final separator = baseUrl.endsWith('/') || url.startsWith('/') ? '' : '/';
    return '$baseUrl$separator$url';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final avatarUrl = _resolvedUrl;
    final fallbackInitial = (org.username ?? '?')[0].toUpperCase();

    if (avatarUrl.isEmpty) {
      return _buildFallback(theme, fallbackInitial);
    }

    return CircleAvatar(
      radius: radius,
      backgroundImage: NetworkImage(avatarUrl),
      onBackgroundImageError: (_, __) {},
      child: Text(
        fallbackInitial,
        style: TextStyle(
          fontSize: radius * 0.9,
          color: theme.colorScheme.onSurfaceVariant,
        ),
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