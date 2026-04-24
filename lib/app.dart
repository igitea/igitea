import 'package:flutter/material.dart';
import 'core/di/injection.dart';
import 'domain/entities/auth_state.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/home_page.dart';

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
  }

  Future<void> _tryRestoreSession() async {
    await Injection.authNotifier.restoreSession();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([Injection.authNotifier, Injection.themeNotifier]),
      builder: (context, child) {
        final state = Injection.authNotifier.state;

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

        return MaterialApp(
          title: 'iGitea',
          debugShowCheckedModeBanner: false,
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
        );
      },
    );
  }
}