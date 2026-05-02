import 'package:flutter/material.dart';

import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../state/repo_notifier.dart';

class CreateReleasePage extends StatefulWidget {
  final String owner;
  final String repo;

  const CreateReleasePage({
    super.key,
    required this.owner,
    required this.repo,
  });

  @override
  State<CreateReleasePage> createState() => _CreateReleasePageState();
}

class _CreateReleasePageState extends State<CreateReleasePage> {
  late final TextEditingController _tagController;
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;
  late final TextEditingController _tagMessageController;
  String? _selectedBranch;
  String? _selectedTag;
  bool _useExistingTag = false;
  bool _draft = false;
  bool _prerelease = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _tagController = TextEditingController();
    _titleController = TextEditingController();
    _bodyController = TextEditingController();
    _tagMessageController = TextEditingController();
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
    _tagMessageController.dispose();
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

  String? _validBranchValue() {
    if (_selectedBranch == null) return null;
    return _branches.any((b) => b.name == _selectedBranch) ? _selectedBranch : null;
  }

  String? _validTagValue() {
    if (_selectedTag == null) return null;
    return _tags.any((t) => t.name == _selectedTag) ? _selectedTag : null;
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    final tag = _useExistingTag ? (_selectedTag ?? '') : _tagController.text.trim();
    if (tag.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.releaseTagNameRequired)),
      );
      return;
    }

    setState(() => _isSaving = true);

    final option = CreateReleaseOption(
      tag_name: tag,
      name: _titleController.text.trim().isEmpty ? null : _titleController.text.trim(),
      body: _bodyController.text.trim().isEmpty ? null : _bodyController.text.trim(),
      target_commitish: _selectedBranch,
      tag_message: _tagMessageController.text.trim().isEmpty ? null : _tagMessageController.text.trim(),
      draft: _draft,
      prerelease: _prerelease,
    );

    final success = await Injection.repoNotifier.createRelease(
      owner: widget.owner,
      repo: widget.repo,
      option: option,
    );

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.releaseCreated)),
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
        title: Text(l10n.createRelease),
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
                const SizedBox(height: UIConstants.sm),
                TextField(
                  controller: _tagMessageController,
                  decoration: InputDecoration(
                    labelText: l10n.tagMessage,
                    border: const OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 3,
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
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: false, label: Text('New')),
                ButtonSegment(value: true, label: Text('Existing')),
              ],
              selected: {_useExistingTag},
              onSelectionChanged: (v) => setState(() => _useExistingTag = v.first),
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                textStyle: WidgetStateProperty.all(
                  Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: UIConstants.sm),
        if (_useExistingTag)
          DropdownButtonFormField<String>(
            value: _validTagValue(),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
            hint: const Text('Select a tag'),
            isExpanded: true,
            items: _uniqueTags().map((name) {
              return DropdownMenuItem(value: name, child: Text(name));
            }).toList(),
            onChanged: (v) => setState(() => _selectedTag = v),
          )
        else
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
      hint: const Text('main'),
      isExpanded: true,
      items: _uniqueBranches().map((name) {
        return DropdownMenuItem(value: name, child: Text(name));
      }).toList(),
      onChanged: (v) => setState(() => _selectedBranch = v),
    );
  }

  List<String> _uniqueBranches() {
    final seen = <String>{};
    return _branches.map((b) => b.name ?? '').where((n) => n.isNotEmpty && seen.add(n)).toList();
  }

  List<String> _uniqueTags() {
    final seen = <String>{};
    return _tags.map((t) => t.name ?? '').where((n) => n.isNotEmpty && seen.add(n)).toList();
  }
}
