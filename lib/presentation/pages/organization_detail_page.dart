import 'package:flutter/material.dart';

import '../../core/animations/animated_wrapper.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../state/organization_notifier.dart';
import '../widgets/empty_state.dart';
import '../widgets/org_avatar.dart';
import '../widgets/premium_card.dart';
import 'edit_org_page.dart';
import 'repo_detail_page.dart';
import 'team_detail_page.dart';

class OrganizationDetailPage extends StatefulWidget {
  final String orgName;

  const OrganizationDetailPage({
    super.key,
    required this.orgName,
  });

  @override
  State<OrganizationDetailPage> createState() => _OrganizationDetailPageState();
}

class _OrganizationDetailPageState extends State<OrganizationDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Injection.organizationNotifier.getOrg(widget.orgName);
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
          final state = Injection.organizationNotifier.state;
          return switch (state) {
            OrgLoading() => const Center(child: CircularProgressIndicator()),
            OrgError(:final message) => _ErrorView(
                message: message,
                onRetry: () =>
                    Injection.organizationNotifier.getOrg(widget.orgName),
              ),
            OrgLoaded(:final org) => _buildContent(context, org, l10n),
            _ => const Center(child: CircularProgressIndicator()),
          };
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, Organization org, AppLocalizations l10n) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            title: Text(org.username ?? widget.orgName),
            pinned: true,
            floating: true,
            forceElevated: innerBoxIsScrolled,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditOrgPage(org: org),
                    ),
                  ).then((result) {
                    if (result == true) {
                      Injection.organizationNotifier.getOrg(widget.orgName);
                    }
                  });
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: _OrgHeader(org: org),
          ),
          SliverPersistentHeader(
            delegate: _SliverTabBarDelegate(
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(icon: const Icon(Icons.info_outline), text: l10n.info),
                  Tab(icon: const Icon(Icons.folder_outlined), text: l10n.repositories),
                  Tab(icon: const Icon(Icons.people_outline), text: l10n.teams),
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
          _InfoTab(org: org),
          _ReposTab(orgName: widget.orgName),
          _TeamsTab(orgName: widget.orgName),
        ],
      ),
    );
  }
}

class _OrgHeader extends StatelessWidget {
  final Organization org;

  const _OrgHeader({required this.org});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          OrgAvatar(org: org, radius: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  org.full_name ?? org.name ?? org.username ?? '',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (org.description != null && org.description!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      org.description!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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

class _InfoTab extends StatelessWidget {
  final Organization org;

  const _InfoTab({required this.org});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Organization Details Card
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.details,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              if (org.description != null && org.description!.isNotEmpty) ...[
                _buildInfoRow(
                  context,
                  icon: Icons.description_outlined,
                  label: l10n.description,
                  value: org.description!,
                ),
                const Divider(height: 24),
              ],
              if (org.location != null && org.location!.isNotEmpty) ...[
                _buildInfoRow(
                  context,
                  icon: Icons.location_on_outlined,
                  label: l10n.location,
                  value: org.location!,
                ),
                const Divider(height: 24),
              ],
              if (org.email != null && org.email!.isNotEmpty) ...[
                _buildInfoRow(
                  context,
                  icon: Icons.email_outlined,
                  label: l10n.email,
                  value: org.email!,
                ),
                const Divider(height: 24),
              ],
              if (org.website != null && org.website!.isNotEmpty) ...[
                _buildInfoRow(
                  context,
                  icon: Icons.link,
                  label: l10n.website,
                  value: org.website!,
                  isLink: true,
                ),
                const Divider(height: 24),
              ],
              _buildInfoRow(
                context,
                icon: Icons.visibility_outlined,
                label: l10n.visibility,
                value: org.visibility ?? 'public',
              ),
              if (org.repo_admin_change_team_access != null) ...[
                const Divider(height: 24),
                _buildInfoRow(
                  context,
                  icon: Icons.admin_panel_settings_outlined,
                  label: l10n.teamAdminAccess,
                  value: org.repo_admin_change_team_access! ? l10n.yes : l10n.no,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Stats Card
        _OrgStatsCard(org: org),
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    bool isLink = false,
  }) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isLink ? theme.colorScheme.primary : null,
                  fontWeight: isLink ? FontWeight.w500 : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OrgStatsCard extends StatelessWidget {
  final Organization org;

  const _OrgStatsCard({required this.org});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return PremiumCard(
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              icon: Icons.folder_outlined,
              label: l10n.id,
              value: '#${org.id ?? 0}',
            ),
          ),
          Container(
            height: 40,
            width: 1,
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
          Expanded(
            child: _StatItem(
              icon: Icons.alternate_email,
              label: l10n.username,
              value: org.username ?? '-',
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, size: 24, color: theme.colorScheme.primary),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _ReposTab extends StatefulWidget {
  final String orgName;

  const _ReposTab({required this.orgName});

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
      Injection.organizationNotifier.listOrgRepos(widget.orgName);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: Injection.organizationNotifier,
      builder: (context, _) {
        final state = Injection.organizationNotifier.reposState;
        if (state is OrgReposLoaded) {
          final repos = state.repos;
          if (repos.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => Injection.organizationNotifier.listOrgRepos(widget.orgName),
              child: ListView(
                children: [
                  EmptyState(
                    icon: Icons.folder_outlined,
                    title: l10n.noRepositoriesFound,
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => Injection.organizationNotifier.listOrgRepos(widget.orgName),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: repos.length,
              itemBuilder: (context, index) {
                final repo = repos[index];
                return FadeInWrapper(
                  delay: Duration(milliseconds: index * 30),
                  child: PremiumListCard(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RepoDetailPage(
                            owner: repo.owner?.login ?? widget.orgName,
                            repo: repo.name ?? '',
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Icon(
                          repo.private == true ? Icons.lock : Icons.public,
                          size: 20,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                repo.name ?? '',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (repo.description != null &&
                                  repo.description!.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  repo.description!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  if (repo.language != null) ...[
                                    Icon(
                                      Icons.code,
                                      size: 14,
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      repo.language!,
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                  ],
                                  Icon(
                                    Icons.star_outline,
                                    size: 14,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${repo.stars_count ?? 0}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Icon(
                                    Icons.call_split,
                                    size: 14,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${repo.forks_count ?? 0}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else if (state is OrgError) {
          return RefreshIndicator(
            onRefresh: () => Injection.organizationNotifier.listOrgRepos(widget.orgName),
            child: ListView(
              children: [
                EmptyState(
                  icon: Icons.error_outline,
                  title: state.message,
                  action: FilledButton(
                    onPressed: () => Injection.organizationNotifier.listOrgRepos(widget.orgName),
                    child: Text(l10n.retry),
                  ),
                ),
              ],
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _TeamsTab extends StatefulWidget {
  final String orgName;

  const _TeamsTab({required this.orgName});

  @override
  State<_TeamsTab> createState() => _TeamsTabState();
}

class _TeamsTabState extends State<_TeamsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Injection.organizationNotifier.listOrgTeams(widget.orgName);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: Injection.organizationNotifier,
      builder: (context, _) {
        final state = Injection.organizationNotifier.teamsState;
        if (state is OrgTeamsLoaded) {
          final teams = state.teams;
          if (teams.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => Injection.organizationNotifier.listOrgTeams(widget.orgName),
              child: ListView(
                children: [
                  EmptyState(
                    icon: Icons.people_outline,
                    title: l10n.noTeams,
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => Injection.organizationNotifier.listOrgTeams(widget.orgName),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: teams.length,
              itemBuilder: (context, index) {
                final team = teams[index];
                return FadeInWrapper(
                  delay: Duration(milliseconds: index * 30),
                  child: PremiumListCard(
                    onTap: () {
                      if (team.id != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TeamDetailPage(teamId: team.id!),
                          ),
                        );
                      }
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: theme.colorScheme.primaryContainer,
                          child: Icon(
                            Icons.people,
                            size: 20,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                team.name ?? '',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (team.description != null &&
                                  team.description!.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  team.description!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 4),
                              Wrap(
                                spacing: 8,
                                children: [
                                  if (team.permission != null)
                                    _TeamBadge(
                                      icon: Icons.security,
                                      label: team.permission!,
                                    ),
                                  if (team.includes_all_repositories == true)
                                    _TeamBadge(
                                      icon: Icons.folder_copy,
                                      label: l10n.allRepos,
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else if (state is OrgError) {
          return RefreshIndicator(
            onRefresh: () => Injection.organizationNotifier.listOrgTeams(widget.orgName),
            child: ListView(
              children: [
                EmptyState(
                  icon: Icons.error_outline,
                  title: state.message,
                  action: FilledButton(
                    onPressed: () => Injection.organizationNotifier.listOrgTeams(widget.orgName),
                    child: Text(l10n.retry),
                  ),
                ),
              ],
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _TeamBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _TeamBadge({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: theme.colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
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
