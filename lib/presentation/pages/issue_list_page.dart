import 'package:flutter/material.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../domain/usecases/issue_usecases.dart';
import '../state/issue_notifier.dart';
import '../widgets/user_avatar.dart';

class IssueListPage extends StatefulWidget {
  const IssueListPage({super.key});

  @override
  State<IssueListPage> createState() => _IssueListPageState();
}

class _IssueListPageState extends State<IssueListPage> {
  String? _selectedState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Issues')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _FilterChips(
              selectedState: _selectedState,
              onSelected: (state) {
                setState(() => _selectedState = state);
              },
            ),
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: Injection.issueNotifier,
              builder: (context, _) {
                final state = Injection.issueNotifier.state;
                return switch (state) {
                  IssueLoading() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  IssueError(:final message) => Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Error: $message'),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () => _loadIssues(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                  IssueListLoaded(:final issues) => _IssueList(issues: issues),
                  _ => const Center(
                    child: Text('Select a repository to view issues'),
                  ),
                };
              },
            ),
          ),
        ],
      ),
    );
  }

  void _loadIssues() {
    Injection.issueNotifier.listIssues(
      ListIssuesParams(owner: '', repo: '', state: _selectedState),
    );
  }
}

class _FilterChips extends StatelessWidget {
  final String? selectedState;
  final ValueChanged<String?> onSelected;

  const _FilterChips({required this.selectedState, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        FilterChip(
          label: const Text('All'),
          selected: selectedState == null,
          onSelected: (_) => onSelected(null),
        ),
        FilterChip(
          label: const Text('Open'),
          selected: selectedState == 'open',
          onSelected: (_) => onSelected('open'),
        ),
        FilterChip(
          label: const Text('Closed'),
          selected: selectedState == 'closed',
          onSelected: (_) => onSelected('closed'),
        ),
      ],
    );
  }
}

class _IssueList extends StatelessWidget {
  final List<Issue> issues;

  const _IssueList({required this.issues});

  @override
  Widget build(BuildContext context) {
    if (issues.isEmpty) {
      return const Center(child: Text('No issues found.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: issues.length,
      itemBuilder: (context, index) {
        final issue = issues[index];
        return _IssueCard(issue: issue);
      },
    );
  }
}

class _IssueCard extends StatelessWidget {
  final Issue issue;

  const _IssueCard({required this.issue});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOpen = issue.state?.value == 'open';
    final stateIcon = isOpen ? Icons.error_outline : Icons.check_circle;
    final stateColor = isOpen ? Colors.green : Colors.purple;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: issue.user != null
            ? UserAvatar(user: issue.user!, radius: 16)
            : Icon(stateIcon, color: stateColor),
        title: Text(
          issue.title ?? 'Untitled',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Row(
          children: [
            Text('#${issue.number ?? 0}'),
            if (issue.labels != null && issue.labels!.isNotEmpty) ...[
              const SizedBox(width: 8),
              ...issue.labels!.take(3).map((label) {
                return Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Chip(
                    label: Text(
                      label.name ?? '',
                      style: const TextStyle(fontSize: 11),
                    ),
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                );
              }),
            ],
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (issue.user?.login != null)
              Text(issue.user!.login!, style: theme.textTheme.bodySmall),
            if (issue.updated_at != null)
              Text(
                _formatDate(issue.updated_at!),
                style: theme.textTheme.labelSmall,
              ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 365) return '${diff.inDays ~/ 365}y ago';
    if (diff.inDays > 30) return '${diff.inDays ~/ 30}mo ago';
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    return 'just now';
  }
}
