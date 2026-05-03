import 'package:flutter/material.dart';

import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../state/org_actions_notifier.dart';

class OrgActionsVariablesPage extends StatefulWidget {
  final String org;
  const OrgActionsVariablesPage({super.key, required this.org});

  @override
  State<OrgActionsVariablesPage> createState() => _OrgActionsVariablesPageState();
}

class _OrgActionsVariablesPageState extends State<OrgActionsVariablesPage> {
  @override
  void initState() {
    super.initState();
    Injection.orgActionsNotifier.loadVariables(widget.org);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.actionsVariablesTitle)),
      body: ListenableBuilder(
        listenable: Injection.orgActionsNotifier,
        builder: (context, _) {
          final state = Injection.orgActionsNotifier.variablesState;
          return switch (state) {
            OrgActionsVariablesLoading() => const Center(child: CircularProgressIndicator()),
            OrgActionsVariablesError(:final message) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${l10n.error}: $message'),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => Injection.orgActionsNotifier.loadVariables(widget.org),
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            ),
            OrgActionsVariablesLoaded(:final variables) => variables.isEmpty
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
                Injection.orgActionsNotifier.createVariable(widget.org, name, value);
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
                Injection.orgActionsNotifier.deleteVariable(widget.org, variable.name!);
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
