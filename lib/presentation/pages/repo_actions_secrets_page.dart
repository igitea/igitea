import 'package:flutter/material.dart';

import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../state/repo_actions_notifier.dart';

class RepoActionsSecretsPage extends StatefulWidget {
  final String owner;
  final String repo;
  const RepoActionsSecretsPage({super.key, required this.owner, required this.repo});

  @override
  State<RepoActionsSecretsPage> createState() => _RepoActionsSecretsPageState();
}

class _RepoActionsSecretsPageState extends State<RepoActionsSecretsPage> {
  @override
  void initState() {
    super.initState();
    Injection.repoActionsNotifier.loadSecrets(widget.owner, widget.repo);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.actionsSecretsTitle)),
      body: ListenableBuilder(
        listenable: Injection.repoActionsNotifier,
        builder: (context, _) {
          final state = Injection.repoActionsNotifier.secretsState;
          return switch (state) {
            RepoActionsSecretsLoading() => const Center(child: CircularProgressIndicator()),
            RepoActionsSecretsError(:final message) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${l10n.error}: $message'),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => Injection.repoActionsNotifier.loadSecrets(widget.owner, widget.repo),
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            ),
            RepoActionsSecretsLoaded(:final secrets) => secrets.isEmpty
              ? Center(child: Text(l10n.actionsNoSecrets))
              : ListView.builder(
                  itemCount: secrets.length,
                  itemBuilder: (context, index) {
                    final secret = secrets[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: ListTile(
                        leading: const Icon(Icons.lock),
                        title: Text(secret.name ?? l10n.unknown),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _confirmDelete(context, secret),
                        ),
                      ),
                    );
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
    final valueController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.actionsCreateSecret),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: l10n.actionsSecretName),
            ),
            TextField(
              controller: valueController,
              decoration: InputDecoration(labelText: l10n.actionsSecretValue),
              obscureText: true,
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
              final value = valueController.text.trim();
              if (name.isNotEmpty && value.isNotEmpty) {
                Injection.repoActionsNotifier.createSecret(widget.owner, widget.repo, name, value);
                Navigator.pop(context);
              }
            },
            child: Text(l10n.create),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, Secret secret) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDelete),
        content: Text(l10n.actionsDeleteSecretConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              if (secret.name != null) {
                Injection.repoActionsNotifier.deleteSecret(widget.owner, widget.repo, secret.name!);
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
