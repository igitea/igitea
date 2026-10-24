import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../core/di/injection.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/forui/app_page.dart';

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
  void dispose() {
    _urlController.dispose();
    _secretController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    final url = _urlController.text.trim();
    if (url.isEmpty) {
      showFToast(context: context, title: Text(l10n.webhookUrlHint));
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
      showFToast(context: context, title: Text(l10n.created));
      Navigator.of(context).pop(true);
    } else {
      showFToast(
        context: context,
        variant: .destructive,
        title: Text('${l10n.error}: ${l10n.unknownError}'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AppPage(
      maxContentWidth: 760,
      title: l10n.createWebhook,
      actions: [
        FHeaderAction(
          icon: _isSaving
              ? const FCircularProgress(size: .xs)
              : const Icon(FIcons.save),
          onPress: _isSaving ? null : _save,
        ),
      ],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FTextField(
              control: FTextFieldControl.managed(controller: _urlController),
              label: Text(l10n.webhookUrl),
              hint: l10n.webhookUrlHint,
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 16),
            FTextField(
              control: FTextFieldControl.managed(controller: _secretController),
              label: Text(l10n.webhookSecret),
              hint: l10n.webhookSecretHint,
            ),
            const SizedBox(height: 16),
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
              onChanged: (v) {
                if (v != null) setState(() => _contentType = v);
              },
            ),
            const SizedBox(height: 16),
            FCard.raw(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 2,
                ),
                child: FSwitch(
                  label: Text(l10n.webhookActive),
                  value: _active,
                  onChange: (v) => setState(() => _active = v),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.webhookEvents,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
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
              return Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: FCheckbox(
                  label: Text(eventLabels[event] ?? event),
                  value: _selectedEvents.contains(event),
                  onChange: (checked) {
                    setState(() {
                      if (checked == true) {
                        _selectedEvents.add(event);
                      } else {
                        _selectedEvents.remove(event);
                      }
                    });
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
