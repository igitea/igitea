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
import '../theme/app_theme.dart';

class GpgKeysPage extends StatefulWidget {
  const GpgKeysPage({super.key});

  @override
  State<GpgKeysPage> createState() => _GpgKeysPageState();
}

class _GpgKeysPageState extends State<GpgKeysPage> {
  List<GPGKey> _keys = [];
  String? _error;
  bool _loading = true;
  final Set<String> _expanded = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final result = await Injection.listGPGKeysUseCase();
    if (!mounted) return;
    switch (result) {
      case Right<Failure, List<GPGKey>>(:final value):
        setState(() {
          _keys = value;
          _loading = false;
          _error = null;
        });
      case Left<Failure, List<GPGKey>>(:final value):
        if (mounted) {
          setState(() {
            _loading = false;
            _error = value.message;
          });
        }
    }
  }

  Future<void> _add() async {
    final l10n = AppLocalizations.of(context)!;
    final ctrl = TextEditingController();
    final key = await showFDialog<String>(
      context: context,
      builder: (ctx, style, animation) => FDialog(
        title: Text(l10n.addGpgKey),
        body: FTextField(
          control: FTextFieldControl.managed(controller: ctrl),
          label: Text(l10n.publicKey),
          hint: l10n.gpgKeyHint,
          maxLines: 6,
        ),
        actions: [
          FButton(
            variant: .outline,
            onPress: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FButton(
            onPress: () {
              final value = ctrl.text.trim();
              if (value.isNotEmpty) Navigator.pop(ctx, value);
            },
            child: Text(l10n.add),
          ),
        ],
      ),
    );
    if (key == null || key.isEmpty || !mounted) return;

    final result = await Injection.addGPGKeyUseCase(key);
    if (!mounted) return;
    switch (result) {
      case Right<Failure, GPGKey>():
        showFToast(context: context, title: Text(l10n.gpgKeyAdded));
        _load();
      case Left<Failure, GPGKey>():
        showFToast(
          context: context,
          variant: .destructive,
          title: Text(l10n.error),
        );
    }
  }

  Future<void> _delete(GPGKey gpgKey) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await showFDialog<bool>(
      context: context,
      builder: (ctx, style, animation) => FDialog(
        title: Text(l10n.deleteGpgKey),
        body: Text(l10n.deleteGpgKeyConfirm),
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
    final id = gpgKey.id;
    if (ok != true || id == null || !mounted) return;

    final result = await Injection.deleteGPGKeyUseCase(id);
    if (!mounted) return;
    switch (result) {
      case Right<Failure, void>():
        showFToast(context: context, title: Text(l10n.gpgKeyDeleted));
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
      title: l10n.gpgKeys,
      actions: [
        FHeaderAction(
          icon: const Icon(FIcons.plus),
          semanticsLabel: l10n.addGpgKey,
          onPress: _add,
        ),
      ],
      child: _loading
          ? const AppLoading()
          : _error != null
          ? AppError(message: _error!, onRetry: _load)
          : _keys.isEmpty
          ? AppEmpty(icon: FIcons.keyRound, title: l10n.noGpgKeys)
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                children: [
                  for (final key in _keys)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _buildKeyCard(key, l10n, theme),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildKeyCard(GPGKey key, AppLocalizations l10n, ThemeData theme) {
    final keyId = key.id?.toString() ?? key.key_id ?? key.public_key ?? '';
    final expanded = _expanded.contains(keyId);
    final badges = [
      if (key.can_sign == true) l10n.sign,
      if (key.can_certify == true) l10n.certify,
      if (key.verified == true) l10n.verified,
    ];

    return FCard.raw(
      child: Column(
        children: [
          AppTile(
            leading: Icon(
              FIcons.keyRound,
              size: 18,
              color: theme.colorScheme.primary,
            ),
            title: key.key_id ?? l10n.unknown,
            subtitle: badges.join(' · '),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  expanded ? FIcons.chevronUp : FIcons.chevronDown,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                FTappable(
                  onPress: () => _delete(key),
                  semanticsLabel: l10n.deleteGpgKey,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      FIcons.trash2,
                      size: 16,
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),
            showChevron: false,
            onPress: () {
              setState(() {
                if (expanded) {
                  _expanded.remove(keyId);
                } else {
                  _expanded.add(keyId);
                }
              });
            },
          ),
          if (expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SelectableText(
                key.public_key ?? '',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                  fontFamilyFallback: kMonoFontFallback,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
