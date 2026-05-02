import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/animations/animated_wrapper.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/user_avatar.dart';
import 'edit_release_page.dart';

class ReleaseDetailPage extends StatefulWidget {
  final String owner;
  final String repo;
  final Release release;

  const ReleaseDetailPage({
    super.key,
    required this.owner,
    required this.repo,
    required this.release,
  });

  @override
  State<ReleaseDetailPage> createState() => _ReleaseDetailPageState();
}

class _ReleaseDetailPageState extends State<ReleaseDetailPage> {
  Future<void> _edit() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => EditReleasePage(
          owner: widget.owner,
          repo: widget.repo,
          release: widget.release,
        ),
      ),
    );
    if (result == true && mounted) {
      Navigator.pop(context, true);
    }
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteRelease),
        content: Text(l10n.deleteReleaseConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final success = await Injection.repoNotifier.deleteRelease(
        owner: widget.owner,
        repo: widget.repo,
        id: widget.release.id!,
      );
      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.releaseDeleted)),
          );
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.error)),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final release = widget.release;
    return Scaffold(
      appBar: AppBar(
        title: Text(release.tag_name ?? ''),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: l10n.editRelease,
            onPressed: _edit,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: l10n.deleteRelease,
            onPressed: _delete,
          ),
        ],
      ),
      body: _buildContent(context, release, l10n),
    );
  }

  Widget _buildContent(BuildContext context, Release release, AppLocalizations l10n) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(UIConstants.md),
      children: [
        Row(
          children: [
            const Icon(
              Icons.new_releases_outlined,
              size: 32,
              color: Colors.amber,
            ),
            const SizedBox(width: UIConstants.md),
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
              UserAvatar(user: release.author!, radius: 12),
              const SizedBox(width: 8),
              Text(release.author?.login ?? ''),
            ],
          ),
          const SizedBox(height: 16),
        ],
        if (release.published_at != null) ...[
          Text(
            '${l10n.publishedAt}: ${_formatDate(release.published_at!)}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
        ],
        if (release.target_commitish != null) ...[
          Text(
            '${l10n.target}: ${release.target_commitish}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
        ],
        if (release.body != null && release.body!.isNotEmpty) ...[
          Text(
            l10n.description,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SelectableText(release.body!),
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
          ...release.assets!.asMap().entries.map((entry) {
            final index = entry.key;
            final asset = entry.value;
            return FadeInWrapper(
              delay: Duration(milliseconds: index * 30),
              child: ListTile(
                leading: const Icon(Icons.attach_file),
                title: Text(asset.name ?? ''),
                subtitle: Text(_formatSize(asset.size ?? 0)),
                trailing: IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () {
                    if (asset.browser_download_url != null) {
                      launchUrl(Uri.parse(asset.browser_download_url!));
                    }
                  },
                ),
              ),
            );
          }),
          const SizedBox(height: 24),
        ],
        if (release.tarball_url != null || release.zipball_url != null) ...[
          Row(
            children: [
              if (release.tarball_url != null) ...[
                IconButton(
                  icon: const Icon(Icons.archive),
                  tooltip: l10n.tarball,
                  onPressed: () => launchUrl(Uri.parse(release.tarball_url!)),
                ),
                Text(l10n.tarball),
              ],
              const SizedBox(width: 16),
              if (release.zipball_url != null) ...[
                IconButton(
                  icon: const Icon(Icons.folder_zip),
                  tooltip: l10n.zipball,
                  onPressed: () => launchUrl(Uri.parse(release.zipball_url!)),
                ),
                Text(l10n.zipball),
              ],
            ],
          ),
        ],
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
