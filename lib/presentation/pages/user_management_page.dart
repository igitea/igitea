import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../state/admin_notifier.dart';
import '../widgets/forui/app_page.dart';
import '../widgets/forui/app_state_views.dart';
import '../widgets/forui/app_tile.dart';
import '../widgets/user_avatar.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Injection.adminNotifier.searchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppPage(
      title: l10n.userManagement,
      actions: [
        FHeaderAction(
          icon: const Icon(FIcons.plus),
          semanticsLabel: l10n.create,
          onPress: () => _showCreateUserDialog(context),
        ),
      ],
      child: ListenableBuilder(
        listenable: Injection.adminNotifier,
        builder: (context, _) {
          final usersState = Injection.adminNotifier.usersState;
          return switch (usersState) {
            AdminUsersLoading() => const AppLoading(),
            AdminUsersError(:final message) => AppError(
              message: message,
              onRetry: () => Injection.adminNotifier.searchUsers(),
            ),
            AdminUsersLoaded(:final users, :final hasMore) => _UserList(
              users: users,
              hasMore: hasMore,
            ),
            _ => const AppLoading(),
          };
        },
      ),
    );
  }

  void _showCreateUserDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showFDialog<void>(
      context: context,
      builder: (ctx, style, animation) => _UserFormDialog(
        title: l10n.createUser,
        onSubmit: (body) async {
          await Injection.adminNotifier.createUser(body);
          if (ctx.mounted) {
            final opState = Injection.adminNotifier.operationState;
            if (opState is AdminOperationSuccess) {
              Navigator.of(ctx).pop();
              Injection.adminNotifier.searchUsers();
              showFToast(context: context, title: Text(l10n.userCreated));
            } else if (opState is AdminOperationError) {
              showFToast(
                context: context,
                variant: .destructive,
                title: Text('${l10n.error}: ${opState.message}'),
              );
            }
            Injection.adminNotifier.resetOperationState();
          }
        },
      ),
    );
  }
}

class _UserList extends StatelessWidget {
  final List<User> users;
  final bool hasMore;

  const _UserList({required this.users, required this.hasMore});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (users.isEmpty) {
      return AppEmpty(icon: FIcons.users, title: l10n.noUsersFound);
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      itemCount: users.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        final theme = Theme.of(context);
        if (index == users.length) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Injection.adminNotifier.usersLoadingMore
                  ? const FCircularProgress(size: .sm)
                  : FButton(
                      variant: .ghost,
                      size: .sm,
                      onPress: () => Injection.adminNotifier.loadMoreUsers(),
                      child: const Text('Load more users'),
                    ),
            ),
          );
        }
        final user = users[index];
        final subtitle = [
          if (user.email?.isNotEmpty == true) user.email!,
          if (user.is_admin == true) l10n.admin,
        ].join(' · ');

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: FCard.raw(
            child: AppTile(
              leading: UserAvatar(user: user, radius: 20),
              title: user.login ?? l10n.unknown,
              subtitle: subtitle,
              showChevron: false,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FTappable(
                    onPress: () => _showEditUserDialog(context, user),
                    semanticsLabel: l10n.edit,
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        FIcons.pencil,
                        size: 16,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  FTappable(
                    onPress: () => _showDeleteUserDialog(context, user),
                    semanticsLabel: l10n.delete,
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        FIcons.trash2,
                        size: 16,
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
              onPress: null,
            ),
          ),
        );
      },
    );
  }

  void _showEditUserDialog(BuildContext context, User user) {
    final l10n = AppLocalizations.of(context)!;
    showFDialog<void>(
      context: context,
      builder: (ctx, style, animation) => _UserFormDialog(
        title: l10n.editUser,
        user: user,
        onSubmit: (body) async {
          await Injection.adminNotifier.editUser(user.login!, body);
          if (ctx.mounted) {
            final opState = Injection.adminNotifier.operationState;
            if (opState is AdminOperationSuccess) {
              Navigator.of(ctx).pop();
              Injection.adminNotifier.searchUsers();
              showFToast(context: context, title: Text(l10n.userUpdated));
            } else if (opState is AdminOperationError) {
              showFToast(
                context: context,
                variant: .destructive,
                title: Text('${l10n.error}: ${opState.message}'),
              );
            }
            Injection.adminNotifier.resetOperationState();
          }
        },
      ),
    );
  }

  void _showDeleteUserDialog(BuildContext context, User user) {
    final l10n = AppLocalizations.of(context)!;
    showFDialog<void>(
      context: context,
      builder: (ctx, style, animation) => FDialog(
        title: Text(l10n.deleteUser),
        body: Text(l10n.deleteUserConfirmParams(user.login ?? '')),
        actions: [
          FButton(
            variant: .outline,
            onPress: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel),
          ),
          FButton(
            variant: .destructive,
            onPress: () async {
              await Injection.adminNotifier.deleteUser(user.login!);
              if (ctx.mounted) {
                Navigator.of(ctx).pop();
                Injection.adminNotifier.searchUsers();
                showFToast(context: context, title: Text(l10n.userDeleted));
              }
            },
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
}

class _UserFormDialog extends StatefulWidget {
  final String title;
  final User? user;
  final ValueChanged<Map<String, dynamic>> onSubmit;

  const _UserFormDialog({
    required this.title,
    this.user,
    required this.onSubmit,
  });

  @override
  State<_UserFormDialog> createState() => _UserFormDialogState();
}

class _UserFormDialogState extends State<_UserFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _loginNameController = TextEditingController(
    text: widget.user?.login ?? '',
  );
  late final _emailController = TextEditingController(
    text: widget.user?.email ?? '',
  );
  late final _fullNameController = TextEditingController(
    text: widget.user?.full_name ?? '',
  );
  final _passwordController = TextEditingController();
  bool _isAdmin = false;
  bool _mustChangePassword = false;

  @override
  void dispose() {
    _loginNameController.dispose();
    _emailController.dispose();
    _fullNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FDialog(
      title: Text(widget.title),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FTextFormField(
                control: FTextFieldControl.managed(
                  controller: _loginNameController,
                ),
                label: Text(l10n.username),
                enabled: widget.user == null,
                validator: (value) =>
                    value?.isEmpty == true ? l10n.pleaseEnterUsername : null,
              ),
              const SizedBox(height: 12),
              FTextFormField(
                control: FTextFieldControl.managed(
                  controller: _emailController,
                ),
                label: Text(l10n.email),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value?.isEmpty == true ? l10n.pleaseEnterEmail : null,
              ),
              const SizedBox(height: 12),
              FTextFormField(
                control: FTextFieldControl.managed(
                  controller: _fullNameController,
                ),
                label: Text(l10n.fullName),
              ),
              const SizedBox(height: 12),
              if (widget.user == null) ...[
                FTextFormField(
                  control: FTextFieldControl.managed(
                    controller: _passwordController,
                  ),
                  label: Text(l10n.password),
                  obscureText: true,
                  validator: (value) =>
                      value?.isEmpty == true ? l10n.pleaseEnterPassword : null,
                ),
                const SizedBox(height: 8),
                FCheckbox(
                  value: _mustChangePassword,
                  onChange: (v) => setState(() => _mustChangePassword = v),
                  label: Text(l10n.mustChangePassword),
                ),
              ],
              FCheckbox(
                value: _isAdmin,
                onChange: (v) => setState(() => _isAdmin = v),
                label: Text(l10n.admin),
              ),
            ],
          ),
        ),
      ),
      actions: [
        FButton(
          variant: .outline,
          onPress: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FButton(
          onPress: () {
            if (_formKey.currentState?.validate() ?? false) {
              final body = <String, dynamic>{
                'login_name': _loginNameController.text,
                'email': _emailController.text,
                'full_name': _fullNameController.text,
                'admin': _isAdmin,
              };
              if (widget.user == null) {
                body['password'] = _passwordController.text;
                body['must_change_password'] = _mustChangePassword;
                body['username'] = _loginNameController.text;
              }
              widget.onSubmit(body);
            }
          },
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
