import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/forui/app_page.dart';

class CreateLabelPage extends StatefulWidget {
  final String owner;
  final String repo;

  const CreateLabelPage({super.key, required this.owner, required this.repo});

  @override
  State<CreateLabelPage> createState() => _CreateLabelPageState();
}

class _CreateLabelPageState extends State<CreateLabelPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _colorController;
  bool _isSaving = false;
  List<Map<String, dynamic>> _templates = [];
  bool _templatesLoading = false;
  bool _isApplyingSet = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _colorController = TextEditingController(text: '#00B4AB');
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadTemplates());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  Future<void> _loadTemplates() async {
    setState(() => _templatesLoading = true);
    try {
      _templates = await Injection.apiService.listLabelTemplates();
    } catch (_) {
      _templates = [];
    }
    if (mounted) {
      if (_templates.isEmpty) _templates = _fallbackTemplates();
      setState(() => _templatesLoading = false);
    }
  }

  static List<Map<String, dynamic>> _fallbackTemplates() {
    return const [
      {
        'name': 'bug',
        'color': 'ee0701',
        'description': 'Something is not working',
      },
      {
        'name': 'enhancement',
        'color': '84b6eb',
        'description': 'New feature or request',
      },
      {
        'name': 'documentation',
        'color': '0075ca',
        'description': 'Improvements or additions to documentation',
      },
      {
        'name': 'help wanted',
        'color': '008672',
        'description': 'Extra attention is needed',
      },
      {
        'name': 'question',
        'color': 'cc317c',
        'description': 'Further information is requested',
      },
      {
        'name': 'duplicate',
        'color': 'cccccc',
        'description': 'This already exists',
      },
      {
        'name': 'invalid',
        'color': 'e4e669',
        'description': 'This does not seem right',
      },
      {
        'name': 'wontfix',
        'color': 'ffffff',
        'description': 'This will not be worked on',
      },
      {
        'name': 'good first issue',
        'color': '7057ff',
        'description': 'Good for newcomers',
      },
      {
        'name': 'feature',
        'color': 'fbca04',
        'description': 'New functionality',
      },
    ];
  }

  Future<void> _applyTemplateSet() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isApplyingSet = true);

    int created = 0;
    for (final t in _templates) {
      final name = t['name']?.toString() ?? '';
      final color = t['color']?.toString() ?? '';
      final desc = t['description']?.toString() ?? '';
      if (name.isEmpty) continue;

      final result = await Injection.issueNotifier
          .createLabel(widget.owner, widget.repo, {
            'name': name,
            'color': color.replaceFirst('#', ''),
            if (desc.isNotEmpty) 'description': desc,
          });
      if (result is Right<Failure, void>) created++;
    }

    if (mounted) {
      setState(() => _isApplyingSet = false);
      showFToast(
        context: context,
        title: Text('${l10n.created}: $created ${l10n.labels}'),
      );
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _pickColor() async {
    final color = await showFDialog<Color>(
      context: context,
      builder: (ctx, style, animation) =>
          _ColorPickerDialog(initial: _parseColor(_colorController.text)),
    );
    if (color != null) {
      final hex =
          '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
      setState(() => _colorController.text = hex);
    }
  }

  Color _parseColor(String hex) {
    final h = hex.replaceFirst('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      showFToast(
        context: context,
        variant: .destructive,
        title: Text(l10n.titleRequired),
      );
      return;
    }

    setState(() => _isSaving = true);

    final result = await Injection.issueNotifier
        .createLabel(widget.owner, widget.repo, {
          'name': name,
          'color': _colorController.text.replaceFirst('#', ''),
          if (_descriptionController.text.trim().isNotEmpty)
            'description': _descriptionController.text.trim(),
        });

    if (mounted) {
      setState(() => _isSaving = false);
      if (result is Right<Failure, void>) {
        showFToast(context: context, title: Text(l10n.created));
        Navigator.of(context).pop(true);
      } else {
        final err = (result as Left<Failure, void>).value;
        showFToast(
          context: context,
          variant: .destructive,
          title: Text('${l10n.error}: ${err.message}'),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppPage(
      maxContentWidth: 760,
      title: l10n.createLabel,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(UIConstants.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTemplateSetSection(l10n),
            const SizedBox(height: UIConstants.md),
            _buildCustomLabelSection(l10n),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(IconData icon, String title) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: UIConstants.sm),
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTemplateSetSection(AppLocalizations l10n) {
    final theme = Theme.of(context);
    return FCard.raw(
      child: Padding(
        padding: const EdgeInsets.all(UIConstants.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(FIcons.listPlus, l10n.applyLabelSet),
            const SizedBox(height: UIConstants.sm),
            Text(
              l10n.applyLabelSetDescription,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: UIConstants.md),
            if (_templatesLoading)
              const Center(child: FCircularProgress(size: .sm))
            else ...[
              Wrap(
                spacing: UIConstants.sm,
                runSpacing: UIConstants.xs,
                children: _templates.map((t) {
                  final name = t['name']?.toString() ?? '';
                  final colorHex =
                      t['color']?.toString().replaceFirst('#', '') ?? '808080';
                  final color = Color(int.parse('FF$colorHex', radix: 16));
                  return FBadge(
                    variant: .outline,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(name, style: theme.textTheme.labelSmall),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: UIConstants.md),
              FButton(
                onPress: _isApplyingSet ? null : _applyTemplateSet,
                prefix: _isApplyingSet
                    ? const FCircularProgress(size: .xs)
                    : const Icon(FIcons.check, size: 16),
                child: Text(
                  _isApplyingSet
                      ? l10n.creating
                      : l10n.applyAllLabels(_templates.length),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCustomLabelSection(AppLocalizations l10n) {
    return FCard.raw(
      child: Padding(
        padding: const EdgeInsets.all(UIConstants.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(FIcons.circlePlus, l10n.addCustomLabel),
            const SizedBox(height: UIConstants.md),
            FTextFormField(
              control: FTextFieldControl.managed(controller: _nameController),
              label: Text(l10n.labelName),
              hint: l10n.labelNameHint,
            ),
            const SizedBox(height: UIConstants.md),
            FTextFormField(
              control: FTextFieldControl.managed(
                controller: _descriptionController,
              ),
              label: Text(l10n.labelDescription),
              hint: l10n.labelDescriptionHint,
            ),
            const SizedBox(height: UIConstants.md),
            Row(
              children: [
                Expanded(
                  child: FTextField(
                    control: FTextFieldControl.managed(
                      controller: _colorController,
                    ),
                    label: Text(l10n.labelColor),
                    hint: l10n.labelColorHint,
                    prefixBuilder: (context, style, variants) => Container(
                      width: 20,
                      height: 20,
                      margin: const EdgeInsetsDirectional.only(end: 8),
                      decoration: BoxDecoration(
                        color: _parseColor(_colorController.text),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: UIConstants.sm),
                FButton.icon(
                  variant: .ghost,
                  size: .sm,
                  onPress: _pickColor,
                  child: const Icon(FIcons.palette),
                ),
              ],
            ),
            const SizedBox(height: UIConstants.md),
            FButton(
              onPress: _isSaving ? null : _save,
              prefix: _isSaving
                  ? const FCircularProgress(size: .xs)
                  : const Icon(FIcons.plus, size: 16),
              child: Text(l10n.createLabel),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorPickerDialog extends StatefulWidget {
  final Color initial;
  const _ColorPickerDialog({required this.initial});

  @override
  State<_ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<_ColorPickerDialog> {
  late Color _selected;

  static const _presetColors = [
    '#DC3545',
    '#E83E8C',
    '#6F42C1',
    '#6610F2',
    '#007BFF',
    '#17A2B8',
    '#00B4AB',
    '#28A745',
    '#FFC107',
    '#FD7E14',
    '#6C757D',
    '#343A40',
  ];

  @override
  void initState() {
    super.initState();
    _selected = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FDialog(
      title: Text(l10n.pickColor),
      body: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _presetColors.map((hex) {
          final color = Color(
            int.parse('FF${hex.replaceFirst('#', '')}', radix: 16),
          );
          return FTappable(
            onPress: () => Navigator.of(context).pop(color),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: _selected.toARGB32() == color.toARGB32()
                      ? Border.all(color: Colors.white, width: 3)
                      : null,
                ),
              ),
            ),
          );
        }).toList(),
      ),
      actions: [
        FButton(
          variant: .outline,
          onPress: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
      ],
    );
  }
}
