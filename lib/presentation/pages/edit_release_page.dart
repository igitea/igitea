import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../state/repo_notifier.dart';
import '../widgets/forui/app_page.dart';

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

  String? _validBranchValue() {
    if (_selectedBranch == null) return null;
    return _branches.any((b) => b.name == _selectedBranch)
        ? _selectedBranch
        : null;
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    final tag = _tagController.text.trim();
    if (tag.isEmpty) {
      showFToast(context: context, title: Text(l10n.releaseTagNameRequired));
      return;
    }

    setState(() => _isSaving = true);

    final option = EditReleaseOption(
      tag_name: tag,
      name: _titleController.text.trim().isEmpty
          ? null
          : _titleController.text.trim(),
      body: _bodyController.text.trim().isEmpty
          ? null
          : _bodyController.text.trim(),
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
        showFToast(context: context, title: Text(l10n.releaseUpdated));
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
      title: l10n.editRelease,
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
            if (_uniqueTags().isNotEmpty)
              FButton(
                variant: .ghost,
                size: .xs,
                prefix: const Icon(FIcons.tag, size: 16),
                onPress: () async {
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
                child: Text(l10n.chooseTag),
              ),
          ],
        ),
        const SizedBox(height: UIConstants.sm),
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
      hint: Text(_selectedBranch ?? 'main'),
      isExpanded: true,
      items: _uniqueBranches().map((name) {
        return DropdownMenuItem(value: name, child: Text(name));
      }).toList(),
      onChanged: (v) => setState(() => _selectedBranch = v),
    );
  }
}
