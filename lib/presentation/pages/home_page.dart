import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';

import '../../core/animations/animated_tab_stack.dart';
import '../../core/animations/app_animations.dart';
import '../../core/platform/desktop_layout.dart';
import '../../core/constants/app_constants.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../domain/entities/auth_state.dart';
import '../state/notification_notifier.dart';
import '../../l10n/app_localizations.dart';
import '../theme/app_palette.dart';
import '../widgets/desktop/app_hover_region.dart';
import '../widgets/desktop/shortcuts_dialog.dart';
import '../widgets/forui/app_chrome.dart';
import '../widgets/user_avatar.dart';
import 'dashboard_page.dart';
import 'notification_page.dart';
import 'profile_page.dart';
import 'search_page.dart';
import 'settings_page.dart';

/// The app shell: an adaptive Forui scaffold with a hand-built sidebar on wide
/// windows and a bottom bar on phones.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

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
      listenable: Listenable.merge([
        Injection.authNotifier,
        Injection.notificationNotifier,
        Injection.themeNotifier,
      ]),
      builder: (context, _) {
        final authState = Injection.authNotifier.state;
        if (authState is! AuthAuthenticated) {
          return const SizedBox.shrink();
        }

        final size = MediaQuery.sizeOf(context);
        final isWide = size.width >= 760;
        final topInset = windowTopInset(context);

        return CallbackShortcuts(
          bindings: {
            _shortcut(LogicalKeyboardKey.keyK): _openSearch,
            _shortcut(LogicalKeyboardKey.digit1): () => _select(0),
            _shortcut(LogicalKeyboardKey.digit2): () => _select(1),
            _shortcut(LogicalKeyboardKey.digit3): () => _select(2),
            _shortcut(LogicalKeyboardKey.digit4): () => _select(3),
            _shortcut(LogicalKeyboardKey.comma): () => _openSettings(context),
            _shortcut(LogicalKeyboardKey.keyB): _toggleSidebar,
            const SingleActivator(LogicalKeyboardKey.slash, shift: true): () =>
                showAppShortcutsDialog(context),
            const SingleActivator(LogicalKeyboardKey.f1): () =>
                showAppShortcutsDialog(context),
          },
          child: Focus(
            autofocus: true,
            child: FScaffold(
              sidebar: isWide
                  ? _Sidebar(
                      topInset: topInset,
                      user: authState.user,
                      selectedIndex: _selectedIndex,
                      onSelect: _select,
                      onOpenSettings: () => _openSettings(context),
                      collapsed: Injection.themeNotifier.sidebarCollapsed,
                      onToggle: _toggleSidebar,
                    )
                  : null,
              header: _buildHeader(
                context,
                l10n,
                authState,
                isWide: isWide,
                topInset: topInset,
                canMarkAllRead: _hasNotifications,
              ),
              footer: isWide ? null : _buildBottomBar(l10n),
              childPad: false,
              child: AnimatedTabStack(index: _selectedIndex, children: _pages),
            ),
          ),
        );
      },
    );
  }

  SingleActivator _shortcut(LogicalKeyboardKey key) {
    final isMac = defaultTargetPlatform == TargetPlatform.macOS;
    return isMac
        ? SingleActivator(key, meta: true)
        : SingleActivator(key, control: true);
  }

  bool get _hasNotifications {
    final state = Injection.notificationNotifier.state;
    return state is NotificationListLoaded && state.notifications.isNotEmpty;
  }

  String _title(AppLocalizations l10n) => switch (_selectedIndex) {
    1 => l10n.notifications,
    2 => l10n.explore,
    3 => l10n.profile,
    _ => l10n.dashboard,
  };

  Widget _buildHeader(
    BuildContext context,
    AppLocalizations l10n,
    AuthAuthenticated authState, {
    required bool isWide,
    required double topInset,
    required bool canMarkAllRead,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppTopBar(
      topInset: topInset,
      title: _title(l10n),
      height: 52,
      actions: [
        if (isWide)
          AppSearchPrompt(
            label: l10n.search,
            hint: defaultTargetPlatform == TargetPlatform.macOS
                ? '⌘K'
                : 'Ctrl K',
            onPress: _openSearch,
          ),
        if (isWide)
          AppIconButton(
            icon: FIcons.panelLeft,
            label: l10n.toggleSidebar,
            selected: !Injection.themeNotifier.sidebarCollapsed,
            onPress: _toggleSidebar,
          ),
        if (isWide)
          AppIconButton(
            icon: FIcons.keyboard,
            label: l10n.keyboardShortcuts,
            onPress: () => showAppShortcutsDialog(context),
          ),
        if (!isWide)
          AppIconButton(
            icon: FIcons.search,
            label: l10n.search,
            onPress: _openSearch,
          ),
        if (_selectedIndex == 0)
          AppIconButton(
            icon: FIcons.bell,
            label: l10n.inbox,
            onPress: () => _select(1),
          ),
        if (_selectedIndex == 1 && canMarkAllRead)
          AppIconButton(
            icon: FIcons.checkCheck,
            label: l10n.markAllRead,
            onPress: _markAllRead,
          ),
        AppIconButton(
          icon: isDark ? FIcons.sun : FIcons.moon,
          label: l10n.theme,
          onPress: () {
            Injection.themeNotifier.setThemeMode(
              isDark ? ThemeMode.light : ThemeMode.dark,
            );
          },
        ),
      ],
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

  void _openSettings(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const SettingsPage()));
  }

  Widget _buildBottomBar(AppLocalizations l10n) {
    return FBottomNavigationBar(
      index: _selectedIndex,
      onChange: _select,
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

  void _toggleSidebar() {
    Injection.themeNotifier.setSidebarCollapsed(
      !Injection.themeNotifier.sidebarCollapsed,
    );
  }

  void _openSearch() {
    _select(2);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SearchPage.searchFocusNode.requestFocus();
    });
  }

  void _select(int index) {
    if (index == _selectedIndex) return;
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _selectedIndex = index);
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.topInset,
    required this.user,
    required this.selectedIndex,
    required this.onSelect,
    required this.onOpenSettings,
    required this.collapsed,
    required this.onToggle,
  });

  final double topInset;
  final User user;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onOpenSettings;
  final bool collapsed;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = context.palette;
    final theme = Theme.of(context);

    final items = [
      (FIcons.house, l10n.home),
      (FIcons.inbox, l10n.inbox),
      (FIcons.compass, l10n.explore),
      (FIcons.user, l10n.profile),
    ];

    final displayName = user.full_name?.isNotEmpty == true
        ? user.full_name!
        : (user.login ?? '');
    final login = user.login ?? '';

    return AnimatedContainer(
      duration: AppAnimations.effective(context, AppAnimations.normal),
      curve: AppAnimations.easeOut,
      width: collapsed
          ? DesktopLayout.sidebarRailWidth
          : DesktopLayout.sidebarWidth,
      decoration: BoxDecoration(
        color: palette.canvas,
        border: Border(right: BorderSide(color: palette.border)),
      ),
      child: Column(
        children: [
          SizedBox(height: topInset),
          Padding(
            padding: EdgeInsets.fromLTRB(
              collapsed ? 10 : 16,
              12,
              collapsed ? 10 : 16,
              12,
            ),
            child: collapsed
                ? Center(child: const BrandMark())
                : Row(
                    children: [
                      const BrandMark(),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'iGitea',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                            color: palette.textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        'v$appVersion',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: palette.textSecondary.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(width: 2),
                      AppIconButton(
                        icon: FIcons.panelLeft,
                        label: l10n.toggleSidebar,
                        size: 26,
                        iconSize: 14,
                        onPress: onToggle,
                      ),
                    ],
                  ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                collapsed ? 8 : 10,
                4,
                collapsed ? 8 : 10,
                12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < items.length; i++)
                    SidebarNavItem(
                      icon: items[i].$1,
                      label: items[i].$2,
                      selected: selectedIndex == i,
                      compact: collapsed,
                      onPress: () => onSelect(i),
                    ),
                  if (collapsed)
                    const SizedBox(height: 8)
                  else
                    SidebarLabel(l10n.account),
                  SidebarNavItem(
                    icon: FIcons.settings,
                    label: l10n.settings,
                    selected: false,
                    compact: collapsed,
                    onPress: onOpenSettings,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              collapsed ? 8 : 10,
              0,
              collapsed ? 8 : 10,
              12,
            ),
            child: _AccountCard(
              displayName: displayName,
              login: login,
              avatar: user,
              selected: selectedIndex == 3,
              compact: collapsed,
              onPress: () => onSelect(3),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  const _AccountCard({
    required this.displayName,
    required this.login,
    required this.avatar,
    required this.selected,
    required this.onPress,
    required this.compact,
  });

  final String displayName;
  final String login;
  final User avatar;
  final bool selected;
  final VoidCallback onPress;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final theme = Theme.of(context);

    return AppHoverRegion(
      onTap: onPress,
      semanticsLabel: displayName,
      tooltip: compact ? displayName : null,
      selected: selected,
      selectedColor: palette.surfaceMuted,
      hoverColor: palette.surfaceMuted,
      borderColor: selected ? palette.border : Colors.transparent,
      hoverBorderColor: selected ? palette.border : Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      padding: EdgeInsets.symmetric(horizontal: compact ? 4 : 8, vertical: 8),
      contentBuilder: (context, hovered, focused) {
        if (compact) {
          return Center(child: UserAvatar(user: avatar, radius: 13));
        }
        return Row(
          children: [
            UserAvatar(user: avatar, radius: 13),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '@$login',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: palette.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(FIcons.chevronRight, size: 14, color: palette.textSecondary),
          ],
        );
      },
    );
  }
}
