import 'package:flutter/material.dart';

import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../state/repo_notifier.dart';

class RepoSettingsPage extends StatefulWidget {
  final Repository repo;

  const RepoSettingsPage({super.key, required this.repo});

  @override
  State<RepoSettingsPage> createState() => _RepoSettingsPageState();
}

class _RepoSettingsPageState extends State<RepoSettingsPage> {
  late final _descriptionController = TextEditingController(text: widget.repo.description ?? '');
  late final _websiteController = TextEditingController(text: widget.repo.website ?? '');
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

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            TextButton(
              onPressed: _save,
              child: Text(l10n.save),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: l10n.description,
              border: const OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _websiteController,
            decoration: InputDecoration(
              labelText: l10n.website,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: Text(l10n.privateRepo),
                  subtitle: Text(l10n.privateRepoDesc),
                  value: _isPrivate,
                  onChanged: (v) => setState(() => _isPrivate = v),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: Text(l10n.enableIssues),
                  value: _hasIssues,
                  onChanged: (v) => setState(() => _hasIssues = v),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: Text(l10n.enablePullRequests),
                  value: _hasPRs,
                  onChanged: (v) => setState(() => _hasPRs = v),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: Text(l10n.enableWiki),
                  value: _hasWiki,
                  onChanged: (v) => setState(() => _hasWiki = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (widget.repo.default_branch != null)
            ListTile(
              leading: const Icon(Icons.call_split),
              title: Text(l10n.defaultBranch),
              subtitle: Text(widget.repo.default_branch!),
            ),
          ListTile(
            leading: const Icon(Icons.shield_outlined),
            title: Text(l10n.branchProtection),
            subtitle: Text(l10n.protectBranch),
            onTap: () async {
              final repoOwner = widget.repo.owner?.login ?? widget.repo.full_name?.split('/').first ?? '';
              try {
                await Injection.apiService.repoCreateBranchProtection(
                  owner: repoOwner,
                  repo: widget.repo.name ?? '',
                  body: {'branch_name': widget.repo.default_branch!},
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.settingsSaved)),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${l10n.error}: $e')),
                  );
                }
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.delete, color: theme.colorScheme.error),
            title: Text(
              l10n.deleteRepo,
              style: TextStyle(color: theme.colorScheme.error),
            ),
            onTap: () => _showDeleteDialog(context),
          ),
        ],
      ),
    );
  }

  void _save() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isLoading = true);

    await Injection.repoNotifier.editRepo(
      widget.repo.owner!.login!,
      widget.repo.name!,
      {
        'description': _descriptionController.text.trim(),
        'website': _websiteController.text.trim(),
        'private': _isPrivate,
        'has_issues': _hasIssues,
        'has_pull_requests': _hasPRs,
        'has_wiki': _hasWiki,
      },
    );

    if (mounted) {
      setState(() => _isLoading = false);

      final state = Injection.repoNotifier.state;
      if (state is RepoLoaded) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.settingsSaved)),
        );
      } else if (state is RepoError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.error}: ${state.message}')),
        );
      }
    }
  }

  void _showDeleteDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteRepo),
        content: Text(l10n.deleteRepoConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await Injection.repoNotifier.deleteRepo(
                widget.repo.owner!.login!,
                widget.repo.name!,
              );
              if (context.mounted) {
                final state = Injection.repoNotifier.state;
                if (state is RepoInitial) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.settingsSaved)),
                  );
                  Navigator.of(context).popUntil((route) => route.isFirst);
                } else if (state is RepoError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${l10n.error}: ${state.message}')),
                  );
                }
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
}