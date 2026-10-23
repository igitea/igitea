import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../core/di/injection.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../domain/usecases/repo_usecases.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/forui/app_page.dart';

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
    'git',
    'github',
    'gitea',
    'gitlab',
    'gogs',
    'onedev',
    'gitbucket',
    'codebase',
    'codecommit',
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

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await Injection.migrateRepoUseCase(
      MigrateRepoParams(
        cloneAddr: _cloneAddrController.text.trim(),
        repoName: _repoNameController.text.trim(),
        repoOwner: _repoOwnerController.text.trim().isEmpty
            ? null
            : _repoOwnerController.text.trim(),
        service: _service,
        authUsername: _authUsernameController.text.trim().isEmpty
            ? null
            : _authUsernameController.text.trim(),
        authPassword: _authPasswordController.text.trim().isEmpty
            ? null
            : _authPasswordController.text.trim(),
        authToken: _authTokenController.text.trim().isEmpty
            ? null
            : _authTokenController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
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
        showFToast(
          context: context,
          title: Text(AppLocalizations.of(context)!.repoImported),
        );
        Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AppPage(
      title: l10n.importRepository,
      actions: [
        FHeaderAction(
          icon: _isLoading
              ? const FCircularProgress(size: .xs)
              : const Icon(FIcons.upload),
          onPress: _isLoading ? null : _migrate,
        ),
      ],
      child: Form(
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
                  child: Text(
                    _error!,
                    style: TextStyle(color: theme.colorScheme.onErrorContainer),
                  ),
                ),
              FTextFormField(
                control: FTextFieldControl.managed(
                  controller: _cloneAddrController,
                ),
                label: Text(l10n.cloneUrl),
                hint: 'https://github.com/owner/repo.git',
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.url],
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? l10n.requiredField : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: FTextFormField(
                      control: FTextFieldControl.managed(
                        controller: _repoNameController,
                      ),
                      label: Text(l10n.repositoryName),
                      textInputAction: TextInputAction.next,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? l10n.requiredField
                          : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FTextField(
                      control: FTextFieldControl.managed(
                        controller: _repoOwnerController,
                      ),
                      label: Text(l10n.repoOwner),
                      hint: l10n.personal,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _service,
                decoration: InputDecoration(
                  labelText: l10n.gitService,
                  border: const OutlineInputBorder(),
                ),
                items: _services
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _service = v);
                },
              ),
              const SizedBox(height: 16),
              FTextField(
                control: FTextFieldControl.managed(
                  controller: _descriptionController,
                ),
                label: Text(l10n.description),
                maxLines: 2,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 24),
              Text(
                l10n.authentication,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              FTextField(
                control: FTextFieldControl.managed(
                  controller: _authUsernameController,
                ),
                label: Text(l10n.authUsername),
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.username],
              ),
              const SizedBox(height: 12),
              FTextField(
                control: FTextFieldControl.managed(
                  controller: _authPasswordController,
                ),
                label: Text(l10n.authPassword),
                obscureText: true,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.password],
              ),
              const SizedBox(height: 12),
              FTextField(
                control: FTextFieldControl.managed(
                  controller: _authTokenController,
                ),
                label: Text(l10n.authToken),
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 24),
              Text(
                l10n.migrationOptions,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              FCard.raw(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 2,
                  ),
                  child: FSwitch(
                    label: Text(l10n.private),
                    value: _private,
                    onChange: (v) => setState(() => _private = v),
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
                    label: Text(l10n.mirror),
                    value: _mirror,
                    onChange: (v) => setState(() => _mirror = v),
                  ),
                ),
              ),
              if (_mirror) ...[
                const SizedBox(height: 8),
                FTextField(
                  control: FTextFieldControl.managed(
                    controller: _mirrorIntervalController,
                  ),
                  label: Text(l10n.mirrorInterval),
                  hint: '8h',
                ),
              ],
              const SizedBox(height: 24),
              Text(
                l10n.migrateData,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              FCard.raw(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 2,
                  ),
                  child: FCheckbox(
                    label: Text(l10n.issues),
                    value: _issues,
                    onChange: (v) => setState(() => _issues = v),
                  ),
                ),
              ),
              FCard.raw(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 2,
                  ),
                  child: FCheckbox(
                    label: Text(l10n.labels),
                    value: _labels,
                    onChange: (v) => setState(() => _labels = v),
                  ),
                ),
              ),
              FCard.raw(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 2,
                  ),
                  child: FCheckbox(
                    label: Text(l10n.milestones),
                    value: _milestones,
                    onChange: (v) => setState(() => _milestones = v),
                  ),
                ),
              ),
              FCard.raw(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 2,
                  ),
                  child: FCheckbox(
                    label: Text(l10n.pullRequests),
                    value: _pullRequests,
                    onChange: (v) => setState(() => _pullRequests = v),
                  ),
                ),
              ),
              FCard.raw(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 2,
                  ),
                  child: FCheckbox(
                    label: Text(l10n.releases),
                    value: _releases,
                    onChange: (v) => setState(() => _releases = v),
                  ),
                ),
              ),
              FCard.raw(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 2,
                  ),
                  child: FCheckbox(
                    label: Text(l10n.wiki),
                    value: _wiki,
                    onChange: (v) => setState(() => _wiki = v),
                  ),
                ),
              ),
              FCard.raw(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 2,
                  ),
                  child: FCheckbox(
                    label: const Text('LFS'),
                    value: _lfs,
                    onChange: (v) => setState(() => _lfs = v),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
