import 'package:flutter/material.dart';

import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../core/utils/either.dart';
import '../../l10n/app_localizations.dart';

class CreateWebhookPage extends StatefulWidget {
  final String owner;
  final String repo;

  const CreateWebhookPage({
    super.key,
    required this.owner,
    required this.repo,
  });

  @override
  State<CreateWebhookPage> createState() => _CreateWebhookPageState();
}

class _CreateWebhookPageState extends State<CreateWebhookPage> {
  late final TextEditingController _urlController;
  late final TextEditingController _secretController;
  String _contentType = 'json';
  final Set<String> _selectedEvents = {};
  bool _active = true;
  bool _isSaving = false;

  static const _availableEvents = [
    'push',
    'pull_request',
    'issues',
    'create',
    'delete',
    'release',
    'wiki',
    'star',
    'fork',
  ];

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController();
    _secretController = TextEditingController();
  }

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
        SnackBar(content: Text(l10n.webhookUrl)),
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

    final result = await Injection.repoNotifier.createHook(
      widget.owner,
      widget.repo,
      body,
    );

    if (mounted) {
      setState(() => _isSaving = false);
      switch (result) {
        case Left(:final value):
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${l10n.error}: ${value.message}')),
          );
        case Right():
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.created)),
          );
          Navigator.of(context).pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.createWebhook),
        actions: [
          IconButton(
            icon: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save),
            onPressed: _isSaving ? null : _save,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(UIConstants.md),
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
            const SizedBox(height: UIConstants.md),
            TextField(
              controller: _secretController,
              decoration: InputDecoration(
                labelText: l10n.webhookSecret,
                hintText: l10n.webhookSecretHint,
                border: const OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: UIConstants.md),
            DropdownButtonFormField<String>(
              initialValue: _contentType,
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
              onChanged: (v) => setState(() => _contentType = v ?? 'json'),
            ),
            const SizedBox(height: UIConstants.md),
            SwitchListTile(
              title: Text(l10n.webhookActive),
              value: _active,
              onChanged: (v) => setState(() => _active = v),
            ),
            const SizedBox(height: UIConstants.sm),
            Text(
              l10n.webhookEvents,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: UIConstants.sm),
            ..._availableEvents.map((event) => CheckboxListTile(
              title: Text(_eventLabel(event, l10n)),
              value: _selectedEvents.contains(event),
              onChanged: (v) {
                setState(() {
                  if (v == true) {
                    _selectedEvents.add(event);
                  } else {
                    _selectedEvents.remove(event);
                  }
                });
              },
              controlAffinity: ListTileControlAffinity.trailing,
              dense: true,
            )),
          ],
        ),
      ),
    );
  }

  String _eventLabel(String event, AppLocalizations l10n) {
    return switch (event) {
      'push' => l10n.webhookPushEvents,
      'pull_request' => l10n.webhookPullRequestEvents,
      'issues' => l10n.webhookIssuesEvents,
      'create' => l10n.webhookCreateEvents,
      'delete' => l10n.webhookDeleteEvents,
      'release' => l10n.webhookReleaseEvents,
      'wiki' => l10n.webhookWikiEvents,
      'star' => l10n.webhookStarEvents,
      'fork' => l10n.webhookForkEvents,
      _ => event,
    };
  }
}
