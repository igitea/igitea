import 'package:flutter/material.dart';

import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../domain/usecases/organization_usecases.dart';

sealed class OrgActionsSecretsState {
  const OrgActionsSecretsState();
}

class OrgActionsSecretsInitial extends OrgActionsSecretsState {
  const OrgActionsSecretsInitial();
}

class OrgActionsSecretsLoading extends OrgActionsSecretsState {
  const OrgActionsSecretsLoading();
}

class OrgActionsSecretsLoaded extends OrgActionsSecretsState {
  final List<Secret> secrets;
  const OrgActionsSecretsLoaded(this.secrets);
}

class OrgActionsSecretsError extends OrgActionsSecretsState {
  final String message;
  const OrgActionsSecretsError(this.message);
}

sealed class OrgActionsVariablesState {
  const OrgActionsVariablesState();
}

class OrgActionsVariablesInitial extends OrgActionsVariablesState {
  const OrgActionsVariablesInitial();
}

class OrgActionsVariablesLoading extends OrgActionsVariablesState {
  const OrgActionsVariablesLoading();
}

class OrgActionsVariablesLoaded extends OrgActionsVariablesState {
  final List<ActionVariable> variables;
  const OrgActionsVariablesLoaded(this.variables);
}

class OrgActionsVariablesError extends OrgActionsVariablesState {
  final String message;
  const OrgActionsVariablesError(this.message);
}

class OrgActionsNotifier extends ChangeNotifier {
  ListOrgActionsSecretsUseCase _listSecretsUseCase;
  CreateOrUpdateOrgActionsSecretUseCase _createSecretUseCase;
  DeleteOrgActionsSecretUseCase _deleteSecretUseCase;
  ListOrgActionsVariablesUseCase _listVariablesUseCase;
  GetOrgActionsVariableUseCase _getVariableUseCase;
  CreateOrUpdateOrgActionsVariableUseCase _createVariableUseCase;
  DeleteOrgActionsVariableUseCase _deleteVariableUseCase;

  OrgActionsNotifier({
    required ListOrgActionsSecretsUseCase listOrgActionsSecretsUseCase,
    required CreateOrUpdateOrgActionsSecretUseCase createOrUpdateOrgActionsSecretUseCase,
    required DeleteOrgActionsSecretUseCase deleteOrgActionsSecretUseCase,
    required ListOrgActionsVariablesUseCase listOrgActionsVariablesUseCase,
    required GetOrgActionsVariableUseCase getOrgActionsVariableUseCase,
    required CreateOrUpdateOrgActionsVariableUseCase createOrUpdateOrgActionsVariableUseCase,
    required DeleteOrgActionsVariableUseCase deleteOrgActionsVariableUseCase,
  }) : _listSecretsUseCase = listOrgActionsSecretsUseCase,
       _createSecretUseCase = createOrUpdateOrgActionsSecretUseCase,
       _deleteSecretUseCase = deleteOrgActionsSecretUseCase,
       _listVariablesUseCase = listOrgActionsVariablesUseCase,
       _getVariableUseCase = getOrgActionsVariableUseCase,
       _createVariableUseCase = createOrUpdateOrgActionsVariableUseCase,
       _deleteVariableUseCase = deleteOrgActionsVariableUseCase;

  void updateUseCases({
    required ListOrgActionsSecretsUseCase listOrgActionsSecretsUseCase,
    required CreateOrUpdateOrgActionsSecretUseCase createOrUpdateOrgActionsSecretUseCase,
    required DeleteOrgActionsSecretUseCase deleteOrgActionsSecretUseCase,
    required ListOrgActionsVariablesUseCase listOrgActionsVariablesUseCase,
    required GetOrgActionsVariableUseCase getOrgActionsVariableUseCase,
    required CreateOrUpdateOrgActionsVariableUseCase createOrUpdateOrgActionsVariableUseCase,
    required DeleteOrgActionsVariableUseCase deleteOrgActionsVariableUseCase,
  }) {
    _listSecretsUseCase = listOrgActionsSecretsUseCase;
    _createSecretUseCase = createOrUpdateOrgActionsSecretUseCase;
    _deleteSecretUseCase = deleteOrgActionsSecretUseCase;
    _listVariablesUseCase = listOrgActionsVariablesUseCase;
    _getVariableUseCase = getOrgActionsVariableUseCase;
    _createVariableUseCase = createOrUpdateOrgActionsVariableUseCase;
    _deleteVariableUseCase = deleteOrgActionsVariableUseCase;
  }

  OrgActionsSecretsState _secretsState = const OrgActionsSecretsInitial();
  OrgActionsSecretsState get secretsState => _secretsState;

  OrgActionsVariablesState _variablesState = const OrgActionsVariablesInitial();
  OrgActionsVariablesState get variablesState => _variablesState;

  Future<void> loadSecrets(String org) async {
    _secretsState = const OrgActionsSecretsLoading();
    notifyListeners();

    final result = await _listSecretsUseCase.call(org);
    switch (result) {
      case Left<Failure, List<Secret>>(:final value):
        _secretsState = OrgActionsSecretsError(value.message);
      case Right<Failure, List<Secret>>(:final value):
        _secretsState = OrgActionsSecretsLoaded(value);
    }
    notifyListeners();
  }

  Future<void> createSecret(String org, String secretName, String secretValue) async {
    final result = await _createSecretUseCase.call(
      CreateOrUpdateOrgActionsSecretParams(
        org: org,
        secretName: secretName,
        body: {'data': secretValue},
      ),
    );
    if (result.isRight) {
      await loadSecrets(org);
    }
  }

  Future<void> deleteSecret(String org, String secretName) async {
    final result = await _deleteSecretUseCase.call(
      DeleteOrgActionsSecretParams(org: org, secretName: secretName),
    );
    if (result.isRight) {
      await loadSecrets(org);
    }
  }

  Future<void> loadVariables(String org) async {
    _variablesState = const OrgActionsVariablesLoading();
    notifyListeners();

    final result = await _listVariablesUseCase.call(org);
    switch (result) {
      case Left<Failure, List<ActionVariable>>(:final value):
        _variablesState = OrgActionsVariablesError(value.message);
      case Right<Failure, List<ActionVariable>>(:final value):
        _variablesState = OrgActionsVariablesLoaded(value);
    }
    notifyListeners();
  }

  Future<void> createVariable(String org, String variableName, String variableValue) async {
    final result = await _createVariableUseCase.call(
      CreateOrUpdateOrgActionsVariableParams(
        org: org,
        variableName: variableName,
        body: {'data': variableValue},
      ),
    );
    if (result.isRight) {
      await loadVariables(org);
    }
  }

  Future<void> deleteVariable(String org, String variableName) async {
    final result = await _deleteVariableUseCase.call(
      DeleteOrgActionsVariableParams(org: org, variableName: variableName),
    );
    if (result.isRight) {
      await loadVariables(org);
    }
  }
}
