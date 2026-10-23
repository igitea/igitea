import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../core/constants/app_constants.dart';
import '../../core/di/injection.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../domain/entities/auth_state.dart';
import '../../l10n/app_localizations.dart';

import '../widgets/forui/app_page.dart';
import '../widgets/forui/app_section.dart';
import '../widgets/forui/app_tile.dart';
import 'admin_badges_page.dart';
import 'admin_cron_page.dart';
import 'admin_emails_page.dart';
import 'admin_hooks_page.dart';
import 'admin_runners_page.dart';
import 'oauth_apps_page.dart';
import 'ssh_keys_page.dart';
import 'tokens_page.dart';
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
      switch (results[0]) {
        case Right<Failure, GeneralAPISettings>(value: final v):
          _apiSettings = v;
        case Left<Failure, GeneralAPISettings>(value: final f):
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(f.message)));
        default:
          break;
      }
      switch (results[1]) {
        case Right<Failure, GeneralUISettings>(value: final v):
          _uiSettings = v;
        case Left<Failure, GeneralUISettings>(value: final f):
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(f.message)));
        default:
          break;
      }
      switch (results[2]) {
        case Right<Failure, GeneralAttachmentSettings>(value: final v):
          _attachmentSettings = v;
        case Left<Failure, GeneralAttachmentSettings>(value: final f):
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(f.message)));
        default:
          break;
      }
      switch (results[3]) {
        case Right<Failure, GeneralRepoSettings>(value: final v):
          _repoSettings = v;
        case Left<Failure, GeneralRepoSettings>(value: final f):
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(f.message)));
        default:
          break;
      }
      _settingsLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final authState = Injection.authNotifier.state;
    final isAdmin =
        authState is AuthAuthenticated && authState.user.is_admin == true;

    return AppPage(
      title: l10n.settings,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          AppSection(
            title: l10n.appearance,
            children: [
              ListenableBuilder(
                listenable: Injection.themeNotifier,
                builder: (context, _) => AppTile(
                  leading: const Icon(FIcons.palette),
                  title: l10n.theme,
                  subtitle: _themeModeLabel(
                    Injection.themeNotifier.themeMode,
                    l10n,
                  ),
                  onPress: () => _showThemeDialog(context),
                ),
              ),
              ListenableBuilder(
                listenable: Injection.themeNotifier,
                builder: (context, _) => AppTile(
                  leading: const Icon(FIcons.languages),
                  title: l10n.languageSelector,
                  subtitle: _localeLabel(Injection.themeNotifier.locale, l10n),
                  onPress: () => _showLanguageDialog(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListenableBuilder(
            listenable: Injection.authNotifier,
            builder: (context, _) {
              final state = Injection.authNotifier.state;
              if (state is! AuthAuthenticated) {
                return const SizedBox.shrink();
              }
              return Column(
                children: [
                  AppSection(
                    title: l10n.account,
                    children: [
                      AppTile(
                        leading: const Icon(FIcons.user),
                        title: state.user.login ?? '',
                        subtitle: state.baseUrl,
                        showChevron: false,
                      ),
                      AppTile(
                        leading: const Icon(FIcons.keyRound),
                        title: l10n.sshKeys,
                        onPress: () => _push(context, const SshKeysPage()),
                      ),
                      AppTile(
                        leading: const Icon(FIcons.key),
                        title: l10n.accessTokens,
                        onPress: () => _push(context, const TokensPage()),
                      ),
                      AppTile(
                        leading: const Icon(FIcons.logOut),
                        title: l10n.signOut,
                        destructive: true,
                        showChevron: false,
                        onPress: () => _showSignOutDialog(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              );
            },
          ),
          if (isAdmin)
            AppSection(
              title: l10n.adminPanel,
              children: [
                AppTile(
                  leading: const Icon(FIcons.webhook),
                  title: l10n.adminHooksTitle,
                  onPress: () => _push(context, const AdminHooksPage()),
                ),
                AppTile(
                  leading: const Icon(FIcons.calendarClock),
                  title: l10n.adminCronTitle,
                  onPress: () => _push(context, const AdminCronPage()),
                ),
                AppTile(
                  leading: const Icon(FIcons.activity),
                  title: l10n.adminRunnersTitle,
                  onPress: () => _push(context, const AdminRunnersPage()),
                ),
                AppTile(
                  leading: const Icon(FIcons.mail),
                  title: l10n.adminEmailsTitle,
                  onPress: () => _push(context, const AdminEmailsPage()),
                ),
                AppTile(
                  leading: const Icon(FIcons.badgeCheck),
                  title: l10n.adminBadgesTitle,
                  onPress: () => _push(context, const AdminBadgesPage()),
                ),
                AppTile(
                  leading: const Icon(FIcons.layoutGrid),
                  title: l10n.oauthAppsTitle,
                  onPress: () => _push(context, const OAuthAppsPage()),
                ),
                AppTile(
                  leading: const Icon(FIcons.users),
                  title: l10n.userManagement,
                  onPress: () => _showUserManagement(context),
                ),
                AppTile(
                  leading: const Icon(FIcons.server),
                  title: l10n.serverSettings,
                  onPress: () => _showServerSettings(context),
                ),
              ],
            ),
          const SizedBox(height: 28),
          Text(
            igiteaVersion,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _push(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
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

    final options = <(String, Locale?, bool)>[
      (l10n.systemDefault, null, currentLocale == null),
      for (final locale in _supportedLocales)
        (
          _localeName(locale, l10n),
          locale,
          currentLocale?.languageCode == locale.languageCode &&
              currentLocale?.countryCode == locale.countryCode,
        ),
    ];

    showFDialog<void>(
      context: context,
      builder: (dialogContext, style, animation) => FDialog(
        title: Text(l10n.selectLanguage),
        body: SizedBox(
          height: 360,
          width: 320,
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (final (label, locale, selected) in options)
                  _DialogOption(
                    label: label,
                    selected: selected,
                    onPress: () {
                      Injection.themeNotifier.setLocale(locale);
                      Navigator.of(dialogContext).pop();
                    },
                  ),
              ],
            ),
          ),
        ),
        actions: [
          FButton(
            variant: .outline,
            onPress: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
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
    final current = Injection.themeNotifier.themeMode;

    final options = <(String, ThemeMode)>[
      (l10n.themeSystem, ThemeMode.system),
      (l10n.themeLight, ThemeMode.light),
      (l10n.themeDark, ThemeMode.dark),
    ];

    showFDialog<void>(
      context: context,
      builder: (dialogContext, style, animation) => FDialog(
        title: Text(l10n.chooseTheme),
        body: Column(
          children: [
            for (final (label, mode) in options)
              _DialogOption(
                label: label,
                selected: current == mode,
                onPress: () {
                  Injection.themeNotifier.setThemeMode(mode);
                  Navigator.of(dialogContext).pop();
                },
              ),
          ],
        ),
        actions: [
          FButton(
            variant: .outline,
            onPress: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showFDialog<void>(
      context: context,
      builder: (dialogContext, style, animation) => FDialog(
        title: Text(l10n.signOut),
        body: Text(l10n.signOutConfirmMessage),
        actions: [
          FButton(
            variant: .outline,
            onPress: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
          FButton(
            variant: .destructive,
            onPress: () {
              Navigator.of(dialogContext).pop();
              Injection.authNotifier.logout();
            },
            child: Text(l10n.signOut),
          ),
        ],
      ),
    );
  }

  void _showUserManagement(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const UserManagementPage()));
  }

  void _showServerSettings(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_settingsLoading) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.loadingSettings)));
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ServerSettingsPage(
          apiSettings: _apiSettings,
          uiSettings: _uiSettings,
          attachmentSettings: _attachmentSettings,
          repoSettings: _repoSettings,
        ),
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
    final l10n = AppLocalizations.of(context)!;

    return AppPage(
      title: l10n.serverSettings,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          if (apiSettings != null)
            AppSection(
              title: l10n.api,
              children: [
                _SettingsTile(
                  title: l10n.maxResponseItems,
                  value: '${apiSettings!.max_response_items ?? '-'}',
                ),
                _SettingsTile(
                  title: l10n.defaultPagingNum,
                  value: '${apiSettings!.default_paging_num ?? '-'}',
                ),
                _SettingsTile(
                  title: l10n.defaultMaxBlobSize,
                  value: '${apiSettings!.default_max_blob_size ?? '-'}',
                ),
              ],
            ),
          if (apiSettings != null) const SizedBox(height: 16),
          if (uiSettings != null)
            AppSection(
              title: l10n.ui,
              children: [
                _SettingsTile(
                  title: l10n.defaultTheme,
                  value: uiSettings!.default_theme ?? '-',
                ),
                if (uiSettings!.allowed_reactions != null)
                  _SettingsTile(
                    title: l10n.allowedReactions,
                    value: uiSettings!.allowed_reactions!.join(', '),
                  ),
              ],
            ),
          if (uiSettings != null) const SizedBox(height: 16),
          if (attachmentSettings != null)
            AppSection(
              title: l10n.attachments,
              children: [
                _SettingsTile(
                  title: l10n.enabled,
                  value: attachmentSettings!.enabled == true
                      ? l10n.yes
                      : l10n.no,
                ),
                _SettingsTile(
                  title: l10n.maxFiles,
                  value: '${attachmentSettings!.max_files ?? '-'}',
                ),
                _SettingsTile(
                  title: l10n.maxSize,
                  value: '${attachmentSettings!.max_size ?? '-'} ${l10n.bytes}',
                ),
                _SettingsTile(
                  title: l10n.allowedTypes,
                  value: attachmentSettings!.allowed_types ?? l10n.all,
                ),
              ],
            ),
          if (attachmentSettings != null) const SizedBox(height: 16),
          if (repoSettings != null)
            AppSection(
              title: l10n.repository,
              children: [
                _SettingsTile(
                  title: l10n.httpGitDisabled,
                  value: repoSettings!.http_git_disabled == true
                      ? l10n.yes
                      : l10n.no,
                ),
                _SettingsTile(
                  title: l10n.lfsDisabled,
                  value: repoSettings!.lfs_disabled == true
                      ? l10n.yes
                      : l10n.no,
                ),
                _SettingsTile(
                  title: l10n.migrationsDisabled,
                  value: repoSettings!.migrations_disabled == true
                      ? l10n.yes
                      : l10n.no,
                ),
                _SettingsTile(
                  title: l10n.mirrorsDisabled,
                  value: repoSettings!.mirrors_disabled == true
                      ? l10n.yes
                      : l10n.no,
                ),
                _SettingsTile(
                  title: l10n.starsDisabled,
                  value: repoSettings!.stars_disabled == true
                      ? l10n.yes
                      : l10n.no,
                ),
                _SettingsTile(
                  title: l10n.timeTrackingDisabled,
                  value: repoSettings!.time_tracking_disabled == true
                      ? l10n.yes
                      : l10n.no,
                ),
              ],
            ),
          if (theme.brightness == Brightness.dark) const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _DialogOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onPress;

  const _DialogOption({
    required this.label,
    required this.selected,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FTappable(
      onPress: onPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        child: Row(
          children: [
            SizedBox(
              width: 22,
              child: selected
                  ? Icon(
                      FIcons.check,
                      size: 16,
                      color: theme.colorScheme.primary,
                    )
                  : null,
            ),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
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
    return AppTile(
      title: title,
      subtitle: value,
      showChevron: false,
      onPress: null,
    );
  }
}
