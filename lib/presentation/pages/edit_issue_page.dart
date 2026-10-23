import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../state/issue_notifier.dart';
import '../widgets/forui/app_page.dart';

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
    _selectedLabels =
        widget.issue.labels?.map((l) => l.id).whereType<int>().toSet() ?? {};
    _selectedMilestoneId = widget.issue.milestone?.id;
    _dueDate = widget.issue.due_date;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadLabels();
      await _loadMilestones();
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
      showFToast(context: context, title: Text(l10n.titleRequired));
      return;
    }

    setState(() => _isSaving = true);

    final body = <String, dynamic>{
      'title': _titleController.text.trim(),
      'body': _bodyController.text.trim(),
      'state': _state,
      if (_selectedMilestoneId != null) 'milestone': _selectedMilestoneId,
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
        showFToast(
          context: context,
          variant: .destructive,
          title: Text('${l10n.error}: ${s.message}'),
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
          showFToast(context: context, title: Text('${l10n.error}: ${value.message}'));
        case Right():
          Navigator.of(context).pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppPage(
      title: l10n.editIssue,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FTextFormField(
              control: FTextFieldControl.managed(controller: _titleController),
              label: Text(l10n.title),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.requiredField;
                }
                return null;
              },
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
            const SizedBox(height: UIConstants.lg),
            FButton(
              onPress: _isSaving ? null : _save,
              child: _isSaving
                  ? const FCircularProgress(size: .sm)
                  : Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDueDateSection(AppLocalizations l10n) {
    return Row(
      children: [
        FButton(
          variant: .outline,
          prefix: const Icon(FIcons.calendar, size: 16),
          onPress: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _dueDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
            );
            if (date != null) {
              final body = {'due_date': date.toIso8601String()};
              await Injection.apiService.issueEditDeadline(
                owner: widget.owner,
                repo: widget.repo,
                index: widget.index,
                body: body,
              );
              setState(() => _dueDate = date);
            }
          },
          child: Text(
            _dueDate != null
                ? '${l10n.setDueDate}: ${_dueDate!.toLocal().toString().split(' ')[0]}'
                : l10n.setDueDate,
          ),
        ),
        if (_dueDate != null) ...[
          const SizedBox(width: UIConstants.sm),
          FTappable(
            onPress: () async {
              await Injection.apiService.issueEditDeadline(
                owner: widget.owner,
                repo: widget.repo,
                index: widget.index,
                body: {'due_date': null},
              );
              setState(() => _dueDate = null);
            },
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(FIcons.x, size: 16),
            ),
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
            return FButton(
              variant: isSelected ? .primary : .outline,
              size: .xs,
              prefix: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: labelColor ?? theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
              onPress: () {
                final id = label.id;
                if (id == null) return;
                setState(() {
                  if (isSelected) {
                    _selectedLabels.remove(id);
                  } else {
                    _selectedLabels.add(id);
                  }
                });
              },
              child: Text(label.name ?? ''),
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
            DropdownMenuItem(value: null, child: Text(l10n.none)),
            ..._milestones.map(
              (m) => DropdownMenuItem(value: m.id, child: Text(m.title ?? '')),
            ),
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
            Text(
              l10n.description,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const Spacer(),
            FButton(
              variant: .ghost,
              size: .xs,
              onPress: () => setState(() => _showPreview = !_showPreview),
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
          FTextField(
            control: FTextFieldControl.managed(controller: _bodyController),
            label: Text(l10n.description),
            hint: l10n.addComment,
            maxLines: 10,
            minLines: 5,
            textAlignVertical: TextAlignVertical.top,
          ),
      ],
    );
  }

  Widget _buildStateSelector(AppLocalizations l10n) {
    final options = [
      ('open', l10n.open, FIcons.circleDot),
      ('closed', l10n.closed, FIcons.circleCheck),
    ];

    return Row(
      children: [
        for (final (value, label, icon) in options)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: FButton(
                variant: _state == value ? .primary : .outline,
                size: .sm,
                prefix: Icon(icon, size: 14),
                onPress: () => setState(() => _state = value),
                child: Text(label),
              ),
            ),
          ),
      ],
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
