import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../state/org_actions_notifier.dart';
import '../widgets/forui/app_page.dart';
import '../widgets/forui/app_state_views.dart';
import '../widgets/forui/app_tile.dart';

class OrgActionsSecretsPage extends StatefulWidget {
  final String org;
  const OrgActionsSecretsPage({super.key, required this.org});

  @override
  State<OrgActionsSecretsPage> createState() => _OrgActionsSecretsPageState();
}

class _OrgActionsSecretsPageState extends State<OrgActionsSecretsPage> {
  @override
  void initState() {
    super.initState();
    Injection.orgActionsNotifier.loadSecrets(widget.org);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AppPage(
      title: l10n.actionsSecretsTitle,
      actions: [
        FHeaderAction(
          icon: const Icon(FIcons.plus),
          semanticsLabel: l10n.actionsCreateSecret,
          onPress: () => _showCreateDialog(context),
        ),
      ],
      child: ListenableBuilder(
        listenable: Injection.orgActionsNotifier,
        builder: (context, _) {
          final state = Injection.orgActionsNotifier.secretsState;
          return switch (state) {
            OrgActionsSecretsLoading() => const AppLoading(),
            OrgActionsSecretsError(:final message) => AppError(
              message: message,
              onRetry: () =>
                  Injection.orgActionsNotifier.loadSecrets(widget.org),
            ),
            OrgActionsSecretsLoaded(:final secrets) =>
              secrets.isEmpty
                  ? AppEmpty(icon: FIcons.lock, title: l10n.actionsNoSecrets)
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                      children: [
                        for (final secret in secrets)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: FCard.raw(
                              child: AppTile(
                                leading: Icon(
                                  FIcons.lock,
                                  size: 18,
                                  color: theme.colorScheme.primary,
                                ),
                                title: secret.name ?? l10n.unknown,
                                showChevron: false,
                                trailing: FTappable(
                                  onPress: () =>
                                      _confirmDelete(context, secret),
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
                            ),
                          ),
                      ],
                    ),
            _ => const SizedBox(),
          };
        },
      ),
    );
  }

  Future<void> _showCreateDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController();
    final valueController = TextEditingController();

    final result = await showFDialog<Map<String, String>>(
      context: context,
      builder: (ctx, style, animation) => FDialog(
        title: Text(l10n.actionsCreateSecret),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FTextField(
              control: FTextFieldControl.managed(controller: nameController),
              label: Text(l10n.actionsSecretName),
            ),
            const SizedBox(height: 16),
            FTextField(
              control: FTextFieldControl.managed(controller: valueController),
              label: Text(l10n.actionsSecretValue),
              obscureText: true,
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
              final value = valueController.text.trim();
              if (name.isNotEmpty && value.isNotEmpty) {
                Navigator.pop(ctx, {'name': name, 'value': value});
              }
            },
            child: Text(l10n.create),
          ),
        ],
      ),
    );

    if (result == null || !mounted) return;
    Injection.orgActionsNotifier.createSecret(
      widget.org,
      result['name'] ?? '',
      result['value'] ?? '',
    );
  }

  Future<void> _confirmDelete(BuildContext context, Secret secret) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showFDialog<bool>(
      context: context,
      builder: (ctx, style, animation) => FDialog(
        title: Text(l10n.confirmDelete),
        body: Text(l10n.actionsDeleteSecretConfirm),
        actions: [
          FButton(
            variant: .outline,
            onPress: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FButton(
            variant: .destructive,
            onPress: () => Navigator.pop(ctx, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    if (secret.name != null) {
      Injection.orgActionsNotifier.deleteSecret(widget.org, secret.name!);
    }
  }
}
