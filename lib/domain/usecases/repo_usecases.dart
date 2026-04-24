import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../repositories/repo_repository.dart';

class GetRepoParams {
  final String owner;
  final String repo;

  const GetRepoParams({required this.owner, required this.repo});
}

class GetRepoUseCase {
  final RepoRepository _repository;

  GetRepoUseCase({required RepoRepository repository})
    : _repository = repository;

  Future<Either<Failure, Repository>> call(GetRepoParams params) async {
    return _repository.getRepo(params.owner, params.repo);
  }
}

class SearchReposParams {
  final String? q;
  final int? uid;
  final int? page;
  final int? limit;

  const SearchReposParams({this.q, this.uid, this.page, this.limit});
}

class SearchReposUseCase {
  final RepoRepository _repository;

  SearchReposUseCase({required RepoRepository repository})
    : _repository = repository;

  Future<Either<Failure, SearchResults>> call(SearchReposParams params) async {
    return _repository.searchRepos(
      q: params.q,
      uid: params.uid,
      page: params.page,
      limit: params.limit,
    );
  }
}

class ListBranchesParams {
  final String owner;
  final String repo;
  final int? page;
  final int? limit;

  const ListBranchesParams({
    required this.owner,
    required this.repo,
    this.page,
    this.limit,
  });
}

class ListBranchesUseCase {
  final RepoRepository _repository;

  ListBranchesUseCase({required RepoRepository repository})
    : _repository = repository;

  Future<Either<Failure, List<Branch>>> call(ListBranchesParams params) async {
    return _repository.listBranches(
      params.owner,
      params.repo,
      page: params.page,
      limit: params.limit,
    );
  }
}

class ListTagsParams {
  final String owner;
  final String repo;
  final int? page;
  final int? limit;

  const ListTagsParams({
    required this.owner,
    required this.repo,
    this.page,
    this.limit,
  });
}

class ListTagsUseCase {
  final RepoRepository _repository;

  ListTagsUseCase({required RepoRepository repository})
    : _repository = repository;

  Future<Either<Failure, List<Tag>>> call(ListTagsParams params) async {
    return _repository.listTags(
      params.owner,
      params.repo,
      page: params.page,
      limit: params.limit,
    );
  }
}

class ListCommitsParams {
  final String owner;
  final String repo;
  final String? sha;
  final int? page;
  final int? limit;

  const ListCommitsParams({
    required this.owner,
    required this.repo,
    this.sha,
    this.page,
    this.limit,
  });
}

class ListCommitsUseCase {
  final RepoRepository _repository;

  ListCommitsUseCase({required RepoRepository repository})
    : _repository = repository;

  Future<Either<Failure, List<Commit>>> call(ListCommitsParams params) async {
    return _repository.listCommits(
      params.owner,
      params.repo,
      sha: params.sha,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetCommitParams {
  final String owner;
  final String repo;
  final String sha;

  const GetCommitParams({
    required this.owner,
    required this.repo,
    required this.sha,
  });
}

class GetCommitUseCase {
  final RepoRepository _repository;

  GetCommitUseCase({required RepoRepository repository})
    : _repository = repository;

  Future<Either<Failure, Commit>> call(GetCommitParams params) async {
    return _repository.getCommit(params.owner, params.repo, params.sha);
  }
}

class ListReleasesParams {
  final String owner;
  final String repo;
  final int? page;
  final int? limit;

  const ListReleasesParams({
    required this.owner,
    required this.repo,
    this.page,
    this.limit,
  });
}

class ListReleasesUseCase {
  final RepoRepository _repository;

  ListReleasesUseCase({required RepoRepository repository})
    : _repository = repository;

  Future<Either<Failure, List<Release>>> call(ListReleasesParams params) async {
    return _repository.listReleases(
      params.owner,
      params.repo,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetRepoContentsParams {
  final String owner;
  final String repo;
  final String? path;
  final String? ref;

  const GetRepoContentsParams({
    required this.owner,
    required this.repo,
    this.path,
    this.ref,
  });
}

class GetRepoContentsUseCase {
  final RepoRepository _repository;

  GetRepoContentsUseCase({required RepoRepository repository})
    : _repository = repository;

  Future<Either<Failure, List<ContentsResponse>>> call(
    GetRepoContentsParams params,
  ) async {
    return _repository.getRepoContents(
      params.owner,
      params.repo,
      path: params.path,
      ref: params.ref,
    );
  }
}

class ListPullRequestsParams {
  final String owner;
  final String repo;
  final String? state;
  final int? page;
  final int? limit;

  const ListPullRequestsParams({
    required this.owner,
    required this.repo,
    this.state,
    this.page,
    this.limit,
  });
}

class ListPullRequestsUseCase {
  final RepoRepository _repository;

  ListPullRequestsUseCase({required RepoRepository repository})
    : _repository = repository;

  Future<Either<Failure, List<PullRequest>>> call(
    ListPullRequestsParams params,
  ) async {
    return _repository.listPullRequests(
      params.owner,
      params.repo,
      state: params.state,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetPullRequestParams {
  final String owner;
  final String repo;
  final int index;

  const GetPullRequestParams({
    required this.owner,
    required this.repo,
    required this.index,
  });
}

class GetPullRequestUseCase {
  final RepoRepository _repository;

  GetPullRequestUseCase({required RepoRepository repository})
    : _repository = repository;

  Future<Either<Failure, PullRequest>> call(GetPullRequestParams params) async {
    return _repository.getPullRequest(params.owner, params.repo, params.index);
  }
}

class StarRepoParams {
  final String owner;
  final String repo;

  const StarRepoParams({required this.owner, required this.repo});
}

class StarRepoUseCase {
  final RepoRepository _repository;

  StarRepoUseCase({required RepoRepository repository})
    : _repository = repository;

  Future<Either<Failure, void>> call(StarRepoParams params) async {
    return _repository.starRepo(params.owner, params.repo);
  }
}

class UnstarRepoParams {
  final String owner;
  final String repo;

  const UnstarRepoParams({required this.owner, required this.repo});
}

class UnstarRepoUseCase {
  final RepoRepository _repository;

  UnstarRepoUseCase({required RepoRepository repository})
    : _repository = repository;

  Future<Either<Failure, void>> call(UnstarRepoParams params) async {
    return _repository.unstarRepo(params.owner, params.repo);
  }
}

class CheckStarredParams {
  final String owner;
  final String repo;

  const CheckStarredParams({required this.owner, required this.repo});
}

class CheckStarredUseCase {
  final RepoRepository _repository;

  CheckStarredUseCase({required RepoRepository repository})
    : _repository = repository;

  Future<Either<Failure, bool>> call(CheckStarredParams params) async {
    return _repository.checkStarred(params.owner, params.repo);
  }
}

class MergePullRequestParams {
  final String owner;
  final String repo;
  final int index;
  final MergePullRequestOption? body;

  const MergePullRequestParams({
    required this.owner,
    required this.repo,
    required this.index,
    this.body,
  });
}

class MergePullRequestUseCase {
  final RepoRepository _repository;

  MergePullRequestUseCase({required RepoRepository repository})
    : _repository = repository;

  Future<Either<Failure, void>> call(MergePullRequestParams params) async {
    return _repository.mergePullRequest(
      params.owner,
      params.repo,
      params.index,
      body: params.body,
    );
  }
}

class CreatePullRequestParams {
  final String owner;
  final String repo;
  final Map<String, dynamic> body;

  const CreatePullRequestParams({
    required this.owner,
    required this.repo,
    required this.body,
  });
}

class CreatePullRequestUseCase {
  final RepoRepository _repository;

  CreatePullRequestUseCase({required RepoRepository repository})
    : _repository = repository;

  Future<Either<Failure, PullRequest>> call(CreatePullRequestParams params) async {
    return _repository.createPullRequest(params.owner, params.repo, params.body);
  }
}

class EditRepoParams {
  final String owner;
  final String repo;
  final Map<String, dynamic> body;

  const EditRepoParams({
    required this.owner,
    required this.repo,
    required this.body,
  });
}

class EditRepoUseCase {
  final RepoRepository _repository;

  EditRepoUseCase({required RepoRepository repository})
    : _repository = repository;

  Future<Either<Failure, Repository>> call(EditRepoParams params) async {
    return _repository.editRepo(params.owner, params.repo, params.body);
  }
}

class DeleteRepoParams {
  final String owner;
  final String repo;

  const DeleteRepoParams({required this.owner, required this.repo});
}

class DeleteRepoUseCase {
  final RepoRepository _repository;

  DeleteRepoUseCase({required RepoRepository repository})
    : _repository = repository;

  Future<Either<Failure, void>> call(DeleteRepoParams params) async {
    return _repository.deleteRepo(params.owner, params.repo);
  }
}
