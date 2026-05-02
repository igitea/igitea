import 'package:flutter/material.dart';

import '../../core/animations/animated_wrapper.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      _repos = await Injection.apiService.userListRepos(username: widget.username);
    } catch (_) {
      _repos = [];
    }
    if (mounted) setState(() => _loading = false);
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
                    itemCount: _repos.length,
                    itemBuilder: (context, index) {
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
