import 'package:igitea/core/storage/auth_method_storage.dart';
import 'package:igitea/core/storage/auth_storage.dart';

class FakeAuthStorage implements AuthStorage {
  SavedCredentials? _saved;

  @override
  Future<void> saveCredentials({
    required String baseUrl,
    required AuthMethod method,
    String? token,
    String? username,
    String? password,
    String? refreshToken,
  }) async {
    _saved = SavedCredentials(
      baseUrl: baseUrl,
      method: method,
      token: token,
      username: username,
      password: password,
      refreshToken: refreshToken,
    );
  }

  @override
  Future<SavedCredentials?> loadCredentials() async => _saved;

  @override
  Future<void> clear() async {
    _saved = null;
  }
}
