import 'package:flutter/material.dart';

import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/empty_state.dart';

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
    final email = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.addEmail),
        content: TextField(
          controller: ctrl,
          decoration: InputDecoration(
            hintText: 'user@example.com',
            border: const OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
          FilledButton(
            onPressed: ctrl.text.trim().isEmpty ? null : () => Navigator.pop(ctx, ctrl.text.trim()),
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.created)));
        _load();
      case Left<Failure, void>(:final value):
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.error)));
    }
  }

  Future<void> _delete(Email email) async {
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
    if (ok != true || !mounted) return;

    final result = await Injection.deleteEmailUseCase([email.email!]);
    if (!mounted) return;
    switch (result) {
      case Right<Failure, void>():
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.labelDeleted)));
        _load();
      case Left<Failure, void>(:final value):
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.emails)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.add),
        label: Text(l10n.addEmail),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline_rounded, size: 48,
                        color: Theme.of(context).colorScheme.error),
                      const SizedBox(height: 16),
                      Text(_error!, style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 16),
                      FilledButton.tonalIcon(
                        onPressed: _load,
                        icon: const Icon(Icons.refresh_rounded, size: 18),
                        label: Text(l10n.retry),
                      ),
                    ],
                  ),
                )
              : _emails.isEmpty
              ? EmptyState(icon: Icons.email_outlined, title: l10n.noData)
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(UIConstants.md),
                    itemCount: _emails.length,
                    itemBuilder: (context, index) {
                      final e = _emails[index];
                      return Card(
                        elevation: 0,
                        margin: const EdgeInsets.only(bottom: UIConstants.sm),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
                        ),
                        child: ListTile(
                          leading: Icon(e.primary == true ? Icons.email : Icons.email_outlined,
                            color: e.primary == true ? Theme.of(context).colorScheme.primary : null),
                          title: Text(e.email ?? ''),
                          subtitle: Row(
                            children: [
                              if (e.verified == true)
                                const _Badge(label: 'Verified', color: Colors.green),
                              if (e.primary == true) ...[
                                if (e.verified == true) const SizedBox(width: 6),
                                const _Badge(label: 'Primary', color: Colors.blue),
                              ],
                            ],
                          ),
                          trailing: e.primary == true ? null : IconButton(
                            icon: const Icon(Icons.delete_outline),
                            tooltip: l10n.delete,
                            onPressed: () => _delete(e),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color)),
    );
  }
}
