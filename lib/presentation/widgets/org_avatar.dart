import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
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

    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: avatarUrl,
        width: radius * 2,
        height: radius * 2,
        fit: BoxFit.cover,
        maxWidthDiskCache: 256,
        memCacheWidth: (radius * 6).round(),
        fadeInDuration: Duration.zero,
        placeholder: (_, _) => _buildFallback(theme, fallbackInitial),
        errorWidget: (_, _, _) => _buildFallback(theme, fallbackInitial),
      ),
    );
  }

  Widget _buildFallback(ThemeData theme, String initial) {
    return FAvatar.raw(
      size: radius * 2,
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