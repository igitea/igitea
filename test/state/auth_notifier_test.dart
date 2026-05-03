import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/core/errors/failures.dart';
import 'package:igitea/core/storage/auth_method_storage.dart';
import 'package:igitea/core/utils/either.dart';
import 'package:igitea/data/models/generated/generated_models.dart';
import 'package:igitea/domain/entities/auth_state.dart';
import 'package:igitea/domain/repositories/misc_repository.dart';
import 'package:igitea/domain/repositories/user_repository.dart';
import 'package:igitea/domain/usecases/auth_usecases.dart';
import 'package:igitea/presentation/state/auth_notifier.dart';

import '../helpers/fake_auth_storage.dart';

class FakeUserRepository implements UserRepository {
  bool shouldFail = false;
  Failure failure = const ServerFailure('error');
  User user = const User(id: 1, login: 'testuser');

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    if (shouldFail) return Left(failure);
    return Right(user);
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
  }) => throw UnimplementedError();

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
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, List<User>>> searchUsers({
    String? q,
    int? uid,
    int? page,
    int? limit,
  }) => throw UnimplementedError();
}

class FakeMiscRepository implements MiscRepository {
  bool shouldFail = false;
  Failure failure = const ServerFailure('error');

  @override
  Future<Either<Failure, GeneralAPISettings>> getGeneralAPISettings() async {
    if (shouldFail) return Left(failure);
    return Right(const GeneralAPISettings(default_paging_num: 30));
  }

  @override
  Future<Either<Failure, GeneralAttachmentSettings>>
  getGeneralAttachmentSettings() => throw UnimplementedError();

  @override
  Future<Either<Failure, GeneralRepoSettings>> getGeneralRepositorySettings() =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, GeneralUISettings>> getGeneralUISettings() =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, List<String>>> listGitignoreTemplates() =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, GitignoreTemplateInfo>> getGitignoreTemplateInfo(
    String name,
  ) => throw UnimplementedError();

  @override
  Future<Either<Failure, String>> renderMarkdown(Map<String, dynamic> body) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, String>> renderMarkdownRaw(String body) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, NodeInfo>> getNodeInfo() => throw UnimplementedError();

  @override
  Future<Either<Failure, ActivityPub>> getActivityPubPerson(int userId) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, void>> sendActivityPubInbox(int userId) =>
      throw UnimplementedError();
}

void main() {
  group('AuthNotifier', () {
    late FakeUserRepository fakeUserRepo;
    late FakeMiscRepository fakeMiscRepo;
    late AuthNotifier notifier;

    setUp(() {
      fakeUserRepo = FakeUserRepository();
      fakeMiscRepo = FakeMiscRepository();
      notifier = AuthNotifier(
        loginUseCase: LoginUseCase(repository: fakeUserRepo),
        getSettingsUseCase: GetSettingsUseCase(repository: fakeMiscRepo),
        storage: FakeAuthStorage(),
      );
    });

    test('initial state is AuthInitial', () {
      expect(notifier.state, isA<AuthInitial>());
    });

    test('isAuthenticated is false initially', () {
      expect(notifier.isAuthenticated, isFalse);
    });

    test('isLoading is false initially', () {
      expect(notifier.isLoading, isFalse);
    });

    group('loginWithToken', () {
      test(
        'transitions through AuthLoading to AuthAuthenticated on success',
        () async {
          final states = <AuthState>[];
          notifier.addListener(() {
            states.add(notifier.state);
          });

          await notifier.loginWithToken(
            'https://gitea.example.com',
            'test-token',
          );

          expect(states.length, 2);
          expect(states[0], isA<AuthLoading>());
          expect(states[1], isA<AuthAuthenticated>());

          final authState = states[1] as AuthAuthenticated;
          expect(authState.baseUrl, 'https://gitea.example.com');
          expect(authState.token, 'test-token');
          expect(authState.method, AuthMethod.token);
          expect(authState.user.id, 1);
          expect(authState.user.login, 'testuser');
        },
      );

      test('sets isAuthenticated to true after successful login', () async {
        await notifier.loginWithToken(
          'https://gitea.example.com',
          'test-token',
        );

        expect(notifier.isAuthenticated, isTrue);
      });

      test('sets isLoading to false after login completes', () async {
        await notifier.loginWithToken(
          'https://gitea.example.com',
          'test-token',
        );

        expect(notifier.isLoading, isFalse);
      });

      test('transitions through AuthLoading to AuthError on failure', () async {
        fakeUserRepo.shouldFail = true;
        fakeUserRepo.failure = const AuthenticationFailure('unauthorized');

        final states = <AuthState>[];
        notifier.addListener(() {
          states.add(notifier.state);
        });

        await notifier.loginWithToken('https://gitea.example.com', 'bad-token');

        expect(states.length, 2);
        expect(states[0], isA<AuthLoading>());
        expect(states[1], isA<AuthError>());

        final errorState = states[1] as AuthError;
        expect(errorState.message, 'unauthorized');
      });

      test('sets isAuthenticated to false after failed login', () async {
        fakeUserRepo.shouldFail = true;
        fakeUserRepo.failure = const AuthenticationFailure('unauthorized');

        await notifier.loginWithToken('https://gitea.example.com', 'bad-token');

        expect(notifier.isAuthenticated, isFalse);
      });

      test('handles server failure', () async {
        fakeUserRepo.shouldFail = true;
        fakeUserRepo.failure = const ServerFailure('internal server error');

        await notifier.loginWithToken(
          'https://gitea.example.com',
          'test-token',
        );

        expect(notifier.state, isA<AuthError>());
        expect((notifier.state as AuthError).message, 'internal server error');
      });
    });

    group('loginWithBasicAuth', () {
      test('transitions to AuthAuthenticated with basic auth method', () async {
        await notifier.loginWithBasicAuth(
          'https://gitea.example.com',
          'testuser',
          'testpass',
        );

        expect(notifier.state, isA<AuthAuthenticated>());
        final authState = notifier.state as AuthAuthenticated;
        expect(authState.baseUrl, 'https://gitea.example.com');
        expect(authState.method, AuthMethod.basic);
        expect(authState.username, 'testuser');
        expect(authState.password, 'testpass');
      });

      test('sets isAuthenticated to true after basic auth login', () async {
        await notifier.loginWithBasicAuth(
          'https://gitea.example.com',
          'testuser',
          'testpass',
        );

        expect(notifier.isAuthenticated, isTrue);
      });

      test('handles basic auth failure', () async {
        fakeUserRepo.shouldFail = true;
        fakeUserRepo.failure = const AuthenticationFailure(
          'invalid credentials',
        );

        await notifier.loginWithBasicAuth(
          'https://gitea.example.com',
          'wrong',
          'wrong',
        );

        expect(notifier.state, isA<AuthError>());
        expect(notifier.isAuthenticated, isFalse);
      });
    });

    group('logout', () {
      test('resets state to AuthInitial', () async {
        await notifier.loginWithToken(
          'https://gitea.example.com',
          'test-token',
        );
        expect(notifier.state, isA<AuthAuthenticated>());

        await notifier.logout();

        expect(notifier.state, isA<AuthInitial>());
      });

      test('sets isAuthenticated to false after logout', () async {
        await notifier.loginWithToken(
          'https://gitea.example.com',
          'test-token',
        );
        expect(notifier.isAuthenticated, isTrue);

        await notifier.logout();

        expect(notifier.isAuthenticated, isFalse);
      });

      test('notifies listeners on logout', () async {
        await notifier.loginWithToken(
          'https://gitea.example.com',
          'test-token',
        );

        var notificationCount = 0;
        notifier.addListener(() {
          notificationCount++;
        });

        await notifier.logout();

        expect(notificationCount, 1);
      });
    });

    group('notifyListeners', () {
      test(
        'notifyListeners called on each state change during loginWithToken',
        () async {
          var notificationCount = 0;
          notifier.addListener(() {
            notificationCount++;
          });

          await notifier.loginWithToken(
            'https://gitea.example.com',
            'test-token',
          );

          expect(notificationCount, 2);
        },
      );

      test(
        'notifyListeners called on each state change during failed login',
        () async {
          fakeUserRepo.shouldFail = true;
          fakeUserRepo.failure = const AuthenticationFailure('unauthorized');

          var notificationCount = 0;
          notifier.addListener(() {
            notificationCount++;
          });

          await notifier.loginWithToken(
            'https://gitea.example.com',
            'bad-token',
          );

          expect(notificationCount, 2);
        },
      );
    });
  });
}
