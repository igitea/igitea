// ignore_for_file: non_constant_identifier_names
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../repositories/notification_repository.dart';

class ListNotificationsUseCase {
  final NotificationRepository _repository;

  ListNotificationsUseCase({required NotificationRepository repository})
    : _repository = repository;

  Future<Either<Failure, List<NotificationThread>>> call({
    bool? all,
    List<String>? status_types,
    List<String>? subject_type,
    DateTime? since,
    DateTime? before,
    int? page,
    int? limit,
  }) async {
    return _repository.listNotifications(
      all: all,
      status_types: status_types,
      subject_type: subject_type,
      since: since,
      before: before,
      page: page,
      limit: limit,
    );
  }
}

class ListRepoNotificationsUseCase {
  final NotificationRepository _repository;

  ListRepoNotificationsUseCase({required NotificationRepository repository})
    : _repository = repository;

  Future<Either<Failure, List<NotificationThread>>> call(
    ListRepoNotificationsParams params,
  ) async {
    return _repository.listRepoNotifications(
      params.owner,
      params.repo,
      all: params.all,
      status_types: params.status_types,
      subject_type: params.subject_type,
      since: params.since,
      before: params.before,
      page: params.page,
      limit: params.limit,
    );
  }
}

class ListRepoNotificationsParams {
  final String owner;
  final String repo;
  final bool? all;
  final List<String>? status_types;
  final List<String>? subject_type;
  final DateTime? since;
  final DateTime? before;
  final int? page;
  final int? limit;

  ListRepoNotificationsParams({
    required this.owner,
    required this.repo,
    this.all,
    this.status_types,
    this.subject_type,
    this.since,
    this.before,
    this.page,
    this.limit,
  });
}

class MarkNotificationsReadUseCase {
  final NotificationRepository _repository;

  MarkNotificationsReadUseCase({required NotificationRepository repository})
    : _repository = repository;

  Future<Either<Failure, void>> call({
    DateTime? last_read_at,
    String? all,
    List<String>? status_types,
    String? to_status,
  }) async {
    return _repository.markNotificationsRead(
      last_read_at: last_read_at,
      all: all,
      status_types: status_types,
      to_status: to_status,
    );
  }
}

class CheckNewNotificationsUseCase {
  final NotificationRepository _repository;

  CheckNewNotificationsUseCase({required NotificationRepository repository})
    : _repository = repository;

  Future<Either<Failure, NotificationCount>> call() async {
    return _repository.checkNewAvailable();
  }
}

class MarkThreadReadUseCase {
  final NotificationRepository _repository;

  MarkThreadReadUseCase({required NotificationRepository repository})
    : _repository = repository;

  Future<Either<Failure, void>> call(MarkThreadReadParams params) async {
    return _repository.markThreadRead(params.id, to_status: params.to_status);
  }
}

class MarkThreadReadParams {
  final String id;
  final String? to_status;

  MarkThreadReadParams({required this.id, this.to_status});
}
