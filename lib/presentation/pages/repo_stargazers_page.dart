import 'package:flutter/material.dart';

import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/empty_state.dart';
import '../widgets/user_avatar.dart';
import 'user_profile_page.dart';

class RepoStargazersPage extends StatefulWidget {
  final String owner;
  final String repo;

  const RepoStargazersPage({super.key, required this.owner, required this.repo});

  @override
  State<RepoStargazersPage> createState() => _RepoStargazersPageState();
}

class _RepoStargazersPageState extends State<RepoStargazersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<User> _stargazers = [];
  List<User> _subscribers = [];
  bool _stargazersLoading = true;
  bool _subscribersLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadStargazers();
    _loadSubscribers();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.owner}/${widget.repo}'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: const Icon(Icons.star), text: l10n.stargazers),
            Tab(icon: const Icon(Icons.visibility), text: l10n.subscribers),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _UserList(
            users: _stargazers,
            loading: _stargazersLoading,
            emptyTitle: l10n.noStargazers,
          ),
          _UserList(
            users: _subscribers,
            loading: _subscribersLoading,
            emptyTitle: l10n.noSubscribers,
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
    final theme = Theme.of(context);

    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (users.isEmpty) {
      return EmptyState(icon: Icons.people_outline, title: emptyTitle);
    }
    return ListView.builder(
      padding: const EdgeInsets.all(UIConstants.md),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: UIConstants.sm),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: theme.colorScheme.outlineVariant),
          ),
          child: ListTile(
            leading: UserAvatar(user: user, radius: UIConstants.avatarMd),
            title: Text(
              user.full_name ?? user.login ?? '',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: user.login != null
                ? Text('@${user.login}', style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ))
                : null,
            trailing: const Icon(Icons.chevron_right, size: 18),
            onTap: () {
              final username = user.login ?? '';
              if (username.isNotEmpty) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => UserProfilePage(username: username),
                ));
              }
            },
          ),
        );
      },
    );
  }
}
