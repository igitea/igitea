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

  UserState _state = const UserInitial();
  UserState get state => _state;

  List<Activity> _activities = [];
  List<Activity> get activities => _activities;

  List<Repository> _starredRepos = [];
  List<Repository> get starredRepos => _starredRepos;

  UserNotifier({
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required ListCurrentUserReposUseCase listCurrentUserReposUseCase,
    required GetUserActivitiesUseCase getUserActivitiesUseCase,
    required ListStarredReposUseCase listStarredReposUseCase,
  }) : _getCurrentUserUseCase = getCurrentUserUseCase,
       _listCurrentUserReposUseCase = listCurrentUserReposUseCase,
       _getUserActivitiesUseCase = getUserActivitiesUseCase,
       _listStarredReposUseCase = listStarredReposUseCase;

  void updateUseCases({
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required ListCurrentUserReposUseCase listCurrentUserReposUseCase,
    required GetUserActivitiesUseCase getUserActivitiesUseCase,
    required ListStarredReposUseCase listStarredReposUseCase,
  }) {
    _getCurrentUserUseCase = getCurrentUserUseCase;
    _listCurrentUserReposUseCase = listCurrentUserReposUseCase;
    _getUserActivitiesUseCase = getUserActivitiesUseCase;
    _listStarredReposUseCase = listStarredReposUseCase;
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
    final result = await _listStarredReposUseCase.call(
      ListStarredReposParams(page: page, limit: limit),
    );
    switch (result) {
      case Left<Failure, List<Repository>>():
        _starredRepos = [];
        notifyListeners();
      case Right<Failure, List<Repository>>(:final value):
        _starredRepos = value;
        notifyListeners();
    }
  }
}
