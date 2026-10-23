import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../core/di/injection.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/forui/app_page.dart';
import '../widgets/forui/app_state_views.dart';
import '../widgets/forui/app_tile.dart';

class EmailsPage extends StatefulWidget {
  const EmailsPage({super.key});

  @override
  State<EmailsPage> createState() => _EmailsPageState();
}

class _EmailsPageState extends State<EmailsPage> {
  List<Email> _emails = [];
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final result = await Injection.listEmailsUseCase();
    if (!mounted) return;
    switch (result) {
      case Right<Failure, List<Email>>(:final value):
        setState(() { _emails = value; _loading = false; _error = null; });
      case Left<Failure, List<Email>>(:final value):
        if (mounted) setState(() { _loading = false; _error = value.message; });
    }
  }

  Future<void> _add() async {
    final l10n = AppLocalizations.of(context)!;
    final ctrl = TextEditingController();
    final email = await showFDialog<String>(
      context: context,
      builder: (ctx, style, animation) => FDialog(
        title: Text(l10n.addEmail),
        body: FTextField(
          control: FTextFieldControl.managed(controller: ctrl),
          label: Text(l10n.email),
          hint: 'user@example.com',
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          FButton(
            variant: .outline,
            onPress: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FButton(
            onPress: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: Text(l10n.addEmail),
          ),
        ],
      ),
    );
    if (email == null || email.isEmpty || !mounted) return;

    final result = await Injection.addEmailUseCase([email]);
    if (!mounted) return;
    switch (result) {
      case Right<Failure, void>():
        showFToast(context: context, title: Text(l10n.created));
        _load();
      case Left<Failure, void>():
        showFToast(
          context: context,
          variant: .destructive,
          title: Text(l10n.error),
        );
    }
  }

  Future<void> _delete(Email email) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await showFDialog<bool>(
      context: context,
      builder: (ctx, style, animation) => FDialog(
        title: Text(l10n.delete),
        body: Text(l10n.deleteLabelConfirm),
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
    if (ok != true || !mounted) return;

    final result = await Injection.deleteEmailUseCase([email.email!]);
    if (!mounted) return;
    switch (result) {
      case Right<Failure, void>():
        showFToast(context: context, title: Text(l10n.labelDeleted));
        _load();
      case Left<Failure, void>():
        showFToast(
          context: context,
          variant: .destructive,
          title: Text(l10n.error),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AppPage(
      title: l10n.emails,
      actions: [
        FHeaderAction(
          icon: const Icon(FIcons.plus),
          semanticsLabel: l10n.addEmail,
          onPress: _add,
        ),
      ],
      child: _loading
          ? const AppLoading()
          : _error != null
          ? AppError(message: _error!, onRetry: _load)
          : _emails.isEmpty
          ? AppEmpty(icon: FIcons.mail, title: l10n.noData)
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                children: [
                  for (final e in _emails)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: FCard.raw(
                        child: AppTile(
                          leading: Icon(
                            e.primary == true ? FIcons.mail : FIcons.mailOpen,
                            size: 18,
                            color: e.primary == true
                                ? theme.colorScheme.primary
                                : null,
                          ),
                          title: e.email ?? '',
                          subtitle: [
                            if (e.verified == true) 'Verified',
                            if (e.primary == true) 'Primary',
                          ].join(' · '),
                          showChevron: false,
                          trailing: e.primary == true
                              ? null
                              : FTappable(
                                  onPress: () => _delete(e),
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
            ),
    );
  }
}
