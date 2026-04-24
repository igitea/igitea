import 'package:flutter/material.dart';

import '../../core/di/injection.dart';
import '../../l10n/app_localizations.dart';
import '../../presentation/state/issue_notifier.dart';

class CreateIssuePage extends StatefulWidget {
  final String owner;
  final String repo;

  const CreateIssuePage({super.key, required this.owner, required this.repo});

  @override
  State<CreateIssuePage> createState() => _CreateIssuePageState();
}

class _CreateIssuePageState extends State<CreateIssuePage> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.newIssue),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            TextButton(
              onPressed: _submit,
              child: Text(l10n.submit),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: l10n.title,
                border: const OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _bodyController,
                decoration: InputDecoration(
                  labelText: l10n.body,
                  border: const OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pleaseEnterTitle)),
      );
      return;
    }

    setState(() => _isLoading = true);

    await Injection.issueNotifier.createIssue(
      widget.owner,
      widget.repo,
      {
        'title': title,
        'body': _bodyController.text.trim(),
      },
    );

    if (mounted) {
      setState(() => _isLoading = false);

      final state = Injection.issueNotifier.state;
      if (state is IssueDetailLoaded) {
        Navigator.of(context).pop(state.issue);
      } else if (state is IssueError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.error}: ${state.message}')),
        );
      }
    }
  }
}