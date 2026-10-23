import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/forui/app_page.dart';
import '../widgets/forui/app_section.dart';
import '../widgets/forui/app_tile.dart';

class TagDetailPage extends StatelessWidget {
  final Tag tag;

  const TagDetailPage({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppPage(
      title: tag.name ?? '',
      child: _buildContent(context, tag, l10n),
    );
  }

  Widget _buildContent(BuildContext context, Tag tag, AppLocalizations l10n) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Icon(FIcons.tag, color: theme.colorScheme.primary, size: 32),
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
          AppSection(
            title: l10n.message,
            children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: Text(tag.message!, style: theme.textTheme.bodyMedium),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
        if (tag.commit != null) ...[
          AppSection(
            title: l10n.commit,
            children: [
              AppTile(
                leading: const Icon(FIcons.fingerprintPattern, size: 18),
                title: l10n.sha,
                subtitle: tag.commit!.sha ?? '',
                showChevron: false,
              ),
              if (tag.commit!.url != null)
                AppTile(
                  leading: const Icon(FIcons.externalLink, size: 18),
                  title: l10n.url,
                  subtitle: tag.commit!.url!,
                  showChevron: false,
                ),
            ],
          ),
          const SizedBox(height: 24),
        ],
        if (tag.tarball_url != null || tag.zipball_url != null) ...[
          AppSection(
            title: l10n.downloads,
            children: [
              if (tag.tarball_url != null)
                _buildDownloadTile(
                  label: l10n.tarball,
                  url: tag.tarball_url!,
                  icon: FIcons.archive,
                ),
              if (tag.zipball_url != null)
                _buildDownloadTile(
                  label: l10n.zipball,
                  url: tag.zipball_url!,
                  icon: FIcons.package,
                ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildDownloadTile({
    required String label,
    required String url,
    required IconData icon,
  }) {
    return AppTile(
      leading: Icon(icon, size: 18),
      title: label,
      showChevron: false,
      trailing: const Icon(FIcons.download, size: 16),
      onPress: () => launchUrl(Uri.parse(url)),
    );
  }
}
