import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../core/animations/animated_wrapper.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/forui/app_page.dart';
import '../widgets/forui/app_state_views.dart';
import '../widgets/forui/app_tile.dart';
import '../widgets/user_avatar.dart';

class CollaboratorsPage extends StatefulWidget {
  final String owner;
  final String repo;

  const CollaboratorsPage({super.key, required this.owner, required this.repo});

  @override
  State<CollaboratorsPage> createState() => _CollaboratorsPageState();
}

class _CollaboratorsPageState extends State<CollaboratorsPage> {
  List<User> _collaborators = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final result = await Injection.repoNotifier.listCollaborators(
      widget.owner,
      widget.repo,
    );
    if (mounted) {
      setState(() {
        _collaborators = result ?? [];
        _loading = false;
      });
    }
  }

  Future<void> _addCollaborator() async {
    final l10n = AppLocalizations.of(context)!;

    final username = await showFDialog<String>(
      context: context,
      builder: (ctx, style, animation) => _AddCollaboratorDialog(l10n: l10n),
    );

    if (username != null && username.isNotEmpty) {
      final success = await Injection.repoNotifier.addCollaborator(
        widget.owner,
        widget.repo,
        username,
        null,
      );
      if (mounted && success) {
        showFToast(context: context, title: Text(l10n.collaboratorAdded));
        _load();
      }
    }
  }

  Future<void> _removeCollaborator(String username) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await showFDialog<bool>(
      context: context,
      builder: (ctx, style, animation) => FDialog(
        title: Text(l10n.removeCollaborator),
        body: Text(l10n.removeCollaboratorConfirmParams(username)),
        actions: [
          FButton(
            variant: .outline,
            onPress: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FButton(
            variant: .destructive,
            onPress: () => Navigator.pop(ctx, true),
            child: Text(l10n.removeCollaborator),
          ),
        ],
      ),
    );
    if (ok == true) {
      final success = await Injection.repoNotifier.removeCollaborator(
        widget.owner,
        widget.repo,
        username,
      );
      if (mounted && success) {
        showFToast(context: context, title: Text(l10n.collaboratorRemoved));
        _load();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AppPage(
      title: l10n.collaborators,
      actions: [
        FHeaderAction(
          icon: const Icon(FIcons.userPlus),
          semanticsLabel: l10n.addCollaborator,
          onPress: _addCollaborator,
        ),
      ],
      child: _loading
          ? const AppLoading()
          : _collaborators.isEmpty
          ? AppEmpty(icon: FIcons.users, title: l10n.noCollaborators)
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.builder(
                padding: const EdgeInsets.all(UIConstants.md),
                itemCount: _collaborators.length,
                itemBuilder: (context, index) {
                  final user = _collaborators[index];
                  return FadeInWrapper(
                    delay: Duration(milliseconds: index * 30),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: UIConstants.sm),
                      child: FCard.raw(
                        child: AppTile(
                          leading: UserAvatar(user: user, radius: 16),
                          title: user.login ?? '',
                          subtitle: user.full_name,
                          showChevron: false,
                          trailing: FTappable(
                            onPress: () =>
                                _removeCollaborator(user.login ?? ''),
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

class _AddCollaboratorDialog extends StatefulWidget {
  final AppLocalizations l10n;

  const _AddCollaboratorDialog({required this.l10n});

  @override
  State<_AddCollaboratorDialog> createState() => _AddCollaboratorDialogState();
}

class _AddCollaboratorDialogState extends State<_AddCollaboratorDialog> {
  final TextEditingController _controller = TextEditingController();
  List<User> _results = [];
  String _query = '';
  bool _searching = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    final q = query.trim();
    setState(() => _query = q);
    if (q.isEmpty) {
      setState(() => _results = []);
      return;
    }
    setState(() => _searching = true);
    try {
      _results = await Injection.apiService.adminSearchUsers(login_name: q);
    } catch (_) {
      _results = [];
    }
    if (mounted) setState(() => _searching = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;

    return FDialog(
      title: Text(l10n.addCollaborator),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FTextField(
            control: FTextFieldControl.managed(
              controller: _controller,
              onChange: (value) => _search(value.text),
            ),
            hint: l10n.searchMembers,
          ),
          const SizedBox(height: 12),
          if (_searching)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: FCircularProgress(size: .sm),
            )
          else if (_results.isEmpty && _query.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(l10n.noSearchResults),
            )
          else
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 260),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final user in _results)
                      AppTile(
                        leading: UserAvatar(user: user, radius: 14),
                        title: user.login ?? '',
                        showChevron: false,
                        onPress: () => Navigator.pop(context, user.login),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
      actions: [
        FButton(
          variant: .outline,
          onPress: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
      ],
    );
  }
}
