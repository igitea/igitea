// ignore_for_file: non_constant_identifier_names

import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../core/utils/repository_helper.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/remote/gitea_api_service.dart';
import '../models/generated/generated_models.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final GiteaApiService _apiService;

  NotificationRepositoryImpl({required GiteaApiService apiService})
    : _apiService = apiService;

  @override
  Future<Either<Failure, List<NotificationThread>>> listNotifications({
    bool? all,
    List<String>? status_types,
    List<String>? subject_type,
    DateTime? since,
    DateTime? before,
    int? page,
    int? limit,
  }) async {
    return execute(
      () => _apiService.notifyGetList(
        all: all,
        status_types: status_types,
        subject_type: subject_type,
        since: since,
        before: before,
        page: page,
        limit: limit,
      ),
    );
  }

  @override
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
  }) async {
    return execute(
      () => _apiService.notifyGetRepoList(
        owner: owner,
        repo: repo,
        all: all,
        status_types: status_types,
        subject_type: subject_type,
        since: since,
        before: before,
        page: page,
        limit: limit,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> markNotificationsRead({
    DateTime? last_read_at,
    String? all,
    List<String>? status_types,
    String? to_status,
  }) async {
    return execute(
      () => _apiService.notifyReadList(
        last_read_at: last_read_at,
        all: all,
        status_types: status_types,
        to_status: to_status,
      ),
    );
  }

  @override
  Future<Either<Failure, NotificationCount>> checkNewAvailable() async {
    return execute(() => _apiService.notifyNewAvailable());
  }

  @override
  Future<Either<Failure, void>> markThreadRead(
    String id, {
    String? to_status,
  }) async {
    return execute(
      () => _apiService.notifyReadThread(id: id, to_status: to_status),
    );
  }
}
