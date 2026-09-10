import 'package:flutter/material.dart';

import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/activity_tile.dart';
import 'repo_detail_page.dart';

/// Full activity feed for a user, with infinite scroll.
class ActivityPage extends StatefulWidget {
  final String username;

  const ActivityPage({super.key, required this.username});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Injection.userNotifier.getUserActivities(widget.username);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      Injection.userNotifier.loadMoreActivities(widget.username);
    }
  }

  String _formatDate(DateTime? date, AppLocalizations l10n) {
    if (date == null) return '';
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 365) return l10n.ago('${diff.inDays ~/ 365}y');
    if (diff.inDays > 30) return l10n.ago('${diff.inDays ~/ 30}mo');
    if (diff.inDays > 0) return l10n.ago('${diff.inDays}d');
    if (diff.inHours > 0) return l10n.ago('${diff.inHours}h');
    if (diff.inMinutes > 0) return l10n.ago('${diff.inMinutes}m');
    return l10n.justNow;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.recentActivity)),
      body: ListenableBuilder(
        listenable: Injection.userNotifier,
        builder: (context, _) {
          final notifier = Injection.userNotifier;
          final activities = notifier.activities;

          if (notifier.activitiesLoading && activities.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final error = notifier.activitiesError;
          if (error != null && activities.isEmpty) {
            return _ErrorView(
              message: error,
              onRetry: () =>
                  Injection.userNotifier.getUserActivities(widget.username),
            );
          }

          if (activities.isEmpty) {
            return Center(child: Text(l10n.noActivity));
          }

          return RefreshIndicator(
            onRefresh: () =>
                Injection.userNotifier.getUserActivities(widget.username),
            child: ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: activities.length +
                  (notifier.activitiesHasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= activities.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: UIConstants.md),
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                }
                final activity = activities[index];
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ActivityTile(
                      activity: activity,
                      timeText: _formatDate(activity.created, l10n),
                      onTap: () => _openRepo(activity),
                    ),
                    if (index < activities.length - 1)
                      const Divider(height: 1, indent: UIConstants.md),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _openRepo(Activity activity) {
    final repo = activity.repo;
    final owner =
        repo?.owner?.login ?? repo?.full_name?.split('/').firstOrNull ?? '';
    final name =
        repo?.name ?? repo?.full_name?.split('/').lastOrNull ?? '';
    if (owner.isEmpty || name.isEmpty) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RepoDetailPage(owner: owner, repo: name),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline,
              size: 48, color: Theme.of(context).colorScheme.error),
          const SizedBox(height: UIConstants.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(message, textAlign: TextAlign.center),
          ),
          const SizedBox(height: UIConstants.md),
          FilledButton(onPressed: onRetry, child: Text(l10n.retry)),
        ],
      ),
    );
  }
}
