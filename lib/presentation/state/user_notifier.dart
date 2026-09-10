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
  bool _activitiesHasMore = false;
  bool get activitiesHasMore => _activitiesHasMore;
  int _activitiesPage = 1;
  bool _activitiesLoadingMore = false;
  bool get activitiesLoadingMore => _activitiesLoadingMore;
  bool _activitiesLoading = false;
  bool get activitiesLoading => _activitiesLoading;
  String? _activitiesError;
  String? get activitiesError => _activitiesError;
  static const int _activitiesLimit = 20;

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

  String? _reposError;
  String? get reposError => _reposError;

  bool _reposLoading = false;
  bool get reposLoading => _reposLoading;

  Future<void> listCurrentUserRepos({int? page, int? limit}) async {
    _reposLoading = true;
    notifyListeners();
    final result = await _listCurrentUserReposUseCase.call(
      ListCurrentUserReposParams(page: page, limit: limit),
    );
    switch (result) {
      case Left<Failure, List<Repository>>(:final value):
        _reposError = value.message;
        _reposLoading = false;
        notifyListeners();
      case Right<Failure, List<Repository>>(:final value):
        _repos = value;
        _reposError = null;
        _reposLoading = false;
        notifyListeners();
    }
  }

  Future<void> getUserActivities(String username, {int? page, int? limit}) async {
    _activitiesPage = 1;
    _activitiesLoading = true;
    _activitiesError = null;
    notifyListeners();
    final result = await _getUserActivitiesUseCase.call(
      GetUserActivitiesParams(username: username, page: page ?? 1, limit: limit ?? _activitiesLimit),
    );
    switch (result) {
      case Left<Failure, List<Activity>>(:final value):
        _activitiesError = value.message;
        _activitiesLoading = false;
        notifyListeners();
      case Right<Failure, List<Activity>>(:final value):
        _activities = value;
        _activitiesHasMore = value.length >= _activitiesLimit;
        _activitiesLoading = false;
        _activitiesError = null;
        notifyListeners();
    }
  }

  Future<void> loadMoreActivities(String username) async {
    if (_activitiesLoadingMore || !_activitiesHasMore) return;
    _activitiesLoadingMore = true;
    notifyListeners();
    _activitiesPage++;
    final result = await _getUserActivitiesUseCase.call(
      GetUserActivitiesParams(username: username, page: _activitiesPage, limit: _activitiesLimit),
    );
    switch (result) {
      case Right<Failure, List<Activity>>(:final value):
        _activities = [..._activities, ...value];
        _activitiesHasMore = value.length >= _activitiesLimit;
      case Left<Failure, List<Activity>>():
        _activitiesPage--;
    }
    _activitiesLoadingMore = false;
    notifyListeners();
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
