import 'package:flutter/material.dart';
import 'core/di/injection.dart';
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

class IGiteaApp extends StatefulWidget {
  const IGiteaApp({super.key});

  @override
  State<IGiteaApp> createState() => _IGiteaAppState();
}

class _IGiteaAppState extends State<IGiteaApp> {
  @override
  void initState() {
    super.initState();
    Injection.initialize();
    _tryRestoreSession();
    Injection.themeNotifier.loadThemeMode();
    Injection.themeNotifier.loadLocale();
  }

  Future<void> _tryRestoreSession() async {
    final saved = await AuthStorage().loadCredentials();
    if (saved != null) {
      Injection.updateAuth(
        baseUrl: saved.baseUrl,
        token: saved.token,
        username: saved.username,
        password: saved.password,
      );
    }
    await Injection.authNotifier.restoreSession();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([Injection.authNotifier, Injection.themeNotifier]),
      builder: (context, child) {
        final state = Injection.authNotifier.state;

        if (state is AuthAuthenticated) {
          Injection.updateAuth(
            baseUrl: state.baseUrl,
            token: state.token,
            username: state.username,
            password: state.password,
          );
        }

        Widget home;
        if (state is AuthAuthenticated) {
          home = const HomePage();
        } else if (state is AuthLoading) {
          home = const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          home = const LoginPage();
        }

        final locale = Injection.themeNotifier.locale;
        return MaterialApp(
          title: 'iGitea',
          debugShowCheckedModeBanner: false,
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.teal,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          themeMode: Injection.themeNotifier.themeMode,
          home: home,
          onGenerateRoute: _onGenerateRoute,
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
            builder: (_) => IssueDetailPage(owner: owner, repo: repo, index: index),
          );
        }
      case 'pull':
        if (index != null && owner != null && repo != null) {
          return MaterialPageRoute(
            builder: (_) => PRDetailPage(owner: owner, repo: repo, index: index),
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
      return {
        'type': 'org',
        'orgName': match.group(1)!,
      };
    }

    if (userPattern.hasMatch(path)) {
      final match = userPattern.firstMatch(path)!;
      return {
        'type': 'user',
        'username': match.group(1)!,
      };
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