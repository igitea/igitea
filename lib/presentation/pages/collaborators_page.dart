import 'package:flutter/material.dart';

import '../../core/animations/animated_wrapper.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/empty_state.dart';
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
    final result = await Injection.repoNotifier.listCollaborators(widget.owner, widget.repo);
    if (mounted) {
      setState(() {
        _collaborators = result ?? [];
        _loading = false;
      });
    }
  }

  Future<void> _addCollaborator() async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    List<User> results = [];
    bool searching = false;

    final username = await showDialog<String>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(l10n.addCollaborator),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: l10n.searchMembers,
                  border: const OutlineInputBorder(),
                ),
                onChanged: (q) async {
                  if (q.trim().isEmpty) { setDialogState(() => results = []); return; }
                  setDialogState(() => searching = true);
                  try { results = await Injection.apiService.adminSearchUsers(login_name: q.trim()); } catch (_) { results = []; }
                  setDialogState(() => searching = false);
                },
              ),
              const SizedBox(height: 12),
              if (searching) const CircularProgressIndicator(strokeWidth: 2)
              else if (results.isEmpty && controller.text.trim().isNotEmpty) Text(l10n.noSearchResults)
              else ...results.map((u) => ListTile(
                leading: UserAvatar(user: u, radius: 14),
                title: Text(u.login ?? ''), dense: true,
                onTap: () => Navigator.pop(ctx, u.login),
              )),
            ],
          ),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel))],
        ),
      ),
    );

    if (username != null && username.isNotEmpty) {
      final success = await Injection.repoNotifier.addCollaborator(widget.owner, widget.repo, username, null);
      if (mounted && success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.collaboratorAdded)));
        _load();
      }
    }
  }

  Future<void> _removeCollaborator(String username) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.removeCollaborator),
        content: Text(l10n.removeCollaboratorConfirmParams(username)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.removeCollaborator)),
        ],
      ),
    );
    if (ok == true) {
      final success = await Injection.repoNotifier.removeCollaborator(widget.owner, widget.repo, username);
      if (mounted && success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.collaboratorRemoved)));
        _load();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.collaborators)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addCollaborator,
        icon: const Icon(Icons.person_add),
        label: Text(l10n.addCollaborator),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _collaborators.isEmpty
              ? EmptyState(icon: Icons.people_outline, title: l10n.noCollaborators)
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(UIConstants.md),
                    itemCount: _collaborators.length,
                    itemBuilder: (context, index) {
                      final user = _collaborators[index];
                      return FadeInWrapper(
                        delay: Duration(milliseconds: index * 30),
                        child: Card(
                          elevation: 0,
                          margin: const EdgeInsets.only(bottom: UIConstants.sm),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
                          ),
                          child: ListTile(
                            leading: UserAvatar(user: user, radius: 16),
                            title: Text(user.login ?? ''),
                            subtitle: user.full_name != null ? Text(user.full_name!) : null,
                            trailing: IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              tooltip: l10n.removeCollaborator,
                              onPressed: () => _removeCollaborator(user.login ?? ''),
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
