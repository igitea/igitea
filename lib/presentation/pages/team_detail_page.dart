import 'package:flutter/material.dart';

import '../../core/animations/animated_wrapper.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../state/organization_notifier.dart';
import '../widgets/user_avatar.dart';
import 'repo_detail_page.dart';

class TeamDetailPage extends StatefulWidget {
  final int teamId;

  const TeamDetailPage({
    super.key,
    required this.teamId,
  });

  @override
  State<TeamDetailPage> createState() => _TeamDetailPageState();
}

class _TeamDetailPageState extends State<TeamDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Injection.organizationNotifier.getTeam(widget.teamId);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: ListenableBuilder(
        listenable: Injection.organizationNotifier,
        builder: (context, _) {
        final state = Injection.organizationNotifier.teamDetailState;
        return switch (state) {
          OrgLoading() => const Center(child: CircularProgressIndicator()),
          OrgError(:final message) => _ErrorView(
              message: message,
              onRetry: () =>
                  Injection.organizationNotifier.getTeam(widget.teamId),
            ),
          OrgTeamDetailLoaded(:final team) => _buildContent(context, team, l10n),
          _ => const Center(child: CircularProgressIndicator()),
        };
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, Team team, AppLocalizations l10n) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            title: Text(team.name ?? ''),
            pinned: true,
            floating: true,
            forceElevated: innerBoxIsScrolled,
          ),
          SliverToBoxAdapter(
            child: _TeamHeader(team: team),
          ),
          SliverPersistentHeader(
            delegate: _SliverTabBarDelegate(
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(icon: const Icon(Icons.info_outline), text: l10n.info),
                  Tab(icon: const Icon(Icons.people_outline), text: l10n.members),
                  Tab(icon: const Icon(Icons.folder_outlined), text: l10n.repositories),
                ],
              ),
            ),
            pinned: true,
          ),
        ];
      },
      body: TabBarView(
        controller: _tabController,
        children: [
          _InfoTab(team: team),
          _MembersTab(teamId: widget.teamId),
          _ReposTab(teamId: widget.teamId),
        ],
      ),
    );
  }
}

class _TeamHeader extends StatelessWidget {
  final Team team;

  const _TeamHeader({required this.team});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Icon(
                  Icons.people,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      team.name ?? '',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (team.description != null && team.description!.isNotEmpty)
                      Text(
                        team.description!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              if (team.permission != null)
                Chip(
                  label: Text(team.permission!),
                  visualDensity: VisualDensity.compact,
                ),
              if (team.includes_all_repositories == true)
                Chip(
                  label: const Text('All Repos'),
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoTab extends StatelessWidget {
  final Team team;

  const _InfoTab({required this.team});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (team.description != null && team.description!.isNotEmpty) ...[
          Text(
            'Description',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(team.description!),
          const SizedBox(height: 16),
        ],
        if (team.units != null && team.units!.isNotEmpty) ...[
          Text(
            'Units',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: team.units!
                .map((unit) => Chip(
                      label: Text(unit),
                      visualDensity: VisualDensity.compact,
                    ))
                .toList(),
          ),
          const SizedBox(height: 16),
        ],
        _InfoRow(
          icon: Icons.security,
          label: 'Permission',
          value: team.permission ?? '-',
        ),
        _InfoRow(
          icon: Icons.folder_copy,
          label: 'All Repositories',
          value: team.includes_all_repositories == true ? 'Yes' : 'No',
        ),
        if (team.can_create_org_repo == true)
          _InfoRow(
            icon: Icons.add_circle_outline,
            label: 'Can Create Org Repo',
            value: 'Yes',
          ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(value, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MembersTab extends StatefulWidget {
  final int teamId;

  const _MembersTab({required this.teamId});

  @override
  State<_MembersTab> createState() => _MembersTabState();
}

class _MembersTabState extends State<_MembersTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Injection.organizationNotifier.listTeamMembers(widget.teamId);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context)!;
    return ListenableBuilder(
      listenable: Injection.organizationNotifier,
      builder: (context, _) {
        final state = Injection.organizationNotifier.teamMembersState;
        if (state is OrgTeamMembersLoaded) {
          final members = state.members;
          if (members.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => Injection.organizationNotifier.listTeamMembers(widget.teamId),
              child: ListView(
                children: [Center(child: Text(l10n.noMembers))],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => Injection.organizationNotifier.listTeamMembers(widget.teamId),
            child: ListView.builder(
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                return FadeInWrapper(
                  delay: Duration(milliseconds: index * 30),
                  child: ListTile(
                    leading: UserAvatar(user: member, radius: 16),
                    title: Text(member.login ?? member.full_name ?? ''),
                    subtitle: member.full_name != null ? Text(member.full_name!) : null,
                  ),
                );
              },
            ),
          );
        } else if (state is OrgError) {
          return RefreshIndicator(
            onRefresh: () => Injection.organizationNotifier.listTeamMembers(widget.teamId),
            child: ListView(
              children: [Center(child: Text(state.message))],
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _ReposTab extends StatefulWidget {
  final int teamId;

  const _ReposTab({required this.teamId});

  @override
  State<_ReposTab> createState() => _ReposTabState();
}

class _ReposTabState extends State<_ReposTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Injection.organizationNotifier.listTeamRepos(widget.teamId);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context)!;
    return ListenableBuilder(
      listenable: Injection.organizationNotifier,
      builder: (context, _) {
        final state = Injection.organizationNotifier.teamReposState;
        if (state is OrgTeamReposLoaded) {
          final repos = state.repos;
          if (repos.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => Injection.organizationNotifier.listTeamRepos(widget.teamId),
              child: ListView(
                children: [Center(child: Text(l10n.noData))],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => Injection.organizationNotifier.listTeamRepos(widget.teamId),
            child: ListView.builder(
              itemCount: repos.length,
              itemBuilder: (context, index) {
                final repo = repos[index];
                return FadeInWrapper(
                  delay: Duration(milliseconds: index * 30),
                  child: ListTile(
                    leading: const Icon(Icons.folder_outlined),
                    title: Text(repo.name ?? ''),
                    subtitle: repo.description != null
                        ? Text(
                            repo.description!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        : null,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RepoDetailPage(
                            owner: repo.owner?.login ?? '',
                            repo: repo.name ?? '',
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        } else if (state is OrgError) {
          return RefreshIndicator(
            onRefresh: () => Injection.organizationNotifier.listTeamRepos(widget.teamId),
            child: ListView(
              children: [Center(child: Text(state.message))],
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: Text(l10n.retry),
          ),
        ],
      ),
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverTabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}
