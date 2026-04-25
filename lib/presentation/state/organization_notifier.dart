import 'package:flutter/material.dart';

import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../domain/usecases/organization_usecases.dart';

sealed class OrgState {
  const OrgState();
}

class OrgInitial extends OrgState {
  const OrgInitial();
}

class OrgLoading extends OrgState {
  const OrgLoading();
}

class OrgLoaded extends OrgState {
  final Organization org;
  const OrgLoaded(this.org);
}

class OrgListLoaded extends OrgState {
  final List<Organization> orgs;
  const OrgListLoaded(this.orgs);
}

class OrgReposLoaded extends OrgState {
  final List<Repository> repos;
  const OrgReposLoaded(this.repos);
}

class OrgTeamsLoaded extends OrgState {
  final List<Team> teams;
  const OrgTeamsLoaded(this.teams);
}

class OrgError extends OrgState {
  final String message;
  const OrgError(this.message);
}

class OrgNotifier extends ChangeNotifier {
  GetOrgUseCase _getOrgUseCase;
  ListCurrentUserOrgsUseCase _listCurrentUserOrgsUseCase;
  ListOrgReposUseCase _listOrgReposUseCase;
  ListOrgTeamsUseCase _listOrgTeamsUseCase;

  OrgState _state = const OrgInitial();
  OrgState get state => _state;

  OrgNotifier({
    required GetOrgUseCase getOrgUseCase,
    required ListCurrentUserOrgsUseCase listCurrentUserOrgsUseCase,
    required ListOrgReposUseCase listOrgReposUseCase,
    required ListOrgTeamsUseCase listOrgTeamsUseCase,
  }) : _getOrgUseCase = getOrgUseCase,
       _listCurrentUserOrgsUseCase = listCurrentUserOrgsUseCase,
       _listOrgReposUseCase = listOrgReposUseCase,
       _listOrgTeamsUseCase = listOrgTeamsUseCase;

  void updateUseCases({
    required GetOrgUseCase getOrgUseCase,
    required ListCurrentUserOrgsUseCase listCurrentUserOrgsUseCase,
    required ListOrgReposUseCase listOrgReposUseCase,
    required ListOrgTeamsUseCase listOrgTeamsUseCase,
  }) {
    _getOrgUseCase = getOrgUseCase;
    _listCurrentUserOrgsUseCase = listCurrentUserOrgsUseCase;
    _listOrgReposUseCase = listOrgReposUseCase;
    _listOrgTeamsUseCase = listOrgTeamsUseCase;
  }

  Future<void> getOrg(String org) async {
    _state = const OrgLoading();
    notifyListeners();

    final result = await _getOrgUseCase.call(org);
    switch (result) {
      case Left<Failure, Organization>(:final value):
        _state = OrgError(value.message);
        notifyListeners();
      case Right<Failure, Organization>(:final value):
        _state = OrgLoaded(value);
        notifyListeners();
    }
  }

  Future<void> listCurrentUserOrgs({int? page, int? limit}) async {
    _state = const OrgLoading();
    notifyListeners();

    final result = await _listCurrentUserOrgsUseCase.call(
      page: page,
      limit: limit,
    );
    switch (result) {
      case Left<Failure, List<Organization>>(:final value):
        _state = OrgError(value.message);
        notifyListeners();
      case Right<Failure, List<Organization>>(:final value):
        _state = OrgListLoaded(value);
        notifyListeners();
    }
  }

  Future<void> listOrgRepos(String org, {int? page, int? limit}) async {
    _state = const OrgLoading();
    notifyListeners();

    final result = await _listOrgReposUseCase.call(
      ListOrgReposParams(org: org, page: page, limit: limit),
    );
    switch (result) {
      case Left<Failure, List<Repository>>(:final value):
        _state = OrgError(value.message);
        notifyListeners();
      case Right<Failure, List<Repository>>(:final value):
        _state = OrgReposLoaded(value);
        notifyListeners();
    }
  }

  Future<void> listOrgTeams(String org, {int? page, int? limit}) async {
    _state = const OrgLoading();
    notifyListeners();

    final result = await _listOrgTeamsUseCase.call(
      ListOrgTeamsParams(org: org, page: page, limit: limit),
    );
    switch (result) {
      case Left<Failure, List<Team>>(:final value):
        _state = OrgError(value.message);
        notifyListeners();
      case Right<Failure, List<Team>>(:final value):
        _state = OrgTeamsLoaded(value);
        notifyListeners();
    }
  }
}
