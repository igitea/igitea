import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/forui/app_page.dart';
import '../widgets/forui/app_state_views.dart';
import '../widgets/forui/app_tile.dart';

class TagProtectionsPage extends StatefulWidget {
  final String owner;
  final String repo;

  const TagProtectionsPage({
    super.key,
    required this.owner,
    required this.repo,
  });

  @override
  State<TagProtectionsPage> createState() => _TagProtectionsPageState();
}

class _TagProtectionsPageState extends State<TagProtectionsPage> {
  List<TagProtection> _protections = [];
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
    final result = await Injection.listTagProtectionsUseCase(
      widget.owner,
      widget.repo,
    );
    if (!mounted) return;
    switch (result) {
      case Right<Failure, List<TagProtection>>(:final value):
        setState(() {
          _protections = value;
          _loading = false;
          _error = null;
        });
      case Left<Failure, List<TagProtection>>(:final value):
        setState(() {
          _error = value.message;
          _loading = false;
        });
    }
  }

  Future<void> _add() async {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController();
    final pattern = await showFDialog<String>(
      context: context,
      builder: (ctx, style, animation) => FDialog(
        title: Text(l10n.createTagProtection),
        body: FTextField(
          control: FTextFieldControl.managed(controller: nameController),
          label: Text(l10n.namePattern),
          hint: 'v*',
        ),
        actions: [
          FButton(
            variant: .outline,
            onPress: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FButton(
            onPress: () => Navigator.pop(ctx, nameController.text.trim()),
            child: Text(l10n.create),
          ),
        ],
      ),
    );

    if (pattern == null || pattern.isEmpty || !mounted) return;

    final result = await Injection.createTagProtectionUseCase(
      widget.owner,
      widget.repo,
      pattern,
    );
    if (!mounted) return;
    switch (result) {
      case Right<Failure, TagProtection>():
        showFToast(context: context, title: Text(l10n.tagProtectionCreated));
        _load();
      case Left<Failure, TagProtection>():
        showFToast(
          context: context,
          variant: .destructive,
          title: Text(l10n.error),
        );
    }
  }

  Future<void> _delete(TagProtection protection) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await showFDialog<bool>(
      context: context,
      builder: (ctx, style, animation) => FDialog(
        title: Text(l10n.deleteTagProtection),
        body: Text(l10n.deleteTagProtectionConfirm),
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
    final id = protection.id;
    if (ok != true || id == null || !mounted) return;

    final result = await Injection.deleteTagProtectionUseCase(
      widget.owner,
      widget.repo,
      id,
    );
    if (!mounted) return;
    switch (result) {
      case Right<Failure, void>():
        showFToast(context: context, title: Text(l10n.tagProtectionDeleted));
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
      title: l10n.tagProtections,
      actions: [
        FHeaderAction(
          icon: const Icon(FIcons.plus),
          semanticsLabel: l10n.create,
          onPress: _add,
        ),
      ],
      child: _loading
          ? const AppLoading()
          : _error != null
          ? AppError(message: _error!, onRetry: _load)
          : _protections.isEmpty
          ? AppEmpty(icon: FIcons.tag, title: l10n.noTagProtections)
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.builder(
                padding: const EdgeInsets.all(UIConstants.md),
                itemCount: _protections.length,
                itemBuilder: (context, index) {
                  final p = _protections[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: UIConstants.sm),
                    child: FCard.raw(
                      child: AppTile(
                        leading: Icon(
                          FIcons.tag,
                          size: 18,
                          color: theme.colorScheme.primary,
                        ),
                        title: p.name_pattern ?? l10n.unknown,
                        subtitle:
                            p.whitelist_usernames != null &&
                                p.whitelist_usernames!.isNotEmpty
                            ? '${l10n.allowedUsers}: ${p.whitelist_usernames!.join(', ')}'
                            : null,
                        showChevron: false,
                        trailing: FTappable(
                          onPress: () => _delete(p),
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Icon(
                              FIcons.trash2,
                              size: 16,
                              color: theme.colorScheme.error,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
