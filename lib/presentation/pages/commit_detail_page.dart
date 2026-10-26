import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/animations/animated_wrapper.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../core/utils/diff_parser.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../state/repo_notifier.dart';
import '../widgets/forui/app_page.dart';
import '../widgets/forui/app_section.dart';
import '../widgets/forui/app_state_views.dart';
import '../widgets/forui/app_tile.dart';
import '../widgets/user_avatar.dart';
import '../theme/app_theme.dart';

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
  Map<String, List<DiffFile>> _fileDiffs = {};
  final Set<String> _expandedFiles = {};
  bool _diffLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Injection.repoNotifier.getCommit(widget.owner, widget.repo, widget.sha);
      _loadDiff();
    });
  }

  Future<void> _loadDiff() async {
    setState(() => _diffLoading = true);
    try {
      final raw = await Injection.apiService.repoGetCommitDiff(
        owner: widget.owner,
        repo: widget.repo,
        sha: widget.sha,
      );
      final files = await compute(DiffParser.parse, raw);
      final fileMap = <String, List<DiffFile>>{};
      for (final f in files) {
        final key = f.newPath.isNotEmpty ? f.newPath : f.oldPath;
        fileMap.putIfAbsent(key, () => []).add(f);
      }
      if (mounted) {
        setState(() {
          _fileDiffs = fileMap;
          _diffLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _diffLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppPage(
      title: l10n.commit,
      child: ListenableBuilder(
        listenable: Injection.repoNotifier,
        builder: (context, _) {
          final state = Injection.repoNotifier.commitDetailState;
          return switch (state) {
            CommitDetailLoading() => const AppLoading(),
            CommitDetailError(:final message) => AppError(
              message: message,
              onRetry: () => Injection.repoNotifier.getCommit(
                widget.owner,
                widget.repo,
                widget.sha,
              ),
            ),
            CommitDetailDataLoaded(:final commit) => _buildContent(
              commit,
              l10n,
            ),
            _ => const AppLoading(),
          };
        },
      ),
    );
  }

  Widget _buildContent(Commit commit, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final commitInfo = commit.commit;
    return ListView(
      padding: const EdgeInsets.all(UIConstants.md),
      children: [
        if (commit.author != null) ...[
          Row(
            children: [
              UserAvatar(user: commit.author!, radius: UIConstants.avatarLg),
              const SizedBox(width: UIConstants.sm),
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
                        _formatDate(commit.created!, l10n),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: UIConstants.md),
        ],
        if (commitInfo?.message != null) ...[
          Text(
            commitInfo!.message!,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: UIConstants.md),
        ],
        AppSection(
          title: '',
          showHeader: false,
          children: [
            AppTile(
              leading: const Icon(FIcons.fingerprintPattern, size: 18),
              title: l10n.sha,
              subtitle: commit.sha ?? '',
              showChevron: false,
              onPress: () => _copyToClipboard(commit.sha ?? ''),
            ),
            if (commit.html_url != null)
              AppTile(
                leading: const Icon(FIcons.externalLink, size: 18),
                title: l10n.url,
                subtitle: commit.html_url!,
                showChevron: false,
                onPress: () => _launchUrl(commit.html_url!),
              ),
          ],
        ),
        if (commit.stats != null) ...[
          const SizedBox(height: UIConstants.md),
          _buildStats(commit.stats!),
        ],
        if (_fileDiffs.isNotEmpty) ...[
          const SizedBox(height: UIConstants.lg),
          Row(
            children: [
              Text(
                l10n.changedFiles,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (_diffLoading) const FCircularProgress(size: .xs),
            ],
          ),
          const SizedBox(height: UIConstants.sm),
          ..._fileDiffs.entries.toList().asMap().entries.map(
            (entry) => FadeInWrapper(
              delay: Duration(milliseconds: entry.key * 30),
              child: _buildFileDiffCard(entry.value.key, entry.value.value),
            ),
          ),
        ] else if (commit.files != null && commit.files!.isNotEmpty) ...[
          const SizedBox(height: UIConstants.lg),
          Text(
            l10n.changedFiles,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: UIConstants.sm),
          ...commit.files!.asMap().entries.map(
            (entry) => FadeInWrapper(
              delay: Duration(milliseconds: entry.key * 30),
              child: _buildSimpleFileItem(entry.value),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFileDiffCard(String filename, List<DiffFile> diffs) {
    final expanded = _expandedFiles.contains(filename);
    final totalAdded = diffs.fold(
      0,
      (sum, f) =>
          sum +
          f.hunks.fold(
            0,
            (s, h) =>
                s + h.lines.where((l) => l.type == DiffLineType.added).length,
          ),
    );
    final totalRemoved = diffs.fold(
      0,
      (sum, f) =>
          sum +
          f.hunks.fold(
            0,
            (s, h) =>
                s + h.lines.where((l) => l.type == DiffLineType.removed).length,
          ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: UIConstants.sm),
      child: FCard.raw(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FTappable(
              onPress: () => setState(() {
                if (expanded) {
                  _expandedFiles.remove(filename);
                } else {
                  _expandedFiles.add(filename);
                }
              }),
              child: Padding(
                padding: const EdgeInsets.all(UIConstants.sm),
                child: Row(
                  children: [
                    Icon(
                      FIcons.file,
                      size: UIConstants.iconMd,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: UIConstants.sm),
                    Expanded(
                      child: Text(
                        filename,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontFamily: 'monospace',
                          fontFamilyFallback: kMonoFontFallback,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      '+$totalAdded',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: UIConstants.sm),
                    Text(
                      '-$totalRemoved',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (expanded)
              ...diffs.expand(
                (d) => d.hunks.expand(
                  (h) => [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: UIConstants.sm,
                        vertical: UIConstants.xs,
                      ),
                      color: Theme.of(context).colorScheme.surfaceContainerLow,
                      child: Text(
                        h.header,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontFamily: 'monospace',
                          fontFamilyFallback: kMonoFontFallback,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    ...h.lines.map((line) {
                      final bgColor = switch (line.type) {
                        DiffLineType.added => Colors.green.withValues(
                          alpha: 0.12,
                        ),
                        DiffLineType.removed => Colors.red.withValues(
                          alpha: 0.12,
                        ),
                        _ => null,
                      };
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          color: bgColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: UIConstants.xs,
                          ),
                          child: Row(
                            children: [
                              Text(
                                '${line.oldLineNum?.toString().padLeft(4) ?? '    '} ${line.newLineNum?.toString().padLeft(4) ?? '    '}',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      fontFamily: 'monospace',
                                      fontFamilyFallback: kMonoFontFallback,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant
                                          .withValues(alpha: 0.5),
                                    ),
                              ),
                              const Text(
                                ' ',
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontFamilyFallback: kMonoFontFallback,
                                ),
                              ),
                              Text(
                                line.content,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      fontFamily: 'monospace',
                                      fontFamilyFallback: kMonoFontFallback,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleFileItem(CommitAffectedFiles file) {
    return Padding(
      padding: const EdgeInsets.only(bottom: UIConstants.sm),
      child: FCard.raw(
        child: AppTile(
          leading: Icon(
            _getFileStatusIcon(file.status),
            size: 18,
            color: _getFileStatusColor(file.status),
          ),
          title: file.filename ?? '',
          subtitle: file.status ?? '',
          showChevron: false,
        ),
      ),
    );
  }

  Widget _buildStats(CommitStats stats) {
    return Row(
      children: [
        _buildStatChip(label: '+${stats.additions ?? 0}', color: Colors.green),
        const SizedBox(width: UIConstants.sm),
        _buildStatChip(label: '-${stats.deletions ?? 0}', color: Colors.red),
        const SizedBox(width: UIConstants.sm),
        _buildStatChip(
          label: '${stats.total ?? 0}',
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ],
    );
  }

  Widget _buildStatChip({required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: UIConstants.sm,
        vertical: UIConstants.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(UIConstants.badgeRadius),
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

  IconData _getFileStatusIcon(String? status) => switch (status) {
    'added' => FIcons.circlePlus,
    'removed' => FIcons.circleMinus,
    'modified' => FIcons.pencil,
    'renamed' => FIcons.filePen,
    _ => FIcons.file,
  };
  Color _getFileStatusColor(String? status) => switch (status) {
    'added' => Colors.green,
    'removed' => Colors.red,
    'modified' => Colors.orange,
    'renamed' => Colors.blue,
    _ => Colors.grey,
  };

  String _formatDate(DateTime date, AppLocalizations l10n) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 365) return l10n.ago('${diff.inDays ~/ 365}y');
    if (diff.inDays > 30) return l10n.ago('${diff.inDays ~/ 30}mo');
    if (diff.inDays > 0) return l10n.ago('${diff.inDays}d');
    if (diff.inHours > 0) return l10n.ago('${diff.inHours}h');
    if (diff.inMinutes > 0) return l10n.ago('${diff.inMinutes}m');
    return l10n.justNow;
  }

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) {
      showFToast(
        context: context,
        title: Text(AppLocalizations.of(context)!.copied),
      );
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
