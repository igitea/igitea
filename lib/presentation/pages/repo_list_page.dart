import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/animations/animated_wrapper.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../state/repo_notifier.dart';
import '../widgets/desktop/app_hover_region.dart';
import '../widgets/forui/app_page.dart';
import '../widgets/forui/app_state_views.dart';
import '../widgets/premium_card.dart';
import '../widgets/user_avatar.dart';
import 'repo_detail_page.dart';

class RepoListPage extends StatefulWidget {
  const RepoListPage({super.key});

  @override
  State<RepoListPage> createState() => _RepoListPageState();
}

class _RepoListPageState extends State<RepoListPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Injection.repoNotifier.searchRepos();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    Injection.repoNotifier.searchRepos(q: query.isEmpty ? null : query);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppPage(
      title: l10n.repoList,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: FTextField(
              control: FTextFieldControl.managed(
                controller: _searchController,
                onChange: (value) => _onSearch(value.text.trim()),
              ),
              hint: l10n.enterSearchQueryRepos,
              textInputAction: TextInputAction.search,
            ),
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: Injection.repoNotifier,
              builder: (context, _) {
                final state = Injection.repoNotifier.state;
                return switch (state) {
                  RepoLoading() => const AppLoading(),
                  RepoError(:final message) => AppError(
                    message: message,
                    onRetry: () => Injection.repoNotifier.searchRepos(),
                  ),
                  SearchResultsLoaded(:final results) => _RepoList(
                    repos: results.data ?? [],
                  ),
                  RepoInitial() => AppEmpty(
                    icon: FIcons.search,
                    title: l10n.searchRepositoriesHint,
                  ),
                  _ => AppEmpty(
                    icon: FIcons.search,
                    title: l10n.searchRepositoriesHint,
                  ),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RepoList extends StatelessWidget {
  final List<Repository> repos;

  const _RepoList({required this.repos});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (repos.isEmpty) {
      return AppEmpty(icon: FIcons.folderOpen, title: l10n.noRepositoriesFound);
    }
    return RefreshIndicator(
      onRefresh: () => Injection.repoNotifier.searchRepos(),
      child: ListView.builder(
        padding:
            UIConstants.pagePadding +
            const EdgeInsets.symmetric(vertical: UIConstants.sm),
        itemCount: repos.length,
        itemBuilder: (context, index) {
          final repo = repos[index];
          return FadeInWrapper(
            delay: Duration(milliseconds: index * 30),
            child: _RepoCard(repo: repo),
          );
        },
      ),
    );
  }
}

class _RepoCard extends StatelessWidget {
  final Repository repo;

  const _RepoCard({required this.repo});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final fullName = repo.full_name ?? repo.name ?? '';

    return PremiumListCard(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => RepoDetailPage(
              owner: repo.owner?.login ?? '',
              repo: repo.name ?? '',
            ),
          ),
        );
      },
      contextMenuItems: [
        AppMenuItem(
          label: l10n.openRepository,
          icon: FIcons.folderGit,
          onSelected: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => RepoDetailPage(
                owner: repo.owner?.login ?? '',
                repo: repo.name ?? '',
              ),
            ),
          ),
        ),
        AppMenuItem(
          label: l10n.copyName,
          icon: FIcons.copy,
          onSelected: () async {
            await Clipboard.setData(ClipboardData(text: fullName));
            if (context.mounted) {
              showFToast(context: context, title: Text(l10n.copied));
            }
          },
        ),
        if (repo.html_url != null)
          AppMenuItem(
            label: l10n.openInBrowser,
            icon: FIcons.externalLink,
            onSelected: () => launchUrl(
              Uri.parse(repo.html_url!),
              mode: LaunchMode.externalApplication,
            ),
          ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (repo.owner != null)
                UserAvatar(user: repo.owner!, radius: UIConstants.avatarSm)
              else
                Icon(
                  repo.private == true ? FIcons.lock : FIcons.globe,
                  size: UIConstants.iconMd,
                  color: theme.colorScheme.primary,
                ),
              const SizedBox(width: UIConstants.sm),
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        repo.full_name ?? repo.name ?? '',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (repo.private == true) ...[
                      const SizedBox(width: UIConstants.sm),
                      FBadge(variant: .secondary, child: Text(l10n.private)),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (repo.description != null && repo.description!.isNotEmpty) ...[
            const SizedBox(height: UIConstants.xs),
            Text(
              repo.description!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: UIConstants.sm),
          Row(
            children: [
              if (repo.language != null) ...[
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: UIConstants.xs),
                Text(repo.language!, style: theme.textTheme.labelSmall),
                const SizedBox(width: UIConstants.md),
              ],
              Icon(
                FIcons.star,
                size: UIConstants.iconSm,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: UIConstants.xs),
              Text(
                '${repo.stars_count ?? 0}',
                style: theme.textTheme.labelSmall,
              ),
              const SizedBox(width: UIConstants.md),
              Icon(
                FIcons.gitFork,
                size: UIConstants.iconSm,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: UIConstants.xs),
              Text(
                '${repo.forks_count ?? 0}',
                style: theme.textTheme.labelSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
