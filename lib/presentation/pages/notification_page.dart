import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../state/notification_notifier.dart';
import '../theme/app_palette.dart';
import '../widgets/forui/app_section.dart';
import '../widgets/forui/app_state_views.dart';
import 'commit_detail_page.dart';
import 'issue_detail_page.dart';
import 'pr_detail_page.dart';
import 'repo_detail_page.dart';
import 'user_profile_page.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Injection.notificationNotifier.listNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListenableBuilder(
      listenable: Injection.notificationNotifier,
      builder: (context, _) {
        final state = Injection.notificationNotifier.state;
        return switch (state) {
          NotificationLoading() => const AppLoading(),
          NotificationError(:final message) => AppError(
            message: message,
            onRetry: () => Injection.notificationNotifier.listNotifications(),
          ),
          NotificationListLoaded(:final notifications, :final hasMore) =>
            _NotificationList(
              notifications: notifications,
              hasMore: hasMore,
              l10n: l10n,
              onNotificationTap: (n) => _navigateTo(context, n),
            ),
          _ => AppEmpty(icon: FIcons.bellOff, title: l10n.noNotifications),
        };
      },
    );
  }

  void _navigateTo(
    BuildContext context,
    NotificationThread notification,
  ) async {
    if (_isNavigating) return;
    _isNavigating = true;

    // Mark as read immediately
    if (notification.id != null) {
      await Injection.notificationNotifier.markThreadRead(
        notification.id.toString(),
      );
    }

    if (!context.mounted) return;
    final subject = notification.subject;
    final subjectUrl = subject?.url ?? '';
    final typeValue = subject?.type?.value?.toLowerCase() ?? '';

    // Parse owner/repo from repository or subject URL
    final repo = notification.repository;
    final owner =
        repo?.owner?.login ?? repo?.full_name?.split('/').firstOrNull ?? '';
    final repoName = repo?.name ?? repo?.full_name?.split('/').lastOrNull ?? '';

    // Try parsing subject URL for type-specific params
    final urlMatch = _parseSubjectUrl(subjectUrl);

    if (typeValue.contains('issue')) {
      final index = urlMatch != null ? int.tryParse(urlMatch.group(1)!) : null;
      final ownerP = urlMatch?.group(2) ?? owner;
      final repoP = urlMatch?.group(3) ?? repoName;
      if (ownerP.isNotEmpty && repoP.isNotEmpty && index != null) {
        _push(
          context,
          IssueDetailPage(owner: ownerP, repo: repoP, index: index),
        );
        return;
      }
    }

    if (typeValue.contains('pull')) {
      final index = urlMatch != null ? int.tryParse(urlMatch.group(1)!) : null;
      final ownerP = urlMatch?.group(2) ?? owner;
      final repoP = urlMatch?.group(3) ?? repoName;
      if (ownerP.isNotEmpty && repoP.isNotEmpty && index != null) {
        _push(context, PRDetailPage(owner: ownerP, repo: repoP, index: index));
        return;
      }
    }

    if (typeValue.contains('commit')) {
      final sha = urlMatch?.group(1);
      final ownerP = urlMatch?.group(2) ?? owner;
      final repoP = urlMatch?.group(3) ?? repoName;
      if (ownerP.isNotEmpty && repoP.isNotEmpty && sha != null) {
        _push(context, CommitDetailPage(owner: ownerP, repo: repoP, sha: sha));
        return;
      }
    }

    if (typeValue.contains('release')) {
      if (owner.isNotEmpty && repoName.isNotEmpty) {
        _push(context, RepoDetailPage(owner: owner, repo: repoName));
        return;
      }
    }

    if (typeValue.contains('repository') &&
        owner.isNotEmpty &&
        repoName.isNotEmpty) {
      _push(context, RepoDetailPage(owner: owner, repo: repoName));
      return;
    }

    // Fallback: try to open via URL parsing for user profile etc.
    if (subjectUrl.isNotEmpty) {
      final userMatch = RegExp(
        r'/api/v\d+/users/([^/]+)$',
      ).firstMatch(subjectUrl);
      if (userMatch != null) {
        _push(context, UserProfilePage(username: userMatch.group(1)!));
        return;
      }
    }

    // Last fallback: open repo from notification.repository
    if (owner.isNotEmpty && repoName.isNotEmpty) {
      _push(context, RepoDetailPage(owner: owner, repo: repoName));
    }
  }

  void _push(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page)).then((
      _,
    ) {
      _isNavigating = false;
    });
  }

  /// Parse subject URL to extract params.
  /// Matches URLs like /api/v1/repos/{owner}/{repo}/issues/{n}
  /// Returns match with groups: (1) resource id/index, (2) owner, (3) repo
  RegExpMatch? _parseSubjectUrl(String url) {
    // Handle both API URLs and web URLs
    final patterns = [
      RegExp(r'/repos/([^/]+)/([^/]+)/(?:issues|pulls)/(\d+)$'),
      RegExp(r'/repos/([^/]+)/([^/]+)/git/commits/([0-9a-fA-F]+)$'),
      RegExp(r'/repos/([^/]+)/([^/]+)/releases/(?:tags/)?(.+)$'),
      RegExp(r'/([^/]+)/([^/]+)/(?:issues|pulls)/(\d+)$'),
      RegExp(r'/([^/]+)/([^/]+)/git/commits/([0-9a-fA-F]+)$'),
    ];
    for (final pattern in patterns) {
      final match = pattern.firstMatch(url);
      if (match != null) return match;
    }
    return null;
  }
}

class _NotificationList extends StatelessWidget {
  final List<NotificationThread> notifications;
  final bool hasMore;
  final AppLocalizations l10n;
  final void Function(NotificationThread) onNotificationTap;

  const _NotificationList({
    required this.notifications,
    required this.hasMore,
    required this.l10n,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) {
      return AppEmpty(icon: FIcons.bellOff, title: l10n.noNotifications);
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final inset = constraints.maxWidth > 940
            ? (constraints.maxWidth - 900) / 2
            : 20.0;
        return RefreshIndicator(
          onRefresh: () => Injection.notificationNotifier.listNotifications(),
          child: ListView(
            padding: EdgeInsets.fromLTRB(inset, 16, inset, 32),
            children: [
              AppSection(
                title: '',
                showHeader: false,
                children: [
                  for (final notification in notifications)
                    _NotificationRow(
                      notification: notification,
                      l10n: l10n,
                      onTap: () => onNotificationTap(notification),
                    ),
                ],
              ),
              if (hasMore)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                    child: Injection.notificationNotifier.notifLoadingMore
                        ? const FCircularProgress(size: .sm)
                        : FButton(
                            variant: .outline,
                            size: .sm,
                            onPress: () => Injection.notificationNotifier
                                .loadMoreNotifications(),
                            child: Text(l10n.loadMore),
                          ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _NotificationRow extends StatefulWidget {
  final NotificationThread notification;
  final AppLocalizations l10n;
  final VoidCallback onTap;

  const _NotificationRow({
    required this.notification,
    required this.l10n,
    required this.onTap,
  });

  @override
  State<_NotificationRow> createState() => _NotificationRowState();
}

class _NotificationRowState extends State<_NotificationRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final theme = Theme.of(context);
    final subject = widget.notification.subject;
    final isUnread = widget.notification.unread == true;
    final iconData = _subjectIcon(subject?.type?.value);
    final repo = widget.notification.repository?.full_name ?? '';
    final time = _relativeTime(widget.notification.updated_at);

    return FTappable(
      onPress: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          color: _hovered
              ? palette.surfaceMuted.withValues(alpha: 0.55)
              : isUnread
              ? palette.brandSoft.withValues(alpha: 0.42)
              : Colors.transparent,
          padding: const EdgeInsets.fromLTRB(14, 11, 12, 11),
          child: Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: isUnread ? palette.brandSoft : palette.surfaceMuted,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Icon(
                  iconData,
                  size: 13,
                  color: isUnread ? palette.brand : palette.textSecondary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject?.title ?? widget.l10n.noTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 13,
                        fontWeight: isUnread
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: palette.textPrimary,
                      ),
                    ),
                    if (repo.isNotEmpty || time.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        [
                          if (repo.isNotEmpty) repo,
                          if (time.isNotEmpty) time,
                        ].join(' · '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          color: palette.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isUnread)
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    color: palette.brand,
                    shape: BoxShape.circle,
                  ),
                ),
              const SizedBox(width: 4),
              Icon(
                FIcons.chevronRight,
                size: 13,
                color: palette.textSecondary.withValues(alpha: 0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _relativeTime(DateTime? date) {
    if (date == null) return '';
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 365) return widget.l10n.ago('${diff.inDays ~/ 365}y');
    if (diff.inDays > 30) return widget.l10n.ago('${diff.inDays ~/ 30}mo');
    if (diff.inDays > 0) return widget.l10n.ago('${diff.inDays}d');
    if (diff.inHours > 0) return widget.l10n.ago('${diff.inHours}h');
    if (diff.inMinutes > 0) return widget.l10n.ago('${diff.inMinutes}m');
    return widget.l10n.justNow;
  }

  IconData _subjectIcon(String? type) {
    if (type == null) return FIcons.bell;
    final t = type.toLowerCase();
    if (t.contains('issue')) return FIcons.circleDot;
    if (t.contains('pull')) return FIcons.gitPullRequest;
    if (t.contains('commit')) return FIcons.gitCommitHorizontal;
    if (t.contains('release')) return FIcons.rocket;
    if (t.contains('repository')) return FIcons.folderGit;
    return FIcons.bell;
  }
}
