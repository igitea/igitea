import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/core/errors/failures.dart';
import 'package:igitea/core/utils/either.dart';
import 'package:igitea/data/models/generated/generated_models.dart';
import 'package:igitea/domain/repositories/organization_repository.dart';
import 'package:igitea/domain/usecases/organization_usecases.dart';

class MockOrganizationRepository implements OrganizationRepository {
  bool shouldFail = false;
  Failure failure = const ServerFailure('error');

  @override
  Future<Either<Failure, Organization>> getOrg(String org) async {
    if (shouldFail) return Left(failure);
    return Right(const Organization(id: 1, username: 'testorg'));
  }

  @override
  Future<Either<Failure, List<Organization>>> listCurrentUserOrgs({
    int? page,
    int? limit,
  }) async {
    if (shouldFail) return Left(failure);
    return const Right([Organization(id: 1, username: 'testorg')]);
  }

  @override
  Future<Either<Failure, List<Organization>>> listUserOrgs(
    String username, {
    int? page,
    int? limit,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, Organization>> createOrg(Map<String, dynamic> body) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, Organization>> editOrg(
    String org,
    Map<String, dynamic> body,
  ) => throw UnimplementedError();

  @override
  Future<Either<Failure, void>> deleteOrg(String org) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, List<Repository>>> listOrgRepos(
    String org, {
    int? page,
    int? limit,
  }) async {
    if (shouldFail) return Left(failure);
    return const Right([
      Repository(id: 1, name: 'repo1', full_name: 'org/repo1'),
    ]);
  }

  @override
  Future<Either<Failure, List<Team>>> listOrgTeams(
    String org, {
    int? page,
    int? limit,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, Team>> getTeam(int id) => throw UnimplementedError();

  @override
  Future<Either<Failure, List<User>>> listTeamMembers(
    int id, {
    int? page,
    int? limit,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, List<Repository>>> listTeamRepos(
    int id, {
    int? page,
    int? limit,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, Team>> createTeam(
    String org,
    CreateTeamOption option,
  ) => throw UnimplementedError();

  @override
  Future<Either<Failure, Team>> editTeam(
    int id,
    EditTeamOption option,
  ) => throw UnimplementedError();

  @override
  Future<Either<Failure, void>> deleteTeam(int id) => throw UnimplementedError();

  @override
  Future<Either<Failure, void>> addTeamMember(
    int id,
    String username,
  ) => throw UnimplementedError();

  @override
  Future<Either<Failure, void>> removeTeamMember(
    int id,
    String username,
  ) => throw UnimplementedError();
}

void main() {
  group('GetOrgUseCase', () {
    late MockOrganizationRepository mockRepo;
    late GetOrgUseCase useCase;

    setUp(() {
      mockRepo = MockOrganizationRepository();
      useCase = GetOrgUseCase(repository: mockRepo);
    });

    test('returns Right(Organization) on success', () async {
      final result = await useCase('testorg');
      expect(result.isRight, isTrue);
      final org = (result as Right<Failure, Organization>).value;
      expect(org.id, 1);
      expect(org.username, 'testorg');
    });

    test('returns Left(Failure) on failure', () async {
      mockRepo.shouldFail = true;
      mockRepo.failure = const ServerFailure('not found');
      final result = await useCase('testorg');
      expect(result.isLeft, isTrue);
      expect(
        (result as Left<Failure, Organization>).value,
        isA<ServerFailure>(),
      );
    });
  });

  group('ListCurrentUserOrgsUseCase', () {
    late MockOrganizationRepository mockRepo;
    late ListCurrentUserOrgsUseCase useCase;

    setUp(() {
      mockRepo = MockOrganizationRepository();
      useCase = ListCurrentUserOrgsUseCase(repository: mockRepo);
    });

    test('returns Right(List<Organization>) on success', () async {
      final result = await useCase();
      expect(result.isRight, isTrue);
      final orgs = (result as Right<Failure, List<Organization>>).value;
      expect(orgs.length, 1);
      expect(orgs.first.id, 1);
    });

    test('returns Left(Failure) on failure', () async {
      mockRepo.shouldFail = true;
      mockRepo.failure = const ServerFailure('error');
      final result = await useCase();
      expect(result.isLeft, isTrue);
      expect(
        (result as Left<Failure, List<Organization>>).value,
        isA<ServerFailure>(),
      );
    });

    test('passes page and limit parameters', () async {
      mockRepo = MockOrganizationRepository();
      useCase = ListCurrentUserOrgsUseCase(repository: mockRepo);
      final result = await useCase(page: 2, limit: 10);
      expect(result.isRight, isTrue);
    });
  });

  group('ListOrgReposUseCase', () {
    late MockOrganizationRepository mockRepo;
    late ListOrgReposUseCase useCase;

    setUp(() {
      mockRepo = MockOrganizationRepository();
      useCase = ListOrgReposUseCase(repository: mockRepo);
    });

    test('returns Right(List<Repository>) on success', () async {
      final params = ListOrgReposParams(org: 'testorg');
      final result = await useCase(params);
      expect(result.isRight, isTrue);
      final repos = (result as Right<Failure, List<Repository>>).value;
      expect(repos.length, 1);
      expect(repos.first.name, 'repo1');
    });

    test('returns Left(Failure) on failure', () async {
      mockRepo.shouldFail = true;
      mockRepo.failure = const ServerFailure('error');
      final params = ListOrgReposParams(org: 'testorg');
      final result = await useCase(params);
      expect(result.isLeft, isTrue);
      expect(
        (result as Left<Failure, List<Repository>>).value,
        isA<ServerFailure>(),
      );
    });

    test('params store values correctly', () {
      final params = ListOrgReposParams(org: 'myorg', page: 2, limit: 10);
      expect(params.org, 'myorg');
      expect(params.page, 2);
      expect(params.limit, 10);
    });
  });
}
