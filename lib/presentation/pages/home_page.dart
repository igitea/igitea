import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../core/di/injection.dart';
import '../../domain/entities/auth_state.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/user_avatar.dart';
import 'dashboard_page.dart';
import 'notification_page.dart';
import 'profile_page.dart';
import 'search_page.dart';

/// The app shell: a Forui scaffold with a header, an adaptive navigation
/// surface (sidebar on wide windows, bottom bar on phones) and the four main
/// tabs.
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

        final isWide = MediaQuery.sizeOf(context).width >= 720;

        return FScaffold(
          header: _buildHeader(context, l10n, authState),
          sidebar: isWide ? _buildSidebar(context, l10n, authState) : null,
          footer: isWide ? null : _buildBottomBar(l10n),
          childPad: false,
          child: IndexedStack(
            index: _selectedIndex,
            children: _pages,
          ),
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AppLocalizations l10n,
    AuthAuthenticated authState,
  ) {
    final title = switch (_selectedIndex) {
      1 => l10n.notifications,
      2 => l10n.explore,
      3 => l10n.profile,
      _ => l10n.myWork,
    };

    return FHeader.nested(
      titleAlignment: Alignment.centerLeft,
      prefixes: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: FTappable(
            onPress: () => _onDestinationSelected(3),
            child: UserAvatar(user: authState.user, radius: 16),
          ),
        ),
      ],
      title: Text(title),
      suffixes: switch (_selectedIndex) {
        0 => [
            FHeaderAction(
              icon: const Icon(FIcons.search),
              semanticsLabel: l10n.explore,
              onPress: () => _onDestinationSelected(2),
            ),
            FHeaderAction(
              icon: const Icon(FIcons.bell),
              semanticsLabel: l10n.inbox,
              onPress: () => _onDestinationSelected(1),
            ),
          ],
        1 => [
            FHeaderAction(
              icon: const Icon(FIcons.checkCheck),
              semanticsLabel: l10n.markAllRead,
              onPress: _markAllRead,
            ),
          ],
        _ => const [],
      },
    );
  }

  Future<void> _markAllRead() async {
    final l10n = AppLocalizations.of(context)!;
    await Injection.notificationNotifier.markAllRead();
    if (!mounted) return;
    showFToast(
      context: context,
      title: Text(l10n.allNotificationsMarkedAsRead),
    );
  }

  Widget _buildBottomBar(AppLocalizations l10n) {
    return FBottomNavigationBar(
      index: _selectedIndex,
      onChange: _onDestinationSelected,
      children: [
        FBottomNavigationBarItem(
          icon: const Icon(FIcons.house),
          label: Text(l10n.home),
        ),
        FBottomNavigationBarItem(
          icon: const Icon(FIcons.inbox),
          label: Text(l10n.inbox),
        ),
        FBottomNavigationBarItem(
          icon: const Icon(FIcons.compass),
          label: Text(l10n.explore),
        ),
        FBottomNavigationBarItem(
          icon: const Icon(FIcons.user),
          label: Text(l10n.profile),
        ),
      ],
    );
  }

  Widget _buildSidebar(
    BuildContext context,
    AppLocalizations l10n,
    AuthAuthenticated authState,
  ) {
    final items = [
      (FIcons.house, l10n.home),
      (FIcons.inbox, l10n.inbox),
      (FIcons.compass, l10n.explore),
      (FIcons.user, l10n.profile),
    ];

    return FSidebar(
      header: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Row(
          children: [
            const Icon(FIcons.squareCode, size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'iGitea',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      footer: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          authState.user.login ?? '',
          style: TextStyle(
            fontSize: 13,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      children: [
        FSidebarGroup(
          children: [
            for (var i = 0; i < items.length; i++)
              FSidebarItem(
                icon: Icon(items[i].$1),
                label: Text(items[i].$2),
                selected: _selectedIndex == i,
                onPress: () => _onDestinationSelected(i),
              ),
          ],
        ),
      ],
    );
  }

  void _onDestinationSelected(int index) {
    setState(() => _selectedIndex = index);
  }
}
