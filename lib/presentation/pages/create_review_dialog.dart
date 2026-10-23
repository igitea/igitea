import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
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

    final options = [
      ('COMMENT', l10n.comment, FIcons.messageSquare),
      ('APPROVED', l10n.approve, FIcons.circleCheck),
      ('REQUEST_CHANGES', l10n.requestChanges, FIcons.circleX),
    ];

    return FDialog(
      title: Text(l10n.reviewChanges),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              for (final (value, label, icon) in options)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: FButton(
                      variant: _event == value ? .primary : .outline,
                      size: .sm,
                      prefix: Icon(icon, size: 14),
                      onPress: () => setState(() => _event = value),
                      child: Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(label, maxLines: 1),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: UIConstants.md),
          FTextField(
            control: FTextFieldControl.managed(controller: _bodyController),
            label: Text(l10n.reviewBody),
            maxLines: 5,
            minLines: 3,
            textAlignVertical: TextAlignVertical.top,
          ),
        ],
      ),
      actions: [
        FButton(
          variant: .outline,
          onPress: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FButton(
          onPress: _submitting ? null : _submit,
          child: _submitting
              ? const FCircularProgress(size: .sm)
              : Text(
                  _event == 'APPROVED'
                      ? l10n.approve
                      : _event == 'REQUEST_CHANGES'
                          ? l10n.requestChanges
                          : l10n.comment,
                ),
        ),
      ],
    );
  }
}
