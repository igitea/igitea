import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../state/repo_notifier.dart';
import '../widgets/forui/app_page.dart';

class CreateReleasePage extends StatefulWidget {
  final String owner;
  final String repo;

  const CreateReleasePage({super.key, required this.owner, required this.repo});

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
    return _branches.any((b) => b.name == _selectedBranch)
        ? _selectedBranch
        : null;
  }

  String? _validTagValue() {
    if (_selectedTag == null) return null;
    return _tags.any((t) => t.name == _selectedTag) ? _selectedTag : null;
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    final tag = _useExistingTag
        ? (_selectedTag ?? '')
        : _tagController.text.trim();
    if (tag.isEmpty) {
      showFToast(context: context, title: Text(l10n.releaseTagNameRequired));
      return;
    }

    setState(() => _isSaving = true);

    final option = CreateReleaseOption(
      tag_name: tag,
      name: _titleController.text.trim().isEmpty
          ? null
          : _titleController.text.trim(),
      body: _bodyController.text.trim().isEmpty
          ? null
          : _bodyController.text.trim(),
      target_commitish: _selectedBranch,
      tag_message: _tagMessageController.text.trim().isEmpty
          ? null
          : _tagMessageController.text.trim(),
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
        showFToast(context: context, title: Text(l10n.releaseCreated));
        Navigator.pop(context, true);
      } else {
        showFToast(
          context: context,
          variant: .destructive,
          title: Text(l10n.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppPage(
      maxContentWidth: 760,
      title: l10n.createRelease,
      actions: [
        FHeaderAction(
          icon: _isSaving
              ? const FCircularProgress(size: .xs)
              : const Icon(FIcons.save),
          onPress: _isSaving ? null : _save,
        ),
      ],
      child: ListenableBuilder(
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
                FTextField(
                  control: FTextFieldControl.managed(
                    controller: _titleController,
                  ),
                  label: Text(l10n.releaseTitle),
                ),
                const SizedBox(height: UIConstants.md),
                FTextField(
                  control: FTextFieldControl.managed(
                    controller: _bodyController,
                  ),
                  label: Text(l10n.releaseBody),
                  maxLines: 8,
                  keyboardType: TextInputType.multiline,
                ),
                const SizedBox(height: UIConstants.sm),
                FTextField(
                  control: FTextFieldControl.managed(
                    controller: _tagMessageController,
                  ),
                  label: Text(l10n.tagMessage),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                ),
                const SizedBox(height: UIConstants.md),
                FCard.raw(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 2,
                    ),
                    child: FSwitch(
                      label: Text(l10n.draft),
                      value: _draft,
                      onChange: (v) => setState(() => _draft = v),
                    ),
                  ),
                ),
                FCard.raw(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 2,
                    ),
                    child: FSwitch(
                      label: Text(l10n.preRelease),
                      value: _prerelease,
                      onChange: (v) => setState(() => _prerelease = v),
                    ),
                  ),
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
            Text(
              l10n.releaseTagName,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Spacer(),
            FButton(
              variant: _useExistingTag ? .outline : .primary,
              size: .xs,
              mainAxisSize: .min,
              onPress: () => setState(() => _useExistingTag = false),
              child: const Text('New'),
            ),
            const SizedBox(width: UIConstants.xs),
            FButton(
              variant: _useExistingTag ? .primary : .outline,
              size: .xs,
              mainAxisSize: .min,
              onPress: () => setState(() => _useExistingTag = true),
              child: const Text('Existing'),
            ),
          ],
        ),
        const SizedBox(height: UIConstants.sm),
        if (_useExistingTag)
          DropdownButtonFormField<String>(
            initialValue: _validTagValue(),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
            ),
            hint: const Text('Select a tag'),
            isExpanded: true,
            items: _uniqueTags().map((name) {
              return DropdownMenuItem(value: name, child: Text(name));
            }).toList(),
            onChanged: (v) => setState(() => _selectedTag = v),
          )
        else
          FTextField(
            control: FTextFieldControl.managed(controller: _tagController),
            hint: 'v1.0.0',
          ),
      ],
    );
  }

  Widget _buildBranchDropdown(AppLocalizations l10n) {
    return DropdownButtonFormField<String>(
      initialValue: _validBranchValue(),
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
    return _branches
        .map((b) => b.name ?? '')
        .where((n) => n.isNotEmpty && seen.add(n))
        .toList();
  }

  List<String> _uniqueTags() {
    final seen = <String>{};
    return _tags
        .map((t) => t.name ?? '')
        .where((n) => n.isNotEmpty && seen.add(n))
        .toList();
  }
}
