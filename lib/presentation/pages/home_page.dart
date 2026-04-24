import 'package:flutter/material.dart';

import '../../core/di/injection.dart';
import '../../domain/entities/auth_state.dart';
import 'dashboard_page.dart';
import 'search_page.dart';
import 'repo_list_page.dart';
import 'issue_list_page.dart';
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
    _TabData(Icons.search_outlined, Icons.search, 'Search'),
    _TabData(Icons.dashboard_outlined, Icons.dashboard, 'Dashboard'),
    _TabData(Icons.source_outlined, Icons.source, 'Repositories'),
    _TabData(Icons.bug_report_outlined, Icons.bug_report, 'Issues'),
    _TabData(
      Icons.notifications_outlined,
      Icons.notifications,
      'Notifications',
    ),
    _TabData(Icons.person_outline, Icons.person, 'Profile'),
  ];

  static final _pages = <Widget>[
    const SearchPage(),
    const DashboardPage(),
    const RepoListPage(),
    const IssueListPage(),
    const NotificationPage(),
    const ProfilePage(),
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
            title: Text(user.login ?? 'iGitea'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Sign Out',
                onPressed: _logout,
              ),
            ],
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
                  destinations: _tabs
                      .map(
                        (t) => NavigationRailDestination(
                          icon: Icon(t.icon),
                          selectedIcon: Icon(t.selectedIcon),
                          label: Text(t.label),
                        ),
                      )
                      .toList(),
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
                  destinations: _tabs
                      .map(
                        (t) => NavigationDestination(
                          icon: Icon(t.icon),
                          selectedIcon: Icon(t.selectedIcon),
                          label: t.label,
                        ),
                      )
                      .toList(),
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

  Future<void> _logout() async {
    await Injection.authNotifier.logout();
  }
}

class _TabData {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const _TabData(this.icon, this.selectedIcon, this.label);
}
