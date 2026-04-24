import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/core/errors/failures.dart';
import 'package:igitea/core/utils/either.dart';
import 'package:igitea/data/models/generated/generated_models.dart';
import 'package:igitea/domain/repositories/repo_repository.dart';
import 'package:igitea/domain/usecases/repo_usecases.dart';

class MockRepoRepository implements RepoRepository {
  bool shouldFail = false;
  Failure failure = const ServerFailure('error');

  @override
  Future<Either<Failure, Repository>> getRepo(String owner, String repo) async {
    if (shouldFail) return Left(failure);
    return Right(Repository(id: 1, name: repo, full_name: '$owner/$repo'));
  }

  @override
  Future<Either<Failure, List<Branch>>> listBranches(
    String owner,
    String repo, {
    int? page,
    int? limit,
  }) async {
    if (shouldFail) return Left(failure);
    return Right([Branch(name: 'main')]);
  }

  @override
  Future<Either<Failure, SearchResults>> searchRepos({
    String? q,
    int? uid,
    int? page,
    int? limit,
  }) async {
    if (shouldFail) return Left(failure);
    return Right(
      SearchResults(ok: true, data: [Repository(id: 1, name: 'result')]),
    );
  }

  @override
  Future<Either<Failure, List<Tag>>> listTags(
    String owner,
    String repo, {
    int? page,
    int? limit,
  }) async {
    if (shouldFail) return Left(failure);
    return Right([Tag(name: 'v1.0')]);
  }

  @override
  Future<Either<Failure, List<Commit>>> listCommits(
    String owner,
    String repo, {
    String? sha,
    int? page,
    int? limit,
  }) async {
    if (shouldFail) return Left(failure);
    return Right(<Commit>[]);
  }

  @override
  Future<Either<Failure, Commit>> getCommit(
    String owner,
    String repo,
    String sha,
  ) async {
    if (shouldFail) return Left(failure);
    return Right(Commit(sha: sha));
  }

  @override
  Future<Either<Failure, List<Release>>> listReleases(
    String owner,
    String repo, {
    int? page,
    int? limit,
  }) async {
    if (shouldFail) return Left(failure);
    return Right(<Release>[]);
  }

  @override
  Future<Either<Failure, Release>> getRelease(
    String owner,
    String repo,
    int id,
  ) async {
    if (shouldFail) return Left(failure);
    return Right(Release(id: id));
  }

  @override
  Future<Either<Failure, void>> deleteRepo(String owner, String repo) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, Repository>> editRepo(
    String owner,
    String repo,
    Map<String, dynamic> body,
  ) => throw UnimplementedError();

  @override
  Future<Either<Failure, Repository>> migrateRepo(Map<String, dynamic> body) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, Branch>> getBranch(
    String owner,
    String repo,
    String branch,
  ) => throw UnimplementedError();

  @override
  Future<Either<Failure, List<User>>> listCollaborators(
    String owner,
    String repo, {
    int? page,
    int? limit,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, void>> addCollaborator(
    String owner,
    String repo,
    String collaborator,
    Map<String, dynamic> body,
  ) => throw UnimplementedError();

  @override
  Future<Either<Failure, void>> removeCollaborator(
    String owner,
    String repo,
    String collaborator,
  ) => throw UnimplementedError();

  @override
  Future<Either<Failure, List<Hook>>> listHooks(
    String owner,
    String repo, {
    int? page,
    int? limit,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, Hook>> createHook(
    String owner,
    String repo,
    Map<String, dynamic> body,
  ) => throw UnimplementedError();

  @override
  Future<Either<Failure, void>> deleteHook(String owner, String repo, int id) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, List<ContentsResponse>>> getRepoContents(
    String owner,
    String repo, {
    String? path,
    String? ref,
  }) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, List<PullRequest>>> listPullRequests(
    String owner,
    String repo, {
    String? state,
    int? page,
    int? limit,
  }) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, PullRequest>> getPullRequest(
    String owner,
    String repo,
    int index,
  ) =>
      throw UnimplementedError();
}

void main() {
  group('GetRepoUseCase', () {
    late MockRepoRepository mockRepo;
    late GetRepoUseCase useCase;

    setUp(() {
      mockRepo = MockRepoRepository();
      useCase = GetRepoUseCase(repository: mockRepo);
    });

    test('returns Right(Repository) when repository succeeds', () async {
      final params = GetRepoParams(owner: 'gitea', repo: 'hello');
      final result = await useCase(params);
      expect(result.isRight, isTrue);
      final repo = (result as Right<Failure, Repository>).value;
      expect(repo.id, 1);
      expect(repo.name, 'hello');
      expect(repo.full_name, 'gitea/hello');
    });

    test('returns Left(Failure) when repository fails', () async {
      mockRepo.shouldFail = true;
      mockRepo.failure = const ServerFailure('not found');
      final params = GetRepoParams(owner: 'gitea', repo: 'hello');
      final result = await useCase(params);
      expect(result.isLeft, isTrue);
      expect((result as Left<Failure, Repository>).value, isA<ServerFailure>());
    });

    test('GetRepoParams holds correct values', () {
      final params = GetRepoParams(owner: 'owner1', repo: 'repo1');
      expect(params.owner, 'owner1');
      expect(params.repo, 'repo1');
    });
  });

  group('SearchReposUseCase', () {
    late MockRepoRepository mockRepo;
    late SearchReposUseCase useCase;

    setUp(() {
      mockRepo = MockRepoRepository();
      useCase = SearchReposUseCase(repository: mockRepo);
    });

    test('returns Right(SearchResults) when repository succeeds', () async {
      final params = SearchReposParams(q: 'test');
      final result = await useCase(params);
      expect(result.isRight, isTrue);
      final results = (result as Right<Failure, SearchResults>).value;
      expect(results.ok, isTrue);
      expect(results.data?.length, 1);
    });

    test('returns Left(Failure) when repository fails', () async {
      mockRepo.shouldFail = true;
      mockRepo.failure = const NetworkFailure('timeout');
      final params = SearchReposParams(q: 'test');
      final result = await useCase(params);
      expect(result.isLeft, isTrue);
      expect(
        (result as Left<Failure, SearchResults>).value,
        isA<NetworkFailure>(),
      );
    });

    test('SearchReposParams holds correct values', () {
      final params = SearchReposParams(
        q: 'flutter',
        uid: 5,
        page: 2,
        limit: 10,
      );
      expect(params.q, 'flutter');
      expect(params.uid, 5);
      expect(params.page, 2);
      expect(params.limit, 10);
    });

    test('SearchReposParams defaults to null', () {
      final params = SearchReposParams();
      expect(params.q, isNull);
      expect(params.uid, isNull);
      expect(params.page, isNull);
      expect(params.limit, isNull);
    });
  });

  group('ListBranchesUseCase', () {
    late MockRepoRepository mockRepo;
    late ListBranchesUseCase useCase;

    setUp(() {
      mockRepo = MockRepoRepository();
      useCase = ListBranchesUseCase(repository: mockRepo);
    });

    test('returns Right(List<Branch>) when repository succeeds', () async {
      final params = ListBranchesParams(owner: 'gitea', repo: 'hello');
      final result = await useCase(params);
      expect(result.isRight, isTrue);
      final branches = (result as Right<Failure, List<Branch>>).value;
      expect(branches.length, 1);
      expect(branches.first.name, 'main');
    });

    test('returns Left(Failure) when repository fails', () async {
      mockRepo.shouldFail = true;
      mockRepo.failure = const ServerFailure('error');
      final params = ListBranchesParams(owner: 'gitea', repo: 'hello');
      final result = await useCase(params);
      expect(result.isLeft, isTrue);
      expect(
        (result as Left<Failure, List<Branch>>).value,
        isA<ServerFailure>(),
      );
    });

    test('ListBranchesParams holds correct values', () {
      final params = ListBranchesParams(
        owner: 'owner1',
        repo: 'repo1',
        page: 2,
        limit: 5,
      );
      expect(params.owner, 'owner1');
      expect(params.repo, 'repo1');
      expect(params.page, 2);
      expect(params.limit, 5);
    });
  });
}
