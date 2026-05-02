import 'package:flutter/material.dart';

import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../l10n/app_localizations.dart';

class CreateLabelPage extends StatefulWidget {
  final String owner;
  final String repo;

  const CreateLabelPage({
    super.key,
    required this.owner,
    required this.repo,
  });

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
      {'name': 'bug', 'color': 'ee0701', 'description': 'Something is not working'},
      {'name': 'enhancement', 'color': '84b6eb', 'description': 'New feature or request'},
      {'name': 'documentation', 'color': '0075ca', 'description': 'Improvements or additions to documentation'},
      {'name': 'help wanted', 'color': '008672', 'description': 'Extra attention is needed'},
      {'name': 'question', 'color': 'cc317c', 'description': 'Further information is requested'},
      {'name': 'duplicate', 'color': 'cccccc', 'description': 'This already exists'},
      {'name': 'invalid', 'color': 'e4e669', 'description': 'This does not seem right'},
      {'name': 'wontfix', 'color': 'ffffff', 'description': 'This will not be worked on'},
      {'name': 'good first issue', 'color': '7057ff', 'description': 'Good for newcomers'},
      {'name': 'feature', 'color': 'fbca04', 'description': 'New functionality'},
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

      final result = await Injection.issueNotifier.createLabel(
        widget.owner,
        widget.repo,
        {
          'name': name,
          'color': color.replaceFirst('#', ''),
          if (desc.isNotEmpty) 'description': desc,
        },
      );
      if (result is Right<Failure, void>) created++;
    }

    if (mounted) {
      setState(() => _isApplyingSet = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l10n.created}: $created ${l10n.labels}')),
      );
      Navigator.of(context).pop(true);
    }
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

  Color _parseColor(String hex) {
    final h = hex.replaceFirst('#', '');
    return Color(int.parse('FF$h', radix: 16));
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

    final result = await Injection.issueNotifier.createLabel(
      widget.owner,
      widget.repo,
      {
        'name': name,
        'color': _colorController.text.replaceFirst('#', ''),
        if (_descriptionController.text.trim().isNotEmpty)
          'description': _descriptionController.text.trim(),
      },
    );

    if (mounted) {
      setState(() => _isSaving = false);
      if (result is Right<Failure, void>) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.created)),
        );
        Navigator.of(context).pop(true);
      } else {
        final err = (result as Left<Failure, void>).value;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.error}: ${err.message}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.createLabel)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(UIConstants.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTemplateSetSection(l10n),
            const SizedBox(height: UIConstants.lg),
            const Divider(),
            const SizedBox(height: UIConstants.lg),
            _buildCustomLabelSection(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplateSetSection(AppLocalizations l10n) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(UIConstants.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.playlist_add, size: 20, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: UIConstants.sm),
                Text(l10n.applyLabelSet, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: UIConstants.sm),
            Text(
              l10n.applyLabelSetDescription,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: UIConstants.md),
            if (_templatesLoading)
              const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)))
            else ...[
              Wrap(
                spacing: UIConstants.sm,
                runSpacing: UIConstants.xs,
                children: _templates.asMap().entries.map((entry) {
                  final t = entry.value;
                  final name = t['name']?.toString() ?? '';
                  final colorHex = t['color']?.toString().replaceFirst('#', '') ?? '808080';
                  final color = Color(int.parse('FF$colorHex', radix: 16));
                  return Chip(
                    avatar: CircleAvatar(backgroundColor: color, radius: 6),
                    label: Text(name, style: Theme.of(context).textTheme.labelSmall),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  );
                }).toList(),
              ),
              const SizedBox(height: UIConstants.md),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _isApplyingSet ? null : _applyTemplateSet,
                  icon: _isApplyingSet
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.check, size: 18),
                  label: Text(_isApplyingSet ? l10n.creating : l10n.applyAllLabels(_templates.length)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCustomLabelSection(AppLocalizations l10n) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(UIConstants.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.add_circle_outline, size: 20, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: UIConstants.sm),
                Text(l10n.addCustomLabel, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: UIConstants.md),
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
                        decoration: BoxDecoration(color: _parseColor(_colorController.text), shape: BoxShape.circle),
                        width: 24, height: 24,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: UIConstants.sm),
                IconButton(icon: const Icon(Icons.colorize), onPressed: _pickColor, tooltip: l10n.labelColor),
              ],
            ),
            const SizedBox(height: UIConstants.md),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isSaving ? null : _save,
                icon: _isSaving
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.add, size: 18),
                label: Text(l10n.createLabel),
              ),
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
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: _selected.toARGB32() == color.toARGB32() ? Border.all(color: Colors.white, width: 3) : null,
              ),
            ),
          );
        }).toList(),
      ),
      actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.cancel))],
    );
  }
}
