import 'package:flutter/material.dart';

import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../state/repo_notifier.dart';

class EditReleasePage extends StatefulWidget {
  final String owner;
  final String repo;
  final Release release;

  const EditReleasePage({
    super.key,
    required this.owner,
    required this.repo,
    required this.release,
  });

  @override
  State<EditReleasePage> createState() => _EditReleasePageState();
}

class _EditReleasePageState extends State<EditReleasePage> {
  late final TextEditingController _tagController;
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;
  String? _selectedBranch;
  late bool _draft;
  late bool _prerelease;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final r = widget.release;
    _tagController = TextEditingController(text: r.tag_name ?? '');
    _titleController = TextEditingController(text: r.name ?? '');
    _bodyController = TextEditingController(text: r.body ?? '');
    _selectedBranch = r.target_commitish;
    _draft = r.draft ?? false;
    _prerelease = r.prerelease ?? false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Injection.repoNotifier.listBranches(widget.owner, widget.repo);
      Injection.repoNotifier.listTags(widget.owner, widget.repo);
    });
  }

  @override
  void dispose() {
    _tagController.dispose();
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  List<Branch> get _branches {
    final state = Injection.repoNotifier.branchesState;
    return state is BranchesLoaded ? state.branches : [];
  }

  List<Tag> get _tags {
    final state = Injection.repoNotifier.tagsState;
    return state is TagsLoaded ? state.tags : [];
  }

  List<String> _uniqueBranches() {
    final seen = <String>{};
    return _branches.map((b) => b.name ?? '').where((n) => n.isNotEmpty && seen.add(n)).toList();
  }

  List<String> _uniqueTags() {
    final seen = <String>{};
    return _tags.map((t) => t.name ?? '').where((n) => n.isNotEmpty && seen.add(n)).toList();
  }

  String? _validBranchValue() {
    if (_selectedBranch == null) return null;
    return _branches.any((b) => b.name == _selectedBranch) ? _selectedBranch : null;
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    final tag = _tagController.text.trim();
    if (tag.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.releaseTagNameRequired)),
      );
      return;
    }

    setState(() => _isSaving = true);

    final option = EditReleaseOption(
      tag_name: tag,
      name: _titleController.text.trim().isEmpty ? null : _titleController.text.trim(),
      body: _bodyController.text.trim().isEmpty ? null : _bodyController.text.trim(),
      target_commitish: _selectedBranch,
      draft: _draft,
      prerelease: _prerelease,
    );

    final success = await Injection.repoNotifier.editRelease(
      owner: widget.owner,
      repo: widget.repo,
      id: widget.release.id!,
      option: option,
    );

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.releaseUpdated)),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.error)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editRelease),
        actions: [
          IconButton(
            icon: _isSaving
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.save),
            onPressed: _isSaving ? null : _save,
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: Injection.repoNotifier,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(UIConstants.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTagNameField(l10n),
                const SizedBox(height: UIConstants.md),
                _buildBranchDropdown(l10n),
                const SizedBox(height: UIConstants.md),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: l10n.releaseTitle,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: UIConstants.md),
                TextField(
                  controller: _bodyController,
                  decoration: InputDecoration(
                    labelText: l10n.releaseBody,
                    border: const OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 8,
                  keyboardType: TextInputType.multiline,
                ),
                const SizedBox(height: UIConstants.md),
                SwitchListTile(
                  title: Text(l10n.draft),
                  value: _draft,
                  onChanged: (v) => setState(() => _draft = v),
                  contentPadding: EdgeInsets.zero,
                ),
                SwitchListTile(
                  title: Text(l10n.preRelease),
                  value: _prerelease,
                  onChanged: (v) => setState(() => _prerelease = v),
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTagNameField(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(l10n.releaseTagName, style: Theme.of(context).textTheme.bodyMedium),
            const Spacer(),
            if (_uniqueTags().isNotEmpty)
              TextButton.icon(
                onPressed: () async {
                  final tag = await showDialog<String>(
                    context: context,
                    builder: (ctx) => SimpleDialog(
                      title: Text(l10n.chooseTag),
                      children: _uniqueTags().map((name) {
                        return SimpleDialogOption(
                          onPressed: () => Navigator.pop(ctx, name),
                          child: Text(name),
                        );
                      }).toList(),
                    ),
                  );
                  if (tag != null) {
                    setState(() => _tagController.text = tag);
                  }
                },
                icon: const Icon(Icons.local_offer_outlined, size: 16),
                label: Text(l10n.chooseTag, style: Theme.of(context).textTheme.labelSmall),
              ),
          ],
        ),
        const SizedBox(height: UIConstants.sm),
        TextField(
          controller: _tagController,
          decoration: const InputDecoration(
            hintText: 'v1.0.0',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildBranchDropdown(AppLocalizations l10n) {
    return DropdownButtonFormField<String>(
      value: _validBranchValue(),
      decoration: InputDecoration(
        labelText: l10n.targetCommitish,
        border: const OutlineInputBorder(),
      ),
      hint: Text(_selectedBranch ?? 'main'),
      isExpanded: true,
      items: _uniqueBranches().map((name) {
        return DropdownMenuItem(value: name, child: Text(name));
      }).toList(),
      onChanged: (v) => setState(() => _selectedBranch = v),
    );
  }
}
