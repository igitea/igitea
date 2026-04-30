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
  Future<Either<Failure, Repository>> getRepo(String owner, String repo) =>
      throw UnimplementedError();

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
  Future<Either<Failure, Repository>> createRepo(Map<String, dynamic> body) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, List<Branch>>> listBranches(
    String owner,
    String repo, {
    int? page,
    int? limit,
  }) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, Branch>> getBranch(
    String owner,
    String repo,
    String branch,
  ) => throw UnimplementedError();

  @override
  Future<Either<Failure, List<Tag>>> listTags(
    String owner,
    String repo, {
    int? page,
    int? limit,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, List<Commit>>> listCommits(
    String owner,
    String repo, {
    String? sha,
    String? path,
    int? page,
    int? limit,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, Commit>> getCommit(
    String owner,
    String repo,
    String sha,
  ) => throw UnimplementedError();

  @override
  Future<Either<Failure, List<Release>>> listReleases(
    String owner,
    String repo, {
    int? page,
    int? limit,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, Release>> getRelease(
    String owner,
    String repo,
    int id,
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
  }) async {
    if (shouldFail) return Left(failure);
    return Right([
      ContentsResponse(name: 'README.md', type: 'file', path: 'README.md'),
      ContentsResponse(name: 'src', type: 'dir', path: 'src'),
    ]);
  }

  @override
  Future<Either<Failure, FileResponse>> updateFile(
    String owner,
    String repo,
    String filepath,
    UpdateFileOptions body,
  ) => throw UnimplementedError();

  @override
  Future<Either<Failure, List<PullRequest>>> listPullRequests(
    String owner,
    String repo, {
    String? state,
    int? page,
    int? limit,
  }) async {
    if (shouldFail) return Left(failure);
    return Right([
      PullRequest(id: 1, number: 42, title: 'Fix bug'),
    ]);
  }

  @override
  Future<Either<Failure, PullRequest>> getPullRequest(
    String owner,
    String repo,
    int index,
  ) => throw UnimplementedError();

  @override
  Future<Either<Failure, SearchResults>> searchRepos({
    String? q,
    int? uid,
    int? page,
    int? limit,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, void>> starRepo(String owner, String repo) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, void>> unstarRepo(String owner, String repo) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, bool>> checkStarred(String owner, String repo) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, PullRequest>> createPullRequest(
    String owner, String repo, Map<String, dynamic> body) => throw UnimplementedError();

  @override
  Future<Either<Failure, Tag>> getTag(
    String owner,
    String repo,
    String tag,
  ) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, void>> mergePullRequest(
    String owner,
    String repo,
    int index, {
    MergePullRequestOption? body,
  }) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, Repository>> createFork(
    String owner,
    String repo, {
    CreateForkOption? body,
  }) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, List<WikiPageMetaData>>> listWikiPages(
    String owner,
    String repo,
  ) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, WikiPage>> getWikiPage(
    String owner,
    String repo,
    String pageName,
  ) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, WikiPage>> createWikiPage(
    String owner,
    String repo,
    String title,
    String content, {
    String? message,
  }) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, WikiPage>> editWikiPage(
    String owner,
    String repo,
    String title,
    String content, {
    String? message,
  }) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, void>> deleteWikiPage(
    String owner,
    String repo,
    String pageName,
  ) =>
      throw UnimplementedError();
}

void main() {
  group('GetRepoContentsUseCase', () {
    late MockRepoRepository mockRepo;
    late GetRepoContentsUseCase useCase;

    setUp(() {
      mockRepo = MockRepoRepository();
      useCase = GetRepoContentsUseCase(repository: mockRepo);
    });

    test('returns Right(List<ContentsResponse>) on success', () async {
      final params = GetRepoContentsParams(owner: 'gitea', repo: 'hello');
      final result = await useCase(params);
      expect(result.isRight, isTrue);
      final contents = (result as Right<Failure, List<ContentsResponse>>).value;
      expect(contents.length, 2);
      expect(contents.first.name, 'README.md');
    });

    test('returns Left(Failure) on failure', () async {
      mockRepo.shouldFail = true;
      mockRepo.failure = const ServerFailure('not found');
      final params = GetRepoContentsParams(owner: 'gitea', repo: 'hello');
      final result = await useCase(params);
      expect(result.isLeft, isTrue);
      expect(
        (result as Left<Failure, List<ContentsResponse>>).value,
        isA<ServerFailure>(),
      );
    });

    test('GetRepoContentsParams holds correct values', () {
      final params = GetRepoContentsParams(
        owner: 'owner1',
        repo: 'repo1',
        path: 'src/lib',
        ref: 'main',
      );
      expect(params.owner, 'owner1');
      expect(params.repo, 'repo1');
      expect(params.path, 'src/lib');
      expect(params.ref, 'main');
    });
  });

  group('ListPullRequestsUseCase', () {
    late MockRepoRepository mockRepo;
    late ListPullRequestsUseCase useCase;

    setUp(() {
      mockRepo = MockRepoRepository();
      useCase = ListPullRequestsUseCase(repository: mockRepo);
    });

    test('returns Right(List<PullRequest>) on success', () async {
      final params = ListPullRequestsParams(owner: 'gitea', repo: 'hello');
      final result = await useCase(params);
      expect(result.isRight, isTrue);
      final prs = (result as Right<Failure, List<PullRequest>>).value;
      expect(prs.length, 1);
      expect(prs.first.title, 'Fix bug');
    });

    test('returns Left(Failure) on failure', () async {
      mockRepo.shouldFail = true;
      mockRepo.failure = const NetworkFailure('timeout');
      final params = ListPullRequestsParams(owner: 'gitea', repo: 'hello');
      final result = await useCase(params);
      expect(result.isLeft, isTrue);
      expect(
        (result as Left<Failure, List<PullRequest>>).value,
        isA<NetworkFailure>(),
      );
    });

    test('ListPullRequestsParams holds correct values', () {
      final params = ListPullRequestsParams(
        owner: 'owner1',
        repo: 'repo1',
        state: 'open',
        page: 2,
        limit: 10,
      );
      expect(params.owner, 'owner1');
      expect(params.repo, 'repo1');
      expect(params.state, 'open');
      expect(params.page, 2);
      expect(params.limit, 10);
    });
  });
}