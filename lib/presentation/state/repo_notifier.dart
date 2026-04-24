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
  ListReleasesUseCase _listReleasesUseCase;

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

  RepoNotifier({
    required GetRepoUseCase getRepoUseCase,
    required SearchReposUseCase searchReposUseCase,
    required ListBranchesUseCase listBranchesUseCase,
    required ListCommitsUseCase listCommitsUseCase,
    required ListTagsUseCase listTagsUseCase,
    required GetRepoContentsUseCase getRepoContentsUseCase,
    required ListPullRequestsUseCase listPullRequestsUseCase,
    required ListReleasesUseCase listReleasesUseCase,
  }) : _getRepoUseCase = getRepoUseCase,
       _searchReposUseCase = searchReposUseCase,
       _listBranchesUseCase = listBranchesUseCase,
       _listCommitsUseCase = listCommitsUseCase,
       _listTagsUseCase = listTagsUseCase,
       _getRepoContentsUseCase = getRepoContentsUseCase,
       _listPullRequestsUseCase = listPullRequestsUseCase,
       _listReleasesUseCase = listReleasesUseCase;

  void updateUseCases({
    required GetRepoUseCase getRepoUseCase,
    required SearchReposUseCase searchReposUseCase,
    required ListBranchesUseCase listBranchesUseCase,
    required ListCommitsUseCase listCommitsUseCase,
    required ListTagsUseCase listTagsUseCase,
    required GetRepoContentsUseCase getRepoContentsUseCase,
    required ListPullRequestsUseCase listPullRequestsUseCase,
    required ListReleasesUseCase listReleasesUseCase,
  }) {
    _getRepoUseCase = getRepoUseCase;
    _searchReposUseCase = searchReposUseCase;
    _listBranchesUseCase = listBranchesUseCase;
    _listCommitsUseCase = listCommitsUseCase;
    _listTagsUseCase = listTagsUseCase;
    _getRepoContentsUseCase = getRepoContentsUseCase;
    _listPullRequestsUseCase = listPullRequestsUseCase;
    _listReleasesUseCase = listReleasesUseCase;
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
}
