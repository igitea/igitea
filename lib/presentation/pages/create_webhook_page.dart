import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/forui/app_page.dart';

class CreateWebhookPage extends StatefulWidget {
  final String owner;
  final String repo;
  final Hook? hook;

  const CreateWebhookPage({
    super.key,
    required this.owner,
    required this.repo,
    this.hook,
  });

  @override
  State<CreateWebhookPage> createState() => _CreateWebhookPageState();
}

class _CreateWebhookPageState extends State<CreateWebhookPage> {
  late final TextEditingController _urlController;
  late final TextEditingController _secretController;
  String _contentType = 'json';
  Set<String> _selectedEvents = {};
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
    final h = widget.hook;
    _urlController = TextEditingController(
      text: h?.config?['url']?.toString() ?? '',
    );
    _secretController = TextEditingController();
    _contentType = h?.config?['content_type']?.toString() ?? 'json';
    _selectedEvents = Set.from(h?.events ?? ['push']);
    _active = h?.active ?? true;
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
      showFToast(context: context, title: Text(l10n.webhookUrl));
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

    final result = widget.hook != null
        ? await Injection.repoNotifier.editHook(
            widget.owner,
            widget.repo,
            widget.hook!.id ?? 0,
            body,
          )
        : await Injection.repoNotifier.createHook(
            widget.owner,
            widget.repo,
            body,
          );

    if (mounted) {
      setState(() => _isSaving = false);
      switch (result) {
        case Left(:final value):
          showFToast(
            context: context,
            variant: .destructive,
            title: Text('${l10n.error}: ${value.message}'),
          );
        case Right():
          showFToast(context: context, title: Text(l10n.created));
          Navigator.of(context).pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppPage(
      title: widget.hook != null ? l10n.editWebhook : l10n.createWebhook,
      actions: [
        FHeaderAction(
          icon: _isSaving
              ? const FCircularProgress(size: .xs)
              : const Icon(FIcons.save),
          onPress: _isSaving ? null : _save,
        ),
      ],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(UIConstants.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FTextField(
              control: FTextFieldControl.managed(controller: _urlController),
              label: Text(l10n.webhookUrl),
              hint: l10n.webhookUrlHint,
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: UIConstants.md),
            FTextField(
              control: FTextFieldControl.managed(controller: _secretController),
              label: Text(l10n.webhookSecret),
              hint: l10n.webhookSecretHint,
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
            FCard.raw(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                child: FSwitch(
                  label: Text(l10n.webhookActive),
                  value: _active,
                  onChange: (v) => setState(() => _active = v),
                ),
              ),
            ),
            const SizedBox(height: UIConstants.sm),
            Text(
              l10n.webhookEvents,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: UIConstants.sm),
            ..._availableEvents.map(
              (event) => Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: FCheckbox(
                  label: Text(_eventLabel(event, l10n)),
                  value: _selectedEvents.contains(event),
                  onChange: (v) {
                    setState(() {
                      if (v == true) {
                        _selectedEvents.add(event);
                      } else {
                        _selectedEvents.remove(event);
                      }
                    });
                  },
                ),
              ),
            ),
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
