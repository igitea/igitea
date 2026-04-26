import 'package:flutter/material.dart';

import '../../core/di/injection.dart';
import '../../domain/entities/auth_state.dart';
import '../../l10n/app_localizations.dart';
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

  static const _tabs = [
    _TabData(Icons.dashboard_outlined, Icons.dashboard, 'Dashboard'),
    _TabData(Icons.search_outlined, Icons.search, 'Search'),
    _TabData(Icons.notifications_outlined, Icons.notifications, 'Notifications'),
    _TabData(Icons.person_outline, Icons.person, 'Profile'),
  ];

  static final _pages = <Widget>[
    const DashboardPage(key: ValueKey('dashboard')),
    const SearchPage(key: ValueKey('search')),
    const NotificationPage(key: ValueKey('notifications')),
    const ProfilePage(key: ValueKey('profile')),
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
            title: Text(user.login ?? l10n.appTitle),
          ),
          body: Row(
            children: [
              if (isWide)
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _onDestinationSelected,
                  labelType: NavigationRailLabelType.all,
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Icon(
                      Icons.code,
                      color: Theme.of(context).colorScheme.primary,
                      size: 32,
                    ),
                  ),
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(_tabs[0].icon),
                      selectedIcon: Icon(_tabs[0].selectedIcon),
                      label: Text(l10n.dashboard),
                    ),
                    NavigationRailDestination(
                      icon: Icon(_tabs[1].icon),
                      selectedIcon: Icon(_tabs[1].selectedIcon),
                      label: Text(l10n.search),
                    ),
                    NavigationRailDestination(
                      icon: Icon(_tabs[2].icon),
                      selectedIcon: Icon(_tabs[2].selectedIcon),
                      label: Text(l10n.notifications),
                    ),
                    NavigationRailDestination(
                      icon: Icon(_tabs[3].icon),
                      selectedIcon: Icon(_tabs[3].selectedIcon),
                      label: Text(l10n.profile),
                    ),
                  ],
                ),
              Expanded(
                child: IndexedStack(
                  index: _selectedIndex,
                  children: _pages,
                ),
              ),
            ],
          ),
          bottomNavigationBar: isWide
              ? null
              : NavigationBar(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _onDestinationSelected,
                  destinations: [
                    NavigationDestination(
                      icon: Icon(_tabs[0].icon),
                      selectedIcon: Icon(_tabs[0].selectedIcon),
                      label: l10n.dashboard,
                    ),
                    NavigationDestination(
                      icon: Icon(_tabs[1].icon),
                      selectedIcon: Icon(_tabs[1].selectedIcon),
                      label: l10n.search,
                    ),
                    NavigationDestination(
                      icon: Icon(_tabs[2].icon),
                      selectedIcon: Icon(_tabs[2].selectedIcon),
                      label: l10n.notifications,
                    ),
                    NavigationDestination(
                      icon: Icon(_tabs[3].icon),
                      selectedIcon: Icon(_tabs[3].selectedIcon),
                      label: l10n.profile,
                    ),
                  ],
                ),
        );
      },
    );
  }

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class _TabData {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const _TabData(this.icon, this.selectedIcon, this.label);
}
