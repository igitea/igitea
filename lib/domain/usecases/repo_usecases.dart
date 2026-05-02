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

class GetTagParams {
  final String owner;
  final String repo;
  final String tag;

  const GetTagParams({
    required this.owner,
    required this.repo,
    required this.tag,
  });
}

class GetTagUseCase {
  final RepoRepository _repository;

  GetTagUseCase({required RepoRepository repository})
    : _repository = repository;

  Future<Either<Failure, Tag>> call(GetTagParams params) async {
    return _repository.getTag(params.owner, params.repo, params.tag);
  }
}

class ListCommitsParams {
  final String owner;
  final String repo;
  final String? sha;
  final String? path;
  final int? page;
  final int? limit;

  const ListCommitsParams({
    required this.owner,
    required this.repo,
    this.sha,
    this.path,
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
      path: params.path,
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

class CreateReleaseUseCase {
  final RepoRepository _repository;

  CreateReleaseUseCase({required RepoRepository repository})
    : _repository = repository;

  Future<Either<Failure, Release>> call(CreateReleaseParams params) async {
    return _repository.createRelease(
      params.owner,
      params.repo,
      params.option,
    );
  }
}

class CreateReleaseParams {
  final String owner;
  final String repo;
  final CreateReleaseOption option;

  CreateReleaseParams({
    required this.owner,
    required this.repo,
    required this.option,
  });
}

class EditReleaseUseCase {
  final RepoRepository _repository;

  EditReleaseUseCase({required RepoRepository repository})
    : _repository = repository;

  Future<Either<Failure, Release>> call(EditReleaseParams params) async {
    return _repository.editRelease(
      params.owner,
      params.repo,
      params.id,
      params.option,
    );
  }
}

class EditReleaseParams {
  final String owner;
  final String repo;
  final int id;
  final EditReleaseOption option;

  EditReleaseParams({
    required this.owner,
    required this.repo,
    required this.id,
    required this.option,
  });
}

class DeleteReleaseUseCase {
  final RepoRepository _repository;

  DeleteReleaseUseCase({required RepoRepository repository})
    : _repository = repository;

  Future<Either<Failure, void>> call(DeleteReleaseParams params) async {
    return _repository.deleteRelease(
      params.owner,
      params.repo,
      params.id,
    );
  }
}

class DeleteReleaseParams {
  final String owner;
  final String repo;
  final int id;

  DeleteReleaseParams({
    required this.owner,
    required this.repo,
    required this.id,
  });
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

class UpdateFileParams {
  final String owner;
  final String repo;
  final String filepath;
  final String content;
  final String message;
  final String? branch;
  final String? sha;

  const UpdateFileParams({
    required this.owner,
    required this.repo,
    required this.filepath,
    required this.content,
    required this.message,
    this.branch,
    this.sha,
  });
}

class UpdateFileUseCase {
  final RepoRepository _repository;

  UpdateFileUseCase({required RepoRepository repository})
    : _repository = repository;

  Future<Either<Failure, FileResponse>> call(UpdateFileParams params) async {
    return _repository.updateFile(
      params.owner,
      params.repo,
      params.filepath,
      UpdateFileOptions(
        content: params.content,
        message: params.message,
        branch: params.branch,
        sha: params.sha,
      ),
    );
  }
}

class CreateForkParams {
  final String owner;
  final String repo;
  final String? name;
  final String? organization;

  const CreateForkParams({
    required this.owner,
    required this.repo,
    this.name,
    this.organization,
  });
}

class CreateForkUseCase {
  final RepoRepository _repository;

  CreateForkUseCase({required RepoRepository repository})
    : _repository = repository;

  Future<Either<Failure, Repository>> call(CreateForkParams params) async {
    return _repository.createFork(
      params.owner,
      params.repo,
      body: CreateForkOption(
        name: params.name,
        organization: params.organization,
      ),
    );
  }
}

class CreateRepoParams {
  final String name;
  final String? description;
  final bool? isPrivate;
  final bool? autoInit;
  final String? defaultBranch;
  final String? license;
  final String? readme;

  const CreateRepoParams({
    required this.name,
    this.description,
    this.isPrivate,
    this.autoInit,
    this.defaultBranch,
    this.license,
    this.readme,
  });
}

class CreateRepoUseCase {
  final RepoRepository _repository;

  CreateRepoUseCase({required RepoRepository repository})
    : _repository = repository;

  Future<Either<Failure, Repository>> call(CreateRepoParams params) async {
    return _repository.createRepo({
      'name': params.name,
      if (params.description != null) 'description': params.description,
      if (params.isPrivate != null) 'private': params.isPrivate,
      if (params.autoInit != null) 'auto_init': params.autoInit,
      if (params.defaultBranch != null) 'default_branch': params.defaultBranch,
      if (params.license != null) 'license': params.license,
      if (params.readme != null) 'readme': params.readme,
    });
  }
}

class GetWikiPageParams {
  final String owner;
  final String repo;
  final String pageName;

  const GetWikiPageParams({
    required this.owner,
    required this.repo,
    required this.pageName,
  });
}

class GetWikiPageUseCase {
  final RepoRepository _repository;

  GetWikiPageUseCase({required RepoRepository repository})
    : _repository = repository;

  Future<Either<Failure, WikiPage>> call(GetWikiPageParams params) async {
    return _repository.getWikiPage(
      params.owner,
      params.repo,
      params.pageName,
    );
  }
}

class ListWikiPagesParams {
  final String owner;
  final String repo;

  const ListWikiPagesParams({
    required this.owner,
    required this.repo,
  });
}

class ListWikiPagesUseCase {
  final RepoRepository _repository;

  ListWikiPagesUseCase({required RepoRepository repository})
    : _repository = repository;

  Future<Either<Failure, List<WikiPageMetaData>>> call(
    ListWikiPagesParams params,
  ) async {
    return _repository.listWikiPages(params.owner, params.repo);
  }
}

class CreateWikiPageParams {
  final String owner;
  final String repo;
  final String title;
  final String content;
  final String? message;

  const CreateWikiPageParams({
    required this.owner,
    required this.repo,
    required this.title,
    required this.content,
    this.message,
  });
}

class CreateWikiPageUseCase {
  final RepoRepository _repository;

  CreateWikiPageUseCase({required RepoRepository repository})
    : _repository = repository;

  Future<Either<Failure, WikiPage>> call(CreateWikiPageParams params) async {
    return _repository.createWikiPage(
      params.owner,
      params.repo,
      params.title,
      params.content,
      message: params.message,
    );
  }
}

class EditWikiPageParams {
  final String owner;
  final String repo;
  final String title;
  final String content;
  final String? message;

  const EditWikiPageParams({
    required this.owner,
    required this.repo,
    required this.title,
    required this.content,
    this.message,
  });
}

class EditWikiPageUseCase {
  final RepoRepository _repository;

  EditWikiPageUseCase({required RepoRepository repository})
    : _repository = repository;

  Future<Either<Failure, WikiPage>> call(EditWikiPageParams params) async {
    return _repository.editWikiPage(
      params.owner,
      params.repo,
      params.title,
      params.content,
      message: params.message,
    );
  }
}

class DeleteWikiPageParams {
  final String owner;
  final String repo;
  final String pageName;

  const DeleteWikiPageParams({
    required this.owner,
    required this.repo,
    required this.pageName,
  });
}

class DeleteWikiPageUseCase {
  final RepoRepository _repository;

  DeleteWikiPageUseCase({required RepoRepository repository})
    : _repository = repository;

  Future<Either<Failure, void>> call(DeleteWikiPageParams params) async {
    return _repository.deleteWikiPage(
      params.owner,
      params.repo,
      params.pageName,
    );
  }
}

class ListHooksParams {
  final String owner;
  final String repo;
  final int? page;
  final int? limit;

  const ListHooksParams({
    required this.owner,
    required this.repo,
    this.page,
    this.limit,
  });
}

class ListHooksUseCase {
  final RepoRepository _repository;

  ListHooksUseCase({required RepoRepository repository})
    : _repository = repository;

  Future<Either<Failure, List<Hook>>> call(ListHooksParams params) async {
    return _repository.listHooks(
      params.owner,
      params.repo,
      page: params.page,
      limit: params.limit,
    );
  }
}

class CreateHookParams {
  final String owner;
  final String repo;
  final Map<String, dynamic> body;

  const CreateHookParams({
    required this.owner,
    required this.repo,
    required this.body,
  });
}

class CreateHookUseCase {
  final RepoRepository _repository;

  CreateHookUseCase({required RepoRepository repository})
    : _repository = repository;

  Future<Either<Failure, Hook>> call(CreateHookParams params) async {
    return _repository.createHook(params.owner, params.repo, params.body);
  }
}

class DeleteHookParams {
  final String owner;
  final String repo;
  final int id;

  const DeleteHookParams({
    required this.owner,
    required this.repo,
    required this.id,
  });
}

class DeleteHookUseCase {
  final RepoRepository _repository;

  DeleteHookUseCase({required RepoRepository repository})
    : _repository = repository;

  Future<Either<Failure, void>> call(DeleteHookParams params) async {
    return _repository.deleteHook(params.owner, params.repo, params.id);
  }
}

class ListCollaboratorsUseCase {
  final RepoRepository _repository;
  ListCollaboratorsUseCase({required RepoRepository repository}) : _repository = repository;
  Future<Either<Failure, List<User>>> call(ListCollaboratorsParams params) async {
    return _repository.listCollaborators(params.owner, params.repo, page: params.page, limit: params.limit);
  }
}

class ListCollaboratorsParams {
  final String owner; final String repo; final int? page; final int? limit;
  ListCollaboratorsParams({required this.owner, required this.repo, this.page, this.limit});
}

class AddCollaboratorUseCase {
  final RepoRepository _repository;
  AddCollaboratorUseCase({required RepoRepository repository}) : _repository = repository;
  Future<Either<Failure, void>> call(AddCollaboratorParams params) async {
    return _repository.addCollaborator(params.owner, params.repo, params.collaborator, params.body ?? {});
  }
}

class AddCollaboratorParams {
  final String owner; final String repo; final String collaborator; final Map<String, dynamic>? body;
  AddCollaboratorParams({required this.owner, required this.repo, required this.collaborator, this.body});
}

class RemoveCollaboratorUseCase {
  final RepoRepository _repository;
  RemoveCollaboratorUseCase({required RepoRepository repository}) : _repository = repository;
  Future<Either<Failure, void>> call(RemoveCollaboratorParams params) async {
    return _repository.removeCollaborator(params.owner, params.repo, params.collaborator);
  }
}

class RemoveCollaboratorParams {
  final String owner; final String repo; final String collaborator;
  RemoveCollaboratorParams({required this.owner, required this.repo, required this.collaborator});
}
