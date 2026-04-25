import 'package:flutter/material.dart';

import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../domain/usecases/repo_usecases.dart';

sealed class RepoState {
  const RepoState();
}

class RepoInitial extends RepoState {
  const RepoInitial();
}

class RepoLoading extends RepoState {
  const RepoLoading();
}

class RepoLoaded extends RepoState {
  final Repository repo;
  const RepoLoaded(this.repo);
}

class RepoListLoaded extends RepoState {
  final List<Repository> repos;
  const RepoListLoaded(this.repos);
}

class BranchesLoaded extends RepoState {
  final List<Branch> branches;
  const BranchesLoaded(this.branches);
}

class CommitsLoaded extends RepoState {
  final List<Commit> commits;
  const CommitsLoaded(this.commits);
}

class TagsLoaded extends RepoState {
  final List<Tag> tags;
  const TagsLoaded(this.tags);
}

class SearchResultsLoaded extends RepoState {
  final SearchResults results;
  const SearchResultsLoaded(this.results);
}

class RepoError extends RepoState {
  final String message;
  const RepoError(this.message);
}

sealed class ContentsState {
  const ContentsState();
}

class ContentsInitial extends ContentsState {
  const ContentsInitial();
}

class ContentsLoading extends ContentsState {
  const ContentsLoading();
}

class ContentsLoaded extends ContentsState {
  final List<ContentsResponse> contents;
  final String path;
  final String? ref;
  const ContentsLoaded(this.contents, this.path, this.ref);
}

class ContentsError extends ContentsState {
  final String message;
  const ContentsError(this.message);
}

sealed class PullRequestsState {
  const PullRequestsState();
}

class PullRequestsInitial extends PullRequestsState {
  const PullRequestsInitial();
}

class PullRequestsLoading extends PullRequestsState {
  const PullRequestsLoading();
}

class PullRequestsLoaded extends PullRequestsState {
  final List<PullRequest> pullRequests;
  const PullRequestsLoaded(this.pullRequests);
}

class PullRequestsError extends PullRequestsState {
  final String message;
  const PullRequestsError(this.message);
}

class PullRequestDetailLoaded extends RepoState {
  final PullRequest pullRequest;
  const PullRequestDetailLoaded(this.pullRequest);
}

sealed class ReleasesState {
  const ReleasesState();
}

class ReleasesInitial extends ReleasesState {
  const ReleasesInitial();
}

class ReleasesLoading extends ReleasesState {
  const ReleasesLoading();
}

class ReleasesLoaded extends ReleasesState {
  final List<Release> releases;
  const ReleasesLoaded(this.releases);
}

class ReleasesError extends ReleasesState {
  final String message;
  const ReleasesError(this.message);
}

class RepoNotifier extends ChangeNotifier {
  GetRepoUseCase _getRepoUseCase;
  SearchReposUseCase _searchReposUseCase;
  ListBranchesUseCase _listBranchesUseCase;
  ListCommitsUseCase _listCommitsUseCase;
  ListTagsUseCase _listTagsUseCase;
  GetRepoContentsUseCase _getRepoContentsUseCase;
  ListPullRequestsUseCase _listPullRequestsUseCase;
  GetPullRequestUseCase _getPullRequestUseCase;
  ListReleasesUseCase _listReleasesUseCase;
  StarRepoUseCase _starRepoUseCase;
  UnstarRepoUseCase _unstarRepoUseCase;
  CheckStarredUseCase _checkStarredUseCase;
  MergePullRequestUseCase _mergePullRequestUseCase;
  CreatePullRequestUseCase _createPullRequestUseCase;
  EditRepoUseCase _editRepoUseCase;
  DeleteRepoUseCase _deleteRepoUseCase;
  UpdateFileUseCase _updateFileUseCase;

  RepoState _state = const RepoInitial();
  RepoState get state => _state;
  set state(RepoState value) {
    _state = value;
    notifyListeners();
  }

  ContentsState _contentsState = const ContentsInitial();
  ContentsState get contentsState => _contentsState;

  PullRequestsState _pullRequestsState = const PullRequestsInitial();
  PullRequestsState get pullRequestsState => _pullRequestsState;

  ReleasesState _releasesState = const ReleasesInitial();
  ReleasesState get releasesState => _releasesState;

  bool _isStarred = false;
  bool get isStarred => _isStarred;
  bool _starLoading = false;
  bool get starLoading => _starLoading;

  RepoNotifier({
    required GetRepoUseCase getRepoUseCase,
    required SearchReposUseCase searchReposUseCase,
    required ListBranchesUseCase listBranchesUseCase,
    required ListCommitsUseCase listCommitsUseCase,
    required ListTagsUseCase listTagsUseCase,
    required GetRepoContentsUseCase getRepoContentsUseCase,
    required ListPullRequestsUseCase listPullRequestsUseCase,
    required GetPullRequestUseCase getPullRequestUseCase,
    required ListReleasesUseCase listReleasesUseCase,
    required StarRepoUseCase starRepoUseCase,
    required UnstarRepoUseCase unstarRepoUseCase,
    required CheckStarredUseCase checkStarredUseCase,
    required MergePullRequestUseCase mergePullRequestUseCase,
    required CreatePullRequestUseCase createPullRequestUseCase,
    required EditRepoUseCase editRepoUseCase,
    required DeleteRepoUseCase deleteRepoUseCase,
    required UpdateFileUseCase updateFileUseCase,
  }) : _getRepoUseCase = getRepoUseCase,
       _searchReposUseCase = searchReposUseCase,
       _listBranchesUseCase = listBranchesUseCase,
       _listCommitsUseCase = listCommitsUseCase,
       _listTagsUseCase = listTagsUseCase,
       _getRepoContentsUseCase = getRepoContentsUseCase,
       _listPullRequestsUseCase = listPullRequestsUseCase,
       _getPullRequestUseCase = getPullRequestUseCase,
       _listReleasesUseCase = listReleasesUseCase,
       _starRepoUseCase = starRepoUseCase,
       _unstarRepoUseCase = unstarRepoUseCase,
       _checkStarredUseCase = checkStarredUseCase,
       _mergePullRequestUseCase = mergePullRequestUseCase,
       _createPullRequestUseCase = createPullRequestUseCase,
       _editRepoUseCase = editRepoUseCase,
       _deleteRepoUseCase = deleteRepoUseCase,
       _updateFileUseCase = updateFileUseCase;

  void updateUseCases({
    required GetRepoUseCase getRepoUseCase,
    required SearchReposUseCase searchReposUseCase,
    required ListBranchesUseCase listBranchesUseCase,
    required ListCommitsUseCase listCommitsUseCase,
    required ListTagsUseCase listTagsUseCase,
    required GetRepoContentsUseCase getRepoContentsUseCase,
    required ListPullRequestsUseCase listPullRequestsUseCase,
    required GetPullRequestUseCase getPullRequestUseCase,
    required ListReleasesUseCase listReleasesUseCase,
    required StarRepoUseCase starRepoUseCase,
    required UnstarRepoUseCase unstarRepoUseCase,
    required CheckStarredUseCase checkStarredUseCase,
    required MergePullRequestUseCase mergePullRequestUseCase,
    required CreatePullRequestUseCase createPullRequestUseCase,
    required EditRepoUseCase editRepoUseCase,
    required DeleteRepoUseCase deleteRepoUseCase,
    required UpdateFileUseCase updateFileUseCase,
  }) {
    _getRepoUseCase = getRepoUseCase;
    _searchReposUseCase = searchReposUseCase;
    _listBranchesUseCase = listBranchesUseCase;
    _listCommitsUseCase = listCommitsUseCase;
    _listTagsUseCase = listTagsUseCase;
    _getRepoContentsUseCase = getRepoContentsUseCase;
    _listPullRequestsUseCase = listPullRequestsUseCase;
    _getPullRequestUseCase = getPullRequestUseCase;
    _listReleasesUseCase = listReleasesUseCase;
    _starRepoUseCase = starRepoUseCase;
    _unstarRepoUseCase = unstarRepoUseCase;
    _checkStarredUseCase = checkStarredUseCase;
    _mergePullRequestUseCase = mergePullRequestUseCase;
    _createPullRequestUseCase = createPullRequestUseCase;
    _editRepoUseCase = editRepoUseCase;
    _deleteRepoUseCase = deleteRepoUseCase;
    _updateFileUseCase = updateFileUseCase;
  }

  Future<void> getRepo(String owner, String repo) async {
    _state = const RepoLoading();
    notifyListeners();

    final result = await _getRepoUseCase.call(
      GetRepoParams(owner: owner, repo: repo),
    );
    switch (result) {
      case Left<Failure, Repository>(:final value):
        _state = RepoError(value.message);
        notifyListeners();
      case Right<Failure, Repository>(:final value):
        _state = RepoLoaded(value);
        notifyListeners();
    }
  }

  Future<void> searchRepos({String? q, int? uid, int? page, int? limit}) async {
    _state = const RepoLoading();
    notifyListeners();

    final result = await _searchReposUseCase.call(
      SearchReposParams(q: q, uid: uid, page: page, limit: limit),
    );
    switch (result) {
      case Left<Failure, SearchResults>(:final value):
        _state = RepoError(value.message);
        notifyListeners();
      case Right<Failure, SearchResults>(:final value):
        _state = SearchResultsLoaded(value);
        notifyListeners();
    }
  }

  Future<void> listBranches(
    String owner,
    String repo, {
    int? page,
    int? limit,
  }) async {
    _state = const RepoLoading();
    notifyListeners();

    final result = await _listBranchesUseCase.call(
      ListBranchesParams(owner: owner, repo: repo, page: page, limit: limit),
    );
    switch (result) {
      case Left<Failure, List<Branch>>(:final value):
        _state = RepoError(value.message);
        notifyListeners();
      case Right<Failure, List<Branch>>(:final value):
        _state = BranchesLoaded(value);
        notifyListeners();
    }
  }

  Future<void> listCommits(
    String owner,
    String repo, {
    String? sha,
    int? page,
    int? limit,
  }) async {
    _state = const RepoLoading();
    notifyListeners();

    final result = await _listCommitsUseCase.call(
      ListCommitsParams(
        owner: owner,
        repo: repo,
        sha: sha,
        page: page,
        limit: limit,
      ),
    );
    switch (result) {
      case Left<Failure, List<Commit>>(:final value):
        _state = RepoError(value.message);
        notifyListeners();
      case Right<Failure, List<Commit>>(:final value):
        _state = CommitsLoaded(value);
        notifyListeners();
    }
  }

  Future<void> listTags(
    String owner,
    String repo, {
    int? page,
    int? limit,
  }) async {
    _state = const RepoLoading();
    notifyListeners();

    final result = await _listTagsUseCase.call(
      ListTagsParams(owner: owner, repo: repo, page: page, limit: limit),
    );
    switch (result) {
      case Left<Failure, List<Tag>>(:final value):
        _state = RepoError(value.message);
        notifyListeners();
      case Right<Failure, List<Tag>>(:final value):
        _state = TagsLoaded(value);
        notifyListeners();
    }
  }

  Future<void> loadContents(String owner, String repo, {String? path, String? ref}) async {
    _contentsState = const ContentsLoading();
    notifyListeners();
    final result = await _getRepoContentsUseCase.call(
      GetRepoContentsParams(owner: owner, repo: repo, path: path, ref: ref),
    );
    switch (result) {
      case Left<Failure, List<ContentsResponse>>(:final value):
        _contentsState = ContentsError(value.message);
        notifyListeners();
      case Right<Failure, List<ContentsResponse>>(:final value):
        _contentsState = ContentsLoaded(value, path ?? '', ref);
        notifyListeners();
    }
  }

  Future<void> listPullRequests(String owner, String repo, {String? state}) async {
    _pullRequestsState = const PullRequestsLoading();
    notifyListeners();
    final result = await _listPullRequestsUseCase.call(
      ListPullRequestsParams(owner: owner, repo: repo, state: state),
    );
    switch (result) {
      case Left<Failure, List<PullRequest>>(:final value):
        _pullRequestsState = PullRequestsError(value.message);
        notifyListeners();
      case Right<Failure, List<PullRequest>>(:final value):
        _pullRequestsState = PullRequestsLoaded(value);
        notifyListeners();
    }
  }

  Future<void> getPullRequest(String owner, String repo, int index) async {
    _state = const RepoLoading();
    notifyListeners();
    final result = await _getPullRequestUseCase.call(
      GetPullRequestParams(owner: owner, repo: repo, index: index),
    );
    switch (result) {
      case Left<Failure, PullRequest>(:final value):
        _state = RepoError(value.message);
        notifyListeners();
      case Right<Failure, PullRequest>(:final value):
        _state = PullRequestDetailLoaded(value);
        notifyListeners();
    }
  }

  Future<void> listReleases(String owner, String repo) async {
    _releasesState = const ReleasesLoading();
    notifyListeners();
    final result = await _listReleasesUseCase.call(
      ListReleasesParams(owner: owner, repo: repo),
    );
    switch (result) {
      case Left<Failure, List<Release>>(:final value):
        _releasesState = ReleasesError(value.message);
        notifyListeners();
      case Right<Failure, List<Release>>(:final value):
        _releasesState = ReleasesLoaded(value);
        notifyListeners();
    }
  }

  Future<void> checkStarred(String owner, String repo) async {
    _starLoading = true;
    notifyListeners();
    final result = await _checkStarredUseCase.call(
      CheckStarredParams(owner: owner, repo: repo),
    );
    switch (result) {
      case Left<Failure, bool>():
        _isStarred = false;
      case Right<Failure, bool>(:final value):
        _isStarred = value;
    }
    _starLoading = false;
    notifyListeners();
  }

  Future<void> toggleStar(String owner, String repo) async {
    if (_starLoading) return;
    _starLoading = true;
    notifyListeners();

    if (_isStarred) {
      final result = await _unstarRepoUseCase.call(
        UnstarRepoParams(owner: owner, repo: repo),
      );
      switch (result) {
        case Left<Failure, void>():
          break;
        case Right<Failure, void>():
          _isStarred = false;
      }
    } else {
      final result = await _starRepoUseCase.call(
        StarRepoParams(owner: owner, repo: repo),
      );
      switch (result) {
        case Left<Failure, void>():
          break;
        case Right<Failure, void>():
          _isStarred = true;
      }
    }
    _starLoading = false;
    notifyListeners();
  }

  Future<void> mergePullRequest(String owner, String repo, int index) async {
    _state = const RepoLoading();
    notifyListeners();

    final result = await _mergePullRequestUseCase.call(
      MergePullRequestParams(owner: owner, repo: repo, index: index),
    );
    switch (result) {
      case Left<Failure, void>(:final value):
        _state = RepoError(value.message);
        notifyListeners();
      case Right<Failure, void>():
        await getPullRequest(owner, repo, index);
    }
  }

  Future<void> createPullRequest(
    String owner,
    String repo,
    Map<String, dynamic> body,
  ) async {
    _state = const RepoLoading();
    notifyListeners();

    final result = await _createPullRequestUseCase.call(
      CreatePullRequestParams(owner: owner, repo: repo, body: body),
    );
    switch (result) {
      case Left<Failure, PullRequest>(:final value):
        _state = RepoError(value.message);
        notifyListeners();
      case Right<Failure, PullRequest>(:final value):
        _state = PullRequestDetailLoaded(value);
        notifyListeners();
    }
  }

  Future<void> editRepo(
    String owner,
    String repo,
    Map<String, dynamic> body,
  ) async {
    final result = await _editRepoUseCase.call(
      EditRepoParams(owner: owner, repo: repo, body: body),
    );
    switch (result) {
      case Left<Failure, Repository>(:final value):
        _state = RepoError(value.message);
        notifyListeners();
      case Right<Failure, Repository>(:final value):
        _state = RepoLoaded(value);
        notifyListeners();
    }
  }

  Future<void> deleteRepo(String owner, String repo) async {
    _state = const RepoLoading();
    notifyListeners();

    final result = await _deleteRepoUseCase.call(
      DeleteRepoParams(owner: owner, repo: repo),
    );
    switch (result) {
      case Left<Failure, void>(:final value):
        _state = RepoError(value.message);
        notifyListeners();
      case Right<Failure, void>():
        _state = const RepoInitial();
        notifyListeners();
    }
  }

  Future<Either<Failure, FileResponse>> updateFile(
    String owner,
    String repo,
    String filepath,
    String content,
    String message, {
    String? branch,
    String? sha,
  }) async {
    return await _updateFileUseCase.call(
      UpdateFileParams(
        owner: owner,
        repo: repo,
        filepath: filepath,
        content: content,
        message: message,
        branch: branch,
        sha: sha,
      ),
    );
  }
}
