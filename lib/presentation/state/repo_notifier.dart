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

class RepoNotifier extends ChangeNotifier {
  GetRepoUseCase _getRepoUseCase;
  SearchReposUseCase _searchReposUseCase;
  ListBranchesUseCase _listBranchesUseCase;
  ListCommitsUseCase _listCommitsUseCase;
  ListTagsUseCase _listTagsUseCase;

  RepoState _state = const RepoInitial();
  RepoState get state => _state;

  RepoNotifier({
    required GetRepoUseCase getRepoUseCase,
    required SearchReposUseCase searchReposUseCase,
    required ListBranchesUseCase listBranchesUseCase,
    required ListCommitsUseCase listCommitsUseCase,
    required ListTagsUseCase listTagsUseCase,
  }) : _getRepoUseCase = getRepoUseCase,
       _searchReposUseCase = searchReposUseCase,
       _listBranchesUseCase = listBranchesUseCase,
       _listCommitsUseCase = listCommitsUseCase,
       _listTagsUseCase = listTagsUseCase;

  void updateUseCases({
    required GetRepoUseCase getRepoUseCase,
    required SearchReposUseCase searchReposUseCase,
    required ListBranchesUseCase listBranchesUseCase,
    required ListCommitsUseCase listCommitsUseCase,
    required ListTagsUseCase listTagsUseCase,
  }) {
    _getRepoUseCase = getRepoUseCase;
    _searchReposUseCase = searchReposUseCase;
    _listBranchesUseCase = listBranchesUseCase;
    _listCommitsUseCase = listCommitsUseCase;
    _listTagsUseCase = listTagsUseCase;
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
}
