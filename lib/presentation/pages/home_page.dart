import 'package:flutter/material.dart';

import '../../core/constants/ui_constants.dart';
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

  static const _pages = <Widget>[
    DashboardPage(key: ValueKey('dashboard')),
    SearchPage(key: ValueKey('search')),
    NotificationPage(key: ValueKey('notifications')),
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
          appBar: AppBar(title: Text(user.login ?? l10n.appTitle)),
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
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: UIConstants.md),
        child: Icon(
          Icons.code,
          color: theme.colorScheme.primary,
          size: 32,
        ),
      ),
      destinations: [
        NavigationRailDestination(
          icon: const Icon(Icons.dashboard_outlined),
          selectedIcon: const Icon(Icons.dashboard),
          label: Text(l10n.dashboard),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.search_outlined),
          selectedIcon: const Icon(Icons.search),
          label: Text(l10n.search),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.notifications_outlined),
          selectedIcon: const Icon(Icons.notifications),
          label: Text(l10n.notifications),
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
          icon: const Icon(Icons.dashboard_outlined),
          selectedIcon: const Icon(Icons.dashboard),
          label: l10n.dashboard,
        ),
        NavigationDestination(
          icon: const Icon(Icons.search_outlined),
          selectedIcon: const Icon(Icons.search),
          label: l10n.search,
        ),
        NavigationDestination(
          icon: const Icon(Icons.notifications_outlined),
          selectedIcon: const Icon(Icons.notifications),
          label: l10n.notifications,
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
