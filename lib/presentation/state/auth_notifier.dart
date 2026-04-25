import 'package:flutter/material.dart';

import '../../core/errors/failures.dart';
import '../../core/storage/auth_storage.dart';
import '../../core/storage/auth_method_storage.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../domain/entities/auth_state.dart';
import '../../domain/usecases/auth_usecases.dart';

class AuthNotifier extends ChangeNotifier {
  LoginUseCase _loginUseCase;
  // ignore: unused_field
  GetSettingsUseCase _getSettingsUseCase;
  final AuthStorage _storage;

  AuthState _state = const AuthInitial();
  AuthState get state => _state;
  set state(AuthState value) {
    _state = value;
    notifyListeners();
  }

  AuthNotifier({
    required LoginUseCase loginUseCase,
    required GetSettingsUseCase getSettingsUseCase,
    AuthStorage? storage,
  }) : _loginUseCase = loginUseCase,
       _getSettingsUseCase = getSettingsUseCase,
       _storage = storage ?? AuthStorage();

  void updateUseCases({
    required LoginUseCase loginUseCase,
    required GetSettingsUseCase getSettingsUseCase,
  }) {
    _loginUseCase = loginUseCase;
    _getSettingsUseCase = getSettingsUseCase;
  }

  Future<void> loginWithToken(String baseUrl, String token) async {
    _state = const AuthLoading();
    notifyListeners();

    final result = await _loginUseCase.call();
    switch (result) {
      case Left<Failure, User>(:final value):
        _state = AuthError(value.message);
        notifyListeners();
      case Right<Failure, User>(:final value):
        _state = AuthAuthenticated(
          baseUrl: baseUrl,
          method: AuthMethod.token,
          token: token,
          user: value,
        );
        await _storage.saveCredentials(
          baseUrl: baseUrl,
          method: AuthMethod.token,
          token: token,
        );
        notifyListeners();
    }
  }

  Future<void> loginWithBasicAuth(
    String baseUrl,
    String username,
    String password,
  ) async {
    _state = const AuthLoading();
    notifyListeners();

    final result = await _loginUseCase.call();
    switch (result) {
      case Left<Failure, User>(:final value):
        _state = AuthError(value.message);
        notifyListeners();
      case Right<Failure, User>(:final value):
        _state = AuthAuthenticated(
          baseUrl: baseUrl,
          method: AuthMethod.basic,
          username: username,
          password: password,
          user: value,
        );
        await _storage.saveCredentials(
          baseUrl: baseUrl,
          method: AuthMethod.basic,
          username: username,
          password: password,
        );
        notifyListeners();
    }
  }

  Future<void> restoreSession() async {
    if (_state is AuthAuthenticated) return;

    final saved = await _storage.loadCredentials();
    if (saved == null) return;

    if (saved.method == AuthMethod.token) {
      await loginWithToken(saved.baseUrl, saved.token!);
    } else {
      await loginWithBasicAuth(saved.baseUrl, saved.username!, saved.password!);
    }
  }

  Future<void> logout() async {
    await _storage.clear();
    _state = const AuthInitial();
    notifyListeners();
  }

  bool get isAuthenticated => _state is AuthAuthenticated;
  bool get isLoading => _state is AuthLoading;
}
