import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/core/errors/failures.dart';
import 'package:igitea/core/utils/either.dart';
import 'package:igitea/data/models/generated/generated_models.dart';
import 'package:igitea/domain/repositories/user_repository.dart';
import 'package:igitea/domain/usecases/user_usecases.dart';

class MockUserRepository implements UserRepository {
  bool shouldFail = false;
  Failure failure = const ServerFailure('error');

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    if (shouldFail) return Left(failure);
    return Right(const User(id: 1, login: 'currentuser'));
  }

  @override
  Future<Either<Failure, User>> getUser(String username) async {
    if (shouldFail) return Left(failure);
    return Right(User(id: 2, login: username));
  }

  @override
  Future<Either<Failure, List<Repository>>> listUserRepos(
    String username, {
    int? page,
    int? limit,
  }) async {
    if (shouldFail) return Left(failure);
    return Right([
      Repository(id: 10, name: '$username/repo', full_name: '$username/repo'),
    ]);
  }

  @override
  Future<Either<Failure, List<Repository>>> listCurrentUserRepos({
    int? page,
    int? limit,
  }) async {
    if (shouldFail) return Left(failure);
    return Right([Repository(id: 20, name: 'myrepo', full_name: 'me/myrepo')]);
  }

  @override
  Future<Either<Failure, List<User>>> listFollowers(
    String username, {
    int? page,
    int? limit,
  }) async {
    if (shouldFail) return Left(failure);
    return Right([User(id: 3, login: 'follower1')]);
  }

  @override
  Future<Either<Failure, List<User>>> listFollowing(
    String username, {
    int? page,
    int? limit,
  }) async {
    if (shouldFail) return Left(failure);
    return Right([User(id: 4, login: 'following1')]);
  }

  @override
  Future<Either<Failure, AccessToken>> createToken(String name) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, List<Email>>> listEmails() =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, void>> addEmail(List<String> emails) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, void>> deleteEmail(List<String> emails) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, List<PublicKey>>> listKeys(String username) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, List<PublicKey>>> listCurrentUserKeys() =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, PublicKey>> addKey(String title, String key) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, void>> deleteKey(int id) => throw UnimplementedError();

  @override
  Future<Either<Failure, List<Activity>>> getUserActivities(
    String username, {
    int? page,
    int? limit,
  }) async {
    if (shouldFail) return Left(failure);
    return Right([]);
  }
}

void main() {
  group('GetCurrentUserUseCase', () {
    late MockUserRepository mockRepo;
    late GetCurrentUserUseCase useCase;

    setUp(() {
      mockRepo = MockUserRepository();
      useCase = GetCurrentUserUseCase(repository: mockRepo);
    });

    test('returns Right(User) when repository succeeds', () async {
      final result = await useCase();
      expect(result.isRight, isTrue);
      final user = (result as Right<Failure, User>).value;
      expect(user.id, 1);
      expect(user.login, 'currentuser');
    });

    test('returns Left(Failure) when repository fails', () async {
      mockRepo.shouldFail = true;
      mockRepo.failure = const ServerFailure('error');
      final result = await useCase();
      expect(result.isLeft, isTrue);
      expect((result as Left<Failure, User>).value, isA<ServerFailure>());
    });
  });

  group('GetUserUseCase', () {
    late MockUserRepository mockRepo;
    late GetUserUseCase useCase;

    setUp(() {
      mockRepo = MockUserRepository();
      useCase = GetUserUseCase(repository: mockRepo);
    });

    test('returns Right(User) when repository succeeds', () async {
      final result = await useCase('alice');
      expect(result.isRight, isTrue);
      final user = (result as Right<Failure, User>).value;
      expect(user.id, 2);
      expect(user.login, 'alice');
    });

    test('returns Left(Failure) when repository fails', () async {
      mockRepo.shouldFail = true;
      mockRepo.failure = const NetworkFailure('no connection');
      final result = await useCase('alice');
      expect(result.isLeft, isTrue);
      expect((result as Left<Failure, User>).value, isA<NetworkFailure>());
    });
  });

  group('ListUserReposUseCase', () {
    late MockUserRepository mockRepo;
    late ListUserReposUseCase useCase;

    setUp(() {
      mockRepo = MockUserRepository();
      useCase = ListUserReposUseCase(repository: mockRepo);
    });

    test('returns Right(List<Repository>) when repository succeeds', () async {
      final params = ListUserReposParams(username: 'bob');
      final result = await useCase(params);
      expect(result.isRight, isTrue);
      final repos = (result as Right<Failure, List<Repository>>).value;
      expect(repos.length, 1);
      expect(repos.first.name, 'bob/repo');
    });

    test('returns Left(Failure) when repository fails', () async {
      mockRepo.shouldFail = true;
      mockRepo.failure = const ServerFailure('error');
      final params = ListUserReposParams(username: 'bob');
      final result = await useCase(params);
      expect(result.isLeft, isTrue);
      expect(
        (result as Left<Failure, List<Repository>>).value,
        isA<ServerFailure>(),
      );
    });

    test('ListUserReposParams holds correct values', () {
      final params = ListUserReposParams(username: 'alice', page: 2, limit: 10);
      expect(params.username, 'alice');
      expect(params.page, 2);
      expect(params.limit, 10);
    });
  });

  group('ListCurrentUserReposUseCase', () {
    late MockUserRepository mockRepo;
    late ListCurrentUserReposUseCase useCase;

    setUp(() {
      mockRepo = MockUserRepository();
      useCase = ListCurrentUserReposUseCase(repository: mockRepo);
    });

    test('returns Right(List<Repository>) when repository succeeds', () async {
      final params = ListCurrentUserReposParams();
      final result = await useCase(params);
      expect(result.isRight, isTrue);
      final repos = (result as Right<Failure, List<Repository>>).value;
      expect(repos.length, 1);
      expect(repos.first.name, 'myrepo');
    });

    test('returns Left(Failure) when repository fails', () async {
      mockRepo.shouldFail = true;
      mockRepo.failure = const ServerFailure('error');
      final params = ListCurrentUserReposParams();
      final result = await useCase(params);
      expect(result.isLeft, isTrue);
      expect(
        (result as Left<Failure, List<Repository>>).value,
        isA<ServerFailure>(),
      );
    });

    test('ListCurrentUserReposParams holds correct values', () {
      final params = ListCurrentUserReposParams(page: 3, limit: 5);
      expect(params.page, 3);
      expect(params.limit, 5);
    });

    test('ListCurrentUserReposParams defaults to null', () {
      final params = ListCurrentUserReposParams();
      expect(params.page, isNull);
      expect(params.limit, isNull);
    });
  });

  group('ListFollowersUseCase', () {
    late MockUserRepository mockRepo;
    late ListFollowersUseCase useCase;

    setUp(() {
      mockRepo = MockUserRepository();
      useCase = ListFollowersUseCase(repository: mockRepo);
    });

    test('returns Right(List<User>) when repository succeeds', () async {
      final params = ListFollowersParams(username: 'alice');
      final result = await useCase(params);
      expect(result.isRight, isTrue);
      final users = (result as Right<Failure, List<User>>).value;
      expect(users.length, 1);
      expect(users.first.login, 'follower1');
    });

    test('returns Left(Failure) when repository fails', () async {
      mockRepo.shouldFail = true;
      mockRepo.failure = const ServerFailure('error');
      final params = ListFollowersParams(username: 'alice');
      final result = await useCase(params);
      expect(result.isLeft, isTrue);
      expect((result as Left<Failure, List<User>>).value, isA<ServerFailure>());
    });

    test('ListFollowersParams holds correct values', () {
      final params = ListFollowersParams(username: 'bob', page: 2, limit: 10);
      expect(params.username, 'bob');
      expect(params.page, 2);
      expect(params.limit, 10);
    });
  });

  group('ListFollowingUseCase', () {
    late MockUserRepository mockRepo;
    late ListFollowingUseCase useCase;

    setUp(() {
      mockRepo = MockUserRepository();
      useCase = ListFollowingUseCase(repository: mockRepo);
    });

    test('returns Right(List<User>) when repository succeeds', () async {
      final params = ListFollowingParams(username: 'alice');
      final result = await useCase(params);
      expect(result.isRight, isTrue);
      final users = (result as Right<Failure, List<User>>).value;
      expect(users.length, 1);
      expect(users.first.login, 'following1');
    });

    test('returns Left(Failure) when repository fails', () async {
      mockRepo.shouldFail = true;
      mockRepo.failure = const ServerFailure('error');
      final params = ListFollowingParams(username: 'alice');
      final result = await useCase(params);
      expect(result.isLeft, isTrue);
      expect((result as Left<Failure, List<User>>).value, isA<ServerFailure>());
    });

    test('ListFollowingParams holds correct values', () {
      final params = ListFollowingParams(username: 'carol', page: 1, limit: 20);
      expect(params.username, 'carol');
      expect(params.page, 1);
      expect(params.limit, 20);
    });
  });
}
