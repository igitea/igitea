import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../state/issue_notifier.dart';
import '../widgets/forui/app_page.dart';

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
  final Set<int> _selectedLabels = {};
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
    return AppPage(
      title: l10n.newIssue,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FTextFormField(
              control: FTextFieldControl.managed(controller: _titleController),
              label: Text(l10n.title),
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.requiredField;
                }
                return null;
              },
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
            FTextField(
              control: FTextFieldControl.managed(controller: _bodyController),
              label: Text(l10n.body),
              maxLines: 10,
              minLines: 5,
              textAlignVertical: TextAlignVertical.top,
            ),
            const SizedBox(height: UIConstants.lg),
            FButton(
              onPress: _isLoading ? null : _submit,
              child: _isLoading
                  ? const FCircularProgress(size: .sm)
                  : Text(l10n.submit),
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
            final isSelected = _selectedLabels.contains(label.id);
            final labelColor = _parseColor(label.color);
            return FButton(
              variant: isSelected ? .primary : .outline,
              size: .xs,
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
              prefix: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: labelColor ?? theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
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

  void _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      showFToast(
        context: context,
        variant: .destructive,
        title: Text(l10n.pleaseEnterTitle),
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
        'labels': <int>[],
      if (_selectedMilestoneId != null) 'milestone': _selectedMilestoneId,
    };

    await Injection.issueNotifier.createIssue(widget.owner, widget.repo, body);

    if (mounted) {
      setState(() => _isLoading = false);
      final s = Injection.issueNotifier.state;
      if (s is IssueDetailLoaded) {
        Navigator.of(context).pop(s.issue);
      } else if (s is IssueError) {
        showFToast(
          context: context,
          variant: .destructive,
          title: Text('${l10n.error}: ${s.message}'),
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
