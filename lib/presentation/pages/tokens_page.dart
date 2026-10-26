import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../core/di/injection.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../domain/entities/auth_state.dart';
import '../../l10n/app_localizations.dart';
import '../state/token_notifier.dart';
import '../widgets/forui/app_page.dart';
import '../widgets/forui/app_state_views.dart';
import '../widgets/forui/app_tile.dart';
import '../theme/app_theme.dart';

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

    final result = await showFDialog<_CreateResult>(
      context: context,
      builder: (ctx, style, animation) => _CreateTokenDialog(
        nameController: nameController,
        selectedScopes: selectedScopes,
      ),
    );

    if (result == null || !mounted) return;

    final createResult = await Injection.tokenNotifier.createToken(
      _getUsername(),
      name: result.name,
      scopes: result.scopes.isEmpty ? null : result.scopes.toList(),
    );
    if (!mounted) return;

    switch (createResult) {
      case Right<Failure, AccessToken>(:final value):
        _showTokenCreatedDialog(value);
        _loadTokens();
      case Left<Failure, AccessToken>(:final value):
        showFToast(
          context: context,
          variant: .destructive,
          title: Text('${l10n.error}: ${value.message}'),
        );
    }
  }

  void _showTokenCreatedDialog(AccessToken token) {
    final l10n = AppLocalizations.of(context)!;

    showFDialog<void>(
      context: context,
      builder: (ctx, style, animation) => FDialog(
        title: Row(
          children: [
            Icon(FIcons.circleCheck, color: Theme.of(ctx).colorScheme.primary),
            const SizedBox(width: 8),
            Text(l10n.tokenCreated),
          ],
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${l10n.tokenName}: ${token.name ?? ''}'),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(
                  ctx,
                ).colorScheme.errorContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    FIcons.triangleAlert,
                    size: 18,
                    color: Theme.of(ctx).colorScheme.error,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.tokenValueWarning,
                      style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                        color: Theme.of(ctx).colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(ctx).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                token.sha1!,
                style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'monospace',
                  fontFamilyFallback: kMonoFontFallback,
                ),
              ),
            ),
          ],
        ),
        actions: [
          FButton(onPress: () => Navigator.pop(ctx), child: Text(l10n.ok)),
        ],
      ),
    );
  }

  Future<void> _deleteToken(AccessToken token) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showFDialog<bool>(
      context: context,
      builder: (ctx, style, animation) => FDialog(
        title: Text(l10n.deleteToken),
        body: Text('${l10n.deleteTokenConfirm} "${token.name ?? ''}"?'),
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

    if (confirmed != true || token.id == null) return;

    final success = await Injection.tokenNotifier.deleteToken(
      username: _getUsername(),
      tokenId: token.id!,
    );

    if (mounted) {
      if (success) {
        showFToast(context: context, title: Text(l10n.tokenDeleted));
      }
      _loadTokens();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppPage(
      title: l10n.accessTokens,
      actions: [
        FHeaderAction(
          icon: const Icon(FIcons.plus),
          semanticsLabel: l10n.createToken,
          onPress: _createToken,
        ),
      ],
      child: ListenableBuilder(
        listenable: Injection.tokenNotifier,
        builder: (context, _) {
          final state = Injection.tokenNotifier.state;
          return switch (state) {
            TokenInitial() => const SizedBox.shrink(),
            TokenLoading() => const AppLoading(),
            TokenError(:final message) => AppError(
              message: message,
              onRetry: _loadTokens,
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
      return AppEmpty(
        icon: FIcons.keyRound,
        title: l10n.noTokens,
        action: FButton(
          prefix: const Icon(FIcons.plus, size: 16),
          onPress: _createToken,
          child: Text(l10n.createToken),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadTokens,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        itemCount: tokens.length,
        itemBuilder: (context, index) {
          final token = tokens[index];
          final theme = Theme.of(context);
          final subtitle = [
            if (token.token_last_eight != null) '...${token.token_last_eight}',
            if (token.created_at != null)
              '${l10n.createdAt}: ${token.created_at!.toLocal().toString().split(' ')[0]}',
          ].join(' · ');

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: FCard.raw(
              child: AppTile(
                leading: Icon(
                  FIcons.keyRound,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
                title: token.name ?? '',
                subtitle: subtitle,
                showChevron: false,
                trailing: FTappable(
                  onPress: () => _deleteToken(token),
                  semanticsLabel: l10n.deleteToken,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      FIcons.trash2,
                      size: 16,
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
                onPress: null,
              ),
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
  final _nameFocusNode = FocusNode();
  bool _selectAll = false;

  @override
  void initState() {
    super.initState();
    _expandedGroups.addAll(_scopeGroups.map((g) => g.name));
    widget.nameController.addListener(_onNameChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _nameFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    widget.nameController.removeListener(_onNameChanged);
    _nameFocusNode.dispose();
    super.dispose();
  }

  void _onNameChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return FDialog(
      title: Text(l10n.createToken),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            FTextField(
              control: FTextFieldControl.managed(
                controller: widget.nameController,
              ),
              focusNode: _nameFocusNode,
              label: Text(l10n.tokenName),
              maxLength: 255,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  l10n.scopes,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                FButton(
                  variant: .ghost,
                  size: .sm,
                  onPress: () {
                    setState(() {
                      _selectAll = !_selectAll;
                      if (_selectAll) {
                        widget.selectedScopes.addAll(
                          _scopeGroups
                              .expand((g) => g.items)
                              .map((i) => i.value),
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
              final allSelected = group.items.every(
                (item) => widget.selectedScopes.contains(item.value),
              );
              final expanded = _expandedGroups.contains(group.name);

              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: FCard.raw(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          FCheckbox(
                            value: allSelected,
                            semanticsLabel: group.name,
                            onChange: (v) {
                              setState(() {
                                if (v) {
                                  widget.selectedScopes.addAll(
                                    group.items.map((i) => i.value),
                                  );
                                } else {
                                  widget.selectedScopes.removeAll(
                                    group.items.map((i) => i.value),
                                  );
                                }
                              });
                            },
                          ),
                          Expanded(
                            child: FTappable(
                              onPress: () {
                                setState(() {
                                  if (expanded) {
                                    _expandedGroups.remove(group.name);
                                  } else {
                                    _expandedGroups.add(group.name);
                                  }
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 10,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        group.name,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ),
                                    Icon(
                                      expanded
                                          ? FIcons.chevronUp
                                          : FIcons.chevronDown,
                                      size: 20,
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (expanded)
                        ...group.items.map((item) {
                          final isSelected = widget.selectedScopes.contains(
                            item.value,
                          );
                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 40,
                              right: 12,
                              top: 4,
                              bottom: 4,
                            ),
                            child: FCheckbox(
                              value: isSelected,
                              label: Text(item.label),
                              onChange: (v) {
                                setState(() {
                                  if (v) {
                                    widget.selectedScopes.add(item.value);
                                  } else {
                                    widget.selectedScopes.remove(item.value);
                                  }
                                });
                              },
                            ),
                          );
                        }),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
      actions: [
        FButton(
          variant: .outline,
          onPress: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FButton(
          onPress: widget.nameController.text.trim().isEmpty
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
