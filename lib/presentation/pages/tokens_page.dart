import 'package:flutter/material.dart';

import '../../core/di/injection.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../domain/entities/auth_state.dart';
import '../../l10n/app_localizations.dart';
import '../state/token_notifier.dart';

const _scopeGroups = [
  _ScopeGroup('User', [
    _ScopeItem('read:user', 'Read'),
    _ScopeItem('write:user', 'Write'),
  ]),
  _ScopeGroup('Repository', [
    _ScopeItem('read:repository', 'Read'),
    _ScopeItem('write:repository', 'Write'),
  ]),
  _ScopeGroup('Issue', [
    _ScopeItem('read:issue', 'Read'),
    _ScopeItem('write:issue', 'Write'),
  ]),
  _ScopeGroup('Pull Request', [
    _ScopeItem('read:pull_request', 'Read'),
    _ScopeItem('write:pull_request', 'Write'),
  ]),
  _ScopeGroup('Organization', [
    _ScopeItem('read:organization', 'Read'),
    _ScopeItem('write:organization', 'Write'),
  ]),
  _ScopeGroup('Miscellaneous', [
    _ScopeItem('read:misc', 'Read'),
    _ScopeItem('write:misc', 'Write'),
  ]),
  _ScopeGroup('Admin', [
    _ScopeItem('read:admin', 'Read'),
    _ScopeItem('write:admin', 'Write'),
  ]),
  _ScopeGroup('Notification', [
    _ScopeItem('read:notification', 'Read'),
    _ScopeItem('write:notification', 'Write'),
  ]),
  _ScopeGroup('Package', [
    _ScopeItem('read:package', 'Read'),
    _ScopeItem('write:package', 'Write'),
  ]),
  _ScopeGroup('GPG Key', [
    _ScopeItem('read:gpg_key', 'Read'),
    _ScopeItem('write:gpg_key', 'Write'),
  ]),
  _ScopeGroup('Public Key', [
    _ScopeItem('read:public_key', 'Read'),
    _ScopeItem('write:public_key', 'Write'),
  ]),
];

class _ScopeItem {
  final String value;
  final String label;
  const _ScopeItem(this.value, this.label);
}

class _ScopeGroup {
  final String name;
  final List<_ScopeItem> items;
  const _ScopeGroup(this.name, this.items);
}

class TokensPage extends StatefulWidget {
  const TokensPage({super.key});

  @override
  State<TokensPage> createState() => _TokensPageState();
}

class _TokensPageState extends State<TokensPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTokens();
    });
  }

  String _getUsername() {
    final auth = Injection.authNotifier.state;
    if (auth is AuthAuthenticated) return auth.user.login ?? '';
    return '';
  }

  Future<void> _loadTokens() async {
    final username = _getUsername();
    if (username.isNotEmpty) {
      Injection.tokenNotifier.listTokens(username);
    }
  }

  Future<void> _createToken() async {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController();
    final selectedScopes = <String>{};

    final result = await showDialog<_CreateResult>(
      context: context,
      builder: (ctx) => _CreateTokenDialog(
        nameController: nameController,
        selectedScopes: selectedScopes,
      ),
    );

    if (result == null || !mounted) return;

    final createResult = await Injection.tokenNotifier.createToken(
      result.name,
      scopes: result.scopes.isEmpty ? null : result.scopes.toList(),
    );
    if (!mounted) return;

    switch (createResult) {
      case Right<Failure, AccessToken>(:final value):
        _showTokenCreatedDialog(value);
        _loadTokens();
      case Left<Failure, AccessToken>(:final value):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.error}: ${value.message}')),
        );
    }
  }

  void _showTokenCreatedDialog(AccessToken token) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Theme.of(ctx).colorScheme.primary),
            const SizedBox(width: 8),
            Text(l10n.tokenCreated),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${l10n.tokenName}: ${token.name ?? ''}'),
            const SizedBox(height: 8),
            if (token.sha1 != null) ...[
              Text(
                l10n.tokenValueWarning,
                style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                  color: Theme.of(ctx).colorScheme.error,
                ),
              ),
              const SizedBox(height: 8),
              SelectableText(
                token.token_last_eight != null
                    ? '...${token.token_last_eight}'
                    : token.sha1!,
                style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteToken(AccessToken token) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteToken),
        content: Text('${l10n.deleteTokenConfirm} "${token.name ?? ''}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed != true || token.id == null) return;

    final success = await Injection.tokenNotifier.deleteToken(
      username: _getUsername(),
      tokenId: token.id!,
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.tokenDeleted)),
        );
      }
      _loadTokens();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.accessTokens),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _createToken,
            tooltip: l10n.createToken,
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: Injection.tokenNotifier,
        builder: (context, _) {
          final state = Injection.tokenNotifier.state;
          return switch (state) {
            TokenInitial() || TokenLoading() => const Center(child: CircularProgressIndicator()),
            TokenError(:final message) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${l10n.error}: $message'),
                  const SizedBox(height: 16),
                  FilledButton(onPressed: _loadTokens, child: Text(l10n.retry)),
                ],
              ),
            ),
            TokenListLoaded(:final tokens) => _buildTokenList(tokens, l10n),
            _ => _buildTokenList([], l10n),
          };
        },
      ),
    );
  }

  Widget _buildTokenList(List<AccessToken> tokens, AppLocalizations l10n) {
    if (tokens.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.key,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noTokens,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _createToken,
              icon: const Icon(Icons.add, size: 18),
              label: Text(l10n.createToken),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadTokens,
      child: ListView.separated(
        itemCount: tokens.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final token = tokens[index];
          final theme = Theme.of(context);
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(Icons.key, color: theme.colorScheme.onPrimaryContainer),
            ),
            title: Text(token.name ?? ''),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (token.token_last_eight != null)
                  Text(
                    '...${token.token_last_eight}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                if (token.created_at != null)
                  Text(
                    '${l10n.createdAt}: ${token.created_at!.toLocal().toString().split(' ')[0]}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _deleteToken(token),
            ),
          );
        },
      ),
    );
  }
}

class _CreateResult {
  final String name;
  final Set<String> scopes;
  const _CreateResult(this.name, this.scopes);
}

class _CreateTokenDialog extends StatefulWidget {
  final TextEditingController nameController;
  final Set<String> selectedScopes;

  const _CreateTokenDialog({
    required this.nameController,
    required this.selectedScopes,
  });

  @override
  State<_CreateTokenDialog> createState() => _CreateTokenDialogState();
}

class _CreateTokenDialogState extends State<_CreateTokenDialog> {
  final _expandedGroups = <String>{};
  bool _selectAll = false;

  @override
  void initState() {
    super.initState();
    _expandedGroups.addAll(_scopeGroups.map((g) => g.name));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(l10n.createToken),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: widget.nameController,
                decoration: InputDecoration(
                  labelText: l10n.tokenName,
                  border: const OutlineInputBorder(),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    l10n.scopes,
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectAll = !_selectAll;
                        if (_selectAll) {
                          widget.selectedScopes.addAll(
                            _scopeGroups.expand((g) => g.items).map((i) => i.value),
                          );
                        } else {
                          widget.selectedScopes.clear();
                        }
                      });
                    },
                    child: Text(_selectAll ? l10n.deselectAll : l10n.selectAll),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ..._scopeGroups.map((group) {
                final allSelected = group.items
                    .every((item) => widget.selectedScopes.contains(item.value));
                final someSelected = group.items
                    .any((item) => widget.selectedScopes.contains(item.value));
                final expanded = _expandedGroups.contains(group.name);

                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: theme.colorScheme.outlineVariant),
                  ),
                  child: Column(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          setState(() {
                            if (expanded) {
                              _expandedGroups.remove(group.name);
                            } else {
                              _expandedGroups.add(group.name);
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          child: Row(
                            children: [
                              Checkbox(
                                value: allSelected,
                                tristate: someSelected && !allSelected,
                                onChanged: (v) {
                                  setState(() {
                                    if (v == true) {
                                      widget.selectedScopes
                                          .addAll(group.items.map((i) => i.value));
                                    } else {
                                      widget.selectedScopes
                                          .removeAll(group.items.map((i) => i.value));
                                    }
                                  });
                                },
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  group.name,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Icon(
                                expanded ? Icons.expand_less : Icons.expand_more,
                                size: 20,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (expanded)
                        ...group.items.map((item) {
                          final isSelected =
                              widget.selectedScopes.contains(item.value);
                          return InkWell(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  widget.selectedScopes.remove(item.value);
                                } else {
                                  widget.selectedScopes.add(item.value);
                                }
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 52, right: 12, top: 4, bottom: 4),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: isSelected,
                                    onChanged: (v) {
                                      setState(() {
                                        if (v == true) {
                                          widget.selectedScopes.add(item.value);
                                        } else {
                                          widget.selectedScopes.remove(item.value);
                                        }
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    item.label,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: widget.nameController.text.trim().isEmpty
              ? null
              : () => Navigator.pop(
                    context,
                    _CreateResult(
                      widget.nameController.text.trim(),
                      Set.from(widget.selectedScopes),
                    ),
                  ),
          child: Text(l10n.create),
        ),
      ],
    );
  }
}
