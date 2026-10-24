import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/forui/app_page.dart';

class EditMilestonePage extends StatefulWidget {
  final String owner;
  final String repo;
  final Milestone milestone;

  const EditMilestonePage({
    super.key,
    required this.owner,
    required this.repo,
    required this.milestone,
  });

  @override
  State<EditMilestonePage> createState() => _EditMilestonePageState();
}

class _EditMilestonePageState extends State<EditMilestonePage> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  DateTime? _dueDate;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.milestone.title ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.milestone.description ?? '',
    );
    _dueDate = widget.milestone.due_on;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (date != null) {
      setState(() => _dueDate = date);
    }
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    final title = _titleController.text.trim();

    if (title.isEmpty) {
      showFToast(
        context: context,
        variant: .destructive,
        title: Text(l10n.titleRequired),
      );
      return;
    }

    setState(() => _isSaving = true);

    final body = <String, dynamic>{
      'title': title,
      if (_descriptionController.text.trim().isNotEmpty)
        'description': _descriptionController.text.trim(),
      if (_dueDate != null) 'due_on': _formatDueDate(_dueDate!),
    };

    final result = await Injection.issueNotifier.editMilestone(
      widget.owner,
      widget.repo,
      widget.milestone.id.toString(),
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
          showFToast(context: context, title: Text(l10n.saved));
          Navigator.of(context).pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppPage(
      maxContentWidth: 760,
      title: l10n.editMilestone,
      actions: [
        if (_isSaving)
          const Padding(
            padding: EdgeInsets.all(8),
            child: FCircularProgress(size: .sm),
          )
        else
          FHeaderAction(
            icon: const Icon(FIcons.save),
            semanticsLabel: l10n.save,
            onPress: _save,
          ),
      ],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(UIConstants.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FTextFormField(
              control: FTextFieldControl.managed(controller: _titleController),
              label: Text(l10n.milestoneTitle),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.titleRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: UIConstants.md),
            FTextField(
              control: FTextFieldControl.managed(
                controller: _descriptionController,
              ),
              label: Text(l10n.milestoneDescription),
              hint: l10n.milestoneDescriptionHint,
              maxLines: 5,
              minLines: 3,
            ),
            const SizedBox(height: UIConstants.md),
            _buildDueDateRow(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildDueDateRow(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: FButton(
            variant: .outline,
            prefix: const Icon(FIcons.calendar, size: 16),
            onPress: _pickDueDate,
            child: Text(
              _dueDate != null ? _formatDate(_dueDate!) : l10n.milestoneDueDate,
            ),
          ),
        ),
        if (_dueDate != null) ...[
          const SizedBox(width: UIConstants.sm),
          FTappable(
            semanticsLabel: l10n.clear,
            onPress: () => setState(() => _dueDate = null),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(FIcons.x, size: 16),
            ),
          ),
        ],
      ],
    );
  }

  String _formatDueDate(DateTime d) {
    final offset = d.timeZoneOffset;
    final sign = offset.isNegative ? '-' : '+';
    final h = offset.inHours.abs().toString().padLeft(2, '0');
    final m = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}T'
        '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}:${d.second.toString().padLeft(2, '0')}$sign$h:$m';
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
