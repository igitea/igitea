import 'package:flutter/material.dart';

import '../../core/di/injection.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../domain/usecases/repo_usecases.dart';
import '../../l10n/app_localizations.dart';

class MigrateRepoPage extends StatefulWidget {
  const MigrateRepoPage({super.key});

  @override
  State<MigrateRepoPage> createState() => _MigrateRepoPageState();
}

class _MigrateRepoPageState extends State<MigrateRepoPage> {
  final _formKey = GlobalKey<FormState>();
  final _cloneAddrController = TextEditingController();
  final _repoNameController = TextEditingController();
  final _repoOwnerController = TextEditingController();
  final _authUsernameController = TextEditingController();
  final _authPasswordController = TextEditingController();
  final _authTokenController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _mirrorIntervalController = TextEditingController();
  String _service = 'git';
  bool _private = false;
  bool _mirror = false;
  bool _issues = true;
  bool _labels = true;
  bool _milestones = true;
  bool _pullRequests = true;
  bool _releases = true;
  bool _wiki = true;
  bool _lfs = false;
  bool _isLoading = false;
  String? _error;

  static const _services = [
    'git', 'github', 'gitea', 'gitlab', 'gogs',
    'onedev', 'gitbucket', 'codebase', 'codecommit',
  ];

  @override
  void dispose() {
    _cloneAddrController.dispose();
    _repoNameController.dispose();
    _repoOwnerController.dispose();
    _authUsernameController.dispose();
    _authPasswordController.dispose();
    _authTokenController.dispose();
    _descriptionController.dispose();
    _mirrorIntervalController.dispose();
    super.dispose();
  }

  Future<void> _migrate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() { _isLoading = true; _error = null; });

    final result = await Injection.migrateRepoUseCase(
      MigrateRepoParams(
        cloneAddr: _cloneAddrController.text.trim(),
        repoName: _repoNameController.text.trim(),
        repoOwner: _repoOwnerController.text.trim().isEmpty
            ? null : _repoOwnerController.text.trim(),
        service: _service,
        authUsername: _authUsernameController.text.trim().isEmpty
            ? null : _authUsernameController.text.trim(),
        authPassword: _authPasswordController.text.trim().isEmpty
            ? null : _authPasswordController.text.trim(),
        authToken: _authTokenController.text.trim().isEmpty
            ? null : _authTokenController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null : _descriptionController.text.trim(),
        issues: _issues,
        labels: _labels,
        milestones: _milestones,
        pullRequests: _pullRequests,
        releases: _releases,
        wiki: _wiki,
        private: _private,
        mirror: _mirror,
        lfs: _lfs,
      ),
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    switch (result) {
      case Left<Failure, Repository>(:final value):
        setState(() => _error = value.message);
      case Right<Failure, Repository>():
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.repoImported)),
        );
        Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.importRepository),
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: 20, height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _migrate,
              child: Text(l10n.import),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_error != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(_error!, style: TextStyle(color: theme.colorScheme.onErrorContainer)),
                ),
              TextFormField(
                controller: _cloneAddrController,
                decoration: InputDecoration(
                  labelText: l10n.cloneUrl,
                  hintText: 'https://github.com/owner/repo.git',
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.url,
                validator: (v) => (v == null || v.trim().isEmpty) ? l10n.requiredField : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _repoNameController,
                      decoration: InputDecoration(
                        labelText: l10n.repositoryName,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty) ? l10n.requiredField : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _repoOwnerController,
                      decoration: InputDecoration(
                        labelText: l10n.repoOwner,
                        hintText: l10n.personal,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _service,
                decoration: InputDecoration(
                  labelText: l10n.gitService,
                  border: const OutlineInputBorder(),
                ),
                items: _services.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) { if (v != null) setState(() => _service = v); },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: l10n.description,
                  border: const OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              Text(l10n.authentication, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              TextFormField(
                controller: _authUsernameController,
                decoration: InputDecoration(
                  labelText: l10n.authUsername,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _authPasswordController,
                decoration: InputDecoration(
                  labelText: l10n.authPassword,
                  border: const OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _authTokenController,
                decoration: InputDecoration(
                  labelText: l10n.authToken,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              Text(l10n.migrationOptions, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              SwitchListTile(
                title: Text(l10n.private),
                value: _private,
                onChanged: (v) => setState(() => _private = v),
              ),
              SwitchListTile(
                title: Text(l10n.mirror),
                value: _mirror,
                onChanged: (v) => setState(() => _mirror = v),
              ),
              if (_mirror) ...[
                const SizedBox(height: 8),
                TextFormField(
                  controller: _mirrorIntervalController,
                  decoration: InputDecoration(
                    labelText: l10n.mirrorInterval,
                    hintText: '8h',
                    border: const OutlineInputBorder(),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              Text(l10n.migrateData, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              CheckboxListTile(title: Text(l10n.issues), value: _issues, onChanged: (v) => setState(() => _issues = v ?? true)),
              CheckboxListTile(title: Text(l10n.labels), value: _labels, onChanged: (v) => setState(() => _labels = v ?? true)),
              CheckboxListTile(title: Text(l10n.milestones), value: _milestones, onChanged: (v) => setState(() => _milestones = v ?? true)),
              CheckboxListTile(title: Text(l10n.pullRequests), value: _pullRequests, onChanged: (v) => setState(() => _pullRequests = v ?? true)),
              CheckboxListTile(title: Text(l10n.releases), value: _releases, onChanged: (v) => setState(() => _releases = v ?? true)),
              CheckboxListTile(title: Text(l10n.wiki), value: _wiki, onChanged: (v) => setState(() => _wiki = v ?? true)),
              CheckboxListTile(title: const Text('LFS'), value: _lfs, onChanged: (v) => setState(() => _lfs = v ?? false)),
            ],
          ),
        ),
      ),
    );
  }
}
