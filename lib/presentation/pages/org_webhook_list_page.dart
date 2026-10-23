import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../core/animations/animated_wrapper.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/forui/app_page.dart';
import '../widgets/forui/app_state_views.dart';
import '../widgets/forui/app_tile.dart';

class OrgWebhookListPage extends StatefulWidget {
  final String org;

  const OrgWebhookListPage({super.key, required this.org});

  @override
  State<OrgWebhookListPage> createState() => _OrgWebhookListPageState();
}

class _OrgWebhookListPageState extends State<OrgWebhookListPage> {
  List<Hook> _hooks = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await Injection.listOrgHooksUseCase(widget.org);
    if (!mounted) return;
    switch (result) {
      case Right<Failure, List<Hook>>(:final value):
        setState(() {
          _hooks = value;
          _loading = false;
        });
      case Left<Failure, List<Hook>>(:final value):
        setState(() {
          _error = value.message;
          _loading = false;
        });
    }
  }

  Future<void> _create() async {
    final l10n = AppLocalizations.of(context)!;
    final urlCtrl = TextEditingController();
    final secretCtrl = TextEditingController();
    String contentType = 'json';
    bool active = true;

    final result = await showFDialog<bool>(
      context: context,
      builder: (ctx, style, animation) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          return FDialog(
            title: Text(l10n.createWebhook),
            body: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FTextField(
                    control: FTextFieldControl.managed(controller: urlCtrl),
                    label: Text(l10n.webhookUrl),
                  ),
                  const SizedBox(height: 12),
                  FTextField(
                    control: FTextFieldControl.managed(controller: secretCtrl),
                    label: Text(l10n.webhookSecret),
                  ),
                  const SizedBox(height: 12),
                  FSelect<String>(
                    items: const {'JSON': 'json', 'Form': 'form'},
                    control: FSelectControl.lifted(
                      value: contentType,
                      onChange: (v) =>
                          setDialogState(() => contentType = v ?? 'json'),
                    ),
                    label: Text(l10n.contentType),
                  ),
                  const SizedBox(height: 12),
                  FSwitch(
                    value: active,
                    label: Text(l10n.active),
                    onChange: (v) => setDialogState(() => active = v),
                  ),
                ],
              ),
            ),
            actions: [
              FButton(
                variant: .outline,
                onPress: () => Navigator.pop(ctx, false),
                child: Text(l10n.cancel),
              ),
              FButton(
                onPress: () async {
                  final url = urlCtrl.text.trim();
                  if (url.isEmpty) return;
                  final r = await Injection.createOrgHookUseCase(widget.org, {
                    'type': 'gitea',
                    'config': {
                      'url': url,
                      'content_type': contentType,
                      if (secretCtrl.text.trim().isNotEmpty)
                        'secret': secretCtrl.text.trim(),
                    },
                    'active': active,
                    'events': ['push'],
                  });
                  if (ctx.mounted) Navigator.pop(ctx, r is Right);
                },
                child: Text(l10n.create),
              ),
            ],
          );
        },
      ),
    );

    if (result == true && mounted) {
      showFToast(context: context, title: Text(l10n.created));
      _load();
    }
  }

  Future<void> _edit(Hook hook) async {
    final l10n = AppLocalizations.of(context)!;
    final config = hook.config ?? {};
    final urlCtrl = TextEditingController(
      text: config['url']?.toString() ?? '',
    );
    final secretCtrl = TextEditingController();
    String contentType = config['content_type']?.toString() ?? 'json';
    bool active = hook.active ?? true;

    final result = await showFDialog<bool>(
      context: context,
      builder: (ctx, style, animation) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          return FDialog(
            title: Text(l10n.editWebhook),
            body: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FTextField(
                    control: FTextFieldControl.managed(controller: urlCtrl),
                    label: Text(l10n.webhookUrl),
                  ),
                  const SizedBox(height: 12),
                  FTextField(
                    control: FTextFieldControl.managed(controller: secretCtrl),
                    label: Text(l10n.webhookSecret),
                  ),
                  const SizedBox(height: 12),
                  FSelect<String>(
                    items: const {'JSON': 'json', 'Form': 'form'},
                    control: FSelectControl.lifted(
                      value: contentType,
                      onChange: (v) =>
                          setDialogState(() => contentType = v ?? 'json'),
                    ),
                    label: Text(l10n.contentType),
                  ),
                  const SizedBox(height: 12),
                  FSwitch(
                    value: active,
                    label: Text(l10n.active),
                    onChange: (v) => setDialogState(() => active = v),
                  ),
                ],
              ),
            ),
            actions: [
              FButton(
                variant: .outline,
                onPress: () => Navigator.pop(ctx, false),
                child: Text(l10n.cancel),
              ),
              FButton(
                onPress: () async {
                  final url = urlCtrl.text.trim();
                  if (url.isEmpty) return;
                  final r = await Injection.editOrgHookUseCase(
                    widget.org,
                    hook.id ?? 0,
                    {
                      'config': {
                        'url': url,
                        'content_type': contentType,
                        if (secretCtrl.text.trim().isNotEmpty)
                          'secret': secretCtrl.text.trim(),
                      },
                      'active': active,
                    },
                  );
                  if (ctx.mounted) Navigator.pop(ctx, r is Right);
                },
                child: Text(l10n.save),
              ),
            ],
          );
        },
      ),
    );

    if (result == true && mounted) {
      showFToast(context: context, title: Text(l10n.saved));
      _load();
    }
  }

  Future<void> _delete(int id) async {
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
    if (ok != true) return;
    final result = await Injection.deleteOrgHookUseCase(widget.org, id);
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
    return AppPage(
      title: l10n.webhooks,
      actions: [
        FHeaderAction(
          icon: const Icon(FIcons.plus),
          semanticsLabel: l10n.createWebhook,
          onPress: _create,
        ),
      ],
      child: _buildBody(l10n),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_loading) return const AppLoading();
    if (_error != null) return AppError(message: _error!, onRetry: _load);
    if (_hooks.isEmpty) {
      return AppEmpty(icon: FIcons.webhook, title: l10n.noData);
    }
    final theme = Theme.of(context);
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        padding: const EdgeInsets.all(UIConstants.md),
        itemCount: _hooks.length,
        itemBuilder: (context, index) {
          final hook = _hooks[index];
          final active = hook.active == true;
          return FadeInWrapper(
            delay: Duration(milliseconds: index * 30),
            child: Padding(
              padding: const EdgeInsets.only(bottom: UIConstants.sm),
              child: FCard.raw(
                child: AppTile(
                  leading: Icon(
                    active ? FIcons.webhook : FIcons.webhookOff,
                    size: UIConstants.iconMd,
                    color: active ? theme.colorScheme.primary : null,
                  ),
                  title: hook.config?['url']?.toString() ?? '?',
                  subtitle: hook.type ?? '',
                  showChevron: false,
                  trailing: FTappable(
                    onPress: () => _delete(hook.id!),
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
                  onPress: () => _edit(hook),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
