import 'package:flutter/material.dart';

import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../core/utils/either.dart';
import '../../domain/usecases/repo_usecases.dart';
import '../../l10n/app_localizations.dart';

class CreateReviewDialog extends StatefulWidget {
  final String owner;
  final String repo;
  final int index;

  const CreateReviewDialog({
    super.key,
    required this.owner,
    required this.repo,
    required this.index,
  });

  @override
  State<CreateReviewDialog> createState() => _CreateReviewDialogState();
}

class _CreateReviewDialogState extends State<CreateReviewDialog> {
  final _bodyController = TextEditingController();
  String _event = 'COMMENT';
  bool _submitting = false;

  @override
  void dispose() {
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _submitting = true);
    try {
      await Injection.apiService.repoCreatePullReview(
        owner: widget.owner,
        repo: widget.repo,
        index: widget.index,
        body: {
          'body': _bodyController.text.trim(),
          'event': _event,
        },
      );
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        setState(() => _submitting = false);
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
    return AlertDialog(
      title: Text(l10n.reviewChanges),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SegmentedButton<String>(
              segments: [
                ButtonSegment(value: 'COMMENT', label: Text(l10n.comment), icon: const Icon(Icons.comment)),
                ButtonSegment(value: 'APPROVED', label: Text(l10n.approve), icon: const Icon(Icons.check_circle, color: Colors.green)),
                ButtonSegment(value: 'REQUEST_CHANGES', label: Text(l10n.requestChanges), icon: const Icon(Icons.cancel, color: Colors.red)),
              ],
              selected: {_event},
              onSelectionChanged: (v) => setState(() => _event = v.first),
            ),
            const SizedBox(height: UIConstants.md),
            TextField(
              controller: _bodyController,
              decoration: InputDecoration(
                labelText: l10n.reviewBody,
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              minLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.cancel)),
        FilledButton(
          onPressed: _submitting ? null : _submit,
          child: _submitting
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
              : Text(_event == 'APPROVED' ? l10n.approve : _event == 'REQUEST_CHANGES' ? l10n.requestChanges : l10n.comment),
        ),
      ],
    );
  }
}
