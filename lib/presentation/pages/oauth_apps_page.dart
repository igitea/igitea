import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../state/user_oauth_notifier.dart';
import '../widgets/forui/app_page.dart';
import '../widgets/forui/app_state_views.dart';
import '../widgets/forui/app_tile.dart';

class OAuthAppsPage extends StatefulWidget {
  const OAuthAppsPage({super.key});

  @override
  State<OAuthAppsPage> createState() => _OAuthAppsPageState();
}

class _OAuthAppsPageState extends State<OAuthAppsPage> {
  @override
  void initState() {
    super.initState();
    Injection.userOAuthNotifier.loadApps();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppPage(
      title: l10n.oauthAppsTitle,
      actions: [
        FHeaderAction(
          icon: const Icon(FIcons.plus),
          semanticsLabel: l10n.oauthCreateApp,
          onPress: () => _showCreateDialog(context),
        ),
      ],
      child: ListenableBuilder(
        listenable: Injection.userOAuthNotifier,
        builder: (context, _) {
          final state = Injection.userOAuthNotifier.appsState;
          return switch (state) {
            OAuth2AppsLoading() => const AppLoading(),
            OAuth2AppsError(:final message) => AppError(
              message: message,
              onRetry: () => Injection.userOAuthNotifier.loadApps(),
            ),
            OAuth2AppsLoaded(:final apps) =>
              apps.isEmpty
                  ? AppEmpty(icon: FIcons.appWindow, title: l10n.oauthNoApps)
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                      itemCount: apps.length,
                      itemBuilder: (context, index) {
                        final app = apps[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _OAuthAppCard(app: app),
                        );
                      },
                    ),
            _ => const SizedBox(),
          };
        },
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController();
    final redirectUriController = TextEditingController();

    showFDialog<void>(
      context: context,
      builder: (ctx, style, animation) => FDialog(
        title: Text(l10n.oauthCreateApp),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FTextField(
              control: FTextFieldControl.managed(controller: nameController),
              label: Text(l10n.name),
            ),
            const SizedBox(height: 12),
            FTextField(
              control: FTextFieldControl.managed(
                controller: redirectUriController,
              ),
              label: Text(l10n.oauthRedirectUri),
            ),
          ],
        ),
        actions: [
          FButton(
            variant: .outline,
            onPress: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FButton(
            onPress: () {
              final name = nameController.text.trim();
              final redirectUri = redirectUriController.text.trim();
              if (name.isNotEmpty && redirectUri.isNotEmpty) {
                Injection.userOAuthNotifier.createApp({
                  'name': name,
                  'redirect_uris': [redirectUri],
                });
                Navigator.pop(ctx);
              }
            },
            child: Text(l10n.create),
          ),
        ],
      ),
    );
  }
}

class _OAuthAppCard extends StatelessWidget {
  final OAuth2Application app;

  const _OAuthAppCard({required this.app});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final subtitle = [
      if (app.client_id != null) 'Client ID: ${app.client_id}',
      if (app.redirect_uris != null && app.redirect_uris!.isNotEmpty)
        '${l10n.oauthRedirectUri}: ${app.redirect_uris!.first}',
    ].join(' · ');

    return FCard.raw(
      child: AppTile(
        leading: Icon(
          FIcons.appWindow,
          size: 18,
          color: theme.colorScheme.primary,
        ),
        title: app.name ?? l10n.unknown,
        subtitle: subtitle,
        showChevron: false,
        trailing: FTappable(
          onPress: () => _confirmDelete(context, app),
          semanticsLabel: l10n.delete,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(
              FIcons.trash2,
              size: 16,
              color: theme.colorScheme.error,
            ),
          ),
        ),
        onPress: null,
      ),
    );
  }

  void _confirmDelete(BuildContext context, OAuth2Application app) {
    final l10n = AppLocalizations.of(context)!;
    showFDialog<bool>(
      context: context,
      builder: (ctx, style, animation) => FDialog(
        title: Text(l10n.confirmDelete),
        body: Text(
          '${l10n.oauthDeleteAppConfirm} "${app.name ?? l10n.unknown}"?',
        ),
        actions: [
          FButton(
            variant: .outline,
            onPress: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FButton(
            variant: .destructive,
            onPress: () {
              if (app.id != null) {
                Injection.userOAuthNotifier.deleteApp(app.id!);
              }
              Navigator.pop(ctx, true);
            },
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
}
