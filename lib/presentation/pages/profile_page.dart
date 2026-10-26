import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../../presentation/state/user_notifier.dart';
import '../../core/animations/animated_wrapper.dart';
import '../widgets/empty_state.dart';
import '../widgets/org_avatar.dart';
import '../theme/app_palette.dart';
import '../widgets/app_skeleton.dart';
import '../widgets/app_surface.dart';
import '../widgets/forui/app_chrome.dart';
import '../widgets/forui/app_section.dart';
import '../widgets/forui/app_state_views.dart';
import '../widgets/forui/app_tile.dart';
import '../widgets/language_dot.dart';
import '../widgets/user_avatar.dart';
import 'create_org_page.dart';
import 'create_repo_page.dart';
import 'migrate_repo_page.dart';
import 'emails_page.dart';
import 'follow_page.dart';
import 'gpg_keys_page.dart';
import 'user_repos_page.dart';
import 'package_list_page.dart';
import 'organization_detail_page.dart';
import 'repo_detail_page.dart';
import 'organizations_list_page.dart';
import 'settings_page.dart';
import 'starred_repos_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Organization> _orgs = [];
  bool _orgsLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    await Future.wait([
      Injection.userNotifier.loadCurrentUser(),
      Injection.userNotifier.listCurrentUserRepos(),
    ]);
    _loadOrgs();
  }

  Future<void> _loadOrgs() async {
    if (_orgsLoading) return;
    setState(() => _orgsLoading = true);
    final result = await Injection.listCurrentUserOrgsUseCase();
    switch (result) {
      case Right<Failure, List<Organization>>(:final value):
        if (mounted) {
          setState(() {
            _orgs = value;
            _orgsLoading = false;
          });
        }
      case Left<Failure, List<Organization>>():
        if (mounted) {
          setState(() => _orgsLoading = false);
        }
    }
  }

  Future<void> _refresh() async {
    await Future.wait([
      Injection.userNotifier.loadCurrentUser(),
      Injection.userNotifier.listCurrentUserRepos(),
    ]);
    _loadOrgs();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Injection.userNotifier,
      builder: (context, _) {
        final state = Injection.userNotifier.state;
        return switch (state) {
          UserLoading() => const _LoadingView(),
          UserError(:final message) => _ErrorView(
            message: message,
            onRetry: _refresh,
          ),
          UserLoaded(:final user) => _ProfileContent(
            user: user,
            orgs: _orgs,
            orgsLoading: _orgsLoading,
            repos: Injection.userNotifier.repos,
            reposLoading: Injection.userNotifier.reposLoading,
            reposError: Injection.userNotifier.reposError,
            onRetryRepos: () => Injection.userNotifier.listCurrentUserRepos(),
            onRefresh: _refresh,
          ),
          _ => const _LoadingView(),
        };
      },
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const AppLoading();
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return EmptyState(
      icon: FIcons.circleAlert,
      title: l10n.failedToLoadProfile,
      subtitle: message,
      action: FButton(
        variant: .outline,
        prefix: const Icon(FIcons.refreshCw),
        onPress: onRetry,
        child: Text(l10n.retry),
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  final User user;
  final List<Organization> orgs;
  final bool orgsLoading;
  final List<Repository> repos;
  final bool reposLoading;
  final String? reposError;
  final VoidCallback onRetryRepos;
  final VoidCallback onRefresh;

  const _ProfileContent({
    required this.user,
    required this.orgs,
    required this.orgsLoading,
    required this.repos,
    required this.reposLoading,
    required this.reposError,
    required this.onRetryRepos,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return LayoutBuilder(
      builder: (context, constraints) {
        final inset = constraints.maxWidth > 940
            ? (constraints.maxWidth - 900) / 2
            : 20.0;
        return RefreshIndicator(
          color: context.palette.brand,
          backgroundColor: context.palette.surface,
          onRefresh: () async => onRefresh(),
          child: ListView(
            padding: EdgeInsets.fromLTRB(inset, 20, inset, 32),
            children: [
              FadeInWrapper(child: _UserHeader(user: user)),
              const SizedBox(height: 16),
              _StatsRow(user: user, l10n: l10n),
              const SizedBox(height: 16),
              _InfoCards(user: user, l10n: l10n),
              if (orgs.isNotEmpty) ...[
                const SizedBox(height: 20),
                _OrgsSection(orgs: orgs, loading: orgsLoading, l10n: l10n),
              ],
              const SizedBox(height: 20),
              _buildRepositories(context, l10n),
              const SizedBox(height: 20),
              AppSection(
                title: l10n.account,
                children: [
                  AppTile(
                    leading: const _AccountIcon(FIcons.plus),
                    title: l10n.createRepository,
                    onPress: () async {
                      final result = await Navigator.of(context).push<bool>(
                        MaterialPageRoute(
                          builder: (_) => const CreateRepoPage(),
                        ),
                      );
                      if (result == true && context.mounted) {
                        await Injection.userNotifier.listCurrentUserRepos();
                      }
                    },
                  ),
                  AppTile(
                    leading: const _AccountIcon(FIcons.import),
                    title: l10n.importRepository,
                    onPress: () async {
                      final result = await Navigator.of(context).push<bool>(
                        MaterialPageRoute(
                          builder: (_) => const MigrateRepoPage(),
                        ),
                      );
                      if (result == true && context.mounted) {
                        await Injection.userNotifier.listCurrentUserRepos();
                      }
                    },
                  ),
                  AppTile(
                    leading: const _AccountIcon(FIcons.star),
                    title: l10n.starredRepos,
                    onPress: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const StarredReposPage(),
                      ),
                    ),
                  ),
                  AppTile(
                    leading: const _AccountIcon(FIcons.package),
                    title: l10n.packages,
                    onPress: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            PackageListPage(owner: user.login ?? ''),
                      ),
                    ),
                  ),
                  AppTile(
                    leading: const _AccountIcon(FIcons.mail),
                    title: l10n.emails,
                    onPress: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const EmailsPage()),
                    ),
                  ),
                  AppTile(
                    leading: const _AccountIcon(FIcons.keyRound),
                    title: l10n.gpgKeys,
                    onPress: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const GpgKeysPage()),
                    ),
                  ),
                  AppTile(
                    leading: const _AccountIcon(FIcons.settings),
                    title: l10n.settings,
                    onPress: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SettingsPage()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _SignOutButton(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRepositories(BuildContext context, AppLocalizations l10n) {
    if (reposLoading && repos.isEmpty) {
      final palette = context.palette;
      return AppSection(
        title: l10n.repositories,
        children: [
          AppSkeleton(
            child: Column(
              children: List.generate(3, (index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(14, 11, 14, 11),
                  child: Row(
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: palette.surfaceMuted,
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SkeletonLine(widthFactor: 0.32, height: 9),
                            SizedBox(height: 5),
                            SkeletonLine(widthFactor: 0.55, height: 8),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      );
    }

    if (reposError != null && repos.isEmpty) {
      return AppSection(
        title: l10n.repositories,
        children: [_InlineRepoError(onRetry: onRetryRepos)],
      );
    }

    if (repos.isEmpty) return const SizedBox.shrink();

    return AppSection(
      title: l10n.repositories,
      trailing: AppSectionAction(
        label: l10n.viewAll,
        onPress: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => UserReposPage(username: user.login ?? ''),
          ),
        ),
      ),
      children: [
        for (final repo in repos.take(5))
          AppTile(
            leading: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: context.palette.brandSoft,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Icon(
                repo.private == true ? FIcons.lock : FIcons.folderGit,
                size: 13,
                color: context.palette.brand,
              ),
            ),
            title: repo.name ?? repo.full_name ?? '',
            subtitle: repo.description?.trim().isNotEmpty == true
                ? repo.description!.trim()
                : (repo.owner?.login ?? user.login ?? ''),
            showChevron: false,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (repo.language != null) LanguageDot(language: repo.language),
                if (repo.language != null) const SizedBox(width: 10),
                Icon(
                  FIcons.star,
                  size: 11,
                  color: context.palette.textSecondary,
                ),
                const SizedBox(width: 3),
                Text(
                  '${repo.stars_count ?? 0}',
                  style: TextStyle(
                    fontSize: 10.5,
                    color: context.palette.textSecondary,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  FIcons.chevronRight,
                  size: 13,
                  color: context.palette.textSecondary.withValues(alpha: 0.7),
                ),
              ],
            ),
            onPress: () {
              final owner = repo.owner?.login ?? user.login ?? '';
              final name = repo.name ?? '';
              if (owner.isNotEmpty && name.isNotEmpty) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => RepoDetailPage(owner: owner, repo: name),
                  ),
                );
              }
            },
          ),
      ],
    );
  }
}

class _InlineRepoError extends StatelessWidget {
  const _InlineRepoError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
      child: Row(
        children: [
          Icon(FIcons.circleAlert, size: 14, color: palette.danger),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.failedToLoadRepositories,
              style: TextStyle(fontSize: 11.5, color: palette.textSecondary),
            ),
          ),
          FButton(
            variant: FButtonVariant.ghost,
            size: FButtonSizeVariant.sm,
            onPress: onRetry,
            child: Text(l10n.retry),
          ),
        ],
      ),
    );
  }
}

class _UserHeader extends StatelessWidget {
  final User user;

  const _UserHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final palette = context.palette;
    final description = user.description?.trim() ?? '';

    return AppSurface(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAvatar(user: user, radius: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    Text(
                      user.full_name?.isNotEmpty == true
                          ? user.full_name!
                          : user.login ?? l10n.unknownUser,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.4,
                        height: 1.2,
                        color: palette.textPrimary,
                      ),
                    ),
                    if (user.is_admin == true)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2.5,
                        ),
                        decoration: BoxDecoration(
                          color: palette.brandSoft,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              FIcons.shieldCheck,
                              size: 10,
                              color: palette.brand,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              l10n.admin,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: palette.brand,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                if (user.login != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '@${user.login}',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: palette.textSecondary,
                    ),
                  ),
                ],
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.5,
                      color: palette.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final User user;
  final AppLocalizations l10n;

  const _StatsRow({required this.user, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return AppSurface(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              label: l10n.repos,
              value: '${user.starred_repos_count ?? 0}',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => UserReposPage(username: user.login ?? ''),
                  ),
                );
              },
            ),
          ),
          Container(width: 1, height: 28, color: palette.border),
          Expanded(
            child: _StatItem(
              label: l10n.followers,
              value: '${user.followers_count ?? 0}',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => FollowPage(
                      username: user.login ?? '',
                      type: FollowType.followers,
                    ),
                  ),
                );
              },
            ),
          ),
          Container(width: 1, height: 28, color: palette.border),
          Expanded(
            child: _StatItem(
              label: l10n.following,
              value: '${user.following_count ?? 0}',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => FollowPage(
                      username: user.login ?? '',
                      type: FollowType.following,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onTap;

  const _StatItem({required this.label, required this.value, this.onTap});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
            color: palette.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: palette.textSecondary),
        ),
      ],
    );
    if (onTap == null) return content;
    return FTappable(onPress: onTap, child: content);
  }
}

class _InfoCards extends StatelessWidget {
  final User user;
  final AppLocalizations l10n;

  const _InfoCards({required this.user, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];
    if (user.email != null && user.email!.isNotEmpty) {
      items.add(
        _InfoTile(
          icon: FIcons.mail,
          label: user.email!,
          onTap: () => _launchUrl('mailto:${user.email!}'),
        ),
      );
    }
    if (user.location != null && user.location!.isNotEmpty) {
      items.add(_InfoTile(icon: FIcons.mapPin, label: user.location!));
    }
    if (user.website != null && user.website!.isNotEmpty) {
      items.add(
        _InfoTile(
          icon: FIcons.globe,
          label: user.website!,
          onTap: () => _launchUrl(user.website!),
        ),
      );
    }
    if (user.created != null) {
      items.add(
        _InfoTile(
          icon: FIcons.calendar,
          label: l10n.joinedOnParams(_formatDate(user.created!)),
        ),
      );
    }

    if (items.isEmpty) return const SizedBox.shrink();

    return AppSection(title: l10n.accountInfo, children: items);
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _launchUrl(String url) async {
    var uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) {
      uri = Uri.tryParse('https://$url');
    }
    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _InfoTile({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppTile(
      leading: Icon(icon, size: 18, color: theme.colorScheme.primary),
      title: label,
      showChevron: false,
      trailing: onTap != null
          ? const Icon(FIcons.externalLink, size: 14)
          : null,
      onPress: onTap,
    );
  }
}

class _OrgsSection extends StatelessWidget {
  final List<Organization> orgs;
  final bool loading;
  final AppLocalizations l10n;

  const _OrgsSection({
    required this.orgs,
    required this.loading,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(3, 0, 3, 8),
          child: Row(
            children: [
              Expanded(
                child: FTappable(
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrganizationsListPage(orgs: orgs),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Text(
                        l10n.organisations,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.4,
                          color: context.palette.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        FIcons.chevronRight,
                        size: 13,
                        color: context.palette.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
              AppIconButton(
                icon: FIcons.plus,
                label: l10n.organisations,
                size: 28,
                iconSize: 15,
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CreateOrgPage()),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 82,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            itemCount: orgs.length,
            separatorBuilder: (_, _) => const SizedBox(width: UIConstants.sm),
            itemBuilder: (context, index) {
              final org = orgs[index];
              final displayName =
                  [org.full_name, org.name, org.username]
                      .whereType<String>()
                      .where((s) => s.isNotEmpty)
                      .firstOrNull ??
                  '';
              return FadeInWrapper(
                delay: Duration(milliseconds: index * 30),
                child: FTooltip(
                  tipBuilder: (context, controller) => Text(displayName),
                  child: FTappable(
                    onPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OrganizationDetailPage(
                            orgName:
                                [org.username, org.name]
                                    .whereType<String>()
                                    .where((s) => s.isNotEmpty)
                                    .firstOrNull ??
                                '',
                          ),
                        ),
                      );
                    },
                    child: SizedBox(
                      width: 76,
                      child: Column(
                        children: [
                          OrgAvatar(org: org, radius: 24),
                          const SizedBox(height: 7),
                          Text(
                            org.username ?? displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              color: context.palette.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SignOutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppSection(
      title: '',
      showHeader: false,
      children: [
        AppTile(
          leading: Icon(FIcons.logOut, size: 16, color: context.palette.danger),
          title: l10n.signOut,
          destructive: true,
          showChevron: false,
          onPress: () => _handleSignOut(context),
        ),
      ],
    );
  }

  void _handleSignOut(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showFDialog<void>(
      context: context,
      builder: (dialogContext, style, animation) => FDialog(
        title: Text(l10n.signOut),
        body: Text(l10n.signOutConfirmMessage),
        actions: [
          FButton(
            variant: .outline,
            onPress: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
          FButton(
            variant: .destructive,
            onPress: () {
              Navigator.of(dialogContext).pop();
              Injection.authNotifier.logout();
            },
            child: Text(l10n.signOut),
          ),
        ],
      ),
    );
  }
}

class _AccountIcon extends StatelessWidget {
  const _AccountIcon(this.icon);

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: context.palette.surfaceMuted,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 14, color: context.palette.textSecondary),
    );
  }
}
