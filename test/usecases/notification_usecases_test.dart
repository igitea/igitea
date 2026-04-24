// ignore_for_file: non_constant_identifier_names
import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/core/errors/failures.dart';
import 'package:igitea/core/utils/either.dart';
import 'package:igitea/data/models/generated/generated_models.dart';
import 'package:igitea/domain/repositories/notification_repository.dart';
import 'package:igitea/domain/usecases/notification_usecases.dart';

class MockNotificationRepository implements NotificationRepository {
  bool shouldFail = false;
  Failure failure = const ServerFailure('error');

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
    if (shouldFail) return Left(failure);
    return const Right([
      NotificationThread(id: 1, pinned: false, unread: true),
    ]);
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
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, void>> markNotificationsRead({
    DateTime? last_read_at,
    String? all,
    List<String>? status_types,
    String? to_status,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, NotificationCount>> checkNewAvailable() async {
    if (shouldFail) return Left(failure);
    return const Right(NotificationCount(new_: 5));
  }

  @override
  Future<Either<Failure, void>> markThreadRead(
    String id, {
    String? to_status,
  }) async {
    if (shouldFail) return Left(failure);
    return const Right(null);
  }
}

void main() {
  group('ListNotificationsUseCase', () {
    late MockNotificationRepository mockRepo;
    late ListNotificationsUseCase useCase;

    setUp(() {
      mockRepo = MockNotificationRepository();
      useCase = ListNotificationsUseCase(repository: mockRepo);
    });

    test('returns Right(List<NotificationThread>) on success', () async {
      final result = await useCase();
      expect(result.isRight, isTrue);
      final threads =
          (result as Right<Failure, List<NotificationThread>>).value;
      expect(threads.length, 1);
      expect(threads.first.id, 1);
    });

    test('returns Left(Failure) on failure', () async {
      mockRepo.shouldFail = true;
      mockRepo.failure = const ServerFailure('error');
      final result = await useCase();
      expect(result.isLeft, isTrue);
      expect(
        (result as Left<Failure, List<NotificationThread>>).value,
        isA<ServerFailure>(),
      );
    });

    test('passes optional parameters', () async {
      final result = await useCase(all: true, page: 1, limit: 10);
      expect(result.isRight, isTrue);
    });
  });

  group('CheckNewNotificationsUseCase', () {
    late MockNotificationRepository mockRepo;
    late CheckNewNotificationsUseCase useCase;

    setUp(() {
      mockRepo = MockNotificationRepository();
      useCase = CheckNewNotificationsUseCase(repository: mockRepo);
    });

    test('returns Right(NotificationCount) on success', () async {
      final result = await useCase();
      expect(result.isRight, isTrue);
      final count = (result as Right<Failure, NotificationCount>).value;
      expect(count.new_, 5);
    });

    test('returns Left(Failure) on failure', () async {
      mockRepo.shouldFail = true;
      mockRepo.failure = const ServerFailure('error');
      final result = await useCase();
      expect(result.isLeft, isTrue);
      expect(
        (result as Left<Failure, NotificationCount>).value,
        isA<ServerFailure>(),
      );
    });
  });

  group('MarkThreadReadUseCase', () {
    late MockNotificationRepository mockRepo;
    late MarkThreadReadUseCase useCase;

    setUp(() {
      mockRepo = MockNotificationRepository();
      useCase = MarkThreadReadUseCase(repository: mockRepo);
    });

    test('returns Right(void) on success', () async {
      final params = MarkThreadReadParams(id: 'thread-1');
      final result = await useCase(params);
      expect(result.isRight, isTrue);
    });

    test('returns Left(Failure) on failure', () async {
      mockRepo.shouldFail = true;
      mockRepo.failure = const ServerFailure('error');
      final params = MarkThreadReadParams(id: 'thread-1');
      final result = await useCase(params);
      expect(result.isLeft, isTrue);
      expect((result as Left<Failure, void>).value, isA<ServerFailure>());
    });

    test('params store values correctly', () {
      final params = MarkThreadReadParams(id: 'thread-1', to_status: 'read');
      expect(params.id, 'thread-1');
      expect(params.to_status, 'read');
    });
  });
}
