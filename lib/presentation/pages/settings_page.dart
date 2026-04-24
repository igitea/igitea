import 'package:flutter/material.dart';
import '../../core/di/injection.dart';
import '../../domain/entities/auth_state.dart';
import '../../presentation/state/theme_notifier.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListenableBuilder(
            listenable: Injection.themeNotifier,
            builder: (context, _) {
              return ListTile(
                leading: const Icon(Icons.palette_outlined),
                title: const Text('Theme'),
                subtitle: Text(_themeModeLabel(Injection.themeNotifier.themeMode)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showThemeDialog(context),
              );
            },
          ),
          const Divider(),
          ListenableBuilder(
            listenable: Injection.authNotifier,
            builder: (context, _) {
              final state = Injection.authNotifier.state;
              if (state is! AuthAuthenticated) return const SizedBox.shrink();
              return ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Account'),
                subtitle: Text(state.user.login ?? ''),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.dns_outlined),
            title: const Text('Server'),
            subtitle: ListenableBuilder(
              listenable: Injection.authNotifier,
              builder: (context, _) {
                final state = Injection.authNotifier.state;
                if (state is AuthAuthenticated) {
                  return Text(state.baseUrl);
                }
                return const Text('Not connected');
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            subtitle: const Text('iGitea v0.11.0'),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FilledButton.tonal(
              onPressed: () async {
                await Injection.authNotifier.logout();
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Sign Out'),
            ),
          ),
        ],
      ),
    );
  }

  String _themeModeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Choose Theme'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Injection.themeNotifier.setThemeMode(ThemeMode.system);
              Navigator.of(ctx).pop();
            },
            child: const Text('System'),
          ),
          SimpleDialogOption(
            onPressed: () {
              Injection.themeNotifier.setThemeMode(ThemeMode.light);
              Navigator.of(ctx).pop();
            },
            child: const Text('Light'),
          ),
          SimpleDialogOption(
            onPressed: () {
              Injection.themeNotifier.setThemeMode(ThemeMode.dark);
              Navigator.of(ctx).pop();
            },
            child: const Text('Dark'),
          ),
        ],
      ),
    );
  }
}