import 'package:flutter/material.dart';

import '../../core/animations/animated_wrapper.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../../presentation/state/admin_notifier.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.userManagement),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: l10n.create,
            onPressed: () => _showCreateUserDialog(context),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: Injection.adminNotifier,
        builder: (context, _) {
          final usersState = Injection.adminNotifier.usersState;
          return switch (usersState) {
            AdminUsersLoading() => const Center(child: CircularProgressIndicator()),
            AdminUsersError(:final message) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${l10n.error}: $message'),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => Injection.adminNotifier.searchUsers(),
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            ),
            AdminUsersLoaded(:final users) => _UserList(users: users),
            _ => const Center(child: CircularProgressIndicator()),
          };
        },
      ),
    );
  }

  void _showCreateUserDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => _UserFormDialog(
        title: l10n.createUser,
        onSubmit: (body) async {
          await Injection.adminNotifier.createUser(body);
          if (ctx.mounted) {
            final opState = Injection.adminNotifier.operationState;
            if (opState is AdminOperationSuccess) {
              Navigator.of(ctx).pop();
              Injection.adminNotifier.searchUsers();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.userCreated)),
              );
            } else if (opState is AdminOperationError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${l10n.error}: ${opState.message}')),
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

  const _UserList({required this.users});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (users.isEmpty) {
      return Center(child: Text(l10n.noUsersFound));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return FadeInWrapper(
          delay: Duration(milliseconds: index * 30),
          child: Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: UserAvatar(user: user, radius: 20),
              title: Text(user.login ?? l10n.unknown),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (user.email?.isNotEmpty == true) Text(user.email!),
                  if (user.is_admin == true)
                    Chip(
                      label: Text(l10n.admin),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                ],
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    _showEditUserDialog(context, user);
                  } else if (value == 'delete') {
                    _showDeleteUserDialog(context, user);
                  }
                },
                itemBuilder: (ctx) => [
                  PopupMenuItem(value: 'edit', child: Text(l10n.edit)),
                  PopupMenuItem(value: 'delete', child: Text(l10n.delete)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showEditUserDialog(BuildContext context, User user) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => _UserFormDialog(
        title: l10n.editUser,
        user: user,
        onSubmit: (body) async {
          await Injection.adminNotifier.editUser(user.login!, body);
          if (ctx.mounted) {
            final opState = Injection.adminNotifier.operationState;
            if (opState is AdminOperationSuccess) {
              Navigator.of(ctx).pop();
              Injection.adminNotifier.searchUsers();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.userUpdated)),
              );
            } else if (opState is AdminOperationError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${l10n.error}: ${opState.message}')),
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
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteUser),
        content: Text(l10n.deleteUserConfirmParams(user.login ?? '')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              await Injection.adminNotifier.deleteUser(user.login!);
              if (ctx.mounted) {
                Navigator.of(ctx).pop();
                Injection.adminNotifier.searchUsers();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.userDeleted)),
                );
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
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

  const _UserFormDialog({required this.title, this.user, required this.onSubmit});

  @override
  State<_UserFormDialog> createState() => _UserFormDialogState();
}

class _UserFormDialogState extends State<_UserFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _loginNameController = TextEditingController(text: widget.user?.login ?? '');
  late final _emailController = TextEditingController(text: widget.user?.email ?? '');
  late final _fullNameController = TextEditingController(text: widget.user?.full_name ?? '');
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
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _loginNameController,
                decoration: InputDecoration(labelText: l10n.username),
                enabled: widget.user == null,
                validator: (value) => value?.isEmpty == true ? l10n.pleaseEnterUsername : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: l10n.email),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value?.isEmpty == true ? l10n.pleaseEnterEmail : null,
              ),
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(labelText: l10n.fullName),
              ),
              if (widget.user == null) ...[
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: l10n.password),
                  obscureText: true,
                  validator: (value) => value?.isEmpty == true ? l10n.pleaseEnterPassword : null,
                ),
                CheckboxListTile(
                  title: Text(l10n.mustChangePassword),
                  value: _mustChangePassword,
                  onChanged: (v) => setState(() => _mustChangePassword = v ?? false),
                ),
              ],
              CheckboxListTile(
                title: Text(l10n.admin),
                value: _isAdmin,
                onChanged: (v) => setState(() => _isAdmin = v ?? false),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
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