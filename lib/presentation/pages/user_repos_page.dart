import 'package:flutter/material.dart';

import '../../core/animations/animated_wrapper.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../domain/usecases/user_usecases.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/empty_state.dart';
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
        _repos = result.value.where((r) => r.owner?.login == widget.username).toList();
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
      ListUserReposParams(username: widget.username, page: _page, limit: _limit),
    );
    if (mounted) {
      if (result is Right<Failure, List<Repository>>) {
        final filtered = result.value.where((r) => r.owner?.login == widget.username).toList();
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
    return Scaffold(
      appBar: AppBar(title: Text(l10n.repos)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _repos.isEmpty
              ? EmptyState(icon: Icons.folder_outlined, title: l10n.noData)
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(UIConstants.md),
                    itemCount: _repos.length + (_hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _repos.length) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: _loadingMore
                                ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2))
                                : TextButton(
                                    onPressed: _loadMore,
                                    child: const Text('Load more'),
                                  ),
                          ),
                        );
                      }
                      final repo = _repos[index];
                      return FadeInWrapper(
                        delay: Duration(milliseconds: index * 20),
                        child: Card(
                          elevation: 0,
                          margin: const EdgeInsets.only(bottom: UIConstants.sm),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
                          ),
                          child: ListTile(
                            leading: Icon(Icons.folder_outlined, color: Theme.of(context).colorScheme.primary),
                            title: Text(repo.full_name ?? repo.name ?? ''),
                            subtitle: repo.description != null && repo.description!.isNotEmpty
                                ? Text(repo.description!, maxLines: 1, overflow: TextOverflow.ellipsis)
                                : null,
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              final owner = repo.owner?.login ?? '';
                              final name = repo.name ?? '';
                              if (owner.isNotEmpty && name.isNotEmpty) {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (_) => RepoDetailPage(owner: owner, repo: name),
                                ));
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
