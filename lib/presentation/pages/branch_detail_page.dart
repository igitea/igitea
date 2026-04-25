import 'package:flutter/material.dart';

import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';

class BranchDetailPage extends StatelessWidget {
  final Branch branch;

  const BranchDetailPage({
    super.key,
    required this.branch,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(branch.name ?? ''),
      ),
      body: _buildContent(context, branch, l10n),
    );
  }

  Widget _buildContent(BuildContext context, Branch branch, AppLocalizations l10n) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Icon(
              Icons.call_split,
              color: theme.colorScheme.primary,
              size: 32,
            ),
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
          _buildInfoSection(context,
            title: l10n.latestCommit,
            children: [
              _buildInfoRow(context,
                icon: Icons.commit,
                label: l10n.sha,
                value: branch.commit!.id ?? '',
              ),
              if (branch.commit!.url != null)
                _buildInfoRow(context,
                  icon: Icons.open_in_new,
                  label: l10n.url,
                  value: branch.commit!.url!,
                  isLink: true,
                ),
            ],
          ),
        ],
        if (branch.user_can_push != null || branch.user_can_merge != null) ...[
          const SizedBox(height: 24),
          _buildInfoSection(context,
            title: l10n.permissions,
            children: [
              if (branch.user_can_push != null)
                _buildPermissionRow(context,
                  icon: Icons.push_pin,
                  label: l10n.canPush,
                  allowed: branch.user_can_push!,
                ),
              if (branch.user_can_merge != null)
                _buildPermissionRow(context,
                  icon: Icons.merge_type,
                  label: l10n.canMerge,
                  allowed: branch.user_can_merge!,
                ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildInfoSection(BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    bool isLink = false,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isLink ? theme.colorScheme.primary : null,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionRow(BuildContext context, {
    required IconData icon,
    required String label,
    required bool allowed,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          Icon(
            allowed ? Icons.check_circle : Icons.cancel,
            color: allowed ? Colors.green : Colors.red,
          ),
        ],
      ),
    );
  }
}