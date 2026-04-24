import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/core/errors/failures.dart';
import 'package:igitea/core/utils/either.dart';
import 'package:igitea/data/models/generated/generated_models.dart';
import 'package:igitea/domain/repositories/misc_repository.dart';
import 'package:igitea/domain/repositories/user_repository.dart';
import 'package:igitea/domain/usecases/auth_usecases.dart';

class FakeUserRepository implements UserRepository {
  bool shouldFail = false;
  Failure failure = const ServerFailure('error');

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    if (shouldFail) return Left(failure);
    return Right(const User(id: 1, login: 'testuser'));
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
  group('LoginUseCase', () {
    late FakeUserRepository fakeRepo;
    late LoginUseCase useCase;

    setUp(() {
      fakeRepo = FakeUserRepository();
      useCase = LoginUseCase(repository: fakeRepo);
    });

    test('returns Right(User) when repository succeeds', () async {
      final result = await useCase();
      expect(result.isRight, isTrue);
      final user = (result as Right<Failure, User>).value;
      expect(user.id, 1);
      expect(user.login, 'testuser');
    });

    test('returns Left(Failure) when repository fails', () async {
      fakeRepo.shouldFail = true;
      fakeRepo.failure = const AuthenticationFailure('unauthorized');
      final result = await useCase();
      expect(result.isLeft, isTrue);
      final failure = (result as Left<Failure, User>).value;
      expect(failure, isA<AuthenticationFailure>());
    });
  });

  group('GetSettingsUseCase', () {
    late FakeMiscRepository fakeRepo;
    late GetSettingsUseCase useCase;

    setUp(() {
      fakeRepo = FakeMiscRepository();
      useCase = GetSettingsUseCase(repository: fakeRepo);
    });

    test(
      'returns Right(GeneralAPISettings) when repository succeeds',
      () async {
        final result = await useCase();
        expect(result.isRight, isTrue);
        final settings = (result as Right<Failure, GeneralAPISettings>).value;
        expect(settings.default_paging_num, 30);
      },
    );

    test('returns Left(Failure) when repository fails', () async {
      fakeRepo.shouldFail = true;
      fakeRepo.failure = const ServerFailure('server error');
      final result = await useCase();
      expect(result.isLeft, isTrue);
      final failure = (result as Left<Failure, GeneralAPISettings>).value;
      expect(failure, isA<ServerFailure>());
    });
  });
}
