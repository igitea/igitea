/// Base class for all domain-level failures.
///
/// Failures represent errors that have been mapped from exceptions
/// and are safe to present in the UI layer.
abstract class Failure {
  final String message;

  const Failure(this.message);
}

/// Failure originating from server-side errors.
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Failure originating from authentication or authorization errors.
class AuthenticationFailure extends Failure {
  const AuthenticationFailure(super.message);
}

/// Failure originating from network connectivity issues.
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Failure for unexpected or unclassified errors.
class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message);
}
