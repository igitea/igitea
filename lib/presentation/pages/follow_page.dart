import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../core/di/injection.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../domain/usecases/user_usecases.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/forui/app_page.dart';
import '../widgets/forui/app_section.dart';
import '../widgets/forui/app_state_views.dart';
import '../widgets/forui/app_tile.dart';
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
    final result = widget.type == FollowType.followers
        ? await Injection.listFollowersUseCase(
            ListFollowersParams(username: widget.username),
          )
        : await Injection.listFollowingUseCase(
            ListFollowingParams(username: widget.username),
          );
    if (mounted) {
      _users
        ..clear()
        ..addAll(result is Right<Failure, List<User>> ? result.value : []);
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = widget.type == FollowType.followers
        ? l10n.followers
        : l10n.following;
    return AppPage(title: title, maxContentWidth: 820, child: _buildBody(l10n));
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_loading) return const AppLoading();

    if (_users.isEmpty) {
      return AppEmpty(icon: FIcons.users, title: l10n.noData);
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          AppSection(
            title: '',
            showHeader: false,
            children: [
              for (final user in _users)
                AppTile(
                  leading: UserAvatar(user: user, radius: 18),
                  title: user.login ?? '',
                  subtitle: user.full_name,
                  onPress: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          UserProfilePage(username: user.login ?? ''),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
