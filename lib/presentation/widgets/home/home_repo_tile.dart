import 'package:flutter/material.dart';

import '../../../data/models/generated/generated_models.dart';
import '../../../core/constants/ui_constants.dart';
import '../user_avatar.dart';

/// 首页仓库行：头像 + owner/name + chevron。
///
/// 纯展示组件，不依赖 DI / Injection / l10n。
class HomeRepoTile extends StatelessWidget {
  final Repository repo;
  final VoidCallback onTap;

  const HomeRepoTile({
    super.key,
    required this.repo,
    required this.onTap,
  });

  String get _ownerName =>
      repo.owner?.login ?? repo.full_name?.split('/').first ?? '';

  String get _repoName =>
      repo.name ?? repo.full_name?.split('/').last ?? '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: UIConstants.md,
          vertical: 10,
        ),
        child: Row(
          children: [
            if (repo.owner != null)
              UserAvatar(user: repo.owner!, radius: UIConstants.avatarMd)
            else
              Icon(
                Icons.public,
                size: UIConstants.iconMd,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            const SizedBox(width: UIConstants.iconTextSpacing),
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: _ownerName,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    TextSpan(
                      text: ' / ',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    TextSpan(
                      text: _repoName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: UIConstants.iconSm,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
