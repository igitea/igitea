import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/di/injection.dart';
import '../../core/errors/failures.dart';
import '../../core/storage/auth_storage.dart';
import '../../core/storage/auth_method_storage.dart';
import '../../core/utils/either.dart';
import '../../data/datasources/remote/gitea_api_service.dart';
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

  Future<void> loginWithOAuth2({
    required String baseUrl,
    required String token,
    String? refreshToken,
  }) async {
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
          method: AuthMethod.oauth2,
          token: token,
          refreshToken: refreshToken,
          user: value,
        );
        await _storage.saveCredentials(
          baseUrl: baseUrl,
          method: AuthMethod.oauth2,
          token: token,
          refreshToken: refreshToken,
        );
        notifyListeners();
    }
  }

  Future<Map<String, dynamic>> exchangeOAuth2Code({
    required String baseUrl,
    required String clientId,
    required String clientSecret,
    required String code,
    required String redirectUri,
  }) async {
    return Injection.apiService.oauth2ExchangeCode(
      baseUrl: baseUrl,
      clientId: clientId,
      clientSecret: clientSecret,
      code: code,
      redirectUri: redirectUri,
    );
  }

  Future<void> openOAuth2Authorization({
    required String baseUrl,
    required String clientId,
    required String redirectUri,
  }) async {
    final uri = Uri.parse(baseUrl).replace(
      path: '/login/oauth/authorize',
      queryParameters: {
        'client_id': clientId,
        'redirect_uri': redirectUri,
        'response_type': 'code',
      },
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> restoreSession() async {
    if (_state is AuthAuthenticated) return;

    final saved = await _storage.loadCredentials();
    if (saved == null) return;

    if (saved.method == AuthMethod.token) {
      await loginWithToken(saved.baseUrl, saved.token!);
    } else if (saved.method == AuthMethod.oauth2) {
      await loginWithOAuth2(
        baseUrl: saved.baseUrl,
        token: saved.token!,
        refreshToken: saved.refreshToken,
      );
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
