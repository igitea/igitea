import 'package:flutter/material.dart';

import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../state/repo_actions_notifier.dart';

class RepoActionsVariablesPage extends StatefulWidget {
  final String owner;
  final String repo;
  const RepoActionsVariablesPage({super.key, required this.owner, required this.repo});

  @override
  State<RepoActionsVariablesPage> createState() => _RepoActionsVariablesPageState();
}

class _RepoActionsVariablesPageState extends State<RepoActionsVariablesPage> {
  @override
  void initState() {
    super.initState();
    Injection.repoActionsNotifier.loadVariables(widget.owner, widget.repo);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.actionsVariablesTitle)),
      body: ListenableBuilder(
        listenable: Injection.repoActionsNotifier,
        builder: (context, _) {
          final state = Injection.repoActionsNotifier.variablesState;
          return switch (state) {
            RepoActionsVariablesLoading() => const Center(child: CircularProgressIndicator()),
            RepoActionsVariablesError(:final message) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${l10n.error}: $message'),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => Injection.repoActionsNotifier.loadVariables(widget.owner, widget.repo),
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            ),
            RepoActionsVariablesLoaded(:final variables) => variables.isEmpty
              ? Center(child: Text(l10n.actionsNoVariables))
              : ListView.builder(
                  itemCount: variables.length,
                  itemBuilder: (context, index) {
                    final variable = variables[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: ListTile(
                        leading: const Icon(Icons.code),
                        title: Text(variable.name ?? l10n.unknown),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _confirmDelete(context, variable),
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
        title: Text(l10n.actionsCreateVariable),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: l10n.actionsVariableName),
            ),
            TextField(
              controller: valueController,
              decoration: InputDecoration(labelText: l10n.actionsVariableValue),
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
                Injection.repoActionsNotifier.createVariable(widget.owner, widget.repo, name, value);
                Navigator.pop(context);
              }
            },
            child: Text(l10n.create),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, ActionVariable variable) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDelete),
        content: Text(l10n.actionsDeleteVariableConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              if (variable.name != null) {
                Injection.repoActionsNotifier.deleteVariable(widget.owner, widget.repo, variable.name!);
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
