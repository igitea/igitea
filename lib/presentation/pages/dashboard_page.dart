import 'package:flutter/material.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
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
                  Text('Error: $message'),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => Injection.userNotifier.loadCurrentUser(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            UserLoaded(:final user) => _buildDashboard(context, user),
            _ => _buildWelcome(context),
          };
        },
      ),
    );
  }

  Widget _buildWelcome(BuildContext context) {
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
            'Welcome to iGitea',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Sign in to get started',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, User user) {
    return RefreshIndicator(
      onRefresh: () => Injection.userNotifier.loadCurrentUser(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _WelcomeCard(user: user),
          const SizedBox(height: 16),
          Text('Quick Actions', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          _QuickActions(),
          const SizedBox(height: 16),
          Text(
            'Your Repositories',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          _RepoSummary(),
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
                    'Hello, ${user.full_name ?? user.login ?? 'User'}!',
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
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionCard(
            icon: Icons.source,
            label: 'Repositories',
            onTap: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const RepoListPage())),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ActionCard(
            icon: Icons.error_outline,
            label: 'Issues',
            onTap: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const IssueListPage())),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ActionCard(
            icon: Icons.notifications,
            label: 'Notifications',
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
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Injection.userNotifier,
      builder: (context, _) {
        final repos = Injection.userNotifier.repos;
        if (repos.isEmpty) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('No repositories found.'),
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
