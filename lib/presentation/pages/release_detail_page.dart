import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/animations/animated_wrapper.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/forui/app_page.dart';
import '../widgets/forui/app_tile.dart';
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
    final confirmed = await showFDialog<bool>(
      context: context,
      builder: (ctx, style, animation) => FDialog(
        title: Text(l10n.deleteRelease),
        body: Text(l10n.deleteReleaseConfirm),
        actions: [
          FButton(
            variant: .outline,
            onPress: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FButton(
            variant: .destructive,
            onPress: () => Navigator.pop(ctx, true),
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
          showFToast(context: context, title: Text(l10n.releaseDeleted));
          Navigator.pop(context, true);
        } else {
          showFToast(
            context: context,
            variant: .destructive,
            title: Text(l10n.error),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final release = widget.release;
    return AppPage(
      title: release.tag_name ?? '',
      actions: [
        FHeaderAction(
          icon: const Icon(FIcons.pencil),
          semanticsLabel: l10n.editRelease,
          onPress: _edit,
        ),
        FHeaderAction(
          icon: const Icon(FIcons.trash2),
          semanticsLabel: l10n.deleteRelease,
          onPress: _delete,
        ),
      ],
      child: _buildContent(context, release, l10n),
    );
  }

  Widget _buildContent(
    BuildContext context,
    Release release,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(UIConstants.md),
      children: [
        Row(
          children: [
            const Icon(FIcons.tag, size: 32, color: Colors.amber),
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
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: FCard.raw(
                  child: AppTile(
                    leading: const Icon(FIcons.file, size: 18),
                    title: asset.name ?? '',
                    subtitle: _formatSize(asset.size ?? 0),
                    showChevron: false,
                    trailing: const Icon(FIcons.download, size: 16),
                    onPress: () {
                      if (asset.browser_download_url != null) {
                        launchUrl(Uri.parse(asset.browser_download_url!));
                      }
                    },
                  ),
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
                FButton(
                  variant: .outline,
                  size: .sm,
                  prefix: const Icon(FIcons.archive, size: 16),
                  onPress: () => launchUrl(Uri.parse(release.tarball_url!)),
                  child: Text(l10n.tarball),
                ),
                const SizedBox(width: 8),
              ],
              if (release.zipball_url != null)
                FButton(
                  variant: .outline,
                  size: .sm,
                  prefix: const Icon(FIcons.package, size: 16),
                  onPress: () => launchUrl(Uri.parse(release.zipball_url!)),
                  child: Text(l10n.zipball),
                ),
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
