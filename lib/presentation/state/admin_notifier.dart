import 'package:flutter/material.dart';

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

class AdminOperationState {
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

class AdminNotifier extends ChangeNotifier {
  SearchUsersUseCase _searchUsersUseCase;
  CreateUserUseCase _createUserUseCase;
  EditUserUseCase _editUserUseCase;
  DeleteUserUseCase _deleteUserUseCase;

  AdminUsersState _usersState = const AdminUsersInitial();
  AdminUsersState get usersState => _usersState;

  AdminOperationState _operationState = const AdminOperationInitial();
  AdminOperationState get operationState => _operationState;

  AdminNotifier({
    required SearchUsersUseCase searchUsersUseCase,
    required CreateUserUseCase createUserUseCase,
    required EditUserUseCase editUserUseCase,
    required DeleteUserUseCase deleteUserUseCase,
  }) : _searchUsersUseCase = searchUsersUseCase,
       _createUserUseCase = createUserUseCase,
       _editUserUseCase = editUserUseCase,
       _deleteUserUseCase = deleteUserUseCase;

  void updateUseCases({
    required SearchUsersUseCase searchUsersUseCase,
    required CreateUserUseCase createUserUseCase,
    required EditUserUseCase editUserUseCase,
    required DeleteUserUseCase deleteUserUseCase,
  }) {
    _searchUsersUseCase = searchUsersUseCase;
    _createUserUseCase = createUserUseCase;
    _editUserUseCase = editUserUseCase;
    _deleteUserUseCase = deleteUserUseCase;
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
}