import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../core/di/injection.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/forui/app_page.dart';
import '../widgets/forui/app_section.dart';
import '../widgets/forui/app_state_views.dart';
import '../widgets/forui/app_tile.dart';
import '../state/admin_notifier.dart';
import 'create_admin_webhook_page.dart';

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
    return AppPage(
      title: l10n.adminHooksTitle,
      actions: [
        FHeaderAction(
          icon: const Icon(FIcons.plus),
          semanticsLabel: l10n.createWebhook,
          onPress: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreateAdminWebhookPage()),
            );
            if (context.mounted) {
              Injection.adminNotifier.loadHooks();
            }
          },
        ),
      ],
      child: ListenableBuilder(
        listenable: Injection.adminNotifier,
        builder: (context, _) {
          final state = Injection.adminNotifier.hooksState;
          return switch (state) {
            AdminHooksLoading() => const AppLoading(),
            AdminHooksError(:final message) => AppError(
              message: message,
              onRetry: () => Injection.adminNotifier.loadHooks(),
            ),
            AdminHooksLoaded(:final hooks) => hooks.isEmpty
              ? AppEmpty(icon: FIcons.webhook, title: l10n.adminNoHooks)
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                  children: [
                    AppSection(
                      title: '',
                      showHeader: false,
                      children: [
                        for (final hook in hooks)
                          AppTile(
                            leading: const Icon(FIcons.webhook),
                            title: hook.type ?? l10n.unknown,
                            subtitle: hook.config?['url']?.toString() ?? '',
                            showChevron: false,
                            trailing: FTappable(
                              onPress: () => _confirmDelete(context, hook.id),
                              child: const Padding(
                                padding: EdgeInsets.all(6),
                                child: Icon(FIcons.trash2, size: 16),
                              ),
                            ),
                            onPress: null,
                          ),
                      ],
                    ),
                  ],
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
    showFDialog<void>(
      context: context,
      builder: (ctx, style, animation) => FDialog(
        title: Text(l10n.deleteWebhook),
        body: Text(l10n.deleteWebhookConfirm),
        actions: [
          FButton(
            variant: .outline,
            onPress: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel),
          ),
          FButton(
            variant: .destructive,
            onPress: () async {
              Navigator.of(ctx).pop();
              await Injection.adminNotifier.deleteHook(id);
              if (context.mounted) {
                Injection.adminNotifier.loadHooks();
              }
            },
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
}
