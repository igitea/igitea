import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/di/injection.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../domain/entities/auth_state.dart';
import '../../l10n/app_localizations.dart';

import 'admin_badges_page.dart';
import 'admin_cron_page.dart';
import 'admin_emails_page.dart';
import 'admin_hooks_page.dart';
import 'admin_runners_page.dart';
import 'oauth_apps_page.dart';
import 'ssh_keys_page.dart';
import 'user_management_page.dart';

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
  bool _settingsLoading = false;

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
    });

    final results = await Future.wait([
      Injection.getGeneralAPISettingsUseCase(),
      Injection.getGeneralUISettingsUseCase(),
      Injection.getGeneralAttachmentSettingsUseCase(),
      Injection.getGeneralRepoSettingsUseCase(),
    ]);

    if (!mounted) return;

    setState(() {
      _apiSettings = (results[0] as Right<Failure, GeneralAPISettings>).value;
      _uiSettings = (results[1] as Right<Failure, GeneralUISettings>).value;
      _attachmentSettings = (results[2] as Right<Failure, GeneralAttachmentSettings>).value;
      _repoSettings = (results[3] as Right<Failure, GeneralRepoSettings>).value;
      _settingsLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = Injection.authNotifier.state;
    final isAdmin = authState is AuthAuthenticated && authState.user.is_admin == true;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          ListenableBuilder(
            listenable: Injection.themeNotifier,
            builder: (context, _) {
              return ListTile(
                leading: const Icon(Icons.palette_outlined),
                title: Text(l10n.theme),
                subtitle: Text(_themeModeLabel(Injection.themeNotifier.themeMode, l10n)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showThemeDialog(context),
              );
            },
          ),
          ListenableBuilder(
            listenable: Injection.themeNotifier,
            builder: (context, _) {
              return ListTile(
                leading: const Icon(Icons.language),
                title: Text(l10n.languageSelector),
                subtitle: Text(_localeLabel(Injection.themeNotifier.locale, l10n)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showLanguageDialog(context),
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
                      title: Text(l10n.account),
                      subtitle: Text('${state.user.login ?? ''}@${state.baseUrl}'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.key_outlined),
                      title: Text(l10n.sshKeys),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SshKeysPage(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: Text(l10n.signOut),
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
                l10n.adminPanel,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.webhook),
              title: Text(l10n.adminHooksTitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminHooksPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: Text(l10n.adminCronTitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminCronPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.directions_run),
              title: Text(l10n.adminRunnersTitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminRunnersPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(l10n.adminEmailsTitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminEmailsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.badge),
              title: Text(l10n.adminBadgesTitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminBadgesPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.apps_outlined),
              title: Text(l10n.oauthAppsTitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const OAuthAppsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.people_outlined),
              title: Text(l10n.userManagement),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showUserManagement(context),
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: Text(l10n.serverSettings),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showServerSettings(context),
            ),
          ],
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              igiteaVersion,
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

  String _themeModeLabel(ThemeMode mode, AppLocalizations l10n) {
    switch (mode) {
      case ThemeMode.light:
        return l10n.themeLight;
      case ThemeMode.dark:
        return l10n.themeDark;
      case ThemeMode.system:
        return l10n.themeSystem;
    }
  }

  String _localeLabel(Locale? locale, AppLocalizations l10n) {
    if (locale == null) return l10n.systemDefault;
    return _localeName(locale, l10n);
  }

  String _localeName(Locale locale, AppLocalizations l10n) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'zh':
        return locale.countryCode == 'TW' ? '繁體中文' : '简体中文';
      case 'ja':
        return '日本語';
      case 'ko':
        return '한국어';
      case 'es':
        return 'Español';
      case 'fr':
        return 'Français';
      case 'de':
        return 'Deutsch';
      case 'pt':
        return 'Português';
      case 'ru':
        return 'Русский';
      default:
        return locale.languageCode;
    }
  }

  void _showLanguageDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = Injection.themeNotifier.locale;
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(l10n.selectLanguage),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Injection.themeNotifier.setLocale(null);
              Navigator.of(ctx).pop();
            },
            child: Row(
              children: [
                if (currentLocale == null) const Icon(Icons.check, size: 18),
                const SizedBox(width: 8),
                Text(l10n.systemDefault),
              ],
            ),
          ),
          ..._supportedLocales.map((locale) => SimpleDialogOption(
            onPressed: () {
              Injection.themeNotifier.setLocale(locale);
              Navigator.of(ctx).pop();
            },
            child: Row(
              children: [
                if (currentLocale?.languageCode == locale.languageCode &&
                    currentLocale?.countryCode == locale.countryCode) const Icon(Icons.check, size: 18),
                const SizedBox(width: 8),
                Text(_localeName(locale, l10n)),
              ],
            ),
          )),
        ],
      ),
    );
  }

  List<Locale> get _supportedLocales => const [
    Locale('en'),
    Locale('zh'),
    Locale('zh', 'TW'),
    Locale('ja'),
    Locale('ko'),
    Locale('es'),
    Locale('fr'),
    Locale('de'),
    Locale('pt'),
    Locale('ru'),
  ];

  void _showThemeDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(l10n.chooseTheme),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Injection.themeNotifier.setThemeMode(ThemeMode.system);
              Navigator.of(ctx).pop();
            },
            child: Text(l10n.themeSystem),
          ),
          SimpleDialogOption(
            onPressed: () {
              Injection.themeNotifier.setThemeMode(ThemeMode.light);
              Navigator.of(ctx).pop();
            },
            child: Text(l10n.themeLight),
          ),
          SimpleDialogOption(
            onPressed: () {
              Injection.themeNotifier.setThemeMode(ThemeMode.dark);
              Navigator.of(ctx).pop();
            },
            child: Text(l10n.themeDark),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.signOut),
        content: Text(l10n.signOutConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel),
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
            child: Text(l10n.signOut),
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
    final l10n = AppLocalizations.of(context)!;
    if (_settingsLoading) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.loadingSettings)),
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.serverSettings)),
      body: ListView(
        children: [
          if (apiSettings != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(l10n.api, style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              )),
            ),
            _SettingsTile(title: l10n.maxResponseItems, value: '${apiSettings!.max_response_items ?? '-'}'),
            _SettingsTile(title: l10n.defaultPagingNum, value: '${apiSettings!.default_paging_num ?? '-'}'),
            _SettingsTile(title: l10n.defaultMaxBlobSize, value: '${apiSettings!.default_max_blob_size ?? '-'}'),
          ],
          if (uiSettings != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(l10n.ui, style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              )),
            ),
            _SettingsTile(title: l10n.defaultTheme, value: uiSettings!.default_theme ?? '-'),
            if (uiSettings!.allowed_reactions != null)
              _SettingsTile(title: l10n.allowedReactions, value: uiSettings!.allowed_reactions!.join(', ')),
          ],
          if (attachmentSettings != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(l10n.attachments, style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              )),
            ),
            _SettingsTile(title: l10n.enabled, value: attachmentSettings!.enabled == true ? l10n.yes : l10n.no),
            _SettingsTile(title: l10n.maxFiles, value: '${attachmentSettings!.max_files ?? '-'}'),
            _SettingsTile(title: l10n.maxSize, value: '${attachmentSettings!.max_size ?? '-'} ${l10n.bytes}'),
            _SettingsTile(title: l10n.allowedTypes, value: attachmentSettings!.allowed_types ?? l10n.all),
          ],
          if (repoSettings != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(l10n.repository, style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              )),
            ),
            _SettingsTile(title: l10n.httpGitDisabled, value: repoSettings!.http_git_disabled == true ? l10n.yes : l10n.no),
            _SettingsTile(title: l10n.lfsDisabled, value: repoSettings!.lfs_disabled == true ? l10n.yes : l10n.no),
            _SettingsTile(title: l10n.migrationsDisabled, value: repoSettings!.migrations_disabled == true ? l10n.yes : l10n.no),
            _SettingsTile(title: l10n.mirrorsDisabled, value: repoSettings!.mirrors_disabled == true ? l10n.yes : l10n.no),
            _SettingsTile(title: l10n.starsDisabled, value: repoSettings!.stars_disabled == true ? l10n.yes : l10n.no),
            _SettingsTile(title: l10n.timeTrackingDisabled, value: repoSettings!.time_tracking_disabled == true ? l10n.yes : l10n.no),
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


