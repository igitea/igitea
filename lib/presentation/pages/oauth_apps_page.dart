import 'package:flutter/material.dart';

import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../state/user_oauth_notifier.dart';

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
    return Scaffold(
      appBar: AppBar(title: Text(l10n.oauthAppsTitle)),
      body: ListenableBuilder(
        listenable: Injection.userOAuthNotifier,
        builder: (context, _) {
          final state = Injection.userOAuthNotifier.appsState;
          return switch (state) {
            OAuth2AppsLoading() => const Center(child: CircularProgressIndicator()),
            OAuth2AppsError(:final message) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${l10n.error}: $message'),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => Injection.userOAuthNotifier.loadApps(),
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            ),
            OAuth2AppsLoaded(:final apps) => apps.isEmpty
              ? Center(child: Text(l10n.oauthNoApps))
              : ListView.builder(
                  itemCount: apps.length,
                  itemBuilder: (context, index) {
                    final app = apps[index];
                    return _OAuthAppCard(app: app);
                  },
                ),
            _ => const SizedBox(),
          };
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController();
    final redirectUriController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.oauthCreateApp),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: l10n.name),
            ),
            TextField(
              controller: redirectUriController,
              decoration: InputDecoration(labelText: l10n.oauthRedirectUri),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              final name = nameController.text.trim();
              final redirectUri = redirectUriController.text.trim();
              if (name.isNotEmpty && redirectUri.isNotEmpty) {
                Injection.userOAuthNotifier.createApp({
                  'name': name,
                  'redirect_uris': [redirectUri],
                });
                Navigator.pop(context);
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
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: const Icon(Icons.apps),
        title: Text(app.name ?? l10n.unknown),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (app.client_id != null)
              Text('Client ID: ${app.client_id}'),
            if (app.redirect_uris != null && app.redirect_uris!.isNotEmpty)
              Text('${l10n.oauthRedirectUri}: ${app.redirect_uris!.first}'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => _confirmDelete(context, app),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, OAuth2Application app) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDelete),
        content: Text('${l10n.oauthDeleteAppConfirm} "${app.name ?? l10n.unknown}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              if (app.id != null) {
                Injection.userOAuthNotifier.deleteApp(app.id!);
              }
              Navigator.pop(context);
            },
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
}
