import 'package:flutter/material.dart';
import '../../data/models/generated/generated_models.dart';

class UserAvatar extends StatelessWidget {
  final User user;
  final double radius;

  const UserAvatar({super.key, required this.user, this.radius = 20});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CircleAvatar(
      radius: radius,
      backgroundImage:
          user.avatar_url != null ? NetworkImage(user.avatar_url!) : null,
      child: user.avatar_url == null
          ? Text(
              (user.login ?? '?')[0].toUpperCase(),
              style: TextStyle(
                fontSize: radius * 0.9,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          : null,
    );
  }
}