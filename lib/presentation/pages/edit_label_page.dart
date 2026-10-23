import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/forui/app_page.dart';

class EditLabelPage extends StatefulWidget {
  final String owner;
  final String repo;
  final Label label;

  const EditLabelPage({
    super.key,
    required this.owner,
    required this.repo,
    required this.label,
  });

  @override
  State<EditLabelPage> createState() => _EditLabelPageState();
}

class _EditLabelPageState extends State<EditLabelPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _colorController;
  bool _isSaving = false;
  List<Map<String, dynamic>> _templates = [];
  bool _templatesLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.label.name ?? '');
    _descriptionController = TextEditingController(
      text: widget.label.description ?? '',
    );
    _colorController = TextEditingController(
      text: '#${widget.label.color ?? '808080'}',
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadTemplates());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  Color _parseColor(String hex) {
    final h = hex.replaceFirst('#', '');
    return Color(int.parse('FF$h', radix: 16));
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

  void _applyTemplate(Map<String, dynamic> template) {
    setState(() {
      _nameController.text = template['name']?.toString() ?? '';
      if (template['color'] != null) {
        _colorController.text =
            '#${template['color'].toString().replaceFirst('#', '')}';
      }
      if (template['description'] != null) {
        _descriptionController.text = template['description'].toString();
      }
    });
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

    final body = <String, dynamic>{
      'name': name,
      'color': _colorController.text.replaceFirst('#', ''),
      if (_descriptionController.text.trim().isNotEmpty)
        'description': _descriptionController.text.trim(),
    };

    final result = await Injection.issueNotifier.editLabel(
      widget.owner,
      widget.repo,
      widget.label.id ?? 0,
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

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showFDialog<bool>(
      context: context,
      builder: (ctx, style, animation) => FDialog(
        title: Text(l10n.deleteLabel),
        body: Text(l10n.deleteLabelConfirm),
        actions: [
          FButton(
            variant: .outline,
            onPress: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          FButton(
            variant: .destructive,
            onPress: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final result = await Injection.issueNotifier.deleteLabel(
      widget.owner,
      widget.repo,
      widget.label.id ?? 0,
    );

    if (mounted) {
      switch (result) {
        case Left(:final value):
          showFToast(
            context: context,
            variant: .destructive,
            title: Text('${l10n.error}: ${value.message}'),
          );
        case Right():
          showFToast(context: context, title: Text(l10n.labelDeleted));
          Navigator.of(context).pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppPage(
      title: l10n.editLabel,
      actions: [
        FHeaderAction(
          icon: const Icon(FIcons.trash2),
          semanticsLabel: l10n.delete,
          onPress: _isSaving ? null : _delete,
        ),
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_nameController.text.trim().isEmpty) ...[
              _buildTemplatesSection(l10n),
              const SizedBox(height: UIConstants.md),
            ],
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
          ],
        ),
      ),
    );
  }

  Widget _buildTemplatesSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.defaultLabels,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: UIConstants.sm),
        if (_templatesLoading)
          const FCircularProgress(size: .sm)
        else
          DropdownButtonFormField<int>(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
            ),
            hint: Text(l10n.selectTemplate),
            isExpanded: true,
            items: _templates.asMap().entries.map((entry) {
              final t = entry.value;
              final name = t['name']?.toString() ?? '';
              final colorHex =
                  t['color']?.toString().replaceFirst('#', '') ?? '808080';
              final color = Color(int.parse('FF$colorHex', radix: 16));
              return DropdownMenuItem(
                value: entry.key,
                child: Row(
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text(name),
                  ],
                ),
              );
            }).toList(),
            onChanged: (index) {
              if (index != null) _applyTemplate(_templates[index]);
            },
          ),
      ],
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
