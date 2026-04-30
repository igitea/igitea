import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/animations/animated_wrapper.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/user_avatar.dart';

class ReleaseDetailPage extends StatelessWidget {
  final Release release;

  const ReleaseDetailPage({
    super.key,
    required this.release,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(release.tag_name ?? ''),
      ),
      body: _buildContent(context, release, l10n),
    );
  }

  Widget _buildContent(BuildContext context, Release release, AppLocalizations l10n) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            const Icon(
              Icons.new_releases_outlined,
              size: 32,
              color: Colors.amber,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    release.name ?? release.tag_name ?? '',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (release.prerelease == true)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        l10n.preRelease,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.orange,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (release.author != null) ...[
          Row(
            children: [
              UserAvatar(user: release.author!, radius: 16),
              const SizedBox(width: 8),
              Text(
                release.author!.login ?? release.author!.full_name ?? '',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
        if (release.published_at != null)
          _buildInfoRow(
            context,
            icon: Icons.calendar_today_outlined,
            label: l10n.publishedAt,
            value: _formatDate(release.published_at!),
          ),
        if (release.target_commitish != null)
          _buildInfoRow(
            context,
            icon: Icons.commit,
            label: l10n.target,
            value: release.target_commitish!,
          ),
        const SizedBox(height: 16),
        if (release.body != null && release.body!.isNotEmpty) ...[
          Text(
            l10n.description,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            release.body!,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
        ],
        if (release.assets != null && release.assets!.isNotEmpty) ...[
          Text(
            l10n.assets,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...release.assets!.asMap().entries.map((entry) => FadeInWrapper(
            delay: Duration(milliseconds: entry.key * 30),
            child: _buildAssetTile(context, entry.value, l10n),
          )),
        ],
        if (release.tarball_url != null || release.zipball_url != null) ...[
          const SizedBox(height: 24),
          Text(
            l10n.downloads,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (release.tarball_url != null)
            ListTile(
              leading: const Icon(Icons.archive),
              title: Text(l10n.tarball),
              trailing: const Icon(Icons.download),
              onTap: () => _launchUrl(release.tarball_url!),
            ),
          if (release.zipball_url != null)
            ListTile(
              leading: const Icon(Icons.folder_zip),
              title: Text(l10n.zipball),
              trailing: const Icon(Icons.download),
              onTap: () => _launchUrl(release.zipball_url!),
            ),
        ],
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
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
              style: theme.textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetTile(BuildContext context, Attachment asset, AppLocalizations l10n) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.insert_drive_file),
        title: Text(asset.name ?? ''),
        subtitle: asset.size != null
            ? Text(_formatBytes(asset.size!))
            : null,
        trailing: const Icon(Icons.download),
        onTap: asset.browser_download_url != null
            ? () => _launchUrl(asset.browser_download_url!)
            : null,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
