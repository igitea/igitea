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

class BranchProtectionPage extends StatefulWidget {
  final String owner;
  final String repo;

  const BranchProtectionPage({
    super.key,
    required this.owner,
    required this.repo,
  });

  @override
  State<BranchProtectionPage> createState() => _BranchProtectionPageState();
}

class _BranchProtectionPageState extends State<BranchProtectionPage> {
  List<BranchProtection> _protections = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await Injection.listBranchProtectionsUseCase(
      widget.owner,
      widget.repo,
    );
    if (!mounted) return;
    switch (result) {
      case Right<Failure, List<BranchProtection>>(:final value):
        setState(() {
          _protections = value;
          _loading = false;
        });
      case Left<Failure, List<BranchProtection>>(:final value):
        if (mounted) {
          setState(() {
            _loading = false;
            _error = value.message;
          });
        }
    }
  }

  Future<void> _create() async {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController();
    final branchName = await showFDialog<String>(
      context: context,
      builder: (ctx, style, animation) => FDialog(
        title: Text(l10n.protectBranch),
        body: FTextField(
          control: FTextFieldControl.managed(controller: nameController),
          label: Text(l10n.releaseTagName),
          hint: 'main',
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

    if (branchName == null || branchName.isEmpty || !mounted) return;

    final result = await Injection.createBranchProtectionUseCase(
      widget.owner,
      widget.repo,
      {'branch_name': branchName},
    );
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

  Future<void> _delete(String name) async {
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

    final result = await Injection.deleteBranchProtectionUseCase(
      widget.owner,
      widget.repo,
      name,
    );
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
      title: l10n.branchProtection,
      actions: [
        FHeaderAction(
          icon: const Icon(FIcons.plus),
          semanticsLabel: l10n.protectBranch,
          onPress: _create,
        ),
      ],
      child: _loading
          ? const AppLoading()
          : _error != null
          ? AppError(message: _error!, onRetry: _load)
          : _protections.isEmpty
          ? AppEmpty(icon: FIcons.shield, title: l10n.noData)
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.builder(
                padding: const EdgeInsets.all(UIConstants.md),
                itemCount: _protections.length,
                itemBuilder: (context, index) {
                  final p = _protections[index];
                  final name = p.branch_name ?? '?';
                  final created = p.created_at?.toString();
                  return FadeInWrapper(
                    delay: Duration(milliseconds: index * 30),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: UIConstants.sm),
                      child: FCard.raw(
                        child: AppTile(
                          leading: const Icon(FIcons.shield, size: 18),
                          title: name,
                          subtitle: created,
                          showChevron: false,
                          trailing: FTappable(
                            onPress: () => _delete(name),
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
                    ),
                  );
                },
              ),
            ),
    );
  }
}
