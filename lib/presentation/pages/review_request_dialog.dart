import 'package:flutter/material.dart';
import '../../core/di/injection.dart';
import '../../l10n/app_localizations.dart';

class ReviewRequestDialog extends StatefulWidget {
  final String owner;
  final String repo;
  final int index;

  const ReviewRequestDialog({super.key, required this.owner, required this.repo, required this.index});

  @override
  State<ReviewRequestDialog> createState() => _ReviewRequestDialogState();
}

class _ReviewRequestDialogState extends State<ReviewRequestDialog> {
  final _controller = TextEditingController();
  final _reviewers = <String>[];
  bool _submitting = false;

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    if (_reviewers.isEmpty) return;
    setState(() => _submitting = true);
    try {
      await Injection.apiService.repoCreatePullReviewRequests(
        owner: widget.owner, repo: widget.repo, index: widget.index,
        body: {'requested_reviewers': _reviewers},
      );
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        setState(() => _submitting = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${l10n.error}: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.requestReviewers),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: l10n.addReviewerHint,
                    border: const OutlineInputBorder(),
                    isDense: true,
                  ),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (v) {
                    if (v.trim().isNotEmpty) {
                      setState(() { _reviewers.add(v.trim()); _controller.clear(); });
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  if (_controller.text.trim().isNotEmpty) {
                    setState(() { _reviewers.add(_controller.text.trim()); _controller.clear(); });
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: _reviewers.map((r) => Chip(
              label: Text(r, style: const TextStyle(fontSize: 12)),
              onDeleted: () => setState(() => _reviewers.remove(r)),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            )).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
        FilledButton(
          onPressed: _submitting || _reviewers.isEmpty ? null : _submit,
          child: _submitting
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
              : Text(l10n.requestReviewers),
        ),
      ],
    );
  }
}
