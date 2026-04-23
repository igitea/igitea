import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';

/// Repository interface for user-related operations.
abstract class UserRepository {
  /// Get the currently authenticated user.
  Future<Either<Failure, User>> getCurrentUser();

  /// Get a user by username.
  Future<Either<Failure, User>> getUser(String username);

  /// List repositories for a user.
  Future<Either<Failure, List<Repository>>> listUserRepos(
    String username, {
    int? page,
    int? limit,
  });

  /// List current user's repositories.
  Future<Either<Failure, List<Repository>>> listCurrentUserRepos({
    int? page,
    int? limit,
  });

  /// List followers of a user.
  Future<Either<Failure, List<User>>> listFollowers(
    String username, {
    int? page,
    int? limit,
  });

  /// List users a user is following.
  Future<Either<Failure, List<User>>> listFollowing(
    String username, {
    int? page,
    int? limit,
  });

  /// Create a new access token.
  Future<Either<Failure, AccessToken>> createToken(String name);

  /// List current user's emails.
  Future<Either<Failure, List<Email>>> listEmails();

  /// Add an email address.
  Future<Either<Failure, void>> addEmail(List<String> emails);

  /// Delete an email address.
  Future<Either<Failure, void>> deleteEmail(List<String> emails);

  /// List public keys for a user.
  Future<Either<Failure, List<PublicKey>>> listKeys(String username);

  /// List current user's public keys.
  Future<Either<Failure, List<PublicKey>>> listCurrentUserKeys();

  /// Add a public key for the current user.
  Future<Either<Failure, PublicKey>> addKey(String title, String key);

  /// Delete a public key for the current user.
  Future<Either<Failure, void>> deleteKey(int id);
}
