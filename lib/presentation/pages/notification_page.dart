import 'package:flutter/material.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
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
                  const SizedBox(height: 16),
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
            _ => Center(child: Text(l10n.noNotifications)),
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
      return Center(child: Text(l10n.noNotifications));
    }
    return RefreshIndicator(
      onRefresh: () => Injection.notificationNotifier.listNotifications(),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return _NotificationCard(notification: notification, l10n: l10n);
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
          subject?.title ?? l10n.noTitle,
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
            ? IconButton(
                icon: const Icon(Icons.check_circle_outline),
                tooltip: l10n.markRead,
                onPressed: () => _markAsRead(context),
              )
            : null,
      ),
    );
  }

  void _markAsRead(BuildContext context) async {
    if (notification.id == null) return;
    await Injection.notificationNotifier.markThreadRead(notification.id!.toString());
    await Injection.notificationNotifier.listNotifications();
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
