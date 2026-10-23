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

class SshKeysPage extends StatefulWidget {
  const SshKeysPage({super.key});

  @override
  State<SshKeysPage> createState() => _SshKeysPageState();
}

class _SshKeysPageState extends State<SshKeysPage> {
  List<PublicKey> _keys = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadKeys();
  }

  Future<void> _loadKeys() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final result = await Injection.listCurrentUserKeysUseCase();
      if (mounted) {
        switch (result) {
          case Right<Failure, List<PublicKey>>(:final value):
            setState(() {
              _keys = value;
              _loading = false;
            });
          case Left<Failure, List<PublicKey>>():
            setState(() {
              _error = 'Load failed';
              _loading = false;
            });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  Future<void> _deleteKey(int id) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showFDialog<bool>(
      context: context,
      builder: (ctx, style, animation) => FDialog(
        title: Text(l10n.deleteKey),
        body: Text(l10n.deleteKeyConfirm),
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

    if (confirmed != true) return;

    try {
      final result = await Injection.deleteKeyUseCase(id);
      switch (result) {
        case Right<Failure, void>():
          if (mounted) {
            showFToast(context: context, title: Text(l10n.keyDeleted));
            _loadKeys();
          }
        case Left<Failure, void>(:final value):
          if (mounted) setState(() => _error = value.message);
      }
    } catch (e) {
      if (mounted) {
        showFToast(
          context: context,
          variant: .destructive,
          title: Text('${l10n.error}: $e'),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AppPage(
      title: l10n.sshKeys,
      actions: [
        FHeaderAction(
          icon: const Icon(FIcons.plus),
          semanticsLabel: l10n.addSshKey,
          onPress: _showAddKeyDialog,
        ),
      ],
      child: _loading
          ? const AppLoading()
          : _error != null
          ? AppError(message: _error!, onRetry: _loadKeys)
          : _keys.isEmpty
          ? AppEmpty(
              icon: FIcons.keyRound,
              title: l10n.noSshKeysFound,
              action: FButton(
                prefix: const Icon(FIcons.plus, size: 16),
                onPress: _showAddKeyDialog,
                child: Text(l10n.addSshKey),
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadKeys,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                children: [
                  for (final key in _keys)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: FCard.raw(
                        child: AppTile(
                          leading: Icon(
                            FIcons.keyRound,
                            size: 18,
                            color: theme.colorScheme.primary,
                          ),
                          title: key.title ?? l10n.untitled,
                          subtitle: [
                            if (key.fingerprint != null) key.fingerprint!,
                            if (key.created_at != null)
                              '${l10n.created}: ${_formatDate(key.created_at!, l10n)}',
                          ].join(' · '),
                          showChevron: false,
                          trailing: FTappable(
                            onPress: key.id != null
                                ? () => _deleteKey(key.id!)
                                : null,
                            semanticsLabel: l10n.deleteKey,
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

  Future<void> _showAddKeyDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final titleController = TextEditingController();
    final keyController = TextEditingController();

    final result = await showFDialog<Map<String, String>>(
      context: context,
      builder: (ctx, style, animation) => FDialog(
        title: Text(l10n.addSshKey),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FTextField(
                control: FTextFieldControl.managed(controller: titleController),
                label: Text(l10n.title),
                hint: l10n.myLaptopHint,
                maxLength: 255,
              ),
              const SizedBox(height: 16),
              FTextField(
                control: FTextFieldControl.managed(controller: keyController),
                label: Text(l10n.publicKey),
                hint: l10n.sshPublicKeyHint,
                maxLines: 5,
              ),
            ],
          ),
        ),
        actions: [
          FButton(
            variant: .outline,
            onPress: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FButton(
            onPress: () {
              if (titleController.text.isNotEmpty &&
                  keyController.text.isNotEmpty) {
                Navigator.pop(ctx, {
                  'title': titleController.text,
                  'key': keyController.text,
                });
              }
            },
            child: Text(l10n.add),
          ),
        ],
      ),
    );

    if (result != null) {
      try {
        final addResult = await Injection.addKeyUseCase(
          result['title'] ?? '',
          result['key'] ?? '',
        );
        switch (addResult) {
          case Right<Failure, PublicKey>():
            if (mounted) {
              showFToast(context: context, title: Text(l10n.keyAdded));
              _loadKeys();
            }
          case Left<Failure, PublicKey>(:final value):
            if (mounted) setState(() => _error = value.message);
        }
      } catch (e) {
        if (mounted) {
          showFToast(
            context: context,
            variant: .destructive,
            title: Text('${l10n.error}: $e'),
          );
        }
      }
    }
  }

  String _formatDate(DateTime date, AppLocalizations l10n) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 365) return l10n.ago('${diff.inDays ~/ 365}y');
    if (diff.inDays > 30) return l10n.ago('${diff.inDays ~/ 30}mo');
    if (diff.inDays > 0) return l10n.ago('${diff.inDays}d');
    return l10n.justNow;
  }
}
