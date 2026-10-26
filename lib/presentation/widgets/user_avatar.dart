import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import 'avatar_fallback.dart';

class UserAvatar extends StatelessWidget {
  final User user;
  final double radius;

  const UserAvatar({super.key, required this.user, this.radius = 20});

  String get _resolvedUrl {
    final url = user.avatar_url;
    if (url == null || url.isEmpty) return '';
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    final baseUrl = Injection.apiClient.baseUrl;
    if (baseUrl.isEmpty) return url;
    final separator = baseUrl.endsWith('/') || url.startsWith('/') ? '' : '/';
    return '$baseUrl$separator$url';
  }

  @override
  Widget build(BuildContext context) {
    final avatarUrl = _resolvedUrl;

    if (avatarUrl.isEmpty) {
      return _buildFallback();
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
        placeholder: (_, _) => _buildFallback(),
        errorWidget: (_, _, _) => _buildFallback(),
      ),
    );
  }

  Widget _buildFallback() {
    return AvatarFallback(name: user.login ?? '?', size: radius * 2);
  }
}
