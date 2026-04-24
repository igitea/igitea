import 'package:flutter/material.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../presentation/state/issue_notifier.dart';
import '../widgets/user_avatar.dart';
import 'issue_detail_page.dart';

class IssueListPage extends StatefulWidget {
  const IssueListPage({super.key});

  @override
  State<IssueListPage> createState() => _IssueListPageState();
}

class _IssueListPageState extends State<IssueListPage> {
  String? _selectedState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadIssues();
    });
  }

  void _loadIssues() {
    final state = _selectedState ?? 'open';
    final notifier = Injection.issueNotifier;
    if (notifier.issuesListState is! IssuesListLoaded) {
      notifier.searchIssues('', state: state);
    }
  }

  void _forceReload() {
    final state = _selectedState ?? 'open';
    Injection.issueNotifier.searchIssues('', state: state);
  }

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
                _forceReload();
              },
            ),
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: Injection.issueNotifier,
              builder: (context, _) {
                final issuesState = Injection.issueNotifier.issuesListState;
                return switch (issuesState) {
                  IssuesListLoading() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  IssuesListError(:final message) => Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Error: $message'),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () => _forceReload(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                  IssuesListLoaded(:final issues) => _IssueList(issues: issues, onRefresh: _forceReload),
                  _ => const Center(
                    child: CircularProgressIndicator(),
                  ),
                };
              },
            ),
          ),
        ],
      ),
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
  final VoidCallback onRefresh;

  const _IssueList({required this.issues, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    if (issues.isEmpty) {
      return const Center(child: Text('No issues found.'));
    }
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: issues.length,
        itemBuilder: (context, index) {
          final issue = issues[index];
          return _IssueCard(issue: issue);
        },
      ),
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

    final repoFullName = issue.repository?.full_name ?? '';
    final owner = issue.repository?.owner ?? '';
    final repo = issue.repository?.name ?? '';
    final canNavigate = owner.isNotEmpty && repo.isNotEmpty && issue.number != null;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: canNavigate
            ? () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => IssueDetailPage(
                    owner: owner,
                    repo: repo,
                    index: issue.number!,
                  ),
                ));
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(stateIcon, size: 16, color: stateColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      issue.title ?? 'Untitled',
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (issue.number != null)
                    Text('#${issue.number}', style: theme.textTheme.bodySmall),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  if (issue.user != null) ...[
                    UserAvatar(user: issue.user!, radius: 10),
                    const SizedBox(width: 4),
                    Text(issue.user!.login ?? '', style: theme.textTheme.labelSmall),
                  ],
                  const Spacer(),
                  if (repoFullName.isNotEmpty) ...[
                    Text(repoFullName, style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    )),
                  ],
                ],
              ),
              if (issue.labels != null && issue.labels!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: issue.labels!.take(3).map((label) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _parseColor(label.color)?.withValues(alpha: 0.2) ?? theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        label.name ?? '',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: _parseColor(label.color) ?? theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 4),
              Row(
                children: [
                  if (issue.comments != null) ...[
                    Icon(Icons.comment_outlined, size: 14, color: theme.colorScheme.onSurfaceVariant),
                    const SizedBox(width: 2),
                    Text('${issue.comments}', style: theme.textTheme.labelSmall),
                    const SizedBox(width: 12),
                  ],
                  if (issue.updated_at != null) ...[
                    Text(
                      _formatDate(issue.updated_at!),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
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

  Color? _parseColor(String? colorStr) {
    if (colorStr == null || colorStr.isEmpty) return null;
    try {
      return Color(int.parse(colorStr.replaceFirst('#', ''), radix: 16) + 0xFF000000);
    } catch (_) {
      return null;
    }
  }
}