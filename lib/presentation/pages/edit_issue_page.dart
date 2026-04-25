import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../core/di/injection.dart';
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
  late Set<String> _selectedLabels;
  int? _selectedMilestoneId;
  bool _isSaving = false;
  bool _showPreview = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.issue.title ?? '');
    _bodyController = TextEditingController(text: widget.issue.body ?? '');
    _state = widget.issue.state?.value ?? 'open';
    _selectedLabels = widget.issue.labels
            ?.map((l) => l.name ?? '')
            .where((n) => n.isNotEmpty)
            .toSet() ??
        {};
    _selectedMilestoneId = widget.issue.milestone?.id;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Injection.issueNotifier.listLabels(widget.owner, widget.repo);
      Injection.issueNotifier.listMilestones(widget.owner, widget.repo);
    });
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
      if (_selectedLabels.isNotEmpty)
        'labels': _selectedLabels.toList()
      else
        'labels': [],
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
      setState(() => _isSaving = false);
      final state = Injection.issueNotifier.state;
      if (state is IssueError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.error}: ${state.message}')),
        );
      } else {
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
      body: ListenableBuilder(
        listenable: Injection.issueNotifier,
        builder: (context, _) {
          final state = Injection.issueNotifier.state;
          final labels = state is LabelsLoaded ? state.labels : <Label>[];
          final milestones =
              state is MilestonesLoaded ? state.milestones : <Milestone>[];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
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
                const SizedBox(height: 16),
                _buildStateSelector(l10n),
                const SizedBox(height: 16),
                if (labels.isNotEmpty) ...[
                  Text(l10n.labels, style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: labels.map((label) {
                      final isSelected = _selectedLabels.contains(label.name);
                      return FilterChip(
                        label: Text(label.name ?? ''),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedLabels.add(label.name!);
                            } else {
                              _selectedLabels.remove(label.name);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],
                if (milestones.isNotEmpty) ...[
                  Text(l10n.milestone, style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int?>(
                    value: _selectedMilestoneId,
                    decoration: InputDecoration(
                      labelText: l10n.selectMilestone,
                      border: const OutlineInputBorder(),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('None'),
                      ),
                      ...milestones.map((m) => DropdownMenuItem(
                        value: m.id,
                        child: Text(m.title ?? ''),
                      )),
                    ],
                    onChanged: (value) {
                      setState(() => _selectedMilestoneId = value);
                    },
                  ),
                  const SizedBox(height: 16),
                ],
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
                const SizedBox(height: 8),
                if (_showPreview)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).colorScheme.outline),
                      borderRadius: BorderRadius.circular(8),
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
            ),
          );
        },
      ),
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
}
