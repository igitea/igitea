import 'package:flutter/material.dart';

import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/empty_state.dart';

class TagProtectionsPage extends StatefulWidget {
  final String owner;
  final String repo;

  const TagProtectionsPage({super.key, required this.owner, required this.repo});

  @override
  State<TagProtectionsPage> createState() => _TagProtectionsPageState();
}

class _TagProtectionsPageState extends State<TagProtectionsPage> {
  List<TagProtection> _protections = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      _protections = await Injection.apiService.repoListTagProtections(
        owner: widget.owner,
        repo: widget.repo,
      );
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _add() async {
    final l10n = AppLocalizations.of(context)!;
    final ctrl = TextEditingController();
    final pattern = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.createTagProtection),
        content: TextField(
          controller: ctrl,
          decoration: InputDecoration(
            labelText: l10n.namePattern,
            hintText: 'v*',
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
          FilledButton(
            onPressed: ctrl.text.trim().isEmpty ? null : () => Navigator.pop(ctx, ctrl.text.trim()),
            child: Text(l10n.create),
          ),
        ],
      ),
    );
    if (pattern != null && mounted) {
      try {
        await Injection.apiService.repoCreateTagProtection(
          owner: widget.owner,
          repo: widget.repo,
          namePattern: pattern,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.tagProtectionCreated)));
          _load();
        }
      } catch (_) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.error)));
      }
    }
  }

  Future<void> _delete(TagProtection protection) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteTagProtection),
        content: Text(l10n.deleteTagProtectionConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.delete)),
        ],
      ),
    );
    if (ok == true && protection.id != null && mounted) {
      try {
        await Injection.apiService.repoDeleteTagProtection(
          owner: widget.owner,
          repo: widget.repo,
          id: protection.id!,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.tagProtectionDeleted)));
          _load();
        }
      } catch (_) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.error)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tagProtections)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.add),
        label: Text(l10n.create),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _protections.isEmpty
              ? EmptyState(icon: Icons.local_offer_outlined, title: l10n.noTagProtections)
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(UIConstants.md),
                    itemCount: _protections.length,
                    itemBuilder: (context, index) {
                      final p = _protections[index];
                      return Card(
                        elevation: 0,
                        margin: const EdgeInsets.only(bottom: UIConstants.sm),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: theme.colorScheme.outlineVariant),
                        ),
                        child: ListTile(
                          leading: Icon(Icons.local_offer, color: theme.colorScheme.primary),
                          title: Text(
                            p.name_pattern ?? l10n.unknown,
                            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
                          ),
                          subtitle: p.whitelist_usernames != null && p.whitelist_usernames!.isNotEmpty
                              ? Text('${l10n.allowedUsers}: ${p.whitelist_usernames!.join(', ')}')
                              : null,
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => _delete(p),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
