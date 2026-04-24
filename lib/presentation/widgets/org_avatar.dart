import 'package:flutter/material.dart';
import '../../data/models/generated/generated_models.dart';

class OrgAvatar extends StatelessWidget {
  final Organization org;
  final double radius;

  const OrgAvatar({super.key, required this.org, this.radius = 24});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CircleAvatar(
      radius: radius,
      backgroundImage:
          org.avatar_url != null ? NetworkImage(org.avatar_url!) : null,
      child: org.avatar_url == null
          ? Text(
              (org.username ?? '?')[0].toUpperCase(),
              style: TextStyle(
                fontSize: radius * 0.9,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          : null,
    );
  }
}