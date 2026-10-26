import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import 'avatar_fallback.dart';

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

  BorderRadius get _radius => BorderRadius.circular(radius * 0.5);

  @override
  Widget build(BuildContext context) {
    final avatarUrl = _resolvedUrl;

    if (avatarUrl.isEmpty) {
      return _buildFallback();
    }

    return ClipRRect(
      borderRadius: _radius,
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
    return AvatarFallback(
      name: org.username ?? '?',
      size: radius * 2,
      borderRadius: _radius,
    );
  }
}
