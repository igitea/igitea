import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/animations/animated_wrapper.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../../presentation/state/repo_notifier.dart';
import '../../presentation/widgets/user_avatar.dart';

class CommitDetailPage extends StatefulWidget {
  final String owner;
  final String repo;
  final String sha;

  const CommitDetailPage({
    super.key,
    required this.owner,
    required this.repo,
    required this.sha,
  });

  @override
  State<CommitDetailPage> createState() => _CommitDetailPageState();
}

class _CommitDetailPageState extends State<CommitDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Injection.repoNotifier.getCommit(widget.owner, widget.repo, widget.sha);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.commit),
      ),
      body: ListenableBuilder(
        listenable: Injection.repoNotifier,
        builder: (context, _) {
          final state = Injection.repoNotifier.state;
          return switch (state) {
            RepoLoading() => const Center(child: CircularProgressIndicator()),
            RepoError(:final message) => _buildError(message, l10n),
            CommitDetailLoaded(:final commit) => _buildContent(commit, l10n),
            _ => const Center(child: CircularProgressIndicator()),
          };
        },
      ),
    );
  }

  Widget _buildError(String message, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${l10n.error}: $message'),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => Injection.repoNotifier.getCommit(
              widget.owner,
              widget.repo,
              widget.sha,
            ),
            child: Text(l10n.retry),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(Commit commit, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final commitInfo = commit.commit;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (commit.author != null) ...[
          Row(
            children: [
              UserAvatar(user: commit.author!, radius: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      commit.author!.login ?? '',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (commit.created != null)
                      Text(
                        _formatDate(commit.created!),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
        if (commitInfo?.message != null) ...[
          Text(
            commitInfo!.message!,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
        ],
        _buildInfoRow(
          icon: Icons.fingerprint,
          label: l10n.sha,
          value: commit.sha ?? '',
          onTap: () => _copyToClipboard(commit.sha ?? ''),
        ),
        if (commit.html_url != null)
          _buildInfoRow(
            icon: Icons.open_in_new,
            label: l10n.url,
            value: commit.html_url!,
            isLink: true,
          ),
        if (commit.stats != null) ...[
          const SizedBox(height: 16),
          _buildStats(commit.stats!),
        ],
        if (commit.files != null && commit.files!.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(
            l10n.changedFiles,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...commit.files!.asMap().entries.map((entry) => FadeInWrapper(
            delay: Duration(milliseconds: entry.key * 30),
            child: _buildFileItem(entry.value),
          )),
        ],
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool isLink = false,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap ?? (isLink ? () => _launchUrl(value) : null),
      child: Padding(
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
            if (onTap != null || isLink)
              Icon(
                Icons.copy,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStats(CommitStats stats) {
    final theme = Theme.of(context);
    return Row(
      children: [
        _buildStatChip(
          label: '+${stats.additions ?? 0}',
          color: Colors.green,
        ),
        const SizedBox(width: 8),
        _buildStatChip(
          label: '-${stats.deletions ?? 0}',
          color: Colors.red,
        ),
        const SizedBox(width: 8),
        _buildStatChip(
          label: '${stats.total ?? 0}',
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ],
    );
  }

  Widget _buildStatChip({required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildFileItem(CommitAffectedFiles file) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          _getFileStatusIcon(file.status),
          color: _getFileStatusColor(file.status),
        ),
        title: Text(
          file.filename ?? '',
          style: theme.textTheme.bodyMedium,
        ),
        subtitle: Text(
          file.status ?? '',
          style: TextStyle(
            color: _getFileStatusColor(file.status),
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  IconData _getFileStatusIcon(String? status) {
    return switch (status) {
      'added' => Icons.add_circle_outline,
      'removed' => Icons.remove_circle_outline,
      'modified' => Icons.edit,
      'renamed' => Icons.drive_file_rename_outline,
      _ => Icons.insert_drive_file,
    };
  }

  Color _getFileStatusColor(String? status) {
    return switch (status) {
      'added' => Colors.green,
      'removed' => Colors.red,
      'modified' => Colors.orange,
      'renamed' => Colors.blue,
      _ => Colors.grey,
    };
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 365) return '${diff.inDays ~/ 365}y ago';
    if (diff.inDays > 30) return '${diff.inDays ~/ 30}mo ago';
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'just now';
  }

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.copied)),
      );
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}