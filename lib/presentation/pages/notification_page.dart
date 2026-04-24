import 'package:flutter/material.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../state/notification_notifier.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: 'Mark all as read',
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
                  Text('Error: $message'),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () =>
                        Injection.notificationNotifier.listNotifications(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            NotificationListLoaded(:final notifications) => _NotificationList(
              notifications: notifications,
            ),
            _ => const Center(child: Text('No notifications')),
          };
        },
      ),
    );
  }

  void _markAllRead() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All notifications marked as read')),
    );
    Injection.notificationNotifier.listNotifications();
  }
}

class _NotificationList extends StatelessWidget {
  final List<NotificationThread> notifications;

  const _NotificationList({required this.notifications});

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) {
      return const Center(child: Text('No notifications.'));
    }
    return RefreshIndicator(
      onRefresh: () => Injection.notificationNotifier.listNotifications(),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return _NotificationCard(notification: notification);
        },
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationThread notification;

  const _NotificationCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subject = notification.subject;
    final isUnread = notification.unread == true;
    final iconData = _subjectIcon(subject?.type?.toString());

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isUnread ? theme.colorScheme.primaryContainer : null,
      child: ListTile(
        leading: notification.repository?.owner != null
            ? UserAvatar(
                user: notification.repository!.owner!,
                radius: 16,
              )
            : Icon(
                iconData,
                color: isUnread
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
        title: Text(
          subject?.title ?? 'No title',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: isUnread ? const TextStyle(fontWeight: FontWeight.bold) : null,
        ),
        subtitle: Row(
          children: [
            if (notification.repository?.full_name != null)
              Text(
                notification.repository!.full_name!,
                style: theme.textTheme.bodySmall,
              ),
          ],
        ),
        trailing: isUnread
            ? Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              )
            : null,
      ),
    );
  }

  IconData _subjectIcon(String? type) {
    if (type == null) return Icons.notifications;
    if (type.contains('Issue')) return Icons.error_outline;
    if (type.contains('PullRequest') || type.contains('pull_request'))
      return Icons.merge_type;
    if (type.contains('Commit')) return Icons.commit;
    if (type.contains('Release')) return Icons.new_releases;
    return Icons.notifications;
  }
}
