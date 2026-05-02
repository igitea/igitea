import 'package:flutter/material.dart';

import '../../core/animations/animated_wrapper.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/empty_state.dart';

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
    setState(() { _loading = true; _error = null; });
    try {
      _hooks = await Injection.apiService.orgListHooks(org: widget.org);
    } catch (e) {
      _error = e.toString();
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _create() async {
    final l10n = AppLocalizations.of(context)!;
    final urlCtrl = TextEditingController();
    final secretCtrl = TextEditingController();
    String contentType = 'json';
    bool active = true;

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(l10n.create),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: urlCtrl, decoration: const InputDecoration(labelText: 'URL', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextField(controller: secretCtrl, decoration: const InputDecoration(labelText: 'Secret', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: contentType,
                  items: const [
                    DropdownMenuItem(value: 'json', child: Text('JSON')),
                    DropdownMenuItem(value: 'form', child: Text('Form')),
                  ],
                  onChanged: (v) => setDialogState(() => contentType = v ?? 'json'),
                  decoration: const InputDecoration(labelText: 'Content Type', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                SwitchListTile(title: const Text('Active'), value: active, onChanged: (v) => setDialogState(() => active = v), contentPadding: EdgeInsets.zero),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
            FilledButton(
              onPressed: urlCtrl.text.trim().isEmpty ? null : () {
                Injection.apiService.orgCreateHook(
                  org: widget.org,
                  body: {
                    'type': 'gitea',
                    'config': {'url': urlCtrl.text.trim(), 'content_type': contentType, 'secret': secretCtrl.text.trim()},
                    'active': active,
                    'events': ['push'],
                  },
                ).then((_) => Navigator.pop(ctx, true)).catchError((_) => Navigator.pop(ctx, false));
              },
              child: Text(l10n.create),
            ),
          ],
        ),
      ),
    );

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.created)));
      _load();
    }
  }

  Future<void> _delete(int id) async {
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
        await Injection.apiService.orgDeleteHook(org: widget.org, id: id);
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
      appBar: AppBar(title: Text(l10n.webhooks)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _create,
        icon: const Icon(Icons.add),
        label: Text(l10n.createWebhook),
      ),
      body: _buildBody(l10n),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Text(_error!), const SizedBox(height: 16), FilledButton(onPressed: _load, child: Text(l10n.retry))]));
    if (_hooks.isEmpty) return EmptyState(icon: Icons.webhook, title: l10n.noData);
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        padding: const EdgeInsets.all(UIConstants.md),
        itemCount: _hooks.length,
        itemBuilder: (context, index) {
          final hook = _hooks[index];
          return FadeInWrapper(
            delay: Duration(milliseconds: index * 30),
            child: Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: UIConstants.sm),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant)),
              child: ListTile(
                leading: Icon(hook.active == true ? Icons.webhook : Icons.webhook_outlined, color: hook.active == true ? Theme.of(context).colorScheme.primary : null),
                title: Text(hook.config?['url']?.toString() ?? '?'),
                subtitle: Text('${hook.type ?? ''}'),
                trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => _delete(hook.id!), tooltip: l10n.delete),
              ),
            ),
          );
        },
      ),
    );
  }
}
