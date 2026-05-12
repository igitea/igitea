import 'package:flutter/material.dart';
import '../../core/animations/animated_wrapper.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../state/user_notifier.dart';
import '../widgets/empty_state.dart';
import '../widgets/premium_card.dart';
import '../widgets/user_avatar.dart';
import 'issue_list_page.dart';
import 'issue_detail_page.dart';
import 'notification_page.dart';
import 'organizations_list_page.dart';
import 'pr_detail_page.dart';
import 'repo_detail_page.dart';
import 'repo_list_page.dart';
import 'starred_repos_page.dart';
import 'user_profile_page.dart';

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
          FadeInWrapper(child: _WelcomeCard(user: user)),
          const SizedBox(height: UIConstants.md),
          FadeInWrapper(
            delay: const Duration(milliseconds: 100),
            child: Text(
              l10n.quickActions,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: UIConstants.sm),
          FadeInWrapper(
            delay: const Duration(milliseconds: 150),
            child: _QuickActions(l10n: l10n, user: user),
          ),
          const SizedBox(height: UIConstants.md),
          FadeInWrapper(
            delay: const Duration(milliseconds: 200),
            child: Text(
              l10n.yourRepositories,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: UIConstants.sm),
          FadeInWrapper(
            delay: const Duration(milliseconds: 250),
            child: _RepoSummary(l10n: l10n),
          ),
          const SizedBox(height: UIConstants.md),
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
          children: repos.take(5).toList().asMap().entries.map((entry) {
            final index = entry.key;
            final repo = entry.value;
            return FadeInWrapper(
              delay: Duration(milliseconds: index * 40),
              child: PremiumListCard(
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
                            fontWeight: FontWeight.w600,
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
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                            ),
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
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
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

class _QuickActions extends StatelessWidget {
  final AppLocalizations l10n;
  final User user;

  const _QuickActions({required this.l10n, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        _ActionTile(
          icon: Icons.source,
          iconColor: theme.colorScheme.primary,
          label: l10n.repositories,
          subtitle: 'Browse your repositories',
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RepoListPage())),
        ),
        _ActionTile(
          icon: Icons.bug_report_outlined,
          iconColor: theme.colorScheme.tertiary,
          label: l10n.issues,
          subtitle: 'View and manage issues',
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const IssueListPage())),
        ),
        _ActionTile(
          icon: Icons.notifications_outlined,
          iconColor: theme.colorScheme.error,
          label: l10n.notifications,
          subtitle: 'Check your notifications',
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NotificationPage())),
        ),
        _ActionTile(
          icon: Icons.history,
          iconColor: theme.colorScheme.secondary,
          label: l10n.recentActivity,
          subtitle: 'Track your recent activity',
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ActivityPage(user: user))),
        ),
        _ActionTile(
          icon: Icons.star_outline,
          iconColor: Colors.amber.shade700,
          label: l10n.starredRepos,
          subtitle: 'Your starred repositories',
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const StarredReposPage())),
        ),
        _ActionTile(
          icon: Icons.assignment_ind_outlined,
          iconColor: theme.colorScheme.secondary,
          label: 'My Issues',
          subtitle: 'Issues assigned to you',
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => IssueListPage(initialFilter: 'assigned'))),
        ),
        _ActionTile(
          icon: Icons.business_outlined,
          iconColor: theme.colorScheme.primary,
          label: l10n.organisations,
          subtitle: 'Your organizations',
          onTap: () async {
            final result = await Injection.listCurrentUserOrgsUseCase();
            if (result is Right<Failure, List<Organization>>) {
              if (context.mounted) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => OrganizationsListPage(orgs: result.value),
                ));
              }
            }
          },
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ActivityPage extends StatefulWidget {
  final User user;
  const ActivityPage({super.key, required this.user});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.recentActivity)),
      body: _ActivityFeed(user: widget.user),
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
          return Center(child: Text(l10n.noActivity));
        }

        final items = <Widget>[
          ...activities.asMap().entries.map((entry) {
            final activity = entry.value;
            return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: theme.colorScheme.outlineVariant),
                ),
                child: InkWell(
                  onTap: () => _navigateToActivity(activity, context),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        activity.act_user != null
                            ? UserAvatar(user: activity.act_user!, radius: 18)
                            : Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(_activityIcon(activity.op_type), size: 16),
                              ),
                        const SizedBox(width: 12),
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
                                  _formatDate(activity.created!, l10n),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          );
          }),
          if (Injection.userNotifier.activitiesHasMore)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Injection.userNotifier.activitiesLoadingMore
                    ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2))
                    : TextButton(
                        onPressed: () => Injection.userNotifier.loadMoreActivities(widget.user.login!),
                        child: const Text('Load more activity'),
                      ),
              ),
            ),
        ];

        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: items,
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
      case 'commit_repo':
        return '$user ${l10n.commitRepo} $repo';
      case 'rename_repo':
        return '$user ${l10n.renameRepo} $repo';
      case 'star_repo':
        return '$user ${l10n.starRepo} $repo';
      case 'watch_repo':
        return '$user ${l10n.watchRepo} $repo';
      case 'push_tag':
        return '$user ${l10n.pushedTag} ${activity.ref_name ?? ''} ${l10n.to} $repo';
      case 'delete_tag':
        return '$user ${l10n.deletedTag} ${activity.ref_name ?? ''} ${l10n.from} $repo';
      case 'delete_branch':
        return '$user ${l10n.deleteBranch} ${activity.ref_name ?? ''} ${l10n.from} $repo';
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
      case 'reopen_pull_request':
        return '$user ${l10n.reopenPR} #${activity.content ?? ''} ${l10n.inRepo} $repo';
      case 'comment_issue':
        return '$user ${l10n.commentedOnIssue} #${activity.content ?? ''} ${l10n.inRepo} $repo';
      case 'comment_pull':
        return '$user ${l10n.commentedOnPR} #${activity.content ?? ''} ${l10n.inRepo} $repo';
      case 'fork_repo':
        return '$user ${l10n.forkedRepo} $repo';
      case 'transfer_repo':
        return '$user ${l10n.transferredRepo} $repo';
      case 'delete_repo':
        return '$user ${l10n.deletedRepo} $repo';
      case 'wiki_page':
        return '$user ${l10n.updatedWiki} ${l10n.inRepo} $repo';
      case 'publish_release':
        return '$user ${l10n.publishRelease} ${l10n.inRepo} $repo';
      case 'approve_pull_request':
        return '$user ${l10n.approvePR} #${activity.content ?? ''} ${l10n.inRepo} $repo';
      case 'reject_pull_request':
        return '$user ${l10n.rejectPR} #${activity.content ?? ''} ${l10n.inRepo} $repo';
      case 'pull_review_dismissed':
        return '$user ${l10n.pullReviewDismissed} ${l10n.inRepo} $repo';
      case 'pull_request_ready_for_review':
        return '$user ${l10n.pullRequestReady} ${l10n.inRepo} $repo';
      case 'auto_merge_pull_request':
        return '$user ${l10n.autoMergePR} #${activity.content ?? ''} ${l10n.inRepo} $repo';
      case 'mirror_sync_push':
        return '$user ${l10n.mirrorSyncPush} $repo';
      case 'mirror_sync_create':
        return '$user ${l10n.mirrorSyncCreate} $repo';
      case 'mirror_sync_delete':
        return '$user ${l10n.mirrorSyncDelete} $repo';
      default:
        return '$user ${l10n.performedAction} $opType ${l10n.inRepo} $repo';
    }
  }

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

  void _navigateToActivity(Activity activity, BuildContext context) {
    final repo = activity.repo;
    final owner = repo?.owner?.login ?? repo?.full_name?.split('/').firstOrNull ?? '';
    final repoName = repo?.name ?? repo?.full_name?.split('/').lastOrNull ?? '';

    final opType = activity.op_type ?? '';
    final content = activity.content ?? '';

    // Try to extract issue/PR number from content (handles plain "3" or "issue #3" formats)
    final parsedIndex = int.tryParse(content);
    final index = parsedIndex ?? (() { final m = RegExp(r'#?(\d+)').firstMatch(content); return m != null ? int.tryParse(m.group(1)!) : null; })();

    // User-related: navigate to user profile
    if (opType == 'follow' || opType == 'follow_user') {
      final username = activity.ref_name ?? content;
      if (username.isNotEmpty) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => UserProfilePage(username: username),
        ));
        return;
      }
    }

    // Issue-related: navigate to issue detail
    if (opType == 'create_issue' ||
        opType == 'close_issue' ||
        opType == 'reopen_issue' ||
        opType == 'comment_issue' ||
        opType == 'approve_pull_request' ||
        opType == 'reject_pull_request') {
      if (index != null && owner.isNotEmpty && repoName.isNotEmpty) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => IssueDetailPage(owner: owner, repo: repoName, index: index),
        ));
        return;
      }
    }

    // PR-related: navigate to PR detail
    if (opType == 'create_pull_request' ||
        opType == 'merge_pull_request' ||
        opType == 'close_pull_request' ||
        opType == 'reopen_pull_request' ||
        opType == 'comment_pull' ||
        opType == 'pull_request_ready_for_review' ||
        opType == 'auto_merge_pull_request' ||
        opType == 'pull_review_dismissed') {
      if (index != null && owner.isNotEmpty && repoName.isNotEmpty) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => PRDetailPage(owner: owner, repo: repoName, index: index),
        ));
        return;
      }
    }

    // Fallback: navigate to repo (requires owner+repoName)
    if (owner.isNotEmpty && repoName.isNotEmpty) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => RepoDetailPage(owner: owner, repo: repoName),
      ));
    }
  }
}
