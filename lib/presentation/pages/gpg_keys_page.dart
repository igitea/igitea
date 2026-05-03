import 'package:flutter/material.dart';

import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/empty_state.dart';

class GpgKeysPage extends StatefulWidget {
  const GpgKeysPage({super.key});

  @override
  State<GpgKeysPage> createState() => _GpgKeysPageState();
}

class _GpgKeysPageState extends State<GpgKeysPage> {
  List<GPGKey> _keys = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      _keys = await Injection.apiService.userCurrentListGPGKeys();
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _add() async {
    final l10n = AppLocalizations.of(context)!;
    final ctrl = TextEditingController();
    final key = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.addGpgKey),
        content: TextField(
          controller: ctrl,
          decoration: InputDecoration(
            hintText: l10n.gpgKeyHint,
            border: const OutlineInputBorder(),
          ),
          maxLines: 6,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
          FilledButton(
            onPressed: ctrl.text.trim().isEmpty ? null : () => Navigator.pop(ctx, ctrl.text.trim()),
            child: Text(l10n.add),
          ),
        ],
      ),
    );
    if (key != null && mounted) {
      try {
        await Injection.apiService.userCurrentPostGPGKey(armoredPublicKey: key);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.gpgKeyAdded)));
          _load();
        }
      } catch (_) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.error)));
      }
    }
  }

  Future<void> _delete(GPGKey gpgKey) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteGpgKey),
        content: Text(l10n.deleteGpgKeyConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.delete)),
        ],
      ),
    );
    if (ok == true && gpgKey.id != null && mounted) {
      try {
        await Injection.apiService.userCurrentDeleteGPGKey(id: gpgKey.id!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.gpgKeyDeleted)));
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
      appBar: AppBar(title: Text(l10n.gpgKeys)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.add),
        label: Text(l10n.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _keys.isEmpty
              ? EmptyState(icon: Icons.vpn_key_outlined, title: l10n.noGpgKeys)
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(UIConstants.md),
                    itemCount: _keys.length,
                    itemBuilder: (context, index) {
                      final key = _keys[index];
                      return Card(
                        elevation: 0,
                        margin: const EdgeInsets.only(bottom: UIConstants.sm),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: theme.colorScheme.outlineVariant),
                        ),
                        child: ExpansionTile(
                          leading: Icon(Icons.vpn_key, color: theme.colorScheme.primary),
                          title: Text(
                            key.key_id ?? l10n.unknown,
                            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Row(
                            children: [
                              if (key.can_sign == true)
                                _Badge(label: l10n.sign, color: Colors.blue),
                              if (key.can_certify == true) ...[
                                const SizedBox(width: 4),
                                _Badge(label: l10n.certify, color: Colors.purple),
                              ],
                              if (key.verified == true) ...[
                                const SizedBox(width: 4),
                                _Badge(label: l10n.verified, color: Colors.green),
                              ],
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => _delete(key),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              child: SelectableText(
                                key.public_key ?? '',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontFamily: 'monospace',
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
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
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}
