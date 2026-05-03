import 'package:flutter/material.dart';

import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../domain/usecases/user_oauth_usecases.dart';

sealed class OAuth2AppsState {
  const OAuth2AppsState();
}

class OAuth2AppsInitial extends OAuth2AppsState {
  const OAuth2AppsInitial();
}

class OAuth2AppsLoading extends OAuth2AppsState {
  const OAuth2AppsLoading();
}

class OAuth2AppsLoaded extends OAuth2AppsState {
  final List<OAuth2Application> apps;
  const OAuth2AppsLoaded(this.apps);
}

class OAuth2AppsError extends OAuth2AppsState {
  final String message;
  const OAuth2AppsError(this.message);
}

class UserOAuthNotifier extends ChangeNotifier {
  ListOAuth2AppsUseCase _listOAuth2AppsUseCase;
  CreateOAuth2AppUseCase _createOAuth2AppUseCase;
  DeleteOAuth2AppUseCase _deleteOAuth2AppUseCase;

  UserOAuthNotifier({
    required ListOAuth2AppsUseCase listOAuth2AppsUseCase,
    required CreateOAuth2AppUseCase createOAuth2AppUseCase,
    required GetOAuth2AppUseCase getOAuth2AppUseCase,
    required DeleteOAuth2AppUseCase deleteOAuth2AppUseCase,
  }) : _listOAuth2AppsUseCase = listOAuth2AppsUseCase,
       _createOAuth2AppUseCase = createOAuth2AppUseCase,
       _deleteOAuth2AppUseCase = deleteOAuth2AppUseCase;

  void updateUseCases({
    required ListOAuth2AppsUseCase listOAuth2AppsUseCase,
    required CreateOAuth2AppUseCase createOAuth2AppUseCase,
    required GetOAuth2AppUseCase getOAuth2AppUseCase,
    required DeleteOAuth2AppUseCase deleteOAuth2AppUseCase,
  }) {
    _listOAuth2AppsUseCase = listOAuth2AppsUseCase;
    _createOAuth2AppUseCase = createOAuth2AppUseCase;
    _deleteOAuth2AppUseCase = deleteOAuth2AppUseCase;
  }

  OAuth2AppsState _appsState = const OAuth2AppsInitial();
  OAuth2AppsState get appsState => _appsState;

  Future<void> loadApps({int? page, int? limit}) async {
    _appsState = const OAuth2AppsLoading();
    notifyListeners();

    final result = await _listOAuth2AppsUseCase.call(page: page, limit: limit);
    switch (result) {
      case Left<Failure, List<OAuth2Application>>(:final value):
        _appsState = OAuth2AppsError(value.message);
        notifyListeners();
      case Right<Failure, List<OAuth2Application>>(:final value):
        _appsState = OAuth2AppsLoaded(value);
        notifyListeners();
    }
  }

  Future<void> createApp(Map<String, dynamic> body) async {
    final result = await _createOAuth2AppUseCase.call(body);
    if (result.isRight) {
      await loadApps();
    }
  }

  Future<void> deleteApp(int id) async {
    final result = await _deleteOAuth2AppUseCase.call(id);
    if (result.isRight) {
      await loadApps();
    }
  }
}
