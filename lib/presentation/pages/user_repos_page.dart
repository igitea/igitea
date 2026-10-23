import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../core/di/injection.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../domain/usecases/user_usecases.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/forui/app_page.dart';
import '../widgets/forui/app_state_views.dart';
import '../widgets/forui/app_tile.dart';
import 'repo_detail_page.dart';

class UserReposPage extends StatefulWidget {
  final String username;

  const UserReposPage({super.key, required this.username});

  @override
  State<UserReposPage> createState() => _UserReposPageState();
}

class _UserReposPageState extends State<UserReposPage> {
  List<Repository> _repos = [];
  bool _loading = true;
  bool _loadingMore = false;
  bool _hasMore = false;
  int _page = 1;
  static const int _limit = 20;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    _page = 1;
    final result = await Injection.listUserReposUseCase(
      ListUserReposParams(username: widget.username, page: 1, limit: _limit),
    );
    if (mounted) {
      if (result is Right<Failure, List<Repository>>) {
        _repos = result.value
            .where((r) => r.owner?.login == widget.username)
            .toList();
        _hasMore = result.value.length >= _limit;
      } else {
        _repos = [];
      }
      setState(() => _loading = false);
    }
  }

  Future<void> _loadMore() async {
    if (_loadingMore || !_hasMore) return;
    setState(() => _loadingMore = true);
    _page++;
    final result = await Injection.listUserReposUseCase(
      ListUserReposParams(
        username: widget.username,
        page: _page,
        limit: _limit,
      ),
    );
    if (mounted) {
      if (result is Right<Failure, List<Repository>>) {
        final filtered = result.value
            .where((r) => r.owner?.login == widget.username)
            .toList();
        _repos = [..._repos, ...filtered];
        _hasMore = result.value.length >= _limit;
      } else {
        _page--;
      }
      setState(() => _loadingMore = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return AppPage(
      title: l10n.repos,
      child: _loading
          ? const AppLoading()
          : _repos.isEmpty
          ? AppEmpty(icon: FIcons.folderGit, title: l10n.noData)
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                itemCount: _repos.length + (_hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _repos.length) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: _loadingMore
                            ? const FCircularProgress(size: .sm)
                            : FButton(
                                variant: .ghost,
                                size: .sm,
                                onPress: _loadMore,
                                child: const Text('Load more'),
                              ),
                      ),
                    );
                  }
                  final repo = _repos[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: FCard.raw(
                      child: AppTile(
                        leading: Icon(
                          FIcons.folderGit,
                          size: 18,
                          color: theme.colorScheme.primary,
                        ),
                        title: repo.full_name ?? repo.name ?? '',
                        subtitle: repo.description,
                        onPress: () {
                          final owner = repo.owner?.login ?? '';
                          final name = repo.name ?? '';
                          if (owner.isNotEmpty && name.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    RepoDetailPage(owner: owner, repo: name),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
