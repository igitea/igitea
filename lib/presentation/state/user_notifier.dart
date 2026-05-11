import 'package:flutter/material.dart';

import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../domain/usecases/user_usecases.dart';

sealed class UserState {
  const UserState();
}

class UserInitial extends UserState {
  const UserInitial();
}

class UserLoading extends UserState {
  const UserLoading();
}

class UserLoaded extends UserState {
  final User user;
  const UserLoaded(this.user);
}

class UserError extends UserState {
  final String message;
  const UserError(this.message);
}

class UserNotifier extends ChangeNotifier {
  GetCurrentUserUseCase _getCurrentUserUseCase;
  ListCurrentUserReposUseCase _listCurrentUserReposUseCase;
  GetUserActivitiesUseCase _getUserActivitiesUseCase;
  ListStarredReposUseCase _listStarredReposUseCase;
  SearchPublicUsersUseCase _searchPublicUsersUseCase;

  UserState _state = const UserInitial();
  UserState get state => _state;

  List<Activity> _activities = [];
  List<Activity> get activities => _activities;

  List<Repository> _starredRepos = [];
  List<Repository> get starredRepos => _starredRepos;
  bool _starredHasMore = false;
  bool get starredHasMore => _starredHasMore;
  int _starredPage = 1;
  bool _starredLoadingMore = false;
  bool get starredLoadingMore => _starredLoadingMore;
  static const int _starredLimit = 20;

  List<User> _searchedUsers = [];
  List<User> get searchedUsers => _searchedUsers;

  bool _searchUsersLoading = false;
  bool get searchUsersLoading => _searchUsersLoading;

  String? _searchUsersError;
  String? get searchUsersError => _searchUsersError;

  UserNotifier({
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required ListCurrentUserReposUseCase listCurrentUserReposUseCase,
    required GetUserActivitiesUseCase getUserActivitiesUseCase,
    required ListStarredReposUseCase listStarredReposUseCase,
    required SearchPublicUsersUseCase searchPublicUsersUseCase,
  }) : _getCurrentUserUseCase = getCurrentUserUseCase,
       _listCurrentUserReposUseCase = listCurrentUserReposUseCase,
       _getUserActivitiesUseCase = getUserActivitiesUseCase,
       _listStarredReposUseCase = listStarredReposUseCase,
       _searchPublicUsersUseCase = searchPublicUsersUseCase;

  void updateUseCases({
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required ListCurrentUserReposUseCase listCurrentUserReposUseCase,
    required GetUserActivitiesUseCase getUserActivitiesUseCase,
    required ListStarredReposUseCase listStarredReposUseCase,
    required SearchPublicUsersUseCase searchPublicUsersUseCase,
  }) {
    _getCurrentUserUseCase = getCurrentUserUseCase;
    _listCurrentUserReposUseCase = listCurrentUserReposUseCase;
    _getUserActivitiesUseCase = getUserActivitiesUseCase;
    _listStarredReposUseCase = listStarredReposUseCase;
    _searchPublicUsersUseCase = searchPublicUsersUseCase;
  }

  Future<void> loadCurrentUser() async {
    _state = const UserLoading();
    notifyListeners();

    final result = await _getCurrentUserUseCase.call();
    switch (result) {
      case Left<Failure, User>(:final value):
        _state = UserError(value.message);
        notifyListeners();
      case Right<Failure, User>(:final value):
        _state = UserLoaded(value);
        notifyListeners();
    }
  }

  List<Repository> _repos = [];
  List<Repository> get repos => _repos;

  Future<void> listCurrentUserRepos({int? page, int? limit}) async {
    final result = await _listCurrentUserReposUseCase.call(
      ListCurrentUserReposParams(page: page, limit: limit),
    );
    switch (result) {
      case Left<Failure, List<Repository>>(:final value):
        _state = UserError(value.message);
        notifyListeners();
      case Right<Failure, List<Repository>>(:final value):
        _repos = value;
        notifyListeners();
    }
  }

  Future<void> getUserActivities(String username, {int? page, int? limit}) async {
    final result = await _getUserActivitiesUseCase.call(
      GetUserActivitiesParams(username: username, page: page, limit: limit),
    );
    switch (result) {
      case Left<Failure, List<Activity>>():
        _activities = [];
        notifyListeners();
      case Right<Failure, List<Activity>>(:final value):
        _activities = value;
        notifyListeners();
    }
  }

  Future<void> listStarredRepos({int? page, int? limit}) async {
    _starredPage = 1;
    final result = await _listStarredReposUseCase.call(
      ListStarredReposParams(page: page ?? 1, limit: limit ?? _starredLimit),
    );
    switch (result) {
      case Left<Failure, List<Repository>>():
        _starredRepos = [];
        notifyListeners();
      case Right<Failure, List<Repository>>(:final value):
        _starredRepos = value;
        _starredHasMore = value.length >= _starredLimit;
        notifyListeners();
    }
  }

  Future<void> loadMoreStarredRepos() async {
    if (_starredLoadingMore || !_starredHasMore) return;
    _starredLoadingMore = true;
    notifyListeners();
    _starredPage++;
    final result = await _listStarredReposUseCase.call(
      ListStarredReposParams(page: _starredPage, limit: _starredLimit),
    );
    switch (result) {
      case Right<Failure, List<Repository>>(:final value):
        _starredRepos = [..._starredRepos, ...value];
        _starredHasMore = value.length >= _starredLimit;
      case Left<Failure, List<Repository>>():
        _starredPage--;
    }
    _starredLoadingMore = false;
    notifyListeners();
  }

  Future<void> searchUsers(String query) async {
    _searchUsersLoading = true;
    _searchUsersError = null;
    notifyListeners();

    final result = await _searchPublicUsersUseCase.call(
      SearchPublicUsersParams(q: query),
    );
    switch (result) {
      case Left<Failure, List<User>>(:final value):
        _searchUsersError = value.message;
        _searchedUsers = [];
      case Right<Failure, List<User>>(:final value):
        _searchedUsers = value;
        _searchUsersError = null;
    }
    _searchUsersLoading = false;
    notifyListeners();
  }
}
