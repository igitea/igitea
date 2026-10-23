import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../core/animations/animated_wrapper.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../state/organization_notifier.dart';
import '../widgets/forui/app_page.dart';
import '../widgets/forui/app_state_views.dart';
import '../widgets/forui/app_tile.dart';
import '../widgets/user_avatar.dart';
import 'edit_team_page.dart';
import 'repo_detail_page.dart';

class TeamDetailPage extends StatefulWidget {
  final int teamId;

  const TeamDetailPage({super.key, required this.teamId});

  @override
  State<TeamDetailPage> createState() => _TeamDetailPageState();
}

class _TeamDetailPageState extends State<TeamDetailPage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Injection.organizationNotifier.getTeam(widget.teamId);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: Injection.organizationNotifier,
      builder: (context, _) {
        final state = Injection.organizationNotifier.teamDetailState;
        final loaded = state is OrgTeamDetailLoaded ? state.team : null;

        return AppPage(
          title: loaded?.name ?? l10n.teams,
          actions: loaded == null
              ? const []
              : [
                  FHeaderAction(
                    icon: const Icon(FIcons.pencilLine),
                    semanticsLabel: l10n.editTeam,
                    onPress: () async {
                      final result = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditTeamPage(team: loaded),
                        ),
                      );
                      if (result == true && mounted) {
                        Injection.organizationNotifier.getTeam(widget.teamId);
                      }
                    },
                  ),
                  FHeaderAction(
                    icon: const Icon(FIcons.trash2),
                    semanticsLabel: l10n.deleteTeam,
                    onPress: () => _deleteTeam(loaded, l10n),
                  ),
                ],
          child: switch (state) {
            OrgLoading() => const AppLoading(),
            OrgError(:final message) => AppError(
              message: message,
              onRetry: () =>
                  Injection.organizationNotifier.getTeam(widget.teamId),
            ),
            OrgTeamDetailLoaded(:final team) => _buildContent(
              context,
              team,
              l10n,
            ),
            _ => const AppLoading(),
          },
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, Team team, AppLocalizations l10n) {
    return Column(
      children: [
        _TeamHeader(team: team),
        Expanded(
          child: FTabs(
            expands: true,
            children: [
              FTabEntry(
                label: Text(l10n.info),
                child: _InfoTab(team: team),
              ),
              FTabEntry(
                label: Text(l10n.members),
                child: _MembersTab(teamId: widget.teamId),
              ),
              FTabEntry(
                label: Text(l10n.repositories),
                child: _ReposTab(teamId: widget.teamId),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _deleteTeam(Team team, AppLocalizations l10n) async {
    final confirmed = await showFDialog<bool>(
      context: context,
      builder: (ctx, style, animation) => FDialog(
        title: Text(l10n.deleteTeam),
        body: Text(l10n.deleteTeamConfirm),
        actions: [
          FButton(
            variant: .outline,
            onPress: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FButton(
            variant: .destructive,
            onPress: () => Navigator.pop(ctx, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      final success = await Injection.organizationNotifier.deleteTeam(
        id: team.id!,
      );
      if (mounted && success) {
        showFToast(context: context, title: Text(l10n.teamDeleted));
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
                  FIcons.users,
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
                    if (team.description != null &&
                        team.description!.isNotEmpty)
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
                FBadge(variant: .outline, child: Text(team.permission!)),
              if (team.includes_all_repositories == true)
                FBadge(
                  variant: .outline,
                  child: Text(AppLocalizations.of(context)!.allRepos),
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
                .map((unit) => FBadge(variant: .outline, child: Text(unit)))
                .toList(),
          ),
          const SizedBox(height: 16),
        ],
        _InfoRow(
          icon: FIcons.shieldCheck,
          label: l10n.permission,
          value: team.permission ?? '-',
        ),
        _InfoRow(
          icon: FIcons.folder,
          label: l10n.allRepos,
          value: team.includes_all_repositories == true ? l10n.yes : l10n.no,
        ),
        if (team.can_create_org_repo == true)
          _InfoRow(
            icon: FIcons.circlePlus,
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

    final username = await showFDialog<String>(
      context: context,
      builder: (ctx, style, animation) => StatefulBuilder(
        builder: (ctx, setDialogState) => FDialog(
          title: Text(l10n.addMember),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FTextField(
                control: FTextFieldControl.managed(
                  controller: controller,
                  onChange: (value) async {
                    final q = value.text;
                    if (q.trim().isEmpty) {
                      setDialogState(() => results = []);
                      return;
                    }
                    setDialogState(() => searching = true);
                    try {
                      results = await Injection.apiService.adminSearchUsers(
                        login_name: q.trim(),
                      );
                    } catch (_) {
                      results = [];
                    }
                    setDialogState(() => searching = false);
                  },
                ),
                hint: l10n.searchMembers,
              ),
              const SizedBox(height: 12),
              if (searching)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: FCircularProgress(size: .sm),
                )
              else if (results.isEmpty && controller.text.trim().isNotEmpty)
                Text(l10n.noSearchResults)
              else
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 260),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (final u in results)
                          AppTile(
                            leading: UserAvatar(user: u, radius: 14),
                            title: u.login ?? '',
                            showChevron: false,
                            onPress: () => Navigator.pop(ctx, u.login),
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          actions: [
            FButton(
              variant: .outline,
              onPress: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
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
        showFToast(context: context, title: Text(l10n.memberAdded));
        Injection.organizationNotifier.listTeamMembers(widget.teamId);
      }
    }
  }

  Future<void> _removeMember(String username) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showFDialog<bool>(
      context: context,
      builder: (ctx, style, animation) => FDialog(
        title: Text(l10n.removeMember),
        body: Text(l10n.removeMemberConfirmParams(username)),
        actions: [
          FButton(
            variant: .outline,
            onPress: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FButton(
            variant: .destructive,
            onPress: () => Navigator.pop(ctx, true),
            child: Text(l10n.removeMember),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      final success = await Injection.organizationNotifier.removeTeamMember(
        id: widget.teamId,
        username: username,
      );
      if (mounted && success) {
        showFToast(context: context, title: Text(l10n.memberRemoved));
        Injection.organizationNotifier.listTeamMembers(widget.teamId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: FButton(
            variant: .outline,
            prefix: const Icon(FIcons.userPlus, size: 18),
            onPress: _addMember,
            child: Text(l10n.addMember),
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
                    onRefresh: () => Injection.organizationNotifier
                        .listTeamMembers(widget.teamId),
                    child: ListView(
                      children: [
                        AppEmpty(icon: FIcons.users, title: l10n.noMembers),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () => Injection.organizationNotifier
                      .listTeamMembers(widget.teamId),
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                    itemCount: members.length,
                    itemBuilder: (context, index) {
                      final member = members[index];
                      return FadeInWrapper(
                        delay: Duration(milliseconds: index * 30),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: FCard.raw(
                            child: AppTile(
                              leading: UserAvatar(user: member, radius: 16),
                              title: member.login ?? member.full_name ?? '',
                              subtitle: member.full_name,
                              showChevron: false,
                              trailing: FTappable(
                                onPress: () =>
                                    _removeMember(member.login ?? ''),
                                semanticsLabel: l10n.removeMember,
                                child: Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: Icon(
                                    FIcons.circleMinus,
                                    size: 18,
                                    color: theme.colorScheme.error,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else if (state is OrgError) {
                return RefreshIndicator(
                  onRefresh: () => Injection.organizationNotifier
                      .listTeamMembers(widget.teamId),
                  child: ListView(
                    children: [
                      AppEmpty(icon: FIcons.circleAlert, title: state.message),
                    ],
                  ),
                );
              }
              return const AppLoading();
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
              onRefresh: () =>
                  Injection.organizationNotifier.listTeamRepos(widget.teamId),
              child: ListView(
                children: [
                  AppEmpty(icon: FIcons.folderOpen, title: l10n.noData),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () =>
                Injection.organizationNotifier.listTeamRepos(widget.teamId),
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              itemCount: repos.length,
              itemBuilder: (context, index) {
                final repo = repos[index];
                return FadeInWrapper(
                  delay: Duration(milliseconds: index * 30),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: FCard.raw(
                      child: AppTile(
                        leading: const Icon(FIcons.folder, size: 18),
                        title: repo.name ?? '',
                        subtitle: repo.description,
                        onPress: () {
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
                    ),
                  ),
                );
              },
            ),
          );
        } else if (state is OrgError) {
          return RefreshIndicator(
            onRefresh: () =>
                Injection.organizationNotifier.listTeamRepos(widget.teamId),
            child: ListView(
              children: [
                AppEmpty(icon: FIcons.circleAlert, title: state.message),
              ],
            ),
          );
        }
        return const AppLoading();
      },
    );
  }
}

