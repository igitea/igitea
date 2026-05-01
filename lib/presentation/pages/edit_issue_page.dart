import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../state/issue_notifier.dart';

class EditIssuePage extends StatefulWidget {
  final String owner;
  final String repo;
  final int index;
  final Issue issue;

  const EditIssuePage({
    super.key,
    required this.owner,
    required this.repo,
    required this.index,
    required this.issue,
  });

  @override
  State<EditIssuePage> createState() => _EditIssuePageState();
}

class _EditIssuePageState extends State<EditIssuePage> {
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;
  late String _state;
  late Set<int> _selectedLabels;
  int? _selectedMilestoneId;
  bool _isSaving = false;
  bool _showPreview = false;
  List<Label> _labels = [];
  List<Milestone> _milestones = [];
  bool _labelsLoading = true;
  bool _milestonesLoading = true;
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.issue.title ?? '');
    _bodyController = TextEditingController(text: widget.issue.body ?? '');
    _state = widget.issue.state?.value ?? 'open';
    _selectedLabels = widget.issue.labels
            ?.map((l) => l.id)
            .whereType<int>()
            .toSet() ??
        {};
    _selectedMilestoneId = widget.issue.milestone?.id;
    _dueDate = widget.issue.due_date;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadLabels();
      _loadMilestones();
    });
  }

  Future<void> _loadLabels() async {
    final result = await _getLabels();
    if (mounted) {
      setState(() {
        _labels = result;
        _labelsLoading = false;
      });
    }
  }

  Future<void> _loadMilestones() async {
    final result = await _getMilestones();
    if (mounted) {
      setState(() {
        _milestones = result;
        _milestonesLoading = false;
      });
    }
  }

  Future<List<Label>> _getLabels() async {
    await Injection.issueNotifier.listLabels(widget.owner, widget.repo);
    final s = Injection.issueNotifier.state;
    if (s is LabelsLoaded) return s.labels;
    return widget.issue.labels ?? [];
  }

  Future<List<Milestone>> _getMilestones() async {
    await Injection.issueNotifier.listMilestones(widget.owner, widget.repo);
    final s = Injection.issueNotifier.state;
    if (s is MilestonesLoaded) return s.milestones;
    return [];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.titleRequired)),
      );
      return;
    }

    setState(() => _isSaving = true);

    final body = <String, dynamic>{
      'title': _titleController.text.trim(),
      'body': _bodyController.text.trim(),
      'state': _state,
      if (_selectedMilestoneId != null)
        'milestone': _selectedMilestoneId,
    };

    await Injection.issueNotifier.editIssue(
      widget.owner,
      widget.repo,
      widget.index,
      body,
    );

    if (mounted) {
      final s = Injection.issueNotifier.state;
      if (s is IssueError) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.error}: ${s.message}')),
        );
        return;
      }
    }

    final labelResult = await Injection.issueNotifier.replaceIssueLabels(
      widget.owner,
      widget.repo,
      widget.index,
      {'labels': _selectedLabels.toList()},
    );

    if (mounted) {
      setState(() => _isSaving = false);
      switch (labelResult) {
        case Left(:final value):
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${l10n.error}: ${value.message}')),
          );
        case Right():
          Navigator.of(context).pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editIssue),
        actions: [
          if (_isSaving)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _save,
              child: Text(l10n.save),
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
                labelText: l10n.title,
                border: const OutlineInputBorder(),
              ),
              maxLines: 1,
            ),
            const SizedBox(height: UIConstants.md),
            _buildStateSelector(l10n),
            const SizedBox(height: UIConstants.md),
            if (!_labelsLoading && _labels.isNotEmpty) ...[
              _buildLabelSection(l10n),
              const SizedBox(height: UIConstants.md),
              _buildDueDateSection(l10n),
              const SizedBox(height: UIConstants.md),
            ],
            if (!_milestonesLoading && _milestones.isNotEmpty) ...[
              _buildMilestoneSection(l10n),
              const SizedBox(height: UIConstants.md),
            ],
            _buildBodySection(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildDueDateSection(AppLocalizations l10n) {
    return Row(
      children: [
        OutlinedButton.icon(
          onPressed: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _dueDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
            );
            if (date != null) {
              final body = {'due_date': date.toIso8601String()};
              await Injection.apiService.issueEditDeadline(
                owner: widget.owner, repo: widget.repo, index: widget.index, body: body,
              );
              setState(() => _dueDate = date);
            }
          },
          icon: const Icon(Icons.calendar_today, size: 18),
          label: Text(_dueDate != null ? '${l10n.setDueDate}: ${_dueDate!.toLocal().toString().split(' ')[0]}' : l10n.setDueDate),
        ),
        if (_dueDate != null) ...[
          const SizedBox(width: UIConstants.sm),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () async {
              await Injection.apiService.issueEditDeadline(
                owner: widget.owner, repo: widget.repo, index: widget.index, body: {'due_date': null},
              );
              setState(() => _dueDate = null);
            },
          ),
        ],
      ],
    );
  }

  Widget _buildLabelSection(AppLocalizations l10n) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.labels, style: theme.textTheme.titleSmall),
        const SizedBox(height: UIConstants.sm),
        Wrap(
          spacing: UIConstants.sm,
          runSpacing: UIConstants.sm,
          children: _labels.map((label) {
            final isSelected = _selectedLabels.contains(label.id);
            final labelColor = _parseColor(label.color);
            return FilterChip(
              label: Text(label.name ?? ''),
              selected: isSelected,
              selectedColor: labelColor?.withValues(alpha: 0.3),
              checkmarkColor: labelColor,
              onSelected: (selected) {
                final id = label.id;
                if (id == null) return;
                setState(() {
                  if (selected) {
                    _selectedLabels.add(id);
                  } else {
                    _selectedLabels.remove(id);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMilestoneSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.milestone, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: UIConstants.sm),
        DropdownButtonFormField<int?>(
          initialValue: _selectedMilestoneId,
          decoration: InputDecoration(
            labelText: l10n.selectMilestone,
            border: const OutlineInputBorder(),
          ),
          items: [
            DropdownMenuItem(
              value: null,
              child: Text(l10n.none),
            ),
            ..._milestones.map((m) => DropdownMenuItem(
              value: m.id,
              child: Text(m.title ?? ''),
            )),
          ],
          onChanged: (value) {
            setState(() => _selectedMilestoneId = value);
          },
        ),
      ],
    );
  }

  Widget _buildBodySection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(l10n.description, style: Theme.of(context).textTheme.titleSmall),
            const Spacer(),
            TextButton(
              onPressed: () => setState(() => _showPreview = !_showPreview),
              child: Text(_showPreview ? l10n.edit : l10n.preview),
            ),
          ],
        ),
        const SizedBox(height: UIConstants.sm),
        if (_showPreview)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(UIConstants.sm),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.outline),
              borderRadius: BorderRadius.circular(UIConstants.chipRadius),
            ),
            child: MarkdownBody(
              data: _bodyController.text.isEmpty
                  ? l10n.noDescriptionProvided
                  : _bodyController.text,
            ),
          )
        else
          TextField(
            controller: _bodyController,
            decoration: InputDecoration(
              hintText: l10n.addComment,
              border: const OutlineInputBorder(),
            ),
            maxLines: 10,
            minLines: 5,
          ),
      ],
    );
  }

  Widget _buildStateSelector(AppLocalizations l10n) {
    return SegmentedButton<String>(
      segments: [
        ButtonSegment(
          value: 'open',
          label: Text(l10n.open),
          icon: const Icon(Icons.error_outline),
        ),
        ButtonSegment(
          value: 'closed',
          label: Text(l10n.closed),
          icon: const Icon(Icons.check_circle),
        ),
      ],
      selected: {_state},
      onSelectionChanged: (selected) {
        setState(() => _state = selected.first);
      },
    );
  }

  Color? _parseColor(String? hex) {
    if (hex == null) return null;
    try {
      return Color(int.parse('FF${hex.replaceFirst('#', '')}', radix: 16));
    } catch (_) {
      return null;
    }
  }
}
