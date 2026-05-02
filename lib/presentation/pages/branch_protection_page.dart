import 'package:flutter/material.dart';

import '../../core/animations/animated_wrapper.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/empty_state.dart';

class BranchProtectionPage extends StatefulWidget {
  final String owner;
  final String repo;

  const BranchProtectionPage({super.key, required this.owner, required this.repo});

  @override
  State<BranchProtectionPage> createState() => _BranchProtectionPageState();
}

class _BranchProtectionPageState extends State<BranchProtectionPage> {
  List<Map<String, dynamic>> _protections = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final result = await Injection.apiService.repoListBranchProtections(owner: widget.owner, repo: widget.repo);
      if (mounted) setState(() { _protections = result.cast<Map<String, dynamic>>(); _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _create() async {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController();
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.protectBranch),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: l10n.releaseTagName,
            hintText: 'main',
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, {'branch_name': nameController.text.trim()}),
            child: Text(l10n.create),
          ),
        ],
      ),
    );

    if (result != null && mounted) {
      try {
        await Injection.apiService.repoCreateBranchProtection(owner: widget.owner, repo: widget.repo, body: result);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.created)));
          _load();
        }
      } catch (_) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.error)));
      }
    }
  }

  Future<void> _delete(String name) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.delete),
        content: Text(l10n.deleteLabelConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.delete)),
        ],
      ),
    );
    if (ok == true && mounted) {
      try {
        await Injection.apiService.repoDeleteBranchProtection(owner: widget.owner, repo: widget.repo, name: name);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.labelDeleted)));
        _load();
      } catch (_) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.error)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.branchProtection)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _create,
        icon: const Icon(Icons.add),
        label: Text(l10n.protectBranch),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _protections.isEmpty
              ? EmptyState(icon: Icons.shield_outlined, title: l10n.noData)
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(UIConstants.md),
                    itemCount: _protections.length,
                    itemBuilder: (context, index) {
                      final p = _protections[index];
                      final name = p['branch_name']?.toString() ?? p['rule_name']?.toString() ?? '?';
                      final created = p['created_at']?.toString();
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
                            leading: const Icon(Icons.shield_outlined),
                            title: Text(name, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                            subtitle: created != null ? Text(created) : null,
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline),
                              tooltip: l10n.delete,
                              onPressed: () => _delete(name),
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
