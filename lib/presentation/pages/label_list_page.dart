import 'package:flutter/material.dart';

import '../../core/animations/animated_wrapper.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';

import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../state/issue_notifier.dart';
import '../widgets/empty_state.dart';
import 'create_label_page.dart';
import 'edit_label_page.dart';

class LabelListPage extends StatefulWidget {
  final String owner;
  final String repo;

  const LabelListPage({
    super.key,
    required this.owner,
    required this.repo,
  });

  @override
  State<LabelListPage> createState() => _LabelListPageState();
}

class _LabelListPageState extends State<LabelListPage> {
  List<Label> _labels = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadLabels();
  }

  Future<void> _loadLabels() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    await Injection.issueNotifier.listLabels(
      widget.owner,
      widget.repo,
    );

    if (mounted) {
      final state = Injection.issueNotifier.state;
      switch (state) {
        case IssueError(:final message):
          setState(() {
            _error = message;
            _loading = false;
          });
        case LabelsLoaded(:final labels):
          setState(() {
            _labels = labels;
            _loading = false;
          });
        default:
          setState(() => _loading = false);
      }
    }
  }

  Future<void> _createLabel() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreateLabelPage(
          owner: widget.owner,
          repo: widget.repo,
        ),
      ),
    );
    if (result == true) _loadLabels();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.labels)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createLabel,
        icon: const Icon(Icons.add),
        label: Text(l10n.createLabel),
      ),
      body: _buildBody(l10n),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return _buildErrorState(l10n);
    }
    if (_labels.isEmpty) {
      return EmptyState(
        icon: Icons.label_outline,
        title: l10n.noLabels,
        action: FilledButton.icon(
          onPressed: _createLabel,
          icon: const Icon(Icons.add),
          label: Text(l10n.createLabel),
        ),
      );
    }
    return _buildLabelList(l10n);
  }

  Widget _buildErrorState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${l10n.error}: $_error'),
          const SizedBox(height: UIConstants.md),
          FilledButton(
            onPressed: _loadLabels,
            child: Text(l10n.retry),
          ),
        ],
      ),
    );
  }

  Widget _buildLabelList(AppLocalizations l10n) {
    return RefreshIndicator(
      onRefresh: _loadLabels,
      child: ListView.builder(
        padding: const EdgeInsets.all(UIConstants.md),
        itemCount: _labels.length,
        itemBuilder: (context, index) {
          final label = _labels[index];
          return FadeInWrapper(
            delay: Duration(milliseconds: index * 30),
            child: Card(
              margin: const EdgeInsets.only(bottom: UIConstants.md),
              child: ListTile(
                leading: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: _parseColor(label.color ?? '#808080'),
                    shape: BoxShape.circle,
                  ),
                ),
                title: Text(
                  label.name ?? '',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: label.description != null
                    ? Text(label.description!, maxLines: 1, overflow: TextOverflow.ellipsis)
                    : null,
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditLabelPage(
                        owner: widget.owner,
                        repo: widget.repo,
                        label: label,
                      ),
                    ),
                  );
                  if (result == true) _loadLabels();
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Color _parseColor(String hex) {
    final h = hex.replaceFirst('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }
}
