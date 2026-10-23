import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';

import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../domain/usecases/repo_usecases.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/forui/app_page.dart';

class CreateRepoPage extends StatefulWidget {
  const CreateRepoPage({super.key});

  @override
  State<CreateRepoPage> createState() => _CreateRepoPageState();
}

class _CreateRepoPageState extends State<CreateRepoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isPrivate = false;
  bool _autoInit = true;
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await Injection.createRepoUseCase(
      CreateRepoParams(
        name: _nameController.text.trim(),
        description: _descriptionController.text.isNotEmpty
            ? _descriptionController.text
            : null,
        isPrivate: _isPrivate,
        autoInit: _autoInit,
      ),
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    switch (result) {
      case Left<Failure, Repository>(:final value):
        setState(() {
          _error = value.message;
        });
      case Right<Failure, Repository>(:final value):
        if (mounted) {
          showFToast(
            context: context,
            title: Text(
              AppLocalizations.of(
                context,
              )!.repoCreated(value.full_name ?? value.name ?? ''),
            ),
          );
          Navigator.pop(context, true);
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AppPage(
      title: l10n.createRepository,
      actions: [
        FHeaderAction(
          icon: _isLoading
              ? const FCircularProgress(size: .xs)
              : const Icon(FIcons.plus),
          onPress: _isLoading ? null : _create,
        ),
      ],
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(UIConstants.md),
          children: [
            if (_error != null) ...[
              Container(
                padding: const EdgeInsets.all(UIConstants.md),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(UIConstants.cardRadius),
                ),
                child: Text(
                  _error!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onErrorContainer,
                  ),
                ),
              ),
              const SizedBox(height: UIConstants.md),
            ],
            FTextFormField(
              control: FTextFieldControl.managed(controller: _nameController),
              label: Text(l10n.repositoryName),
              hint: l10n.repositoryNameHint,
              textInputAction: TextInputAction.next,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_.-]')),
              ],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.repositoryNameRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: UIConstants.md),
            FTextField(
              control: FTextFieldControl.managed(
                controller: _descriptionController,
              ),
              label: Text(l10n.description),
              hint: l10n.descriptionHint,
              maxLines: 3,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: UIConstants.md),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(UIConstants.cardRadius),
                side: BorderSide(
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.5,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(UIConstants.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.visibility,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: UIConstants.sm),
                    _VisibilityOption(
                      title: l10n.public,
                      subtitle: l10n.publicDescription,
                      icon: FIcons.globe,
                      isSelected: !_isPrivate,
                      onTap: () => setState(() => _isPrivate = false),
                    ),
                    const Divider(),
                    _VisibilityOption(
                      title: l10n.private,
                      subtitle: l10n.privateDescription,
                      icon: FIcons.lock,
                      isSelected: _isPrivate,
                      onTap: () => setState(() => _isPrivate = true),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: UIConstants.md),
            SwitchListTile(
              title: Text(l10n.initializeWithReadme),
              subtitle: Text(l10n.initializeWithReadmeDescription),
              value: _autoInit,
              onChanged: (value) => setState(() => _autoInit = value),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(UIConstants.cardRadius),
                side: BorderSide(
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VisibilityOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _VisibilityOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(UIConstants.badgeRadius),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: UIConstants.sm),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: UIConstants.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: isSelected ? FontWeight.w600 : null,
                      color: isSelected ? theme.colorScheme.primary : null,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(FIcons.circleCheck, color: theme.colorScheme.primary)
            else
              Icon(FIcons.circle, color: theme.colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
