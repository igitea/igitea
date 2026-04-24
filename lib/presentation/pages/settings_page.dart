import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/di/injection.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../domain/entities/auth_state.dart';
import '../../presentation/state/theme_notifier.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  GeneralAPISettings? _apiSettings;
  GeneralUISettings? _uiSettings;
  GeneralAttachmentSettings? _attachmentSettings;
  GeneralRepoSettings? _repoSettings;
  List<Cron>? _cronTasks;
  bool _settingsLoading = false;
  String? _settingsError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAdminAndLoad();
    });
  }

  Future<void> _checkAdminAndLoad() async {
    final authState = Injection.authNotifier.state;
    if (authState is! AuthAuthenticated) return;
    if (authState.user.is_admin != true) return;

    setState(() {
      _settingsLoading = true;
      _settingsError = null;
    });

    final results = await Future.wait([
      Injection.getGeneralAPISettingsUseCase(),
      Injection.getGeneralUISettingsUseCase(),
      Injection.getGeneralAttachmentSettingsUseCase(),
      Injection.getGeneralRepoSettingsUseCase(),
      Injection.listCronTasksUseCase(),
    ]);

    if (!mounted) return;

    bool hasError = false;
    String errorMsg = '';

    for (final result in results) {
      if (result is Left<Failure, dynamic>) {
        hasError = true;
        errorMsg = (result as Left<Failure, dynamic>).value.message;
      }
    }

    setState(() {
      _apiSettings = (results[0] as Right<Failure, GeneralAPISettings>).value;
      _uiSettings = (results[1] as Right<Failure, GeneralUISettings>).value;
      _attachmentSettings = (results[2] as Right<Failure, GeneralAttachmentSettings>).value;
      _repoSettings = (results[3] as Right<Failure, GeneralRepoSettings>).value;
      _cronTasks = (results[4] as Right<Failure, List<Cron>>).value;
      _settingsLoading = false;
      if (hasError) {
        _settingsError = errorMsg;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = Injection.authNotifier.state;
    final isAdmin = authState is AuthAuthenticated && authState.user.is_admin == true;

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
              if (state is AuthAuthenticated) {
                return Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: const Text('Account'),
                      subtitle: Text('${state.user.login ?? ''}@${state.baseUrl}'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Sign Out'),
                      onTap: () => _showSignOutDialog(context),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
          if (isAdmin) ...[
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Administration',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.people_outlined),
              title: const Text('User Management'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showUserManagement(context),
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Server Settings'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showServerSettings(context),
            ),
            ListTile(
              leading: const Icon(Icons.schedule_outlined),
              title: const Text('Cron Tasks'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showCronTasks(context),
            ),
          ],
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'iGitea v0.12.0',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
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

  void _showSignOutDialog(BuildContext context) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await Injection.authNotifier.logout();
            },
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showUserManagement(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => const UserManagementPage(),
    ));
  }

  void _showServerSettings(BuildContext context) {
    if (_settingsLoading) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Loading settings...')),
      );
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ServerSettingsPage(
        apiSettings: _apiSettings,
        uiSettings: _uiSettings,
        attachmentSettings: _attachmentSettings,
        repoSettings: _repoSettings,
      ),
    ));
  }

  void _showCronTasks(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => CronTasksPage(cronTasks: _cronTasks),
    ));
  }
}

class UserManagementPage extends StatelessWidget {
  const UserManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Management')),
      body: Center(
        child: Text('User management coming soon', style: Theme.of(context).textTheme.bodyLarge),
      ),
    );
  }
}

class ServerSettingsPage extends StatelessWidget {
  final GeneralAPISettings? apiSettings;
  final GeneralUISettings? uiSettings;
  final GeneralAttachmentSettings? attachmentSettings;
  final GeneralRepoSettings? repoSettings;

  const ServerSettingsPage({
    super.key,
    this.apiSettings,
    this.uiSettings,
    this.attachmentSettings,
    this.repoSettings,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Server Settings')),
      body: ListView(
        children: [
          if (apiSettings != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text('API', style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              )),
            ),
            _SettingsTile(title: 'Max Response Items', value: '${apiSettings!.max_response_items ?? '-'}'),
            _SettingsTile(title: 'Default Paging Num', value: '${apiSettings!.default_paging_num ?? '-'}'),
            _SettingsTile(title: 'Default Max Blob Size', value: '${apiSettings!.default_max_blob_size ?? '-'}'),
          ],
          if (uiSettings != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text('UI', style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              )),
            ),
            _SettingsTile(title: 'Default Theme', value: uiSettings!.default_theme ?? '-'),
            if (uiSettings!.allowed_reactions != null)
              _SettingsTile(title: 'Allowed Reactions', value: uiSettings!.allowed_reactions!.join(', ')),
          ],
          if (attachmentSettings != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text('Attachments', style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              )),
            ),
            _SettingsTile(title: 'Enabled', value: attachmentSettings!.enabled == true ? 'Yes' : 'No'),
            _SettingsTile(title: 'Max Files', value: '${attachmentSettings!.max_files ?? '-'}'),
            _SettingsTile(title: 'Max Size', value: '${attachmentSettings!.max_size ?? '-'} bytes'),
            _SettingsTile(title: 'Allowed Types', value: attachmentSettings!.allowed_types ?? 'All'),
          ],
          if (repoSettings != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text('Repository', style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              )),
            ),
            _SettingsTile(title: 'HTTP Git Disabled', value: repoSettings!.http_git_disabled == true ? 'Yes' : 'No'),
            _SettingsTile(title: 'LFS Disabled', value: repoSettings!.lfs_disabled == true ? 'Yes' : 'No'),
            _SettingsTile(title: 'Migrations Disabled', value: repoSettings!.migrations_disabled == true ? 'Yes' : 'No'),
            _SettingsTile(title: 'Mirrors Disabled', value: repoSettings!.mirrors_disabled == true ? 'Yes' : 'No'),
            _SettingsTile(title: 'Stars Disabled', value: repoSettings!.stars_disabled == true ? 'Yes' : 'No'),
            _SettingsTile(title: 'Time Tracking Disabled', value: repoSettings!.time_tracking_disabled == true ? 'Yes' : 'No'),
          ],
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String title;
  final String value;

  const _SettingsTile({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}

class CronTasksPage extends StatelessWidget {
  final List<Cron>? cronTasks;

  const CronTasksPage({super.key, this.cronTasks});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Cron Tasks')),
      body: cronTasks == null
          ? const Center(child: Text('Failed to load cron tasks'))
          : cronTasks!.isEmpty
              ? const Center(child: Text('No cron tasks found'))
              : ListView.builder(
                  itemCount: cronTasks!.length,
                  itemBuilder: (context, index) {
                    final cron = cronTasks![index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: ListTile(
                        leading: const Icon(Icons.schedule),
                        title: Text(cron.name ?? 'Unknown'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (cron.schedule != null)
                              Text('Schedule: ${cron.schedule}'),
                            if (cron.next != null)
                              Text('Next: ${_formatDate(cron.next!)}'),
                            if (cron.exec_times != null)
                              Text('Executions: ${cron.exec_times}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.play_arrow),
                          tooltip: 'Run now',
                          onPressed: () async {
                            if (cron.name != null) {
                              final result = await Injection.runCronTaskUseCase(cron.name!);
                              if (context.mounted) {
                                switch (result) {
                                  case Right<Failure, void>():
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Cron "${cron.name}" triggered')),
                                    );
                                  case Left<Failure, void>(:final value):
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error: ${value.message}')),
                                    );
                                }
                              }
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}