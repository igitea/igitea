import 'package:flutter/material.dart';

import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';

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

  static const _defaultLabels = [
    ('bug', 'DC3545'),
    ('enhancement', '28A745'),
    ('documentation', '007BFF'),
    ('help wanted', 'FD7E14'),
    ('question', '6F42C1'),
    ('duplicate', '6C757D'),
    ('invalid', 'FFC107'),
    ('wontfix', '343A40'),
    ('good first issue', '17A2B8'),
    ('feature', 'E83E8C'),
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.label.name ?? '');
    _descriptionController = TextEditingController(text: widget.label.description ?? '');
    _colorController = TextEditingController(text: '#${widget.label.color ?? '808080'}');
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

  void _selectDefault(String name, String color) {
    setState(() {
      _nameController.text = name;
      _colorController.text = '#$color';
    });
  }

  Future<void> _pickColor() async {
    final color = await showDialog<Color>(
      context: context,
      builder: (context) => _ColorPickerDialog(initial: _parseColor(_colorController.text)),
    );
    if (color != null) {
      final hex = '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
      setState(() => _colorController.text = hex);
    }
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.titleRequired)),
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${l10n.error}: ${value.message}')),
          );
        case Right():
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.saved)),
          );
          Navigator.of(context).pop(true);
      }
    }
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteLabel),
        content: Text(l10n.deleteLabelConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${l10n.error}: ${value.message}')),
          );
        case Right():
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.labelDeleted)),
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
        title: Text(l10n.editLabel),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: l10n.delete,
            onPressed: _isSaving ? null : _delete,
          ),
          IconButton(
            icon: _isSaving
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
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
            if (_nameController.text.trim().isEmpty) ...[
              _buildDefaultLabels(l10n),
              const SizedBox(height: UIConstants.md),
            ],
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.labelName,
                hintText: l10n.labelNameHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: UIConstants.md),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: l10n.labelDescription,
                hintText: l10n.labelDescriptionHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: UIConstants.md),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _colorController,
                    decoration: InputDecoration(
                      labelText: l10n.labelColor,
                      hintText: l10n.labelColorHint,
                      border: const OutlineInputBorder(),
                      prefixIcon: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _parseColor(_colorController.text),
                          shape: BoxShape.circle,
                        ),
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: UIConstants.sm),
                IconButton(
                  icon: const Icon(Icons.colorize),
                  onPressed: _pickColor,
                  tooltip: l10n.labelColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultLabels(AppLocalizations l10n) {
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
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _defaultLabels.map((label) {
              final (name, color) = label;
              return Padding(
                padding: const EdgeInsets.only(right: UIConstants.sm),
                child: ActionChip(
                  avatar: CircleAvatar(
                    backgroundColor: Color(int.parse('FF$color', radix: 16)),
                    radius: 6,
                  ),
                  label: Text(name, style: Theme.of(context).textTheme.labelSmall),
                  onPressed: () => _selectDefault(name, color),
                ),
              );
            }).toList(),
          ),
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
    '#DC3545', '#E83E8C', '#6F42C1', '#6610F2',
    '#007BFF', '#17A2B8', '#00B4AB', '#28A745',
    '#FFC107', '#FD7E14', '#6C757D', '#343A40',
  ];

  @override
  void initState() {
    super.initState();
    _selected = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.pickColor),
      content: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _presetColors.map((hex) {
          final color = Color(int.parse('FF${hex.replaceFirst('#', '')}', radix: 16));
          return GestureDetector(
            onTap: () => Navigator.of(context).pop(color),
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
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
      ],
    );
  }
}
