import 'package:flutter/material.dart';

import '../../core/animations/animated_wrapper.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/empty_state.dart';
import '../widgets/user_avatar.dart';
import 'user_profile_page.dart';

enum FollowType { followers, following }

class FollowPage extends StatefulWidget {
  final String username;
  final FollowType type;

  const FollowPage({super.key, required this.username, required this.type});

  @override
  State<FollowPage> createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPage> {
  final List<User> _users = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final users = widget.type == FollowType.followers
          ? await Injection.apiService.userListFollowers(username: widget.username)
          : await Injection.apiService.userListFollowing(username: widget.username);
      _users
        ..clear()
        ..addAll(users);
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = widget.type == FollowType.followers ? l10n.followers : l10n.following;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: _buildBody(l10n),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    if (_users.isEmpty) {
      return EmptyState(icon: Icons.people_outline, title: l10n.noData);
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: UIConstants.md),
        itemCount: _users.length,
        itemBuilder: (context, index) => _UserCard(user: _users[index], index: index),
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final User user;
  final int index;

  const _UserCard({required this.user, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FadeInWrapper(
      delay: Duration(milliseconds: index * 20),
      child: Padding(
        padding: const EdgeInsets.only(bottom: UIConstants.sm),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: theme.colorScheme.outlineVariant),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => UserProfilePage(username: user.login ?? '')),
            ),
            child: ListTile(
              leading: UserAvatar(user: user, radius: 18),
              title: Text(
                user.login ?? '',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              subtitle: user.full_name != null
                  ? Text(user.full_name!, style: theme.textTheme.bodySmall)
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
