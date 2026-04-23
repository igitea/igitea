/// Base exception for all remote data source errors.
class ServerException implements Exception {
  final String message;

  const ServerException(this.message);

  @override
  String toString() => 'ServerException: $message';
}

/// Thrown when the server responds with 401 or 403.
class AuthenticationException implements Exception {
  final String message;

  const AuthenticationException(this.message);

  @override
  String toString() => 'AuthenticationException: $message';
}

/// Thrown when a network-level failure occurs (no connectivity, timeout, etc.).
class NetworkException implements Exception {
  final String message;

  const NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}
