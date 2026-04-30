import '../../core/storage/auth_method_storage.dart';
import '../../data/models/generated/generated_models.dart';

sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final String baseUrl;
  final AuthMethod method;
  final String? token;
  final String? username;
  final String? password;
  final String? refreshToken;
  final User user;

  const AuthAuthenticated({
    required this.baseUrl,
    required this.method,
    required this.user,
    this.token,
    this.username,
    this.password,
    this.refreshToken,
  });
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);
}
