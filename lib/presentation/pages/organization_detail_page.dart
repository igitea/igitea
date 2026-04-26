import 'package:flutter/material.dart';

import '../../core/animations/animated_wrapper.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../state/organization_notifier.dart';
import '../widgets/org_avatar.dart';
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
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (org.location != null && org.location!.isNotEmpty)
          _buildInfoRow(
            context,
            icon: Icons.location_on_outlined,
            label: l10n.location,
            value: org.location!,
          ),
        if (org.email != null && org.email!.isNotEmpty)
          _buildInfoRow(
            context,
            icon: Icons.email_outlined,
            label: l10n.email,
            value: org.email!,
          ),
        if (org.website != null && org.website!.isNotEmpty)
          _buildInfoRow(
            context,
            icon: Icons.link,
            label: l10n.website,
            value: org.website!,
            isLink: true,
          ),
        if (org.visibility != null)
          _buildInfoRow(
            context,
            icon: Icons.visibility_outlined,
            label: l10n.visibility,
            value: org.visibility!,
          ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isLink ? theme.colorScheme.primary : null,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
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
    return ListenableBuilder(
      listenable: Injection.organizationNotifier,
      builder: (context, _) {
        final state = Injection.organizationNotifier.state;
        if (state is OrgReposLoaded) {
          final repos = state.repos;
          if (repos.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => Injection.organizationNotifier.listOrgRepos(widget.orgName),
              child: ListView(
                children: [Center(child: Text(l10n.noData))],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => Injection.organizationNotifier.listOrgRepos(widget.orgName),
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
                            owner: repo.owner?.login ?? widget.orgName,
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
            onRefresh: () => Injection.organizationNotifier.listOrgRepos(widget.orgName),
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
    return ListenableBuilder(
      listenable: Injection.organizationNotifier,
      builder: (context, _) {
        final state = Injection.organizationNotifier.state;
        if (state is OrgTeamsLoaded) {
          final teams = state.teams;
          if (teams.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => Injection.organizationNotifier.listOrgTeams(widget.orgName),
              child: ListView(
                children: [Center(child: Text(l10n.noTeams))],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => Injection.organizationNotifier.listOrgTeams(widget.orgName),
            child: ListView.builder(
              itemCount: teams.length,
              itemBuilder: (context, index) {
                final team = teams[index];
                return FadeInWrapper(
                  delay: Duration(milliseconds: index * 30),
                  child: ListTile(
                    leading: const Icon(Icons.people_outline),
                    title: Text(team.name ?? ''),
                    subtitle: team.description != null
                        ? Text(
                            team.description!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        : null,
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
                  ),
                );
              },
            ),
          );
        } else if (state is OrgError) {
          return RefreshIndicator(
            onRefresh: () => Injection.organizationNotifier.listOrgTeams(widget.orgName),
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
