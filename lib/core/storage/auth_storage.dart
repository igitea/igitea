import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'auth_method_storage.dart';

class AuthStorage {
  static const _keyBaseUrl = 'auth_base_url';
  static const _keyAuthMethod = 'auth_method';
  static const _keyToken = 'auth_token';
  static const _keyUsername = 'auth_username';
  static const _keyPassword = 'auth_password';
  static const _keyRefreshToken = 'auth_refresh_token';

  final FlutterSecureStorage _secureStorage;

  AuthStorage({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  Future<void> saveCredentials({
    required String baseUrl,
    required AuthMethod method,
    String? token,
    String? username,
    String? password,
    String? refreshToken,
  }) async {
    await _secureStorage.write(key: _keyBaseUrl, value: baseUrl);
    await _secureStorage.write(key: _keyAuthMethod, value: method.name);
    if (token != null) {
      await _secureStorage.write(key: _keyToken, value: token);
    } else {
      await _secureStorage.delete(key: _keyToken);
    }
    if (username != null) {
      await _secureStorage.write(key: _keyUsername, value: username);
    } else {
      await _secureStorage.delete(key: _keyUsername);
    }
    if (password != null) {
      await _secureStorage.write(key: _keyPassword, value: password);
    } else {
      await _secureStorage.delete(key: _keyPassword);
    }
    if (refreshToken != null) {
      await _secureStorage.write(key: _keyRefreshToken, value: refreshToken);
    } else {
      await _secureStorage.delete(key: _keyRefreshToken);
    }
  }

  Future<SavedCredentials?> loadCredentials() async {
    final baseUrl = await _secureStorage.read(key: _keyBaseUrl);
    if (baseUrl == null) return null;

    final methodStr = await _secureStorage.read(key: _keyAuthMethod);
    if (methodStr == null) return null;

    final method = AuthMethod.values.firstWhere(
      (m) => m.name == methodStr,
      orElse: () => AuthMethod.token,
    );

    return SavedCredentials(
      baseUrl: baseUrl,
      method: method,
      token: await _secureStorage.read(key: _keyToken),
      username: await _secureStorage.read(key: _keyUsername),
      password: await _secureStorage.read(key: _keyPassword),
      refreshToken: await _secureStorage.read(key: _keyRefreshToken),
    );
  }

  Future<void> clear() async {
    await _secureStorage.delete(key: _keyBaseUrl);
    await _secureStorage.delete(key: _keyAuthMethod);
    await _secureStorage.delete(key: _keyToken);
    await _secureStorage.delete(key: _keyUsername);
    await _secureStorage.delete(key: _keyPassword);
    await _secureStorage.delete(key: _keyRefreshToken);
  }
}

class SavedCredentials {
  final String baseUrl;
  final AuthMethod method;
  final String? token;
  final String? username;
  final String? password;
  final String? refreshToken;

  const SavedCredentials({
    required this.baseUrl,
    required this.method,
    this.token,
    this.username,
    this.password,
    this.refreshToken,
  });
}
