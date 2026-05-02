import 'package:flutter/material.dart';

import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';

class EditTeamPage extends StatefulWidget {
  final Team team;

  const EditTeamPage({super.key, required this.team});

  @override
  State<EditTeamPage> createState() => _EditTeamPageState();
}

class _EditTeamPageState extends State<EditTeamPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _descController;
  late String _permission;
  late bool _canCreateRepo;
  late bool _includesAllRepos;
  bool _isSaving = false;

  static const _permissions = ['read', 'write', 'admin'];

  @override
  void initState() {
    super.initState();
    final t = widget.team;
    _nameController = TextEditingController(text: t.name ?? '');
    _descController = TextEditingController(text: t.description ?? '');
    _permission = t.permission ?? 'read';
    _canCreateRepo = t.can_create_org_repo ?? false;
    _includesAllRepos = t.includes_all_repositories ?? false;
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.teamNameRequired)),
      );
      return;
    }
    setState(() => _isSaving = true);

    final option = EditTeamOption(
      name: name,
      description: _descController.text.trim().isEmpty ? null : _descController.text.trim(),
      permission: _permission,
      can_create_org_repo: _canCreateRepo,
      includes_all_repositories: _includesAllRepos,
    );

    final success = await Injection.organizationNotifier.editTeam(
      id: widget.team.id!,
      option: option,
    );

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.teamUpdated)),
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
        title: Text(l10n.editTeam),
        actions: [
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
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.teamName,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: UIConstants.md),
            TextField(
              controller: _descController,
              decoration: InputDecoration(
                labelText: l10n.teamDescription,
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: UIConstants.md),
            DropdownButtonFormField<String>(
              value: _permission,
              decoration: InputDecoration(
                labelText: l10n.teamPermission,
                border: const OutlineInputBorder(),
              ),
              items: _permissions.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
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
