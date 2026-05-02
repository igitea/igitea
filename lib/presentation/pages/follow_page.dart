import 'package:flutter/material.dart';

import '../../core/animations/animated_wrapper.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/empty_state.dart';
import '../widgets/user_avatar.dart';

class FollowPage extends StatefulWidget {
  final String username;

  const FollowPage({super.key, required this.username});

  @override
  State<FollowPage> createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPage> {
  int _tab = 0;
  List<User> _users = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      _users = _tab == 0
          ? await Injection.apiService.userListFollowers(username: widget.username)
          : await Injection.apiService.userListFollowing(username: widget.username);
    } catch (_) {
      _users = [];
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(widget.username)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: UIConstants.md, vertical: UIConstants.sm),
            child: SegmentedButton<int>(
              segments: [
                ButtonSegment(value: 0, label: Text('${l10n.followers} ${_tab == 0 && !_loading ? '(${_users.length})' : ''}')),
                ButtonSegment(value: 1, label: Text('${l10n.following} ${_tab == 1 && !_loading ? '(${_users.length})' : ''}')),
              ],
              selected: {_tab},
              onSelectionChanged: (v) {
                setState(() => _tab = v.first);
                _load();
              },
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _users.isEmpty
                    ? EmptyState(icon: Icons.people_outline, title: l10n.noData)
                    : RefreshIndicator(
                        onRefresh: _load,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: UIConstants.md),
                          itemCount: _users.length,
                          itemBuilder: (context, index) {
                            final u = _users[index];
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
                                  leading: UserAvatar(user: u, radius: 18),
                                  title: Text(u.login ?? ''),
                                  subtitle: u.full_name != null ? Text(u.full_name!) : null,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
