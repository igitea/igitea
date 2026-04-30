import 'package:flutter/material.dart';

import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../state/repo_notifier.dart';

class CreatePRPage extends StatefulWidget {
  final String owner;
  final String repo;

  const CreatePRPage({super.key, required this.owner, required this.repo});

  @override
  State<CreatePRPage> createState() => _CreatePRPageState();
}

class _CreatePRPageState extends State<CreatePRPage> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  String? _headBranch;
  String? _baseBranch;
  List<Branch> _branches = [];
  bool _isLoading = false;
  bool _branchesLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBranches();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _loadBranches() async {
    await Injection.repoNotifier.listBranches(widget.owner, widget.repo);
    if (mounted) {
      final state = Injection.repoNotifier.branchesState;
      if (state is BranchesLoaded) {
        setState(() {
          _branches = state.branches;
          _branchesLoading = false;
          if (_branches.isNotEmpty) {
            _baseBranch = _branches.first.name;
            _headBranch = _branches.length > 1 ? _branches[1].name : _branches.first.name;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.newPullRequest),
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
              onPressed: _submit,
              child: Text(l10n.submit),
            ),
        ],
      ),
      body: _branchesLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _headBranch,
                          decoration: InputDecoration(labelText: l10n.headBranch),
                          items: _branches.map((b) => DropdownMenuItem(
                            value: b.name,
                            child: Text(b.name ?? ''),
                          )).toList(),
                          onChanged: (v) => setState(() => _headBranch = v),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(Icons.arrow_forward),
                      ),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _baseBranch,
                          decoration: InputDecoration(labelText: l10n.baseBranch),
                          items: _branches.map((b) => DropdownMenuItem(
                            value: b.name,
                            child: Text(b.name ?? ''),
                          )).toList(),
                          onChanged: (v) => setState(() => _baseBranch = v),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: l10n.title,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: TextField(
                      controller: _bodyController,
                      decoration: InputDecoration(
                        labelText: l10n.body,
                        border: const OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final title = _titleController.text.trim();
    if (title.isEmpty || _headBranch == null || _baseBranch == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pleaseFillAllFields)),
      );
      return;
    }

    setState(() => _isLoading = true);

    await Injection.repoNotifier.createPullRequest(
      widget.owner,
      widget.repo,
      {
        'title': title,
        'body': _bodyController.text.trim(),
        'head': _headBranch,
        'base': _baseBranch,
      },
    );

    if (mounted) {
      setState(() => _isLoading = false);

      final state = Injection.repoNotifier.pullRequestDetailState;
      if (state is PullRequestDetailDataLoaded) {
        Navigator.of(context).pop(state.pullRequest);
      } else if (state is PullRequestDetailError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.error}: ${state.message}')),
        );
      }
    }
  }
}