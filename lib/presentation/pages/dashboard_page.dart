import 'package:flutter/material.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../state/user_notifier.dart';
import '../widgets/user_avatar.dart';
import 'issue_list_page.dart';
import 'notification_page.dart';
import 'repo_detail_page.dart';
import 'repo_list_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: ListenableBuilder(
        listenable: Injection.userNotifier,
        builder: (context, child) {
          final state = Injection.userNotifier.state;
          return switch (state) {
            UserLoading() => const Center(child: CircularProgressIndicator()),
            UserError(:final message) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${l10n.error}: $message'),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => Injection.userNotifier.loadCurrentUser(),
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            ),
            UserLoaded(:final user) => _buildDashboard(context, user, l10n),
            _ => _buildWelcome(context, l10n),
          };
        },
      ),
    );
  }

  Widget _buildWelcome(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.code,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.welcomeToIgitea,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.signInToGetStarted,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, User user, AppLocalizations l10n) {
    return RefreshIndicator(
      onRefresh: () => Injection.userNotifier.loadCurrentUser(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _WelcomeCard(user: user),
          const SizedBox(height: 16),
          Text(l10n.quickActions, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          _QuickActions(l10n: l10n),
          const SizedBox(height: 16),
          Text(
            l10n.yourRepositories,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          _RepoSummary(l10n: l10n),
          const SizedBox(height: 16),
          Text(
            l10n.recentActivity,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          _ActivityFeed(user: user),
        ],
      ),
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  final User user;

  const _WelcomeCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            UserAvatar(user: user, radius: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.helloParams(user.full_name ?? user.login ?? l10n.user),
                    style: theme.textTheme.titleLarge,
                  ),
                  if (user.login != null)
                    Text('@${user.login}', style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  final AppLocalizations l10n;

  const _QuickActions({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionCard(
            icon: Icons.source,
            label: l10n.repositories,
            onTap: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const RepoListPage())),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ActionCard(
            icon: Icons.error_outline,
            label: l10n.issues,
            onTap: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const IssueListPage())),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ActionCard(
            icon: Icons.notifications,
            label: l10n.notifications,
            onTap: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const NotificationPage())),
          ),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(
            children: [
              Icon(icon, size: 28, color: theme.colorScheme.primary),
              const SizedBox(height: 8),
              Text(label, style: theme.textTheme.labelLarge),
            ],
          ),
        ),
      ),
    );
  }
}

class _RepoSummary extends StatelessWidget {
  final AppLocalizations l10n;

  const _RepoSummary({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Injection.userNotifier,
      builder: (context, _) {
        final repos = Injection.userNotifier.repos;
        if (repos.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(l10n.noRepositoriesFound),
            ),
          );
        }
        return Column(
          children: repos.take(5).map((repo) {
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => RepoDetailPage(
                      owner: repo.owner?.login ?? '',
                      repo: repo.name ?? '',
                    ),
                  ));
                },
                leading: repo.owner != null
                    ? UserAvatar(user: repo.owner!, radius: 16)
                    : Icon(
                        repo.private == true ? Icons.lock : Icons.public,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                title: Text(repo.full_name ?? repo.name ?? ''),
                subtitle:
                    repo.description != null && repo.description!.isNotEmpty
                    ? Text(
                        repo.description!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    : null,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (repo.language != null) ...[
                      Text(
                        repo.language!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Icon(
                      Icons.star_outline,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    Text(
                      '${repo.stars_count ?? 0}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _ActivityFeed extends StatefulWidget {
  final User user;

  const _ActivityFeed({required this.user});

  @override
  State<_ActivityFeed> createState() => _ActivityFeedState();
}

class _ActivityFeedState extends State<_ActivityFeed> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.user.login != null) {
        Injection.userNotifier.getUserActivities(widget.user.login!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: Injection.userNotifier,
      builder: (context, _) {
        final activities = Injection.userNotifier.activities;

        if (activities.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(child: Text(l10n.noActivity)),
            ),
          );
        }

        return Column(
          children: activities.take(10).map((activity) {
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: activity.act_user != null
                    ? UserAvatar(user: activity.act_user!, radius: 16)
                    : Icon(_activityIcon(activity.op_type), size: 20),
                title: Text(
                  _activityDescription(activity, l10n),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: activity.created != null
                    ? Text(
                        _formatDate(activity.created!),
                        style: theme.textTheme.bodySmall,
                      )
                    : null,
                onTap: () => _navigateToActivity(activity, context),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  IconData _activityIcon(String? opType) {
    switch (opType) {
      case 'create_repo':
        return Icons.create_new_folder;
      case 'push_tag':
      case 'delete_tag':
        return Icons.tag;
      case 'create_issue':
      case 'close_issue':
      case 'reopen_issue':
        return Icons.error_outline;
      case 'create_pull_request':
      case 'merge_pull_request':
      case 'close_pull_request':
        return Icons.merge_type;
      case 'comment_issue':
      case 'comment_pull_request':
        return Icons.comment;
      case 'fork_repo':
        return Icons.fork_right;
      case 'transfer_repo':
        return Icons.swap_horiz;
      case 'delete_repo':
        return Icons.delete;
      case 'wiki_page':
        return Icons.book;
      default:
        return Icons.circle;
    }
  }

  String _activityDescription(Activity activity, AppLocalizations l10n) {
    final user = activity.act_user?.login ?? l10n.unknown;
    final repo = activity.repo?.full_name ?? l10n.unknown;
    final opType = activity.op_type ?? '';

    switch (opType) {
      case 'create_repo':
        return '$user ${l10n.createdRepo} $repo';
      case 'push_tag':
        return '$user ${l10n.pushedTag} ${activity.ref_name ?? ''} ${l10n.to} $repo';
      case 'delete_tag':
        return '$user ${l10n.deletedTag} ${activity.ref_name ?? ''} ${l10n.from} $repo';
      case 'create_issue':
        return '$user ${l10n.createdIssue} #${activity.content ?? ''} ${l10n.inRepo} $repo';
      case 'close_issue':
        return '$user ${l10n.closedIssue} #${activity.content ?? ''} ${l10n.inRepo} $repo';
      case 'reopen_issue':
        return '$user ${l10n.reopenedIssue} #${activity.content ?? ''} ${l10n.inRepo} $repo';
      case 'create_pull_request':
        return '$user ${l10n.createdPR} #${activity.content ?? ''} ${l10n.inRepo} $repo';
      case 'merge_pull_request':
        return '$user ${l10n.mergedPR} #${activity.content ?? ''} ${l10n.inRepo} $repo';
      case 'close_pull_request':
        return '$user ${l10n.closedPR} #${activity.content ?? ''} ${l10n.inRepo} $repo';
      case 'comment_issue':
        return '$user ${l10n.commentedOnIssue} #${activity.content ?? ''} ${l10n.inRepo} $repo';
      case 'comment_pull_request':
        return '$user ${l10n.commentedOnPR} #${activity.content ?? ''} ${l10n.inRepo} $repo';
      case 'fork_repo':
        return '$user ${l10n.forkedRepo} $repo';
      case 'transfer_repo':
        return '$user ${l10n.transferredRepo} $repo';
      case 'delete_repo':
        return '$user ${l10n.deletedRepo} $repo';
      case 'wiki_page':
        return '$user ${l10n.updatedWiki} ${l10n.inRepo} $repo';
      default:
        return '$user ${l10n.performedAction} $opType ${l10n.inRepo} $repo';
    }
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

  void _navigateToActivity(Activity activity, BuildContext context) {
    if (activity.repo?.owner == null || activity.repo?.name == null) return;

    final owner = activity.repo!.owner!.login!;
    final repo = activity.repo!.name!;

    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => RepoDetailPage(owner: owner, repo: repo),
    ));
  }
}
