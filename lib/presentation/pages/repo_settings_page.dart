import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../state/repo_notifier.dart';
import '../widgets/forui/app_page.dart';
import '../widgets/forui/app_section.dart';
import '../widgets/forui/app_tile.dart';
import 'repo_actions_secrets_page.dart';
import 'repo_actions_variables_page.dart';
import 'tag_protections_page.dart';

class RepoSettingsPage extends StatefulWidget {
  final Repository repo;

  const RepoSettingsPage({super.key, required this.repo});

  @override
  State<RepoSettingsPage> createState() => _RepoSettingsPageState();
}

class _RepoSettingsPageState extends State<RepoSettingsPage> {
  late final _descriptionController = TextEditingController(
    text: widget.repo.description ?? '',
  );
  late final _websiteController = TextEditingController(
    text: widget.repo.website ?? '',
  );
  late bool _isPrivate = widget.repo.private ?? false;
  late bool _hasIssues = widget.repo.has_issues ?? true;
  late bool _hasPRs = widget.repo.has_pull_requests ?? true;
  late bool _hasWiki = widget.repo.has_wiki ?? false;
  bool _isLoading = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AppPage(
      title: l10n.settings,
      actions: [
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(8),
            child: FCircularProgress(size: .sm),
          )
        else
          FHeaderAction(
            icon: const Icon(FIcons.save),
            semanticsLabel: l10n.save,
            onPress: _save,
          ),
      ],
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FTextField(
            control: FTextFieldControl.managed(
              controller: _descriptionController,
            ),
            label: Text(l10n.description),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          FTextField(
            control: FTextFieldControl.managed(controller: _websiteController),
            label: Text(l10n.website),
            keyboardType: TextInputType.url,
          ),
          const SizedBox(height: 16),
          FCard.raw(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: FSwitch(
                    value: _isPrivate,
                    label: Text(l10n.privateRepo),
                    description: Text(l10n.privateRepoDesc),
                    onChange: (v) => setState(() => _isPrivate = v),
                  ),
                ),
                const FDivider(),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: FSwitch(
                    value: _hasIssues,
                    label: Text(l10n.enableIssues),
                    onChange: (v) => setState(() => _hasIssues = v),
                  ),
                ),
                const FDivider(),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: FSwitch(
                    value: _hasPRs,
                    label: Text(l10n.enablePullRequests),
                    onChange: (v) => setState(() => _hasPRs = v),
                  ),
                ),
                const FDivider(),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: FSwitch(
                    value: _hasWiki,
                    label: Text(l10n.enableWiki),
                    onChange: (v) => setState(() => _hasWiki = v),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppSection(
            title: '',
            showHeader: false,
            children: [
              if (widget.repo.default_branch != null)
                AppTile(
                  leading: const Icon(FIcons.gitBranch, size: 18),
                  title: l10n.defaultBranch,
                  subtitle: widget.repo.default_branch!,
                  showChevron: false,
                ),
              AppTile(
                leading: const Icon(FIcons.shield, size: 18),
                title: l10n.branchProtection,
                subtitle: l10n.protectBranch,
                onPress: () async {
                  final repoOwner =
                      widget.repo.owner?.login ??
                      widget.repo.full_name?.split('/').first ??
                      '';
                  try {
                    await Injection.apiService.repoCreateBranchProtection(
                      owner: repoOwner,
                      repo: widget.repo.name ?? '',
                      body: {'branch_name': widget.repo.default_branch!},
                    );
                    if (context.mounted) {
                      showFToast(
                        context: context,
                        title: Text(l10n.settingsSaved),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      showFToast(
                        context: context,
                        variant: .destructive,
                        title: Text('${l10n.error}: $e'),
                      );
                    }
                  }
                },
              ),
              AppTile(
                leading: const Icon(FIcons.tag, size: 18),
                title: l10n.tagProtections,
                subtitle: l10n.manageTagProtections,
                onPress: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => TagProtectionsPage(
                        owner: widget.repo.owner?.login ?? '',
                        repo: widget.repo.name ?? '',
                      ),
                    ),
                  );
                },
              ),
              AppTile(
                leading: const Icon(FIcons.lock, size: 18),
                title: l10n.actionsSecretsTitle,
                onPress: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RepoActionsSecretsPage(
                        owner: widget.repo.owner?.login ?? '',
                        repo: widget.repo.name ?? '',
                      ),
                    ),
                  );
                },
              ),
              AppTile(
                leading: const Icon(FIcons.code, size: 18),
                title: l10n.actionsVariablesTitle,
                onPress: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RepoActionsVariablesPage(
                        owner: widget.repo.owner?.login ?? '',
                        repo: widget.repo.name ?? '',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          FCard.raw(
            child: AppTile(
              leading: Icon(
                FIcons.trash2,
                size: 18,
                color: theme.colorScheme.error,
              ),
              title: l10n.deleteRepo,
              destructive: true,
              showChevron: false,
              onPress: _showDeleteDialog,
            ),
          ),
        ],
      ),
    );
  }

  void _save() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isLoading = true);

    await Injection.repoNotifier
        .editRepo(widget.repo.owner!.login!, widget.repo.name!, {
          'description': _descriptionController.text.trim(),
          'website': _websiteController.text.trim(),
          'private': _isPrivate,
          'has_issues': _hasIssues,
          'has_pull_requests': _hasPRs,
          'has_wiki': _hasWiki,
        });

    if (mounted) {
      setState(() => _isLoading = false);

      final state = Injection.repoNotifier.state;
      if (state is RepoLoaded) {
        showFToast(context: context, title: Text(l10n.settingsSaved));
      } else if (state is RepoError) {
        showFToast(
          context: context,
          variant: .destructive,
          title: Text('${l10n.error}: ${state.message}'),
        );
      }
    }
  }

  Future<void> _showDeleteDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showFDialog<bool>(
      context: context,
      builder: (ctx, style, animation) => FDialog(
        title: Text(l10n.deleteRepo),
        body: Text(l10n.deleteRepoConfirm),
        actions: [
          FButton(
            variant: .outline,
            onPress: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          FButton(
            variant: .destructive,
            onPress: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    await Injection.repoNotifier.deleteRepo(
      widget.repo.owner!.login!,
      widget.repo.name!,
    );
    if (mounted) {
      final state = Injection.repoNotifier.state;
      if (state is RepoInitial) {
        showFToast(context: context, title: Text(l10n.settingsSaved));
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else if (state is RepoError) {
        showFToast(
          context: context,
          variant: .destructive,
          title: Text('${l10n.error}: ${state.message}'),
        );
      }
    }
  }
}
