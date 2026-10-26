import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import 'core/animations/app_animations.dart';
import 'core/di/injection.dart';
import 'core/storage/auth_method_storage.dart';
import 'core/storage/auth_storage.dart';
import 'domain/entities/auth_state.dart';
import 'l10n/app_localizations.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/issue_detail_page.dart';
import 'presentation/pages/pr_detail_page.dart';
import 'presentation/pages/repo_detail_page.dart';
import 'presentation/pages/organization_detail_page.dart';
import 'presentation/pages/search_page.dart';
import 'presentation/pages/notification_page.dart';
import 'presentation/pages/user_profile_page.dart';
import 'presentation/pages/settings_page.dart';
import 'presentation/pages/starred_repos_page.dart';
import 'presentation/theme/app_palette.dart';
import 'presentation/theme/app_theme.dart';
import 'presentation/widgets/desktop/app_scroll_behavior.dart';
import 'presentation/widgets/forui/app_chrome.dart';

class IGiteaApp extends StatefulWidget {
  const IGiteaApp({super.key});

  /// Text on touch screens is set a step larger than the dense desktop scale
  /// so lists and metadata stay comfortable at arm's length.
  static const double touchTextBoost = 1.08;

  /// Wraps the navigator with the Forui theme, toasts, tooltips and the touch
  /// text scale. Shared with tests so they render exactly like the app.
  static Widget wrap(
    BuildContext context,
    Widget? child, {
    required bool touch,
  }) {
    final brightness = Theme.of(context).brightness;
    Widget content = FTheme(
      data: AppTheme.forui(brightness, touch: touch),
      platform: touch ? FPlatformVariant.iOS : FPlatformVariant.macOS,
      child: FToaster(
        child: FTooltipGroup(child: child ?? const SizedBox.shrink()),
      ),
    );
    if (touch) {
      final media = MediaQuery.of(context);
      content = MediaQuery(
        data: media.copyWith(
          textScaler: _BoostedTextScaler(media.textScaler, touchTextBoost),
        ),
        child: content,
      );
    }
    return content;
  }

  @override
  State<IGiteaApp> createState() => _IGiteaAppState();
}

class _IGiteaAppState extends State<IGiteaApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  bool _wasAuthenticated = false;
  String? _lastBaseUrl;
  String? _lastToken;
  AuthMethod? _lastMethod;

  @override
  void initState() {
    super.initState();
    Injection.initialize();
    _tryRestoreSession().catchError(
      (e) => debugPrint('Session restore error: $e'),
    );
    Injection.themeNotifier.loadThemeMode().catchError(
      (e) => debugPrint('Theme load error: $e'),
    );
    Injection.themeNotifier.loadLocale().catchError(
      (e) => debugPrint('Locale load error: $e'),
    );
    Injection.themeNotifier.loadSidebarCollapsed().catchError(
      (e) => debugPrint('Sidebar state load error: $e'),
    );
  }

  Future<void> _tryRestoreSession() async {
    final saved = await AuthStorage().loadCredentials();
    if (saved != null) {
      _applyAuth(
        baseUrl: saved.baseUrl,
        token: saved.token,
        method: saved.method,
        username: saved.username,
        password: saved.password,
      );
    }
    await Injection.authNotifier.restoreSession();
  }

  void _applyAuth({
    required String baseUrl,
    String? token,
    AuthMethod? method,
    String? username,
    String? password,
  }) {
    if (baseUrl == _lastBaseUrl &&
        token == _lastToken &&
        method == _lastMethod) {
      return;
    }
    _lastBaseUrl = baseUrl;
    _lastToken = token;
    _lastMethod = method;
    Injection.updateAuth(
      baseUrl: baseUrl,
      token: token,
      username: username,
      password: password,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        Injection.authNotifier,
        Injection.themeNotifier,
      ]),
      builder: (context, child) {
        final state = Injection.authNotifier.state;

        if (state is AuthAuthenticated) {
          _wasAuthenticated = true;
          _applyAuth(
            baseUrl: state.baseUrl,
            token: state.token,
            method: state.method,
            username: state.username,
          );
        } else if (_wasAuthenticated) {
          // Signing out must leave the user on the login screen, not on a
          // settings/detail route that belonged to the old session.
          _wasAuthenticated = false;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _navigatorKey.currentState?.popUntil((route) => route.isFirst);
          });
        }

        Widget home;
        if (state is AuthAuthenticated) {
          home = const HomePage();
        } else if (state is AuthLoading) {
          home = const _BootSplash();
        } else {
          home = const LoginPage();
        }

        final locale = Injection.themeNotifier.locale;
        final touch = AppTheme.touchFor(defaultTargetPlatform);
        return MaterialApp(
          navigatorKey: _navigatorKey,
          title: 'iGitea',
          debugShowCheckedModeBanner: false,
          scrollBehavior: const AppScrollBehavior(),
          locale: locale,
          localizationsDelegates: [
            ...AppLocalizations.localizationsDelegates,
            FLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.material(Brightness.light, touch: touch),
          darkTheme: AppTheme.material(Brightness.dark, touch: touch),
          themeMode: Injection.themeNotifier.themeMode,
          themeAnimationDuration: AppAnimations.slow,
          themeAnimationCurve: AppAnimations.easeOut,
          home: home,
          onGenerateRoute: _onGenerateRoute,
          builder: (context, child) =>
              IGiteaApp.wrap(context, child, touch: touch),
        );
      },
    );
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    final uri = Uri.tryParse(settings.name ?? '');
    if (uri == null) return null;

    final path = uri.path;

    // Static routes
    if (path == '/explore') {
      return MaterialPageRoute(builder: (_) => const SearchPage());
    }
    if (path == '/notifications') {
      return MaterialPageRoute(builder: (_) => const NotificationPage());
    }
    if (path == '/settings') {
      return MaterialPageRoute(builder: (_) => const SettingsPage());
    }
    if (path == '/stars') {
      return MaterialPageRoute(builder: (_) => const StarredReposPage());
    }

    // Parameterized routes
    final match = _parsePath(path);
    if (match == null) return null;

    final type = match['type'];
    final owner = match['owner'];
    final repo = match['repo'];
    final index = int.tryParse(match['index'] ?? '');
    final orgName = match['orgName'];
    final username = match['username'];

    switch (type) {
      case 'issue':
        if (index != null && owner != null && repo != null) {
          return MaterialPageRoute(
            builder: (_) =>
                IssueDetailPage(owner: owner, repo: repo, index: index),
          );
        }
      case 'pull':
        if (index != null && owner != null && repo != null) {
          return MaterialPageRoute(
            builder: (_) =>
                PRDetailPage(owner: owner, repo: repo, index: index),
          );
        }
      case 'repo':
        if (owner != null && repo != null) {
          return MaterialPageRoute(
            builder: (_) => RepoDetailPage(owner: owner, repo: repo),
          );
        }
      case 'org':
        if (orgName != null) {
          return MaterialPageRoute(
            builder: (_) => OrganizationDetailPage(orgName: orgName),
          );
        }
      case 'user':
        if (username != null) {
          return MaterialPageRoute(
            builder: (_) => UserProfilePage(username: username),
          );
        }
    }

    return null;
  }

  Map<String, String>? _parsePath(String path) {
    final issuePattern = RegExp(r'^/([^/]+)/([^/]+)/issues/(\d+)$');
    final prPattern = RegExp(r'^/([^/]+)/([^/]+)/pulls/(\d+)$');
    final repoPattern = RegExp(r'^/([^/]+)/([^/]+)$');
    final orgPattern = RegExp(r'^/org/([^/]+)$');
    final userPattern = RegExp(r'^/user/([^/]+)$');

    if (issuePattern.hasMatch(path)) {
      final match = issuePattern.firstMatch(path)!;
      return {
        'type': 'issue',
        'owner': match.group(1)!,
        'repo': match.group(2)!,
        'index': match.group(3)!,
      };
    }

    if (prPattern.hasMatch(path)) {
      final match = prPattern.firstMatch(path)!;
      return {
        'type': 'pull',
        'owner': match.group(1)!,
        'repo': match.group(2)!,
        'index': match.group(3)!,
      };
    }

    if (orgPattern.hasMatch(path)) {
      final match = orgPattern.firstMatch(path)!;
      return {'type': 'org', 'orgName': match.group(1)!};
    }

    if (userPattern.hasMatch(path)) {
      final match = userPattern.firstMatch(path)!;
      return {'type': 'user', 'username': match.group(1)!};
    }

    if (repoPattern.hasMatch(path)) {
      final match = repoPattern.firstMatch(path)!;
      return {
        'type': 'repo',
        'owner': match.group(1)!,
        'repo': match.group(2)!,
      };
    }

    return null;
  }
}

/// A quiet branded splash shown while the saved session is restored.
class _BootSplash extends StatelessWidget {
  const _BootSplash();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return ColoredBox(
      color: palette.canvas,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BrandMark(size: 42, iconSize: 22),
            const SizedBox(height: 14),
            Text(
              'iGitea',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.4,
                color: palette.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
                color: palette.brand.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Multiplies the platform text scale by a fixed [factor].
class _BoostedTextScaler extends TextScaler {
  const _BoostedTextScaler(this.base, this.factor);

  final TextScaler base;
  final double factor;

  @override
  double scale(double fontSize) => base.scale(fontSize * factor);

  @override
  // ignore: deprecated_member_use
  double get textScaleFactor => base.textScaleFactor * factor;

  @override
  bool operator ==(Object other) =>
      other is _BoostedTextScaler &&
      other.base == base &&
      other.factor == factor;

  @override
  int get hashCode => Object.hash(base, factor);
}
