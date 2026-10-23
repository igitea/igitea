import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../core/animations/animated_wrapper.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../state/issue_notifier.dart';
import '../widgets/forui/app_page.dart';
import '../widgets/forui/app_state_views.dart';
import '../widgets/forui/app_tile.dart';
import 'create_label_page.dart';
import 'edit_label_page.dart';

class LabelListPage extends StatefulWidget {
  final String owner;
  final String repo;

  const LabelListPage({super.key, required this.owner, required this.repo});

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

    await Injection.issueNotifier.listLabels(widget.owner, widget.repo);

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
        builder: (_) => CreateLabelPage(owner: widget.owner, repo: widget.repo),
      ),
    );
    if (result == true) _loadLabels();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppPage(
      title: l10n.labels,
      actions: [
        FHeaderAction(
          icon: const Icon(FIcons.plus),
          semanticsLabel: l10n.createLabel,
          onPress: _createLabel,
        ),
      ],
      child: _buildBody(l10n),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_loading) {
      return const AppLoading();
    }
    if (_error != null) {
      return AppError(message: _error!, onRetry: _loadLabels);
    }
    if (_labels.isEmpty) {
      return AppEmpty(
        icon: FIcons.tag,
        title: l10n.noLabels,
        action: FButton(
          onPress: _createLabel,
          prefix: const Icon(FIcons.plus, size: 16),
          child: Text(l10n.createLabel),
        ),
      );
    }
    return _buildLabelList(l10n);
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
            child: Padding(
              padding: const EdgeInsets.only(bottom: UIConstants.sm),
              child: FCard.raw(
                child: AppTile(
                  leading: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _parseColor(label.color ?? '#808080'),
                      shape: BoxShape.circle,
                    ),
                  ),
                  title: label.name ?? '',
                  subtitle: label.description,
                  onPress: () async {
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
