import 'package:flutter/material.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../state/user_notifier.dart';
import '../widgets/empty_state.dart';
import '../widgets/premium_card.dart';
import '../widgets/user_avatar.dart';
import 'issue_list_page.dart';
import 'notification_page.dart';
import 'repo_detail_page.dart';
import 'repo_list_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Injection.userNotifier.loadCurrentUser();
    });
  }

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
                  const SizedBox(height: UIConstants.md),
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
    return EmptyState(
      icon: Icons.code,
      title: l10n.welcomeToIgitea,
      subtitle: l10n.signInToGetStarted,
    );
  }

  Widget _buildDashboard(BuildContext context, User user, AppLocalizations l10n) {
    return RefreshIndicator(
      onRefresh: () => Injection.userNotifier.loadCurrentUser(),
      child: ListView(
        padding: const EdgeInsets.all(UIConstants.md),
        children: [
          _WelcomeCard(user: user),
          const SizedBox(height: UIConstants.md),
          Text(
            l10n.quickActions,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: UIConstants.sm),
          _QuickActions(l10n: l10n),
          const SizedBox(height: UIConstants.md),
          Text(
            l10n.yourRepositories,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: UIConstants.sm),
          _RepoSummary(l10n: l10n),
          const SizedBox(height: UIConstants.md),
          Text(
            l10n.recentActivity,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: UIConstants.sm),
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
    return PremiumCard(
      child: Row(
        children: [
          UserAvatar(user: user, radius: UIConstants.avatarXl),
          const SizedBox(width: UIConstants.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.helloParams(user.full_name ?? user.login ?? l10n.user),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (user.login != null)
                  Text(
                    '@${user.login}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
        ],
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
        const SizedBox(width: UIConstants.sm),
        Expanded(
          child: _ActionCard(
            icon: Icons.error_outline,
            label: l10n.issues,
            onTap: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const IssueListPage())),
          ),
        ),
        const SizedBox(width: UIConstants.sm),
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
    return PremiumCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(vertical: UIConstants.md, horizontal: UIConstants.sm),
      child: Column(
        children: [
          Icon(icon, size: UIConstants.iconLg, color: theme.colorScheme.primary),
          const SizedBox(height: UIConstants.sm),
          Text(label, style: theme.textTheme.labelLarge),
        ],
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
          return PremiumCard(
            child: Text(l10n.noRepositoriesFound),
          );
        }
        return Column(
          children: repos.take(5).map((repo) {
            return PremiumListCard(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => RepoDetailPage(
                    owner: repo.owner?.login ?? '',
                    repo: repo.name ?? '',
                  ),
                ));
              },
              child: Row(
                children: [
                  repo.owner != null
                      ? UserAvatar(user: repo.owner!, radius: UIConstants.avatarMd)
                      : Icon(
                          repo.private == true ? Icons.lock : Icons.public,
                          color: Theme.of(context).colorScheme.primary,
                          size: UIConstants.iconMd,
                        ),
                  const SizedBox(width: UIConstants.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          repo.full_name ?? repo.name ?? '',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (repo.description != null && repo.description!.isNotEmpty)
                          Text(
                            repo.description!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (repo.language != null) ...[
                        Text(
                          repo.language!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(width: UIConstants.sm),
                      ],
                      Icon(
                        Icons.star_outline,
                        size: UIConstants.iconSm,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: UIConstants.xs),
                      Text(
                        '${repo.stars_count ?? 0}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
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
          return PremiumCard(
            child: Center(child: Text(l10n.noActivity)),
          );
        }

        return Column(
          children: activities.take(10).map((activity) {
            return PremiumListCard(
              onTap: () => _navigateToActivity(activity, context),
              child: Row(
                children: [
                  activity.act_user != null
                      ? UserAvatar(user: activity.act_user!, radius: UIConstants.avatarMd)
                      : Container(
                          padding: const EdgeInsets.all(UIConstants.xs),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(_activityIcon(activity.op_type), size: UIConstants.iconMd),
                        ),
                  const SizedBox(width: UIConstants.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _activityDescription(activity, l10n),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium,
                        ),
                        if (activity.created != null)
                          Text(
                            _formatDate(activity.created!),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
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
