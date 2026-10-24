import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../state/issue_notifier.dart';
import '../theme/app_palette.dart';
import '../widgets/app_surface.dart';
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
      maxContentWidth: 760,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppSurface(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  FTextFormField(
                    control: FTextFieldControl.managed(
                      controller: _titleController,
                    ),
                    label: Text(l10n.title),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.requiredField;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                  FTextField(
                    control: FTextFieldControl.managed(
                      controller: _bodyController,
                    ),
                    label: Text(l10n.body),
                    maxLines: 10,
                    minLines: 6,
                    textAlignVertical: TextAlignVertical.top,
                  ),
                ],
              ),
            ),
            if (!_labelsLoading && _labels.isNotEmpty) ...[
              const SizedBox(height: 16),
              AppSurface(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: _buildLabelSection(l10n),
              ),
            ],
            if (!_milestonesLoading && _milestones.isNotEmpty) ...[
              const SizedBox(height: 16),
              AppSurface(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: _buildMilestoneSection(l10n),
              ),
            ],
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FButton(
                  variant: .outline,
                  onPress: _isLoading ? null : () => Navigator.pop(context),
                  child: Text(l10n.cancel),
                ),
                const SizedBox(width: 10),
                FButton(
                  onPress: _isLoading ? null : _submit,
                  prefix: _isLoading
                      ? const FCircularProgress(size: .xs)
                      : null,
                  child: Text(l10n.submit),
                ),
              ],
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
        Text(
          l10n.labels,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
            color: Theme.of(context).extension<AppPalette>()!.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: UIConstants.sm,
          runSpacing: UIConstants.sm,
          children: _labels.map((label) {
            final isSelected = _selectedLabels.contains(label.id);
            final labelColor = _parseColor(label.color);
            return FButton(
              variant: isSelected ? .primary : .outline,
              size: .xs,
              mainAxisSize: .min,
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
    final palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.milestone,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
            color: palette.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        FSelect<int>(
          items: {
            l10n.none: -1,
            for (final milestone in _milestones)
              milestone.title ?? '': milestone.id ?? -1,
          },
          control: FSelectControl.lifted(
            value: _selectedMilestoneId ?? -1,
            onChange: (value) {
              setState(() {
                _selectedMilestoneId = value == -1 ? null : value;
              });
            },
          ),
          hint: l10n.selectMilestone,
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
