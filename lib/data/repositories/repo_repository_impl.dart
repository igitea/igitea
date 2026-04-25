import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../core/utils/repository_helper.dart';
import '../../domain/repositories/repo_repository.dart';
import '../datasources/remote/gitea_api_service.dart';
import '../models/generated/generated_models.dart';

/// Implementation of [RepoRepository] using [GiteaApiService].
class RepoRepositoryImpl implements RepoRepository {
  final GiteaApiService _apiService;

  RepoRepositoryImpl({required GiteaApiService apiService})
    : _apiService = apiService;

  @override
  Future<Either<Failure, Repository>> getRepo(String owner, String repo) async {
    return execute(() => _apiService.repoGet(owner: owner, repo: repo));
  }

  @override
  Future<Either<Failure, void>> deleteRepo(String owner, String repo) async {
    return execute(() => _apiService.repoDelete(owner: owner, repo: repo));
  }

  @override
  Future<Either<Failure, Repository>> editRepo(
    String owner,
    String repo,
    Map<String, dynamic> body,
  ) async {
    return execute(
      () => _apiService.repoEdit(owner: owner, repo: repo, body: body),
    );
  }

  @override
  Future<Either<Failure, Repository>> migrateRepo(
    Map<String, dynamic> body,
  ) async {
    return execute(() => _apiService.repoMigrate(body: body));
  }

  @override
  Future<Either<Failure, List<Branch>>> listBranches(
    String owner,
    String repo, {
    int? page,
    int? limit,
  }) async {
    return execute(
      () => _apiService.repoListBranches(
        owner: owner,
        repo: repo,
        page: page,
        limit: limit,
      ),
    );
  }

  @override
  Future<Either<Failure, Branch>> getBranch(
    String owner,
    String repo,
    String branch,
  ) async {
    return execute(
      () => _apiService.repoGetBranch(owner: owner, repo: repo, branch: branch),
    );
  }

  @override
  Future<Either<Failure, List<Tag>>> listTags(
    String owner,
    String repo, {
    int? page,
    int? limit,
  }) async {
    return execute(
      () => _apiService.repoListTags(
        owner: owner,
        repo: repo,
        page: page,
        limit: limit,
      ),
    );
  }

  @override
  Future<Either<Failure, Tag>> getTag(
    String owner,
    String repo,
    String tag,
  ) async {
    return execute(
      () => _apiService.repoGetTag(owner: owner, repo: repo, tag: tag),
    );
  }

  @override
  Future<Either<Failure, List<Commit>>> listCommits(
    String owner,
    String repo, {
    String? sha,
    int? page,
    int? limit,
  }) async {
    return execute(
      () => _apiService.repoGetAllCommits(
        owner: owner,
        repo: repo,
        sha: sha,
        page: page,
        limit: limit,
      ),
    );
  }

  @override
  Future<Either<Failure, Commit>> getCommit(
    String owner,
    String repo,
    String sha,
  ) async {
    return execute(
      () => _apiService.repoGetSingleCommit(owner: owner, repo: repo, sha: sha),
    );
  }

  @override
  Future<Either<Failure, List<Release>>> listReleases(
    String owner,
    String repo, {
    int? page,
    int? limit,
  }) async {
    return execute(
      () => _apiService.repoListReleases(
        owner: owner,
        repo: repo,
        page: page,
        limit: limit,
      ),
    );
  }

  @override
  Future<Either<Failure, Release>> getRelease(
    String owner,
    String repo,
    int id,
  ) async {
    return execute(
      () => _apiService.repoGetRelease(owner: owner, repo: repo, id: id),
    );
  }

  @override
  Future<Either<Failure, List<User>>> listCollaborators(
    String owner,
    String repo, {
    int? page,
    int? limit,
  }) async {
    return execute(
      () => _apiService.repoListCollaborators(
        owner: owner,
        repo: repo,
        page: page,
        limit: limit,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> addCollaborator(
    String owner,
    String repo,
    String collaborator,
    Map<String, dynamic> body,
  ) async {
    return execute(
      () => _apiService.repoAddCollaborator(
        owner: owner,
        repo: repo,
        collaborator: collaborator,
        body: body,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> removeCollaborator(
    String owner,
    String repo,
    String collaborator,
  ) async {
    return execute(
      () => _apiService.repoDeleteCollaborator(
        owner: owner,
        repo: repo,
        collaborator: collaborator,
      ),
    );
  }

  @override
  Future<Either<Failure, List<Hook>>> listHooks(
    String owner,
    String repo, {
    int? page,
    int? limit,
  }) async {
    return execute(
      () => _apiService.repoListHooks(
        owner: owner,
        repo: repo,
        page: page,
        limit: limit,
      ),
    );
  }

  @override
  Future<Either<Failure, Hook>> createHook(
    String owner,
    String repo,
    Map<String, dynamic> body,
  ) async {
    return execute(
      () => _apiService.repoCreateHook(owner: owner, repo: repo, body: body),
    );
  }

  @override
  Future<Either<Failure, void>> deleteHook(
    String owner,
    String repo,
    int id,
  ) async {
    return execute(
      () => _apiService.repoDeleteHook(owner: owner, repo: repo, id: id),
    );
  }

  @override
  Future<Either<Failure, List<ContentsResponse>>> getRepoContents(
    String owner,
    String repo, {
    String? path,
    String? ref,
  }) async {
    return execute(
      () => _apiService.repoGetContents(
        owner: owner,
        repo: repo,
        path: path,
        ref: ref,
      ),
    );
  }

  @override
  Future<Either<Failure, FileResponse>> updateFile(
    String owner,
    String repo,
    String filepath,
    UpdateFileOptions body,
  ) async {
    return execute(
      () => _apiService.repoUpdateFile(
        owner: owner,
        repo: repo,
        filepath: filepath,
        body: body,
      ),
    );
  }

  @override
  Future<Either<Failure, List<PullRequest>>> listPullRequests(
    String owner,
    String repo, {
    String? state,
    int? page,
    int? limit,
  }) async {
    return execute(
      () => _apiService.repoListPullRequests(
        owner: owner,
        repo: repo,
        state: state,
        page: page,
        limit: limit,
      ),
    );
  }

  @override
  Future<Either<Failure, PullRequest>> getPullRequest(
    String owner,
    String repo,
    int index,
  ) async {
    return execute(
      () => _apiService.repoGetPullRequest(owner: owner, repo: repo, index: index),
    );
  }

  @override
  Future<Either<Failure, SearchResults>> searchRepos({
    String? q,
    int? uid,
    int? page,
    int? limit,
  }) async {
    return execute(
      () => _apiService.repoSearch(q: q, uid: uid, page: page, limit: limit),
    );
  }

  @override
  Future<Either<Failure, void>> starRepo(String owner, String repo) async {
    return execute(() async {
      await _apiService.userCurrentPutStar(owner: owner, repo: repo);
    });
  }

  @override
  Future<Either<Failure, void>> unstarRepo(String owner, String repo) async {
    return execute(() async {
      await _apiService.userCurrentDeleteStar(owner: owner, repo: repo);
    });
  }

  @override
  Future<Either<Failure, bool>> checkStarred(String owner, String repo) async {
    return execute(
      () => _apiService.userCurrentCheckStar(owner: owner, repo: repo),
    );
  }

  @override
  Future<Either<Failure, PullRequest>> createPullRequest(
    String owner,
    String repo,
    Map<String, dynamic> body,
  ) async {
    return execute(
      () => _apiService.repoCreatePullRequest(owner: owner, repo: repo, body: body),
    );
  }

  @override
  Future<Either<Failure, void>> mergePullRequest(
    String owner,
    String repo,
    int index, {
    MergePullRequestOption? body,
  }) async {
    return execute(
      () => _apiService.repoMergePullRequest(
        owner: owner,
        repo: repo,
        index: index,
        body: body,
      ),
    );
  }
}
