import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/core/errors/failures.dart';
import 'package:igitea/core/utils/either.dart';
import 'package:igitea/data/models/generated/generated_models.dart';
import 'package:igitea/domain/repositories/user_repository.dart';
import 'package:igitea/domain/usecases/user_usecases.dart';
import 'package:igitea/presentation/state/user_notifier.dart';

class FakeUserRepository implements UserRepository {
  bool shouldFailGetCurrentUser = false;
  bool shouldFailListCurrentUserRepos = false;
  Failure failure = const ServerFailure('error');
  User currentUser = const User(id: 1, login: 'testuser');
  List<Repository> repos = const [
    Repository(id: 10, name: 'repo1'),
    Repository(id: 20, name: 'repo2'),
  ];

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    if (shouldFailGetCurrentUser) return Left(failure);
    return Right(currentUser);
  }

  @override
  Future<Either<Failure, User>> getUser(String username) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, List<Repository>>> listUserRepos(
    String username, {
    int? page,
    int? limit,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, List<Repository>>> listCurrentUserRepos({
    int? page,
    int? limit,
  }) async {
    if (shouldFailListCurrentUserRepos) return Left(failure);
    return Right(repos);
  }

  @override
  Future<Either<Failure, List<User>>> listFollowers(
    String username, {
    int? page,
    int? limit,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, List<User>>> listFollowing(
    String username, {
    int? page,
    int? limit,
  }) => throw UnimplementedError();

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
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, List<Repository>>> listStarredRepos({
    int? page,
    int? limit,
  }) async {
    if (shouldFailListCurrentUserRepos) return Left(failure);
    return Right(repos);
  }

  @override
  Future<Either<Failure, List<User>>> searchUsers({
    String? q,
    int? uid,
    int? page,
    int? limit,
  }) async => Right([currentUser]);
}

void main() {
  group('UserNotifier', () {
    late FakeUserRepository fakeRepo;
    late UserNotifier notifier;

    setUp(() {
      fakeRepo = FakeUserRepository();
      notifier = UserNotifier(
        getCurrentUserUseCase: GetCurrentUserUseCase(repository: fakeRepo),
        getUserActivitiesUseCase: GetUserActivitiesUseCase(repository: fakeRepo),
        listCurrentUserReposUseCase: ListCurrentUserReposUseCase(
          repository: fakeRepo,
        ),
        listStarredReposUseCase: ListStarredReposUseCase(repository: fakeRepo),
        searchPublicUsersUseCase: SearchPublicUsersUseCase(repository: fakeRepo),
      );
    });

    test('initial state is UserInitial', () {
      expect(notifier.state, isA<UserInitial>());
    });

    group('loadCurrentUser', () {
      test(
        'transitions through UserLoading to UserLoaded on success',
        () async {
          final states = <UserState>[];
          notifier.addListener(() {
            states.add(notifier.state);
          });

          await notifier.loadCurrentUser();

          expect(states.length, 2);
          expect(states[0], isA<UserLoading>());
          expect(states[1], isA<UserLoaded>());

          final loaded = states[1] as UserLoaded;
          expect(loaded.user.id, 1);
          expect(loaded.user.login, 'testuser');
        },
      );

      test('transitions through UserLoading to UserError on failure', () async {
        fakeRepo.shouldFailGetCurrentUser = true;
        fakeRepo.failure = const ServerFailure('server error');

        final states = <UserState>[];
        notifier.addListener(() {
          states.add(notifier.state);
        });

        await notifier.loadCurrentUser();

        expect(states.length, 2);
        expect(states[0], isA<UserLoading>());
        expect(states[1], isA<UserError>());

        final errorState = states[1] as UserError;
        expect(errorState.message, 'server error');
      });

      test('handles authentication failure', () async {
        fakeRepo.shouldFailGetCurrentUser = true;
        fakeRepo.failure = const AuthenticationFailure('unauthorized');

        await notifier.loadCurrentUser();

        expect(notifier.state, isA<UserError>());
        expect((notifier.state as UserError).message, 'unauthorized');
      });

      test('notifyListeners called on each state change', () async {
        var notificationCount = 0;
        notifier.addListener(() {
          notificationCount++;
        });

        await notifier.loadCurrentUser();

        expect(notificationCount, 2);
      });

      test('notifyListeners called on error path', () async {
        fakeRepo.shouldFailGetCurrentUser = true;

        var notificationCount = 0;
        notifier.addListener(() {
          notificationCount++;
        });

        await notifier.loadCurrentUser();

        expect(notificationCount, 2);
      });
    });

    group('listCurrentUserRepos', () {
      test('loads repos on success', () async {
        await notifier.listCurrentUserRepos();

        expect(notifier.repos.length, 2);
        expect(notifier.repos[0].name, 'repo1');
        expect(notifier.repos[1].name, 'repo2');
      });

      test('sets UserError on failure', () async {
        fakeRepo.shouldFailListCurrentUserRepos = true;
        fakeRepo.failure = const ServerFailure('server error');

        await notifier.listCurrentUserRepos();

        expect(notifier.state, isA<UserError>());
        expect((notifier.state as UserError).message, 'server error');
      });

      test('notifies listeners on success', () async {
        var notificationCount = 0;
        notifier.addListener(() {
          notificationCount++;
        });

        await notifier.listCurrentUserRepos();

        expect(notificationCount, 1);
      });

      test('notifies listeners on failure', () async {
        fakeRepo.shouldFailListCurrentUserRepos = true;

        var notificationCount = 0;
        notifier.addListener(() {
          notificationCount++;
        });

        await notifier.listCurrentUserRepos();

        expect(notificationCount, 1);
      });
    });
  });
}
