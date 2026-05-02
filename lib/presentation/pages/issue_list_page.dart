import 'package:flutter/material.dart';
import '../../core/animations/animated_wrapper.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../domain/entities/issue_state.dart';
import '../../l10n/app_localizations.dart';
import '../../presentation/state/issue_notifier.dart';
import '../widgets/empty_state.dart';
import '../widgets/premium_card.dart';
import '../widgets/user_avatar.dart';
import 'issue_detail_page.dart';

class IssueListPage extends StatefulWidget {
  const IssueListPage({super.key});

  @override
  State<IssueListPage> createState() => _IssueListPageState();
}

class _IssueListPageState extends State<IssueListPage> {
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = Injection.issueNotifier;
      if (notifier.issuesListState is! IssuesListLoaded) {
        notifier.searchIssues('', state: notifier.issuesListFilter);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _forceReload() {
    final notifier = Injection.issueNotifier;
    notifier.searchIssues(
      _searchQuery,
      state: notifier.issuesListFilter,
    );
  }

  void _onSearch(String query) {
    setState(() => _searchQuery = query);
    _forceReload();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.issues)),
      body: Column(
        children: [
          FadeInWrapper(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: UIConstants.md, vertical: UIConstants.sm),
              child: SearchBar(
                controller: _searchController,
                hintText: l10n.searchIssues,
                leading: const Icon(Icons.search),
                trailing: [
                  if (_searchQuery.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _onSearch('');
                      },
                    ),
                ],
                onChanged: _onSearch,
                padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: UIConstants.md),
                ),
              ),
            ),
          ),
          FadeInWrapper(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: UIConstants.md, vertical: UIConstants.sm),
              child: _FilterChips(
                selectedState: Injection.issueNotifier.issuesListFilter,
                onSelected: (state) {
                  setState(() {});
                  Injection.issueNotifier.searchIssues(
                    _searchQuery,
                    state: state,
                  );
                },
                l10n: l10n,
              ),
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
                        Text('${l10n.error}: $message'),
                        const SizedBox(height: UIConstants.md),
                        FilledButton(
                          onPressed: () => _forceReload(),
                          child: Text(l10n.retry),
                        ),
                      ],
                    ),
                  ),
                  IssuesListLoaded(:final issues) => _IssueList(issues: issues, onRefresh: _forceReload, l10n: l10n),
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
  final AppLocalizations l10n;

  const _FilterChips({required this.selectedState, required this.onSelected, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: UIConstants.sm,
      children: [
        FilterChip(
          label: Text(l10n.all),
          selected: selectedState == null,
          onSelected: (_) => onSelected(null),
        ),
        FilterChip(
          label: Text(l10n.open),
          selected: selectedState == 'open',
          onSelected: (_) => onSelected('open'),
        ),
        FilterChip(
          label: Text(l10n.closed),
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
  final AppLocalizations l10n;

  const _IssueList({required this.issues, required this.onRefresh, required this.l10n});

  @override
  Widget build(BuildContext context) {
    if (issues.isEmpty) {
      return EmptyState(icon: Icons.bug_report_outlined, title: l10n.noIssuesFound);
    }
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView.builder(
        padding: UIConstants.pagePadding + const EdgeInsets.symmetric(vertical: UIConstants.sm),
        itemCount: issues.length,
        itemBuilder: (context, index) {
          final issue = issues[index];
          return FadeInWrapper(
            delay: Duration(milliseconds: index * 40),
            child: _IssueCard(issue: issue, l10n: l10n),
          );
        },
      ),
    );
  }
}

class _IssueCard extends StatelessWidget {
  final Issue issue;
  final AppLocalizations l10n;

  const _IssueCard({required this.issue, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOpen = issue.state?.isOpen == true;
    final stateIcon = isOpen ? Icons.error_outline : Icons.check_circle;
    final stateColor = isOpen ? Colors.green : Colors.purple;

    final repoFullName = issue.repository?.full_name ?? '';
    final owner = issue.repository?.owner ?? '';
    final repo = issue.repository?.name ?? '';
    final canNavigate = owner.isNotEmpty && repo.isNotEmpty && issue.number != null;

    return PremiumListCard(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(stateIcon, size: UIConstants.iconSm, color: stateColor),
              const SizedBox(width: UIConstants.sm),
              Expanded(
                child: Text(
                  issue.title ?? l10n.untitled,
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (issue.number != null)
                Text(
                  '#${issue.number}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                  ),
                ),
            ],
          ),
          const SizedBox(height: UIConstants.sm),
          Row(
            children: [
              if (issue.user != null) ...[
                UserAvatar(user: issue.user!, radius: UIConstants.avatarXs),
                const SizedBox(width: UIConstants.xs),
                Text(
                  issue.user!.login ?? '',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              const Spacer(),
              if (repoFullName.isNotEmpty) ...[
                Text(
                  repoFullName,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
          if (issue.labels != null && issue.labels!.isNotEmpty) ...[
            const SizedBox(height: UIConstants.sm),
            _LabelRow(labels: issue.labels!),
          ],
          const SizedBox(height: UIConstants.sm),
          Row(
            children: [
              if (issue.comments != null) ...[
                Icon(Icons.comment_outlined, size: UIConstants.iconXs, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: UIConstants.xs),
                Text(
                  '${issue.comments}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(width: UIConstants.md),
              ],
              if (issue.updated_at != null) ...[
                Text(
                  _formatDate(issue.updated_at!),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ],
          ),
        ],
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

class _LabelRow extends StatelessWidget {
  final List<Label> labels;
  const _LabelRow({required this.labels});

  Color _color(String? hex) {
    if (hex == null || hex.isEmpty) return Colors.grey;
    try {
      return Color(int.parse(hex.replaceFirst('#', 'FF'), radix: 16));
    } catch (_) {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const maxShow = 4;
    final overflow = labels.length - maxShow;

    return Wrap(
      spacing: 4,
      runSpacing: 3,
      children: [
        ...labels.take(maxShow).map((label) {
          final c = _color(label.color);
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            decoration: BoxDecoration(
              color: c.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: c.withValues(alpha: 0.35), width: 0.5),
            ),
            child: Text(
              label.name ?? '',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: c, height: 1.2),
            ),
          );
        }),
        if (overflow > 0)
          Text(
            '+$overflow',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: theme.colorScheme.onSurfaceVariant),
          ),
      ],
    );
  }
}
