import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/forui/app_page.dart';
import '../widgets/forui/app_section.dart';
import '../widgets/forui/app_tile.dart';

class BranchDetailPage extends StatelessWidget {
  final Branch branch;

  const BranchDetailPage({super.key, required this.branch});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppPage(
      title: branch.name ?? '',
      child: _buildContent(context, branch, l10n),
    );
  }

  Widget _buildContent(
    BuildContext context,
    Branch branch,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Icon(FIcons.gitBranch, color: theme.colorScheme.primary, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    branch.name ?? '',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (branch.protected == true)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        l10n.protected,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        if (branch.commit != null) ...[
          AppSection(
            title: l10n.latestCommit,
            children: [
              AppTile(
                leading: const Icon(FIcons.gitCommitHorizontal, size: 18),
                title: l10n.sha,
                subtitle: branch.commit!.id ?? '',
                showChevron: false,
              ),
              if (branch.commit!.url != null)
                AppTile(
                  leading: const Icon(FIcons.externalLink, size: 18),
                  title: l10n.url,
                  subtitle: branch.commit!.url!,
                  showChevron: false,
                ),
            ],
          ),
        ],
        if (branch.user_can_push != null || branch.user_can_merge != null) ...[
          const SizedBox(height: 24),
          AppSection(
            title: l10n.permissions,
            children: [
              if (branch.user_can_push != null)
                AppTile(
                  leading: const Icon(FIcons.upload, size: 18),
                  title: l10n.canPush,
                  showChevron: false,
                  trailing: Icon(
                    branch.user_can_push! ? FIcons.circleCheck : FIcons.circleX,
                    size: 18,
                    color: branch.user_can_push!
                        ? Colors.green
                        : theme.colorScheme.error,
                  ),
                ),
              if (branch.user_can_merge != null)
                AppTile(
                  leading: const Icon(FIcons.gitMerge, size: 18),
                  title: l10n.canMerge,
                  showChevron: false,
                  trailing: Icon(
                    branch.user_can_merge!
                        ? FIcons.circleCheck
                        : FIcons.circleX,
                    size: 18,
                    color: branch.user_can_merge!
                        ? Colors.green
                        : theme.colorScheme.error,
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
