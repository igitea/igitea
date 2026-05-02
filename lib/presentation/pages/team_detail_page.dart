import 'package:flutter/material.dart';

import '../../core/animations/animated_wrapper.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../state/organization_notifier.dart';
import '../widgets/user_avatar.dart';
import 'repo_detail_page.dart';
import 'edit_team_page.dart';

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
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: l10n.editTeam,
                onPressed: () async {
                  final result = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(builder: (_) => EditTeamPage(team: team)),
                  );
                  if (result == true && mounted) {
                    Injection.organizationNotifier.getTeam(widget.teamId);
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: l10n.deleteTeam,
                onPressed: () => _deleteTeam(team, l10n),
              ),
            ],
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

  Future<void> _deleteTeam(Team team, AppLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteTeam),
        content: Text(l10n.deleteTeamConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      final success = await Injection.organizationNotifier.deleteTeam(id: team.id!);
      if (mounted && success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.teamDeleted)));
        Navigator.pop(context, true);
      }
    }
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
                  label: Text(AppLocalizations.of(context)!.allRepos),
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
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (team.description != null && team.description!.isNotEmpty) ...[
          Text(
            l10n.description,
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
            l10n.units,
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
          label: l10n.permission,
          value: team.permission ?? '-',
        ),
        _InfoRow(
          icon: Icons.folder_copy,
          label: l10n.allRepos,
          value: team.includes_all_repositories == true ? l10n.yes : l10n.no,
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

class _MembersTabState extends State<_MembersTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Injection.organizationNotifier.listTeamMembers(widget.teamId);
    });
  }

  Future<void> _addMember() async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    List<User> results = [];
    bool searching = false;

    final username = await showDialog<String>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(l10n.addMember),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: l10n.searchMembers,
                  border: const OutlineInputBorder(),
                ),
                onChanged: (q) async {
                  if (q.trim().isEmpty) {
                    setDialogState(() => results = []);
                    return;
                  }
                  setDialogState(() => searching = true);
                  try {
                    results = await Injection.apiService.adminSearchUsers(login_name: q.trim());
                  } catch (_) {
                    results = [];
                  }
                  setDialogState(() => searching = false);
                },
              ),
              const SizedBox(height: 12),
              if (searching)
                const CircularProgressIndicator(strokeWidth: 2)
              else if (results.isEmpty && controller.text.trim().isNotEmpty)
                Text(l10n.noSearchResults)
              else
                ...results.map((u) => ListTile(
                  leading: UserAvatar(user: u, radius: 14),
                  title: Text(u.login ?? ''),
                  dense: true,
                  onTap: () => Navigator.pop(ctx, u.login),
                )),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
          ],
        ),
      ),
    );

    if (username != null && username.isNotEmpty) {
      final success = await Injection.organizationNotifier.addTeamMember(
        id: widget.teamId,
        username: username,
      );
      if (mounted && success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.memberAdded)));
        Injection.organizationNotifier.listTeamMembers(widget.teamId);
      }
    }
  }

  Future<void> _removeMember(String username) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.removeMember),
        content: Text(l10n.removeMemberConfirmParams(username)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.removeMember)),
        ],
      ),
    );
    if (confirmed == true) {
      final success = await Injection.organizationNotifier.removeTeamMember(
        id: widget.teamId,
        username: username,
      );
      if (mounted && success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.memberRemoved)));
        Injection.organizationNotifier.listTeamMembers(widget.teamId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _addMember,
              icon: const Icon(Icons.person_add_outlined, size: 18),
              label: Text(l10n.addMember),
            ),
          ),
        ),
        Expanded(
          child: ListenableBuilder(
            listenable: Injection.organizationNotifier,
            builder: (context, _) {
              final state = Injection.organizationNotifier.teamMembersState;
              if (state is OrgTeamMembersLoaded) {
                final members = state.members;
                if (members.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () => Injection.organizationNotifier.listTeamMembers(widget.teamId),
                    child: ListView(children: [Center(child: Text(l10n.noMembers))]),
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
                          trailing: IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            tooltip: l10n.removeMember,
                            onPressed: () => _removeMember(member.login ?? ''),
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else if (state is OrgError) {
                return RefreshIndicator(
                  onRefresh: () => Injection.organizationNotifier.listTeamMembers(widget.teamId),
                  child: ListView(children: [Center(child: Text(state.message))]),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }
}

class _ReposTab extends StatefulWidget {
  final int teamId;

  const _ReposTab({required this.teamId});

  @override
  State<_ReposTab> createState() => _ReposTabState();
}

class _ReposTabState extends State<_ReposTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Injection.organizationNotifier.listTeamRepos(widget.teamId);
    });
  }

  @override
  Widget build(BuildContext context) {
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
