import 'package:flutter/material.dart';
import '../../core/animations/animated_wrapper.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';

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
      final result = await Injection.apiService.userCurrentListKeys();
      if (mounted) {
        setState(() {
          _keys = result;
          _loading = false;
        });
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Key'),
        content: Text('Are you sure you want to delete this SSH key?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await Injection.apiService.userCurrentDeleteKey(id: id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Key deleted successfully')),
        );
        _loadKeys();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.error}: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.sshKeys),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddKeyDialog(),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${l10n.error}: $_error'),
                      const SizedBox(height: UIConstants.md),
                      FilledButton(
                        onPressed: _loadKeys,
                        child: Text(l10n.retry),
                      ),
                    ],
                  ),
                )
              : _keys.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.key_outlined,
                            size: 64,
                            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No SSH keys found',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 8),
                          FilledButton.icon(
                            onPressed: () => _showAddKeyDialog(),
                            icon: const Icon(Icons.add),
                            label: Text('Add SSH Key'),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadKeys,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(UIConstants.md),
                        itemCount: _keys.length,
                        itemBuilder: (context, index) {
                          final key = _keys[index];
                          return FadeInWrapper(
                            delay: Duration(milliseconds: index * 30),
                            child: Card(
                              margin: const EdgeInsets.only(bottom: UIConstants.md),
                              child: Padding(
                                padding: const EdgeInsets.all(UIConstants.md),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            key.title ?? l10n.untitled,
                                            style: theme.textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline),
                                          onPressed: key.id != null
                                              ? () => _deleteKey(key.id!)
                                              : null,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: UIConstants.sm),
                                    Text(
                                      key.fingerprint ?? '',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: theme.colorScheme.onSurfaceVariant,
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                    if (key.created_at != null) ...[
                                      const SizedBox(height: UIConstants.sm),
                                      Text(
                                        '${'Created'}: ${_formatDate(key.created_at!)}',
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }

  Future<void> _showAddKeyDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final titleController = TextEditingController();
    final keyController = TextEditingController();

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add SSH Key'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                hintText: 'My Laptop',
              ),
            ),
            const SizedBox(height: UIConstants.md),
            TextField(
              controller: keyController,
              decoration: InputDecoration(
                labelText: 'Public Key',
                hintText: 'Paste your SSH public key here',
              ),
              maxLines: 5,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              if (titleController.text.isNotEmpty &&
                  keyController.text.isNotEmpty) {
                Navigator.pop(context, {
                  'title': titleController.text,
                  'key': keyController.text,
                });
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );

    if (result != null) {
      try {
        await Injection.apiService.userCurrentPostKey(body: {
          'title': result['title'],
          'key': result['key'],
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Key added successfully')),
          );
          _loadKeys();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${l10n.error}: $e')),
          );
        }
      }
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 365) return '${diff.inDays ~/ 365}y ago';
    if (diff.inDays > 30) return '${diff.inDays ~/ 30}mo ago';
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    return 'just now';
  }
}
