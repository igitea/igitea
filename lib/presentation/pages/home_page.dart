import 'package:flutter/material.dart';

import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../domain/entities/auth_state.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/user_avatar.dart';
import 'dashboard_page.dart';
import 'search_page.dart';
import 'notification_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Tab order: 主页 / 收件箱 / 探索 / 个人资料
  static const _pages = <Widget>[
    DashboardPage(key: ValueKey('dashboard')),
    NotificationPage(key: ValueKey('notifications')),
    SearchPage(key: ValueKey('search')),
    ProfilePage(key: ValueKey('profile')),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Injection.userNotifier.loadCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: Injection.authNotifier,
      builder: (context, _) {
        final authState = Injection.authNotifier.state;
        if (authState is! AuthAuthenticated) {
          return const SizedBox.shrink();
        }
        final user = authState.user;
        final isWide = MediaQuery.of(context).size.width >= 600;

        return Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.only(left: UIConstants.sm),
              child: InkWell(
                onTap: () => _onDestinationSelected(3),
                borderRadius: BorderRadius.circular(20),
                child: Center(
                  child: UserAvatar(user: user, radius: UIConstants.avatarLg),
                ),
              ),
            ),
            title: Text(l10n.myWork),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                tooltip: l10n.explore,
                onPressed: () => _onDestinationSelected(2),
              ),
            ],
          ),
          body: Row(
            children: [
              if (isWide) _buildNavigationRail(l10n),
              Expanded(
                child: IndexedStack(
                  index: _selectedIndex,
                  children: _pages,
                ),
              ),
            ],
          ),
          bottomNavigationBar:
              isWide ? null : _buildNavigationBar(l10n),
        );
      },
    );
  }

  Widget _buildNavigationRail(AppLocalizations l10n) {
    final theme = Theme.of(context);
    return NavigationRail(
      selectedIndex: _selectedIndex,
      onDestinationSelected: _onDestinationSelected,
      labelType: NavigationRailLabelType.all,
      leading: Semantics(
        excludeSemantics: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: UIConstants.md),
          child: Icon(
            Icons.code,
            color: theme.colorScheme.primary,
            size: 32,
          ),
        ),
      ),
      destinations: [
        NavigationRailDestination(
          icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home),
          label: Text(l10n.home),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.inbox_outlined),
          selectedIcon: const Icon(Icons.inbox),
          label: Text(l10n.inbox),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.explore_outlined),
          selectedIcon: const Icon(Icons.explore),
          label: Text(l10n.explore),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.person_outline),
          selectedIcon: const Icon(Icons.person),
          label: Text(l10n.profile),
        ),
      ],
    );
  }

  Widget _buildNavigationBar(AppLocalizations l10n) {
    return NavigationBar(
      selectedIndex: _selectedIndex,
      onDestinationSelected: _onDestinationSelected,
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home),
          label: l10n.home,
        ),
        NavigationDestination(
          icon: const Icon(Icons.inbox_outlined),
          selectedIcon: const Icon(Icons.inbox),
          label: l10n.inbox,
        ),
        NavigationDestination(
          icon: const Icon(Icons.explore_outlined),
          selectedIcon: const Icon(Icons.explore),
          label: l10n.explore,
        ),
        NavigationDestination(
          icon: const Icon(Icons.person_outline),
          selectedIcon: const Icon(Icons.person),
          label: l10n.profile,
        ),
      ],
    );
  }

  void _onDestinationSelected(int index) {
    setState(() => _selectedIndex = index);
  }
}
