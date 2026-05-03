import 'package:flutter/material.dart' hide Badge;

import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../domain/usecases/admin_usecases.dart';

sealed class AdminUsersState {
  const AdminUsersState();
}

class AdminUsersInitial extends AdminUsersState {
  const AdminUsersInitial();
}

class AdminUsersLoading extends AdminUsersState {
  const AdminUsersLoading();
}

class AdminUsersLoaded extends AdminUsersState {
  final List<User> users;
  const AdminUsersLoaded(this.users);
}

class AdminUsersError extends AdminUsersState {
  final String message;
  const AdminUsersError(this.message);
}

sealed class AdminOperationState {
  const AdminOperationState();
}

class AdminOperationInitial extends AdminOperationState {
  const AdminOperationInitial();
}

class AdminOperationLoading extends AdminOperationState {
  const AdminOperationLoading();
}

class AdminOperationSuccess extends AdminOperationState {
  const AdminOperationSuccess();
}

class AdminOperationError extends AdminOperationState {
  final String message;
  const AdminOperationError(this.message);
}

sealed class AdminHooksState {
  const AdminHooksState();
}

class AdminHooksInitial extends AdminHooksState {
  const AdminHooksInitial();
}

class AdminHooksLoading extends AdminHooksState {
  const AdminHooksLoading();
}

class AdminHooksLoaded extends AdminHooksState {
  final List<Hook> hooks;
  const AdminHooksLoaded(this.hooks);
}

class AdminHooksError extends AdminHooksState {
  final String message;
  const AdminHooksError(this.message);
}

sealed class AdminCronState {
  const AdminCronState();
}

class AdminCronInitial extends AdminCronState {
  const AdminCronInitial();
}

class AdminCronLoading extends AdminCronState {
  const AdminCronLoading();
}

class AdminCronLoaded extends AdminCronState {
  final List<Cron> tasks;
  const AdminCronLoaded(this.tasks);
}

class AdminCronError extends AdminCronState {
  final String message;
  const AdminCronError(this.message);
}

sealed class AdminRunnersState {
  const AdminRunnersState();
}

class AdminRunnersInitial extends AdminRunnersState {
  const AdminRunnersInitial();
}

class AdminRunnersLoading extends AdminRunnersState {
  const AdminRunnersLoading();
}

class AdminRunnersLoaded extends AdminRunnersState {
  final List<ActionRunner> runners;
  const AdminRunnersLoaded(this.runners);
}

class AdminRunnersError extends AdminRunnersState {
  final String message;
  const AdminRunnersError(this.message);
}

sealed class AdminEmailsState {
  const AdminEmailsState();
}

class AdminEmailsInitial extends AdminEmailsState {
  const AdminEmailsInitial();
}

class AdminEmailsLoading extends AdminEmailsState {
  const AdminEmailsLoading();
}

class AdminEmailsLoaded extends AdminEmailsState {
  final List<Email> emails;
  const AdminEmailsLoaded(this.emails);
}

class AdminEmailsError extends AdminEmailsState {
  final String message;
  const AdminEmailsError(this.message);
}

sealed class AdminBadgesState {
  const AdminBadgesState();
}

class AdminBadgesInitial extends AdminBadgesState {
  const AdminBadgesInitial();
}

class AdminBadgesLoading extends AdminBadgesState {
  const AdminBadgesLoading();
}

class AdminBadgesLoaded extends AdminBadgesState {
  final List<Badge> badges;
  const AdminBadgesLoaded(this.badges);
}

class AdminBadgesError extends AdminBadgesState {
  final String message;
  const AdminBadgesError(this.message);
}

class AdminNotifier extends ChangeNotifier {
  SearchUsersUseCase _searchUsersUseCase;
  CreateUserUseCase _createUserUseCase;
  EditUserUseCase _editUserUseCase;
  DeleteUserUseCase _deleteUserUseCase;
  ListAdminHooksUseCase _listAdminHooksUseCase;
  GetAdminHookUseCase _getAdminHookUseCase;
  DeleteAdminHookUseCase _deleteAdminHookUseCase;
  ListCronTasksUseCase _listCronTasksUseCase;
  RunCronTaskUseCase _runCronTaskUseCase;
  ListAdminRunnersUseCase _listAdminRunnersUseCase;
  GetAdminRunnerUseCase _getAdminRunnerUseCase;
  GetAdminRunnerRegistrationTokenUseCase _getAdminRunnerRegistrationTokenUseCase;
  ListAdminEmailsUseCase _listAdminEmailsUseCase;
  ListUserBadgesUseCase _listUserBadgesUseCase;
  CreateUserBadgeUseCase _createUserBadgeUseCase;
  DeleteUserBadgeUseCase _deleteUserBadgeUseCase;

  AdminUsersState _usersState = const AdminUsersInitial();
  AdminUsersState get usersState => _usersState;

  AdminOperationState _operationState = const AdminOperationInitial();
  AdminOperationState get operationState => _operationState;

  AdminHooksState _hooksState = const AdminHooksInitial();
  AdminHooksState get hooksState => _hooksState;

  AdminCronState _cronState = const AdminCronInitial();
  AdminCronState get cronState => _cronState;

  AdminRunnersState _runnersState = const AdminRunnersInitial();
  AdminRunnersState get runnersState => _runnersState;

  AdminEmailsState _emailsState = const AdminEmailsInitial();
  AdminEmailsState get emailsState => _emailsState;

  AdminBadgesState _badgesState = const AdminBadgesInitial();
  AdminBadgesState get badgesState => _badgesState;

  AdminNotifier({
    required SearchUsersUseCase searchUsersUseCase,
    required CreateUserUseCase createUserUseCase,
    required EditUserUseCase editUserUseCase,
    required DeleteUserUseCase deleteUserUseCase,
    required ListAdminHooksUseCase listAdminHooksUseCase,
    required GetAdminHookUseCase getAdminHookUseCase,
    required DeleteAdminHookUseCase deleteAdminHookUseCase,
    required ListCronTasksUseCase listCronTasksUseCase,
    required RunCronTaskUseCase runCronTaskUseCase,
    required ListAdminRunnersUseCase listAdminRunnersUseCase,
    required GetAdminRunnerUseCase getAdminRunnerUseCase,
    required GetAdminRunnerRegistrationTokenUseCase getAdminRunnerRegistrationTokenUseCase,
    required ListAdminEmailsUseCase listAdminEmailsUseCase,
    required ListUserBadgesUseCase listUserBadgesUseCase,
    required CreateUserBadgeUseCase createUserBadgeUseCase,
    required DeleteUserBadgeUseCase deleteUserBadgeUseCase,
  }) : _searchUsersUseCase = searchUsersUseCase,
       _createUserUseCase = createUserUseCase,
       _editUserUseCase = editUserUseCase,
       _deleteUserUseCase = deleteUserUseCase,
       _listAdminHooksUseCase = listAdminHooksUseCase,
       _getAdminHookUseCase = getAdminHookUseCase,
       _deleteAdminHookUseCase = deleteAdminHookUseCase,
       _listCronTasksUseCase = listCronTasksUseCase,
       _runCronTaskUseCase = runCronTaskUseCase,
       _listAdminRunnersUseCase = listAdminRunnersUseCase,
       _getAdminRunnerUseCase = getAdminRunnerUseCase,
       _getAdminRunnerRegistrationTokenUseCase = getAdminRunnerRegistrationTokenUseCase,
       _listAdminEmailsUseCase = listAdminEmailsUseCase,
       _listUserBadgesUseCase = listUserBadgesUseCase,
       _createUserBadgeUseCase = createUserBadgeUseCase,
       _deleteUserBadgeUseCase = deleteUserBadgeUseCase;

  void updateUseCases({
    required SearchUsersUseCase searchUsersUseCase,
    required CreateUserUseCase createUserUseCase,
    required EditUserUseCase editUserUseCase,
    required DeleteUserUseCase deleteUserUseCase,
    required ListAdminHooksUseCase listAdminHooksUseCase,
    required GetAdminHookUseCase getAdminHookUseCase,
    required DeleteAdminHookUseCase deleteAdminHookUseCase,
    required ListCronTasksUseCase listCronTasksUseCase,
    required RunCronTaskUseCase runCronTaskUseCase,
    required ListAdminRunnersUseCase listAdminRunnersUseCase,
    required GetAdminRunnerUseCase getAdminRunnerUseCase,
    required GetAdminRunnerRegistrationTokenUseCase getAdminRunnerRegistrationTokenUseCase,
    required ListAdminEmailsUseCase listAdminEmailsUseCase,
    required ListUserBadgesUseCase listUserBadgesUseCase,
    required CreateUserBadgeUseCase createUserBadgeUseCase,
    required DeleteUserBadgeUseCase deleteUserBadgeUseCase,
  }) {
    _searchUsersUseCase = searchUsersUseCase;
    _createUserUseCase = createUserUseCase;
    _editUserUseCase = editUserUseCase;
    _deleteUserUseCase = deleteUserUseCase;
    _listAdminHooksUseCase = listAdminHooksUseCase;
    _getAdminHookUseCase = getAdminHookUseCase;
    _deleteAdminHookUseCase = deleteAdminHookUseCase;
    _listCronTasksUseCase = listCronTasksUseCase;
    _runCronTaskUseCase = runCronTaskUseCase;
    _listAdminRunnersUseCase = listAdminRunnersUseCase;
    _getAdminRunnerUseCase = getAdminRunnerUseCase;
    _getAdminRunnerRegistrationTokenUseCase = getAdminRunnerRegistrationTokenUseCase;
    _listAdminEmailsUseCase = listAdminEmailsUseCase;
    _listUserBadgesUseCase = listUserBadgesUseCase;
    _createUserBadgeUseCase = createUserBadgeUseCase;
    _deleteUserBadgeUseCase = deleteUserBadgeUseCase;
  }

  Future<void> searchUsers({int? sourceId, String? loginName, int? page, int? limit}) async {
    _usersState = const AdminUsersLoading();
    notifyListeners();

    final result = await _searchUsersUseCase.call(
      SearchUsersParams(source_id: sourceId, login_name: loginName, page: page, limit: limit),
    );
    switch (result) {
      case Left<Failure, List<User>>(:final value):
        _usersState = AdminUsersError(value.message);
        notifyListeners();
      case Right<Failure, List<User>>(:final value):
        _usersState = AdminUsersLoaded(value);
        notifyListeners();
    }
  }

  Future<void> createUser(Map<String, dynamic> body) async {
    _operationState = const AdminOperationLoading();
    notifyListeners();

    final result = await _createUserUseCase.call(body);
    switch (result) {
      case Left<Failure, User>(:final value):
        _operationState = AdminOperationError(value.message);
        notifyListeners();
      case Right<Failure, User>():
        _operationState = const AdminOperationSuccess();
        notifyListeners();
    }
  }

  Future<void> editUser(String username, Map<String, dynamic> body) async {
    _operationState = const AdminOperationLoading();
    notifyListeners();

    final result = await _editUserUseCase.call(EditUserParams(username: username, body: body));
    switch (result) {
      case Left<Failure, User>(:final value):
        _operationState = AdminOperationError(value.message);
        notifyListeners();
      case Right<Failure, User>():
        _operationState = const AdminOperationSuccess();
        notifyListeners();
    }
  }

  Future<void> deleteUser(String username, {bool? purge}) async {
    _operationState = const AdminOperationLoading();
    notifyListeners();

    final result = await _deleteUserUseCase.call(DeleteUserParams(username: username, purge: purge));
    switch (result) {
      case Left<Failure, void>(:final value):
        _operationState = AdminOperationError(value.message);
        notifyListeners();
      case Right<Failure, void>():
        _operationState = const AdminOperationSuccess();
        notifyListeners();
    }
  }

  void resetOperationState() {
    _operationState = const AdminOperationInitial();
    notifyListeners();
  }

  Future<void> loadHooks({int? page, int? limit, String? type}) async {
    _hooksState = const AdminHooksLoading();
    notifyListeners();

    final result = await _listAdminHooksUseCase.call(page: page, limit: limit, type: type);
    switch (result) {
      case Left<Failure, List<Hook>>(:final value):
        _hooksState = AdminHooksError(value.message);
        notifyListeners();
      case Right<Failure, List<Hook>>(:final value):
        _hooksState = AdminHooksLoaded(value);
        notifyListeners();
    }
  }

  Future<void> deleteHook(int id) async {
    _operationState = const AdminOperationLoading();
    notifyListeners();

    final result = await _deleteAdminHookUseCase.call(id);
    switch (result) {
      case Left<Failure, void>(:final value):
        _operationState = AdminOperationError(value.message);
        notifyListeners();
      case Right<Failure, void>():
        _operationState = const AdminOperationSuccess();
        notifyListeners();
    }
  }

  Future<void> loadCronTasks({int? page, int? limit}) async {
    _cronState = const AdminCronLoading();
    notifyListeners();

    final result = await _listCronTasksUseCase.call(page: page, limit: limit);
    switch (result) {
      case Left<Failure, List<Cron>>(:final value):
        _cronState = AdminCronError(value.message);
        notifyListeners();
      case Right<Failure, List<Cron>>(:final value):
        _cronState = AdminCronLoaded(value);
        notifyListeners();
    }
  }

  Future<void> runCronTask(String task) async {
    _operationState = const AdminOperationLoading();
    notifyListeners();

    final result = await _runCronTaskUseCase.call(task);
    switch (result) {
      case Left<Failure, void>(:final value):
        _operationState = AdminOperationError(value.message);
        notifyListeners();
      case Right<Failure, void>():
        _operationState = const AdminOperationSuccess();
        notifyListeners();
    }
  }

  Future<void> loadRunners({int? page, int? limit}) async {
    _runnersState = const AdminRunnersLoading();
    notifyListeners();

    final result = await _listAdminRunnersUseCase.call(page: page, limit: limit);
    switch (result) {
      case Left<Failure, List<ActionRunner>>(:final value):
        _runnersState = AdminRunnersError(value.message);
        notifyListeners();
      case Right<Failure, List<ActionRunner>>(:final value):
        _runnersState = AdminRunnersLoaded(value);
        notifyListeners();
    }
  }

  Future<void> loadEmails({int? page, int? limit}) async {
    _emailsState = const AdminEmailsLoading();
    notifyListeners();

    final result = await _listAdminEmailsUseCase.call(page: page, limit: limit);
    switch (result) {
      case Left<Failure, List<Email>>(:final value):
        _emailsState = AdminEmailsError(value.message);
        notifyListeners();
      case Right<Failure, List<Email>>(:final value):
        _emailsState = AdminEmailsLoaded(value);
        notifyListeners();
    }
  }

  Future<void> loadBadges(String username) async {
    _badgesState = const AdminBadgesLoading();
    notifyListeners();

    final result = await _listUserBadgesUseCase.call(username);
    if (result.isLeft) {
      _badgesState = AdminBadgesError(result.getLeftOrElse(const ServerFailure('')).message);
      notifyListeners();
    } else {
      _badgesState = AdminBadgesLoaded(result.getRightOrElse([]));
      notifyListeners();
    }
  }

  Future<void> createBadge(String username, Map<String, dynamic> body) async {
    _operationState = const AdminOperationLoading();
    notifyListeners();

    final result = await _createUserBadgeUseCase.call(CreateUserBadgeParams(username: username, body: body));
    if (result.isLeft) {
      _operationState = AdminOperationError(result.getLeftOrElse(const ServerFailure('')).message);
      notifyListeners();
    } else {
      _operationState = const AdminOperationSuccess();
      notifyListeners();
    }
  }

  Future<void> deleteBadge(String username, int badgeId) async {
    _operationState = const AdminOperationLoading();
    notifyListeners();

    final result = await _deleteUserBadgeUseCase.call(DeleteUserBadgeParams(username: username, badgeId: badgeId));
    switch (result) {
      case Left<Failure, void>(:final value):
        _operationState = AdminOperationError(value.message);
        notifyListeners();
      case Right<Failure, void>():
        _operationState = const AdminOperationSuccess();
        notifyListeners();
    }
  }

  Future<Hook?> getHookDetail(int id) async {
    final result = await _getAdminHookUseCase.call(id);
    return switch (result) {
      Left<Failure, Hook>() => null,
      Right<Failure, Hook>(:final value) => value,
    };
  }

  Future<ActionRunner?> getRunnerDetail(int runnerId) async {
    final result = await _getAdminRunnerUseCase.call(runnerId);
    return switch (result) {
      Left<Failure, ActionRunner>() => null,
      Right<Failure, ActionRunner>(:final value) => value,
    };
  }

  Future<String?> getRunnerRegistrationToken() async {
    final result = await _getAdminRunnerRegistrationTokenUseCase.call();
    return switch (result) {
      Left<Failure, String>() => null,
      Right<Failure, String>(:final value) => value,
    };
  }
}
