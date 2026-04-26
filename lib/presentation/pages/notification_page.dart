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

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
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
}

class _NotificationList extends StatelessWidget {
  final List<NotificationThread> notifications;
  final AppLocalizations l10n;

  const _NotificationList({required this.notifications, required this.l10n});

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
            child: _NotificationCard(notification: notification, l10n: l10n),
          );
        },
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationThread notification;
  final AppLocalizations l10n;

  const _NotificationCard({required this.notification, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subject = notification.subject;
    final isUnread = notification.unread == true;
    final iconData = _subjectIcon(subject?.type?.toString());

    return PremiumListCard(
      onTap: () {},
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
    if (type == null) {
      return Icons.notifications;
    }
    if (type.contains('Issue')) {
      return Icons.error_outline;
    }
    if (type.contains('PullRequest') || type.contains('pull_request')) {
      return Icons.merge_type;
    }
    if (type.contains('Commit')) {
      return Icons.commit;
    }
    if (type.contains('Release')) {
      return Icons.new_releases;
    }
    return Icons.notifications;
  }
}
