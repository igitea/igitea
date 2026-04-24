// ignore_for_file: non_constant_identifier_names
import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/core/errors/failures.dart';
import 'package:igitea/core/utils/either.dart';
import 'package:igitea/data/models/generated/generated_models.dart';
import 'package:igitea/domain/repositories/admin_repository.dart';
import 'package:igitea/domain/usecases/admin_usecases.dart';

class MockAdminRepository implements AdminRepository {
  bool shouldFail = false;
  Failure failure = const ServerFailure('error');

  @override
  Future<Either<Failure, List<User>>> searchUsers({
    int? source_id,
    String? login_name,
    int? page,
    int? limit,
  }) async {
    if (shouldFail) return Left(failure);
    return const Right([User(id: 1, login: 'testuser')]);
  }

  @override
  Future<Either<Failure, User>> createUser(Map<String, dynamic> body) async {
    if (shouldFail) return Left(failure);
    return const Right(User(id: 2, login: 'newuser'));
  }

  @override
  Future<Either<Failure, void>> deleteUser(
    String username, {
    bool? purge,
  }) async {
    if (shouldFail) return Left(failure);
    return const Right(null);
  }

  @override
  Future<Either<Failure, User>> editUser(
    String username,
    Map<String, dynamic> body,
  ) => throw UnimplementedError();

  @override
  Future<Either<Failure, List<Organization>>> getAllOrgs({
    int? page,
    int? limit,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, List<Cron>>> listCron({int? page, int? limit}) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, void>> runCron(String task) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, List<Hook>>> listAdminHooks({
    int? page,
    int? limit,
    String? type,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, Hook>> getAdminHook(int id) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, Hook>> createAdminHook(Map<String, dynamic> body) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, void>> deleteAdminHook(int id) =>
      throw UnimplementedError();
}

void main() {
  group('SearchUsersUseCase', () {
    late MockAdminRepository mockRepo;
    late SearchUsersUseCase useCase;

    setUp(() {
      mockRepo = MockAdminRepository();
      useCase = SearchUsersUseCase(repository: mockRepo);
    });

    test('returns Right(List<User>) on success', () async {
      final params = SearchUsersParams(login_name: 'test');
      final result = await useCase(params);
      expect(result.isRight, isTrue);
      final users = (result as Right<Failure, List<User>>).value;
      expect(users.length, 1);
      expect(users.first.login, 'testuser');
    });

    test('returns Left(Failure) on failure', () async {
      mockRepo.shouldFail = true;
      mockRepo.failure = const ServerFailure('error');
      final params = SearchUsersParams(login_name: 'test');
      final result = await useCase(params);
      expect(result.isLeft, isTrue);
      expect((result as Left<Failure, List<User>>).value, isA<ServerFailure>());
    });

    test('params store values correctly', () {
      final params = SearchUsersParams(
        source_id: 1,
        login_name: 'admin',
        page: 2,
        limit: 20,
      );
      expect(params.source_id, 1);
      expect(params.login_name, 'admin');
      expect(params.page, 2);
      expect(params.limit, 20);
    });
  });

  group('CreateUserUseCase', () {
    late MockAdminRepository mockRepo;
    late CreateUserUseCase useCase;

    setUp(() {
      mockRepo = MockAdminRepository();
      useCase = CreateUserUseCase(repository: mockRepo);
    });

    test('returns Right(User) on success', () async {
      final body = {'login': 'newuser', 'email': 'new@test.com'};
      final result = await useCase(body);
      expect(result.isRight, isTrue);
      final user = (result as Right<Failure, User>).value;
      expect(user.id, 2);
      expect(user.login, 'newuser');
    });

    test('returns Left(Failure) on failure', () async {
      mockRepo.shouldFail = true;
      mockRepo.failure = const ServerFailure('conflict');
      final body = {'login': 'newuser'};
      final result = await useCase(body);
      expect(result.isLeft, isTrue);
      expect((result as Left<Failure, User>).value, isA<ServerFailure>());
    });
  });

  group('DeleteUserUseCase', () {
    late MockAdminRepository mockRepo;
    late DeleteUserUseCase useCase;

    setUp(() {
      mockRepo = MockAdminRepository();
      useCase = DeleteUserUseCase(repository: mockRepo);
    });

    test('returns Right(void) on success', () async {
      final params = DeleteUserParams(username: 'testuser');
      final result = await useCase(params);
      expect(result.isRight, isTrue);
    });

    test('returns Left(Failure) on failure', () async {
      mockRepo.shouldFail = true;
      mockRepo.failure = const ServerFailure('not found');
      final params = DeleteUserParams(username: 'testuser');
      final result = await useCase(params);
      expect(result.isLeft, isTrue);
      expect((result as Left<Failure, void>).value, isA<ServerFailure>());
    });

    test('params store values correctly', () {
      final params = DeleteUserParams(username: 'testuser', purge: true);
      expect(params.username, 'testuser');
      expect(params.purge, true);
    });
  });
}
