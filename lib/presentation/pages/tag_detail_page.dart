import 'package:flutter/material.dart';

import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';

class TagDetailPage extends StatelessWidget {
  final Tag tag;

  const TagDetailPage({
    super.key,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(tag.name ?? ''),
      ),
      body: _buildContent(context, tag, l10n),
    );
  }

  Widget _buildContent(BuildContext context, Tag tag, AppLocalizations l10n) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Icon(
              Icons.label,
              color: theme.colorScheme.primary,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tag.name ?? '',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (tag.id != null)
                    Text(
                      tag.id!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        if (tag.message != null && tag.message!.isNotEmpty) ...[
          _buildInfoSection(context,
            title: l10n.message,
            children: [
              Text(
                tag.message!,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
        if (tag.commit != null) ...[
          _buildInfoSection(context,
            title: l10n.commit,
            children: [
              _buildInfoRow(context,
                icon: Icons.fingerprint,
                label: l10n.sha,
                value: tag.commit!.sha ?? '',
              ),
              if (tag.commit!.url != null)
                _buildInfoRow(context,
                  icon: Icons.open_in_new,
                  label: l10n.url,
                  value: tag.commit!.url!,
                  isLink: true,
                ),
            ],
          ),
          const SizedBox(height: 24),
        ],
        if (tag.tarball_url != null || tag.zipball_url != null) ...[
          _buildInfoSection(context,
            title: l10n.downloads,
            children: [
              if (tag.tarball_url != null)
                _buildDownloadButton(
                  label: l10n.tarball,
                  url: tag.tarball_url!,
                ),
              if (tag.zipball_url != null)
                _buildDownloadButton(
                  label: l10n.zipball,
                  url: tag.zipball_url!,
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

  Widget _buildDownloadButton({required String label, required String url}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.download),
        label: Text(label),
      ),
    );
  }
}