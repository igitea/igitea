import 'package:flutter/material.dart';

import '../../core/di/injection.dart';
import '../../l10n/app_localizations.dart';
import '../state/admin_notifier.dart';

class AdminHooksPage extends StatefulWidget {
  const AdminHooksPage({super.key});

  @override
  State<AdminHooksPage> createState() => _AdminHooksPageState();
}

class _AdminHooksPageState extends State<AdminHooksPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Injection.adminNotifier.loadHooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.adminHooksTitle)),
      body: ListenableBuilder(
        listenable: Injection.adminNotifier,
        builder: (context, _) {
          final state = Injection.adminNotifier.hooksState;
          return switch (state) {
            AdminHooksLoading() => const Center(child: CircularProgressIndicator()),
            AdminHooksError(:final message) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${l10n.error}: $message'),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => Injection.adminNotifier.loadHooks(),
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            ),
            AdminHooksLoaded(:final hooks) => hooks.isEmpty
              ? Center(child: Text(l10n.adminNoHooks))
              : ListView.builder(
                  itemCount: hooks.length,
                  itemBuilder: (context, index) {
                    final hook = hooks[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: ListTile(
                        leading: const Icon(Icons.webhook),
                        title: Text(hook.type ?? l10n.unknown),
                        subtitle: Text(hook.config?['url']?.toString() ?? ''),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          tooltip: l10n.delete,
                          onPressed: () => _confirmDelete(context, hook.id),
                        ),
                      ),
                    );
                  },
                ),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, int? id) {
    if (id == null) return;
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteWebhook),
        content: Text(l10n.deleteWebhookConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await Injection.adminNotifier.deleteHook(id);
              if (context.mounted) {
                Injection.adminNotifier.loadHooks();
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
}
