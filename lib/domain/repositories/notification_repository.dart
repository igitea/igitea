// ignore_for_file: non_constant_identifier_names
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';

/// Repository interface for notification-related operations.
abstract class NotificationRepository {
  /// List notifications for the current user.
  Future<Either<Failure, List<NotificationThread>>> listNotifications({
    bool? all,
    List<String>? status_types,
    List<String>? subject_type,
    DateTime? since,
    DateTime? before,
    int? page,
    int? limit,
  });

  /// List notifications for a specific repository.
  Future<Either<Failure, List<NotificationThread>>> listRepoNotifications(
    String owner,
    String repo, {
    bool? all,
    List<String>? status_types,
    List<String>? subject_type,
    DateTime? since,
    DateTime? before,
    int? page,
    int? limit,
  });

  /// Mark notifications as read.
  Future<Either<Failure, void>> markNotificationsRead({
    DateTime? last_read_at,
    String? all,
    List<String>? status_types,
    String? to_status,
  });

  /// Check if new notifications are available.
  Future<Either<Failure, NotificationCount>> checkNewAvailable();

  /// Mark a specific notification thread as read.
  Future<Either<Failure, void>> markThreadRead(String id, {String? to_status});
}
