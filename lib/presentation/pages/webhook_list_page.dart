import 'package:flutter/material.dart';

import '../../core/animations/animated_wrapper.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/empty_state.dart';
import 'create_webhook_page.dart';

class WebhookListPage extends StatefulWidget {
  final String owner;
  final String repo;

  const WebhookListPage({
    super.key,
    required this.owner,
    required this.repo,
  });

  @override
  State<WebhookListPage> createState() => _WebhookListPageState();
}

class _WebhookListPageState extends State<WebhookListPage> {
  List<Hook> _hooks = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadHooks();
  }

  Future<void> _loadHooks() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final result = await Injection.repoNotifier.listHooks(
      widget.owner,
      widget.repo,
    );

    if (mounted) {
      switch (result) {
        case Left(:final value):
          setState(() {
            _error = value.message;
            _loading = false;
          });
        case Right(:final value):
          setState(() {
            _hooks = value;
            _loading = false;
          });
      }
    }
  }

  Future<void> _createWebhook() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreateWebhookPage(
          owner: widget.owner,
          repo: widget.repo,
        ),
      ),
    );
    if (result == true) {
      _loadHooks();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.webhooks)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createWebhook,
        icon: const Icon(Icons.add),
        label: Text(l10n.createWebhook),
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
    if (_hooks.isEmpty) {
      return EmptyState(
        icon: Icons.webhook,
        title: l10n.noWebhooks,
        action: FilledButton.icon(
          onPressed: _createWebhook,
          icon: const Icon(Icons.add),
          label: Text(l10n.createWebhook),
        ),
      );
    }
    return _buildHookList(l10n);
  }

  Widget _buildErrorState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${l10n.error}: $_error'),
          const SizedBox(height: UIConstants.md),
          FilledButton(
            onPressed: _loadHooks,
            child: Text(l10n.retry),
          ),
        ],
      ),
    );
  }

  Widget _buildHookList(AppLocalizations l10n) {
    final theme = Theme.of(context);
    return RefreshIndicator(
      onRefresh: _loadHooks,
      child: ListView.builder(
        padding: const EdgeInsets.all(UIConstants.md),
        itemCount: _hooks.length,
        itemBuilder: (context, index) {
          final hook = _hooks[index];
          return FadeInWrapper(
            delay: Duration(milliseconds: index * 30),
            child: Card(
              margin: const EdgeInsets.only(bottom: UIConstants.md),
              child: ListTile(
                leading: Icon(
                  Icons.webhook,
                  color: hook.active == true
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                ),
                title: Text(
                  hook.type?.toUpperCase() ?? l10n.webhook,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hook.config?['url'] != null)
                      Text(
                        hook.config!['url']!.toString(),
                        style: theme.textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: UIConstants.xs),
                    Row(
                      children: [
                        Icon(
                          hook.active == true
                              ? Icons.check_circle
                              : Icons.cancel,
                          size: UIConstants.iconSm,
                          color: hook.active == true
                              ? Colors.green
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: UIConstants.xs),
                        Text(
                          hook.active == true
                              ? l10n.webhookActive
                              : l10n.webhookInactive,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: hook.active == true
                                ? Colors.green
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WebhookDetailPage(
                        owner: widget.owner,
                        repo: widget.repo,
                        hook: hook,
                      ),
                    ),
                  ).then((_) => _loadHooks());
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class WebhookDetailPage extends StatefulWidget {
  final String owner;
  final String repo;
  final Hook hook;

  const WebhookDetailPage({
    super.key,
    required this.owner,
    required this.repo,
    required this.hook,
  });

  @override
  State<WebhookDetailPage> createState() => _WebhookDetailPageState();
}

class _WebhookDetailPageState extends State<WebhookDetailPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.hook.type?.toUpperCase() ?? l10n.webhook} #${widget.hook.id ?? 0}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: l10n.edit,
            onPressed: () => _editWebhook(l10n),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: l10n.delete,
            onPressed: () => _deleteWebhook(l10n),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(UIConstants.md),
        children: [
          _buildInfoSection(l10n, theme),
          const SizedBox(height: UIConstants.md),
          _buildConfigSection(l10n, theme),
          const SizedBox(height: UIConstants.md),
          _buildEventsSection(l10n, theme),
        ],
      ),
    );
  }

  Widget _buildInfoSection(AppLocalizations l10n, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(UIConstants.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.webhook, color: theme.colorScheme.primary),
                const SizedBox(width: UIConstants.sm),
                Text(
                  l10n.webhook,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: UIConstants.sm,
                    vertical: UIConstants.xs,
                  ),
                  decoration: BoxDecoration(
                    color: widget.hook.active == true
                        ? Colors.green.withValues(alpha: 0.2)
                        : theme.colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(UIConstants.badgeRadius),
                  ),
                  child: Text(
                    widget.hook.active == true
                        ? l10n.webhookActive
                        : l10n.webhookInactive,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: widget.hook.active == true
                          ? Colors.green
                          : theme.colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: UIConstants.md),
            _InfoRow(label: l10n.webhookType, value: widget.hook.type ?? '-'),
            if (widget.hook.created_at != null)
              _InfoRow(
                label: l10n.webhookCreatedAt,
                value: _formatDate(widget.hook.created_at!),
              ),
            if (widget.hook.updated_at != null)
              _InfoRow(
                label: l10n.webhookUpdatedAt,
                value: _formatDate(widget.hook.updated_at!),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigSection(AppLocalizations l10n, ThemeData theme) {
    final config = widget.hook.config ?? {};
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(UIConstants.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.configuration,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: UIConstants.sm),
            if (config['url'] != null)
              _InfoRow(label: l10n.webhookUrl, value: config['url'].toString()),
            if (config['content_type'] != null)
              _InfoRow(
                label: l10n.webhookContentType,
                value: config['content_type'].toString(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsSection(AppLocalizations l10n, ThemeData theme) {
    final events = widget.hook.events ?? [];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(UIConstants.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.webhookEvents,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: UIConstants.sm),
            Wrap(
              spacing: UIConstants.sm,
              runSpacing: UIConstants.xs,
              children: events.map((event) => Chip(
                label: Text(event),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              )).toList(),
            ),
            if (events.isEmpty)
              Text(
                '-',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _editWebhook(AppLocalizations l10n) async {
    final config = widget.hook.config ?? {};
    final urlController = TextEditingController(text: config['url']?.toString() ?? '');
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.editWebhook),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: urlController,
              decoration: InputDecoration(
                labelText: l10n.webhookUrl,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: Text(l10n.save)),
        ],
      ),
    );

    if (result != true || urlController.text.trim().isEmpty) return;

    try {
      await Injection.apiService.repoEditHook(
        owner: widget.owner,
        repo: widget.repo,
        id: widget.hook.id ?? 0,
        body: {
          'active': widget.hook.active ?? true,
          'config': {
            'url': urlController.text.trim(),
            'content_type': config['content_type'] ?? 'json',
          },
          'events': widget.hook.events ?? [],
        },
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.saved)),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.error}: $e')),
        );
      }
    }
  }

  Future<void> _deleteWebhook(AppLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteWebhook),
        content: Text(l10n.deleteWebhookConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final result = await Injection.repoNotifier.deleteHook(
      widget.owner,
      widget.repo,
      widget.hook.id ?? 0,
    );

    if (mounted) {
      switch (result) {
        case Left(:final value):
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${l10n.error}: ${value.message}')),
          );
        case Right():
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.webhookDeleted)),
          );
          Navigator.of(context).pop(true);
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: UIConstants.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
