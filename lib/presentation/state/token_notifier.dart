import 'package:flutter/material.dart';

import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../domain/usecases/user_usecases.dart';

sealed class TokenState {
  const TokenState();
}

class TokenInitial extends TokenState {
  const TokenInitial();
}

class TokenLoading extends TokenState {
  const TokenLoading();
}

class TokenListLoaded extends TokenState {
  final List<AccessToken> tokens;
  const TokenListLoaded(this.tokens);
}

class TokenError extends TokenState {
  final String message;
  const TokenError(this.message);
}

class TokenCreated extends TokenState {
  final AccessToken token;
  const TokenCreated(this.token);
}

class TokenDeleted extends TokenState {
  const TokenDeleted();
}

class TokenNotifier extends ChangeNotifier {
  ListTokensUseCase _listTokensUseCase;
  CreateTokenUseCase _createTokenUseCase;
  DeleteTokenUseCase _deleteTokenUseCase;

  TokenState _state = const TokenInitial();
  TokenState get state => _state;

  TokenNotifier({
    required ListTokensUseCase listTokensUseCase,
    required CreateTokenUseCase createTokenUseCase,
    required DeleteTokenUseCase deleteTokenUseCase,
  })  : _listTokensUseCase = listTokensUseCase,
        _createTokenUseCase = createTokenUseCase,
        _deleteTokenUseCase = deleteTokenUseCase;

  void updateUseCases({
    required ListTokensUseCase listTokensUseCase,
    required CreateTokenUseCase createTokenUseCase,
    required DeleteTokenUseCase deleteTokenUseCase,
  }) {
    _listTokensUseCase = listTokensUseCase;
    _createTokenUseCase = createTokenUseCase;
    _deleteTokenUseCase = deleteTokenUseCase;
  }

  Future<void> listTokens(String username) async {
    _state = const TokenLoading();
    notifyListeners();

    final result = await _listTokensUseCase(username);
    switch (result) {
      case Left<Failure, List<AccessToken>>(:final value):
        _state = TokenError(value.message);
      case Right<Failure, List<AccessToken>>(:final value):
        _state = TokenListLoaded(value);
    }
    notifyListeners();
  }

  Future<Either<Failure, AccessToken>> createToken(
    String username, {
    required String name,
    List<String>? scopes,
  }) async {
    return _createTokenUseCase(username, name: name, scopes: scopes);
  }

  Future<bool> deleteToken({
    required String username,
    required int tokenId,
  }) async {
    final result = await _deleteTokenUseCase(
      username: username,
      tokenId: tokenId,
    );
    final success = result is Right<Failure, void>;
    if (success) {
      _state = const TokenDeleted();
      notifyListeners();
    }
    return success;
  }
}
