import 'package:flutter/material.dart';
import '../../core/animations/animated_wrapper.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../state/notification_notifier.dart';
import '../widgets/empty_state.dart';
import '../widgets/premium_card.dart';
import '../widgets/user_avatar.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notifications),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: l10n.markAllRead,
            onPressed: _markAllRead,
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: Injection.notificationNotifier,
        builder: (context, _) {
          final state = Injection.notificationNotifier.state;
          return switch (state) {
            NotificationLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            NotificationError(:final message) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${l10n.error}: $message'),
                  const SizedBox(height: UIConstants.md),
                  FilledButton(
                    onPressed: () =>
                        Injection.notificationNotifier.listNotifications(),
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            ),
             NotificationListLoaded(:final notifications) => _NotificationList(
              notifications: notifications,
              l10n: l10n,
              onNotificationTap: (n) => _navigateTo(context, n),
            ),
            _ => EmptyState(icon: Icons.notifications_none, title: l10n.noNotifications),
          };
        },
      ),
    );
  }

  void _markAllRead() async {
    final l10n = AppLocalizations.of(context)!;
    await Injection.notificationNotifier.markAllRead();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.allNotificationsMarkedAsRead)),
      );
    }
  }

  void _navigateTo(BuildContext context, NotificationThread notification) async {
    if (_isNavigating) return;
    _isNavigating = true;

    // Mark as read immediately
    if (notification.id != null) {
      await Injection.notificationNotifier.markThreadRead(notification.id.toString());
    }

    final subject = notification.subject;
    final subjectUrl = subject?.url ?? '';
    final typeValue = subject?.type?.value?.toLowerCase() ?? '';

    // Parse owner/repo from repository or subject URL
    final repo = notification.repository;
    final owner = repo?.owner?.login ?? repo?.full_name?.split('/').firstOrNull ?? '';
    final repoName = repo?.name ?? repo?.full_name?.split('/').lastOrNull ?? '';

    // Try parsing subject URL for type-specific params
    final urlMatch = _parseSubjectUrl(subjectUrl);

    if (typeValue.contains('issue')) {
      final index = urlMatch != null ? int.tryParse(urlMatch.group(1)!) : null;
      final ownerP = urlMatch?.group(2) ?? owner;
      final repoP = urlMatch?.group(3) ?? repoName;
      if (ownerP.isNotEmpty && repoP.isNotEmpty && index != null) {
        _push(context, IssueDetailPage(owner: ownerP, repo: repoP, index: index));
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

    if (typeValue.contains('repository') && owner.isNotEmpty && repoName.isNotEmpty) {
      _push(context, RepoDetailPage(owner: owner, repo: repoName));
      return;
    }

    // Fallback: try to open via URL parsing for user profile etc.
    if (subjectUrl.isNotEmpty) {
      final userMatch = RegExp(r'/api/v\d+/users/([^/]+)$').firstMatch(subjectUrl);
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
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page)).then((_) {
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
  final AppLocalizations l10n;
  final void Function(NotificationThread) onNotificationTap;

  const _NotificationList({
    required this.notifications,
    required this.l10n,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) {
      return EmptyState(icon: Icons.notifications_none, title: l10n.noNotifications);
    }
    return RefreshIndicator(
      onRefresh: () => Injection.notificationNotifier.listNotifications(),
      child: ListView.builder(
        padding: UIConstants.pagePadding + const EdgeInsets.symmetric(vertical: UIConstants.sm),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return FadeInWrapper(
            delay: Duration(milliseconds: index * 30),
            child: _NotificationCard(
              notification: notification,
              l10n: l10n,
              onTap: () => onNotificationTap(notification),
            ),
          );
        },
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationThread notification;
  final AppLocalizations l10n;
  final VoidCallback onTap;

  const _NotificationCard({required this.notification, required this.l10n, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subject = notification.subject;
    final isUnread = notification.unread == true;
    final iconData = _subjectIcon(subject?.type?.value);

    return PremiumListCard(
      onTap: onTap,
      child: Row(
        children: [
          if (notification.repository?.owner != null)
            UserAvatar(
              user: notification.repository!.owner!,
              radius: UIConstants.avatarMd,
            )
          else
            Container(
              padding: const EdgeInsets.all(UIConstants.sm),
              decoration: BoxDecoration(
                color: isUnread
                    ? theme.colorScheme.primaryContainer.withValues(alpha: 0.5)
                    : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                iconData,
                size: UIConstants.iconMd,
                color: isUnread
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          const SizedBox(width: UIConstants.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject?.title ?? l10n.noTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: isUnread
                      ? theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)
                      : theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: UIConstants.xs),
                if (notification.repository?.full_name != null)
                  Text(
                    notification.repository!.full_name!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          if (isUnread)
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  IconData _subjectIcon(String? type) {
    if (type == null) return Icons.notifications;
    final t = type.toLowerCase();
    if (t.contains('issue')) return Icons.error_outline;
    if (t.contains('pull')) return Icons.merge_type;
    if (t.contains('commit')) return Icons.commit;
    if (t.contains('release')) return Icons.new_releases;
    if (t.contains('repository')) return Icons.source;
    return Icons.notifications;
  }
}
