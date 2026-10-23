import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
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
        showFToast(
          context: context,
          variant: .destructive,
          title: Text('${l10n.error}: $e'),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FDialog(
      title: Text(l10n.requestReviewers),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: FTextField(
                  control: FTextFieldControl.managed(controller: _controller),
                  hint: l10n.addReviewerHint,
                  textInputAction: TextInputAction.done,
                  onSubmit: (v) {
                    if (v.trim().isNotEmpty) {
                      setState(() {
                        _reviewers.add(v.trim());
                        _controller.clear();
                      });
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              FTappable(
                onPress: () {
                  if (_controller.text.trim().isNotEmpty) {
                    setState(() {
                      _reviewers.add(_controller.text.trim());
                      _controller.clear();
                    });
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(FIcons.plus, size: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _reviewers
                  .map(
                    (r) => FBadge(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(r),
                          const SizedBox(width: 4),
                          FTappable(
                            onPress: () => setState(() => _reviewers.remove(r)),
                            child: const Icon(FIcons.x, size: 12),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
      actions: [
        FButton(
          variant: .outline,
          onPress: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FButton(
          onPress: _submitting || _reviewers.isEmpty ? null : _submit,
          child: _submitting
              ? const FCircularProgress(size: .sm)
              : Text(l10n.requestReviewers),
        ),
      ],
    );
  }
}
