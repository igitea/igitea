import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/forui/app_page.dart';

class CreateTeamPage extends StatefulWidget {
  final String org;

  const CreateTeamPage({super.key, required this.org});

  @override
  State<CreateTeamPage> createState() => _CreateTeamPageState();
}

class _CreateTeamPageState extends State<CreateTeamPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _descController;
  String _permission = 'read';
  bool _canCreateRepo = false;
  bool _includesAllRepos = false;
  bool _isSaving = false;

  static const _permissions = ['read', 'write', 'admin'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      showFToast(context: context, title: Text(l10n.teamNameRequired));
      return;
    }
    setState(() => _isSaving = true);

    final option = CreateTeamOption(
      name: name,
      description: _descController.text.trim().isEmpty
          ? null
          : _descController.text.trim(),
      permission: _permission,
      can_create_org_repo: _canCreateRepo,
      includes_all_repositories: _includesAllRepos,
    );

    final success = await Injection.organizationNotifier.createTeam(
      org: widget.org,
      option: option,
    );

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        showFToast(context: context, title: Text(l10n.teamCreated));
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
      title: l10n.createTeam,
      actions: [
        FHeaderAction(
          icon: _isSaving
              ? const FCircularProgress(size: .xs)
              : const Icon(FIcons.save),
          onPress: _isSaving ? null : _save,
        ),
      ],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(UIConstants.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FTextFormField(
              control: FTextFieldControl.managed(controller: _nameController),
              label: Text(l10n.teamName),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.requiredField;
                }
                return null;
              },
            ),
            const SizedBox(height: UIConstants.md),
            FTextField(
              control: FTextFieldControl.managed(controller: _descController),
              label: Text(l10n.teamDescription),
              maxLines: 3,
            ),
            const SizedBox(height: UIConstants.md),
            DropdownButtonFormField<String>(
              initialValue: _permission,
              decoration: InputDecoration(
                labelText: l10n.teamPermission,
                border: const OutlineInputBorder(),
              ),
              items: _permissions
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
              onChanged: (v) => setState(() => _permission = v ?? 'read'),
            ),
            const SizedBox(height: UIConstants.md),
            SwitchListTile(
              title: Text(l10n.teamCanCreateOrgRepos),
              value: _canCreateRepo,
              onChanged: (v) => setState(() => _canCreateRepo = v),
              contentPadding: EdgeInsets.zero,
            ),
            SwitchListTile(
              title: Text(l10n.teamIncludesAllRepos),
              value: _includesAllRepos,
              onChanged: (v) => setState(() => _includesAllRepos = v),
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}
