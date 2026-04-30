import 'package:flutter/material.dart';

import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../core/utils/either.dart';
import '../../l10n/app_localizations.dart';

class CreateMilestonePage extends StatefulWidget {
  final String owner;
  final String repo;

  const CreateMilestonePage({
    super.key,
    required this.owner,
    required this.repo,
  });

  @override
  State<CreateMilestonePage> createState() => _CreateMilestonePageState();
}

class _CreateMilestonePageState extends State<CreateMilestonePage> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  DateTime? _dueDate;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
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
      firstDate: DateTime.now(),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.titleRequired)),
      );
      return;
    }

    setState(() => _isSaving = true);

    final body = <String, dynamic>{
      'title': title,
      if (_descriptionController.text.trim().isNotEmpty)
        'description': _descriptionController.text.trim(),
      if (_dueDate != null)
        'due_on': _dueDate!.toIso8601String(),
    };

    final result = await Injection.issueNotifier.createMilestone(
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
        title: Text(l10n.createMilestone),
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
              controller: _titleController,
              decoration: InputDecoration(
                labelText: l10n.milestoneTitle,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: UIConstants.md),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: l10n.milestoneDescription,
                hintText: l10n.milestoneDescriptionHint,
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              keyboardType: TextInputType.multiline,
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
          child: OutlinedButton.icon(
            onPressed: _pickDueDate,
            icon: const Icon(Icons.calendar_today),
            label: Text(
              _dueDate != null
                  ? _formatDate(_dueDate!)
                  : l10n.milestoneDueDate,
            ),
          ),
        ),
        if (_dueDate != null) ...[
          const SizedBox(width: UIConstants.sm),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () => setState(() => _dueDate = null),
            tooltip: l10n.clear,
          ),
        ],
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
