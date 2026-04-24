// ignore_for_file: non_constant_identifier_names
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';

/// Repository interface for admin-related operations.
abstract class AdminRepository {
  /// Search for users.
  Future<Either<Failure, List<User>>> searchUsers({
    int? source_id,
    String? login_name,
    int? page,
    int? limit,
  });

  /// Create a new user.
  Future<Either<Failure, User>> createUser(Map<String, dynamic> body);

  /// Delete a user.
  Future<Either<Failure, void>> deleteUser(String username, {bool? purge});

  /// Edit an existing user.
  Future<Either<Failure, User>> editUser(
    String username,
    Map<String, dynamic> body,
  );

  /// List all organizations.
  Future<Either<Failure, List<Organization>>> getAllOrgs({
    int? page,
    int? limit,
  });

  /// List cron tasks.
  Future<Either<Failure, List<Cron>>> listCron({int? page, int? limit});

  /// Run a cron task.
  Future<Either<Failure, void>> runCron(String task);

  /// List admin-level hooks.
  Future<Either<Failure, List<Hook>>> listAdminHooks({
    int? page,
    int? limit,
    String? type,
  });

  /// Get an admin-level hook.
  Future<Either<Failure, Hook>> getAdminHook(int id);

  /// Create an admin-level hook.
  Future<Either<Failure, Hook>> createAdminHook(Map<String, dynamic> body);

  /// Delete an admin-level hook.
  Future<Either<Failure, void>> deleteAdminHook(int id);
}
