import 'package:flutter/material.dart';

import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../state/issue_notifier.dart';

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
  Set<String> _selectedLabels = {};
  int? _selectedMilestoneId;
  List<Label> _labels = [];
  List<Milestone> _milestones = [];
  bool _labelsLoading = true;
  bool _milestonesLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadLabels();
      _loadMilestones();
    });
  }

  Future<void> _loadLabels() async {
    await Injection.issueNotifier.listLabels(widget.owner, widget.repo);
    final s = Injection.issueNotifier.state;
    if (mounted) {
      setState(() {
        _labels = s is LabelsLoaded ? s.labels : [];
        _labelsLoading = false;
      });
    }
  }

  Future<void> _loadMilestones() async {
    await Injection.issueNotifier.listMilestones(widget.owner, widget.repo);
    final s = Injection.issueNotifier.state;
    if (mounted) {
      setState(() {
        _milestones = s is MilestonesLoaded ? s.milestones : [];
        _milestonesLoading = false;
      });
    }
  }

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(UIConstants.md),
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
            const SizedBox(height: UIConstants.md),
            if (!_labelsLoading && _labels.isNotEmpty) ...[
              _buildLabelSection(l10n),
              const SizedBox(height: UIConstants.md),
            ],
            if (!_milestonesLoading && _milestones.isNotEmpty) ...[
              _buildMilestoneSection(l10n),
              const SizedBox(height: UIConstants.md),
            ],
            TextField(
              controller: _bodyController,
              decoration: InputDecoration(
                labelText: l10n.body,
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 10,
              minLines: 5,
              textAlignVertical: TextAlignVertical.top,
            ),
          ],
        ),
      ),
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
            final isSelected = _selectedLabels.contains(label.name);
            final labelColor = _parseColor(label.color);
            return FilterChip(
              label: Text(label.name ?? ''),
              selected: isSelected,
              selectedColor: labelColor?.withValues(alpha: 0.3),
              checkmarkColor: labelColor,
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
          value: _selectedMilestoneId,
          decoration: InputDecoration(
            labelText: l10n.selectMilestone,
            border: const OutlineInputBorder(),
          ),
          items: [
            const DropdownMenuItem(value: null, child: Text('None')),
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

    final body = <String, dynamic>{
      'title': title,
      'body': _bodyController.text.trim(),
      if (_selectedLabels.isNotEmpty)
        'labels': _selectedLabels.toList()
      else
        'labels': [],
      if (_selectedMilestoneId != null)
        'milestone': _selectedMilestoneId,
    };

    await Injection.issueNotifier.createIssue(
      widget.owner,
      widget.repo,
      body,
    );

    if (mounted) {
      setState(() => _isLoading = false);
      final s = Injection.issueNotifier.state;
      if (s is IssueDetailLoaded) {
        Navigator.of(context).pop(s.issue);
      } else if (s is IssueError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.error}: ${s.message}')),
        );
      }
    }
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
