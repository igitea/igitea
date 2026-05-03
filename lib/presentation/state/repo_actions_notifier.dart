import 'package:flutter/material.dart';

import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../domain/usecases/repo_usecases.dart';

sealed class RepoActionsSecretsState {
  const RepoActionsSecretsState();
}

class RepoActionsSecretsInitial extends RepoActionsSecretsState {
  const RepoActionsSecretsInitial();
}

class RepoActionsSecretsLoading extends RepoActionsSecretsState {
  const RepoActionsSecretsLoading();
}

class RepoActionsSecretsLoaded extends RepoActionsSecretsState {
  final List<Secret> secrets;
  const RepoActionsSecretsLoaded(this.secrets);
}

class RepoActionsSecretsError extends RepoActionsSecretsState {
  final String message;
  const RepoActionsSecretsError(this.message);
}

sealed class RepoActionsVariablesState {
  const RepoActionsVariablesState();
}

class RepoActionsVariablesInitial extends RepoActionsVariablesState {
  const RepoActionsVariablesInitial();
}

class RepoActionsVariablesLoading extends RepoActionsVariablesState {
  const RepoActionsVariablesLoading();
}

class RepoActionsVariablesLoaded extends RepoActionsVariablesState {
  final List<ActionVariable> variables;
  const RepoActionsVariablesLoaded(this.variables);
}

class RepoActionsVariablesError extends RepoActionsVariablesState {
  final String message;
  const RepoActionsVariablesError(this.message);
}

class RepoActionsNotifier extends ChangeNotifier {
  ListRepoActionsSecretsUseCase _listSecretsUseCase;
  CreateOrUpdateRepoActionsSecretUseCase _createSecretUseCase;
  DeleteRepoActionsSecretUseCase _deleteSecretUseCase;
  ListRepoActionsVariablesUseCase _listVariablesUseCase;
  GetRepoActionsVariableUseCase _getVariableUseCase;
  CreateOrUpdateRepoActionsVariableUseCase _createVariableUseCase;
  DeleteRepoActionsVariableUseCase _deleteVariableUseCase;

  RepoActionsNotifier({
    required ListRepoActionsSecretsUseCase listRepoActionsSecretsUseCase,
    required CreateOrUpdateRepoActionsSecretUseCase createOrUpdateRepoActionsSecretUseCase,
    required DeleteRepoActionsSecretUseCase deleteRepoActionsSecretUseCase,
    required ListRepoActionsVariablesUseCase listRepoActionsVariablesUseCase,
    required GetRepoActionsVariableUseCase getRepoActionsVariableUseCase,
    required CreateOrUpdateRepoActionsVariableUseCase createOrUpdateRepoActionsVariableUseCase,
    required DeleteRepoActionsVariableUseCase deleteRepoActionsVariableUseCase,
  }) : _listSecretsUseCase = listRepoActionsSecretsUseCase,
       _createSecretUseCase = createOrUpdateRepoActionsSecretUseCase,
       _deleteSecretUseCase = deleteRepoActionsSecretUseCase,
       _listVariablesUseCase = listRepoActionsVariablesUseCase,
       _getVariableUseCase = getRepoActionsVariableUseCase,
       _createVariableUseCase = createOrUpdateRepoActionsVariableUseCase,
       _deleteVariableUseCase = deleteRepoActionsVariableUseCase;

  void updateUseCases({
    required ListRepoActionsSecretsUseCase listRepoActionsSecretsUseCase,
    required CreateOrUpdateRepoActionsSecretUseCase createOrUpdateRepoActionsSecretUseCase,
    required DeleteRepoActionsSecretUseCase deleteRepoActionsSecretUseCase,
    required ListRepoActionsVariablesUseCase listRepoActionsVariablesUseCase,
    required GetRepoActionsVariableUseCase getRepoActionsVariableUseCase,
    required CreateOrUpdateRepoActionsVariableUseCase createOrUpdateRepoActionsVariableUseCase,
    required DeleteRepoActionsVariableUseCase deleteRepoActionsVariableUseCase,
  }) {
    _listSecretsUseCase = listRepoActionsSecretsUseCase;
    _createSecretUseCase = createOrUpdateRepoActionsSecretUseCase;
    _deleteSecretUseCase = deleteRepoActionsSecretUseCase;
    _listVariablesUseCase = listRepoActionsVariablesUseCase;
    _getVariableUseCase = getRepoActionsVariableUseCase;
    _createVariableUseCase = createOrUpdateRepoActionsVariableUseCase;
    _deleteVariableUseCase = deleteRepoActionsVariableUseCase;
  }

  RepoActionsSecretsState _secretsState = const RepoActionsSecretsInitial();
  RepoActionsSecretsState get secretsState => _secretsState;

  RepoActionsVariablesState _variablesState = const RepoActionsVariablesInitial();
  RepoActionsVariablesState get variablesState => _variablesState;

  Future<void> loadSecrets(String owner, String repo) async {
    _secretsState = const RepoActionsSecretsLoading();
    notifyListeners();

    final result = await _listSecretsUseCase.call(
      ListRepoActionsSecretsParams(owner: owner, repo: repo),
    );
    switch (result) {
      case Left<Failure, List<Secret>>(:final value):
        _secretsState = RepoActionsSecretsError(value.message);
      case Right<Failure, List<Secret>>(:final value):
        _secretsState = RepoActionsSecretsLoaded(value);
    }
    notifyListeners();
  }

  Future<void> createSecret(String owner, String repo, String secretName, String secretValue) async {
    final result = await _createSecretUseCase.call(
      CreateOrUpdateRepoActionsSecretParams(
        owner: owner,
        repo: repo,
        secretName: secretName,
        body: {'data': secretValue},
      ),
    );
    if (result.isRight) {
      await loadSecrets(owner, repo);
    }
  }

  Future<void> deleteSecret(String owner, String repo, String secretName) async {
    final result = await _deleteSecretUseCase.call(
      DeleteRepoActionsSecretParams(owner: owner, repo: repo, secretName: secretName),
    );
    if (result.isRight) {
      await loadSecrets(owner, repo);
    }
  }

  Future<void> loadVariables(String owner, String repo) async {
    _variablesState = const RepoActionsVariablesLoading();
    notifyListeners();

    final result = await _listVariablesUseCase.call(
      ListRepoActionsVariablesParams(owner: owner, repo: repo),
    );
    switch (result) {
      case Left<Failure, List<ActionVariable>>(:final value):
        _variablesState = RepoActionsVariablesError(value.message);
      case Right<Failure, List<ActionVariable>>(:final value):
        _variablesState = RepoActionsVariablesLoaded(value);
    }
    notifyListeners();
  }

  Future<void> createVariable(String owner, String repo, String variableName, String variableValue) async {
    final result = await _createVariableUseCase.call(
      CreateOrUpdateRepoActionsVariableParams(
        owner: owner,
        repo: repo,
        variableName: variableName,
        body: {'data': variableValue},
      ),
    );
    if (result.isRight) {
      await loadVariables(owner, repo);
    }
  }

  Future<void> deleteVariable(String owner, String repo, String variableName) async {
    final result = await _deleteVariableUseCase.call(
      DeleteRepoActionsVariableParams(owner: owner, repo: repo, variableName: variableName),
    );
    if (result.isRight) {
      await loadVariables(owner, repo);
    }
  }
}
