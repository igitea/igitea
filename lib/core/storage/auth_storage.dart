import 'package:shared_preferences/shared_preferences.dart';

import 'auth_method_storage.dart';

class AuthStorage {
  static const _keyBaseUrl = 'auth_base_url';
  static const _keyAuthMethod = 'auth_method';
  static const _keyToken = 'auth_token';
  static const _keyUsername = 'auth_username';
  static const _keyPassword = 'auth_password';
  static const _keyRefreshToken = 'auth_refresh_token';

  Future<void> saveCredentials({
    required String baseUrl,
    required AuthMethod method,
    String? token,
    String? username,
    String? password,
    String? refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyBaseUrl, baseUrl);
    await prefs.setString(_keyAuthMethod, method.name);
    if (token != null) {
      await prefs.setString(_keyToken, token);
    } else {
      await prefs.remove(_keyToken);
    }
    if (username != null) {
      await prefs.setString(_keyUsername, username);
    } else {
      await prefs.remove(_keyUsername);
    }
    if (password != null) {
      await prefs.setString(_keyPassword, password);
    } else {
      await prefs.remove(_keyPassword);
    }
    if (refreshToken != null) {
      await prefs.setString(_keyRefreshToken, refreshToken);
    } else {
      await prefs.remove(_keyRefreshToken);
    }
  }

  Future<SavedCredentials?> loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final baseUrl = prefs.getString(_keyBaseUrl);
    if (baseUrl == null) return null;

    final methodStr = prefs.getString(_keyAuthMethod);
    if (methodStr == null) return null;

    final method = AuthMethod.values.firstWhere(
      (m) => m.name == methodStr,
      orElse: () => AuthMethod.token,
    );

    return SavedCredentials(
      baseUrl: baseUrl,
      method: method,
      token: prefs.getString(_keyToken),
      username: prefs.getString(_keyUsername),
      password: prefs.getString(_keyPassword),
      refreshToken: prefs.getString(_keyRefreshToken),
    );
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyBaseUrl);
    await prefs.remove(_keyAuthMethod);
    await prefs.remove(_keyToken);
    await prefs.remove(_keyUsername);
    await prefs.remove(_keyPassword);
    await prefs.remove(_keyRefreshToken);
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
