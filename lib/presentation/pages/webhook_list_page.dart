import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../core/animations/animated_wrapper.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/forui/app_page.dart';
import '../widgets/forui/app_state_views.dart';
import '../widgets/forui/app_tile.dart';
import 'create_webhook_page.dart';

class WebhookListPage extends StatefulWidget {
  final String owner;
  final String repo;

  const WebhookListPage({super.key, required this.owner, required this.repo});

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
        builder: (_) =>
            CreateWebhookPage(owner: widget.owner, repo: widget.repo),
      ),
    );
    if (result == true) {
      _loadHooks();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppPage(
      title: l10n.webhooks,
      actions: [
        FHeaderAction(
          icon: const Icon(FIcons.plus),
          semanticsLabel: l10n.createWebhook,
          onPress: _createWebhook,
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
      return AppError(message: _error!, onRetry: _loadHooks);
    }
    if (_hooks.isEmpty) {
      return AppEmpty(
        icon: FIcons.webhook,
        title: l10n.noWebhooks,
        action: FButton(
          prefix: const Icon(FIcons.plus, size: 16),
          onPress: _createWebhook,
          child: Text(l10n.createWebhook),
        ),
      );
    }
    return _buildHookList(l10n);
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
          final active = hook.active == true;
          return FadeInWrapper(
            delay: Duration(milliseconds: index * 30),
            child: Padding(
              padding: const EdgeInsets.only(bottom: UIConstants.md),
              child: FCard.raw(
                child: AppTile(
                  leading: Icon(
                    FIcons.webhook,
                    size: UIConstants.iconMd,
                    color: active
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                  title: hook.type?.toUpperCase() ?? l10n.webhook,
                  subtitle: hook.config?['url']?.toString(),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        active ? FIcons.circleCheck : FIcons.circleX,
                        size: UIConstants.iconSm,
                        color: active
                            ? Colors.green
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: UIConstants.xs),
                      Text(
                        active ? l10n.webhookActive : l10n.webhookInactive,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: active
                              ? Colors.green
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  onPress: () {
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

    return AppPage(
      title:
          '${widget.hook.type?.toUpperCase() ?? l10n.webhook} #${widget.hook.id ?? 0}',
      actions: [
        FHeaderAction(
          icon: const Icon(FIcons.pencil),
          semanticsLabel: l10n.edit,
          onPress: () => _editWebhook(l10n),
        ),
        FHeaderAction(
          icon: const Icon(FIcons.trash2),
          semanticsLabel: l10n.delete,
          onPress: () => _deleteWebhook(l10n),
        ),
      ],
      child: ListView(
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
    return FCard.raw(
      child: Padding(
        padding: const EdgeInsets.all(UIConstants.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(FIcons.webhook, color: theme.colorScheme.primary),
                const SizedBox(width: UIConstants.sm),
                Text(
                  l10n.webhook,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                FBadge(
                  variant: widget.hook.active == true ? .primary : .destructive,
                  child: Text(
                    widget.hook.active == true
                        ? l10n.webhookActive
                        : l10n.webhookInactive,
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
    return FCard.raw(
      child: Padding(
        padding: const EdgeInsets.all(UIConstants.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.configuration,
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
    return FCard.raw(
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
              children: events
                  .map((event) => FBadge(variant: .outline, child: Text(event)))
                  .toList(),
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
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CreateWebhookPage(
          owner: widget.owner,
          repo: widget.repo,
          hook: widget.hook,
        ),
      ),
    );
    if (result == true && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _deleteWebhook(AppLocalizations l10n) async {
    final confirmed = await showFDialog<bool>(
      context: context,
      builder: (ctx, style, animation) => FDialog(
        title: Text(l10n.deleteWebhook),
        body: Text(l10n.deleteWebhookConfirm),
        actions: [
          FButton(
            variant: .outline,
            onPress: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FButton(
            variant: .destructive,
            onPress: () => Navigator.pop(ctx, true),
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
          showFToast(
            context: context,
            variant: .destructive,
            title: Text('${l10n.error}: ${value.message}'),
          );
        case Right():
          showFToast(context: context, title: Text(l10n.webhookDeleted));
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
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
