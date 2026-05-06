import 'package:flutter/material.dart';

import '../../core/di/injection.dart';
import '../../l10n/app_localizations.dart';

class CreateAdminWebhookPage extends StatefulWidget {
  const CreateAdminWebhookPage({super.key});

  @override
  State<CreateAdminWebhookPage> createState() => _CreateAdminWebhookPageState();
}

class _CreateAdminWebhookPageState extends State<CreateAdminWebhookPage> {
  final _urlController = TextEditingController();
  final _secretController = TextEditingController();
  String _contentType = 'json';
  final _selectedEvents = <String>{'push'};
  bool _active = true;
  bool _isSaving = false;

  static const _availableEvents = [
    'push', 'pull_request', 'issues', 'create', 'delete',
    'release', 'wiki', 'star', 'fork',
  ];

  @override
  void dispose() {
    _urlController.dispose();
    _secretController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    final url = _urlController.text.trim();
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.webhookUrlHint)),
      );
      return;
    }

    setState(() => _isSaving = true);

    final body = <String, dynamic>{
      'type': 'gitea',
      'active': _active,
      'events': _selectedEvents.toList(),
      'config': {
        'url': url,
        'content_type': _contentType,
        if (_secretController.text.trim().isNotEmpty)
          'secret': _secretController.text.trim(),
      },
    };

    final result = await Injection.adminNotifier.createHook(body);
    if (!mounted) return;

    setState(() => _isSaving = false);

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.created)),
      );
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l10n.error}: ${l10n.unknownError}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.createWebhook),
        actions: [
          if (_isSaving)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: 20, height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _save,
              child: Text(l10n.save),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: l10n.webhookUrl,
                hintText: l10n.webhookUrlHint,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _secretController,
              decoration: InputDecoration(
                labelText: l10n.webhookSecret,
                hintText: l10n.webhookSecretHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _contentType,
              decoration: InputDecoration(
                labelText: l10n.webhookContentType,
                border: const OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(
                  value: 'json',
                  child: Text(l10n.webhookContentTypeJson),
                ),
                DropdownMenuItem(
                  value: 'form',
                  child: Text(l10n.webhookContentTypeForm),
                ),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _contentType = v);
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: Text(l10n.webhookActive),
              value: _active,
              onChanged: (v) => setState(() => _active = v),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.webhookEvents,
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ..._availableEvents.map((event) {
              final eventLabels = {
                'push': l10n.webhookPushEvents,
                'pull_request': l10n.webhookPullRequestEvents,
                'issues': l10n.webhookIssuesEvents,
                'create': l10n.webhookCreateEvents,
                'delete': l10n.webhookDeleteEvents,
                'release': l10n.webhookReleaseEvents,
                'wiki': l10n.webhookWikiEvents,
                'star': l10n.webhookStarEvents,
                'fork': l10n.webhookForkEvents,
              };
              return CheckboxListTile(
                title: Text(eventLabels[event] ?? event),
                value: _selectedEvents.contains(event),
                onChanged: (checked) {
                  setState(() {
                    if (checked == true) {
                      _selectedEvents.add(event);
                    } else {
                      _selectedEvents.remove(event);
                    }
                  });
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
