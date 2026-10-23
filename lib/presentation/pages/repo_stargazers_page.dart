import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/forui/app_page.dart';
import '../widgets/forui/app_state_views.dart';
import '../widgets/forui/app_tile.dart';
import '../widgets/user_avatar.dart';
import 'user_profile_page.dart';

class RepoStargazersPage extends StatefulWidget {
  final String owner;
  final String repo;

  const RepoStargazersPage({
    super.key,
    required this.owner,
    required this.repo,
  });

  @override
  State<RepoStargazersPage> createState() => _RepoStargazersPageState();
}

class _RepoStargazersPageState extends State<RepoStargazersPage> {
  List<User> _stargazers = [];
  List<User> _subscribers = [];
  bool _stargazersLoading = true;
  bool _subscribersLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStargazers();
    _loadSubscribers();
  }

  Future<void> _loadStargazers() async {
    setState(() => _stargazersLoading = true);
    try {
      _stargazers = await Injection.apiService.repoListStargazers(
        owner: widget.owner,
        repo: widget.repo,
      );
    } catch (_) {}
    if (mounted) setState(() => _stargazersLoading = false);
  }

  Future<void> _loadSubscribers() async {
    setState(() => _subscribersLoading = true);
    try {
      _subscribers = await Injection.apiService.repoListSubscribers(
        owner: widget.owner,
        repo: widget.repo,
      );
    } catch (_) {}
    if (mounted) setState(() => _subscribersLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppPage(
      title: '${widget.owner}/${widget.repo}',
      child: FTabs(
        expands: true,
        children: [
          FTabEntry(
            label: Text(l10n.stargazers),
            child: _UserList(
              users: _stargazers,
              loading: _stargazersLoading,
              emptyTitle: l10n.noStargazers,
            ),
          ),
          FTabEntry(
            label: Text(l10n.subscribers),
            child: _UserList(
              users: _subscribers,
              loading: _subscribersLoading,
              emptyTitle: l10n.noSubscribers,
            ),
          ),
        ],
      ),
    );
  }
}

class _UserList extends StatelessWidget {
  final List<User> users;
  final bool loading;
  final String emptyTitle;

  const _UserList({
    required this.users,
    required this.loading,
    required this.emptyTitle,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const AppLoading();
    }
    if (users.isEmpty) {
      return AppEmpty(icon: FIcons.users, title: emptyTitle);
    }
    return ListView.builder(
      padding: const EdgeInsets.all(UIConstants.md),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: UIConstants.sm),
          child: FCard.raw(
            child: AppTile(
              leading: UserAvatar(user: user, radius: UIConstants.avatarMd),
              title: user.full_name ?? user.login ?? '',
              subtitle: user.login != null ? '@${user.login}' : null,
              onPress: () {
                final username = user.login ?? '';
                if (username.isNotEmpty) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => UserProfilePage(username: username),
                    ),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
