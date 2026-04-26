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

class OrgTeamDetailLoaded extends OrgState {
  final Team team;
  const OrgTeamDetailLoaded(this.team);
}

class OrgTeamMembersLoaded extends OrgState {
  final List<User> members;
  const OrgTeamMembersLoaded(this.members);
}

class OrgTeamReposLoaded extends OrgState {
  final List<Repository> repos;
  const OrgTeamReposLoaded(this.repos);
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
  GetTeamUseCase _getTeamUseCase;
  ListTeamMembersUseCase _listTeamMembersUseCase;
  ListTeamReposUseCase _listTeamReposUseCase;
  EditOrgUseCase _editOrgUseCase;
  CreateOrgUseCase _createOrgUseCase;

  // Main state for org operations (getOrg, editOrg, createOrg, listOrgs)
  OrgState _state = const OrgInitial();
  OrgState get state => _state;

  // Separate state tracks for tabs to avoid parent rebuilds
  OrgState _reposState = const OrgInitial();
  OrgState get reposState => _reposState;

  OrgState _teamsState = const OrgInitial();
  OrgState get teamsState => _teamsState;

  OrgState _teamDetailState = const OrgInitial();
  OrgState get teamDetailState => _teamDetailState;

  OrgNotifier({
    required GetOrgUseCase getOrgUseCase,
    required ListCurrentUserOrgsUseCase listCurrentUserOrgsUseCase,
    required ListOrgReposUseCase listOrgReposUseCase,
    required ListOrgTeamsUseCase listOrgTeamsUseCase,
    required GetTeamUseCase getTeamUseCase,
    required ListTeamMembersUseCase listTeamMembersUseCase,
    required ListTeamReposUseCase listTeamReposUseCase,
    required EditOrgUseCase editOrgUseCase,
    required CreateOrgUseCase createOrgUseCase,
  }) : _getOrgUseCase = getOrgUseCase,
       _listCurrentUserOrgsUseCase = listCurrentUserOrgsUseCase,
       _listOrgReposUseCase = listOrgReposUseCase,
       _listOrgTeamsUseCase = listOrgTeamsUseCase,
       _getTeamUseCase = getTeamUseCase,
       _listTeamMembersUseCase = listTeamMembersUseCase,
       _listTeamReposUseCase = listTeamReposUseCase,
       _editOrgUseCase = editOrgUseCase,
       _createOrgUseCase = createOrgUseCase;

  void updateUseCases({
    required GetOrgUseCase getOrgUseCase,
    required ListCurrentUserOrgsUseCase listCurrentUserOrgsUseCase,
    required ListOrgReposUseCase listOrgReposUseCase,
    required ListOrgTeamsUseCase listOrgTeamsUseCase,
    required GetTeamUseCase getTeamUseCase,
    required ListTeamMembersUseCase listTeamMembersUseCase,
    required ListTeamReposUseCase listTeamReposUseCase,
    required EditOrgUseCase editOrgUseCase,
    required CreateOrgUseCase createOrgUseCase,
  }) {
    _getOrgUseCase = getOrgUseCase;
    _listCurrentUserOrgsUseCase = listCurrentUserOrgsUseCase;
    _listOrgReposUseCase = listOrgReposUseCase;
    _listOrgTeamsUseCase = listOrgTeamsUseCase;
    _getTeamUseCase = getTeamUseCase;
    _listTeamMembersUseCase = listTeamMembersUseCase;
    _listTeamReposUseCase = listTeamReposUseCase;
    _editOrgUseCase = editOrgUseCase;
    _createOrgUseCase = createOrgUseCase;
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
    _reposState = const OrgLoading();
    notifyListeners();

    final result = await _listOrgReposUseCase.call(
      ListOrgReposParams(org: org, page: page, limit: limit),
    );
    switch (result) {
      case Left<Failure, List<Repository>>(:final value):
        _reposState = OrgError(value.message);
        notifyListeners();
      case Right<Failure, List<Repository>>(:final value):
        _reposState = OrgReposLoaded(value);
        notifyListeners();
    }
  }

  Future<void> listOrgTeams(String org, {int? page, int? limit}) async {
    _teamsState = const OrgLoading();
    notifyListeners();

    final result = await _listOrgTeamsUseCase.call(
      ListOrgTeamsParams(org: org, page: page, limit: limit),
    );
    switch (result) {
      case Left<Failure, List<Team>>(:final value):
        _teamsState = OrgError(value.message);
        notifyListeners();
      case Right<Failure, List<Team>>(:final value):
        _teamsState = OrgTeamsLoaded(value);
        notifyListeners();
    }
  }

  Future<void> getTeam(int id) async {
    _teamDetailState = const OrgLoading();
    notifyListeners();

    final result = await _getTeamUseCase.call(id);
    switch (result) {
      case Left<Failure, Team>(:final value):
        _teamDetailState = OrgError(value.message);
        notifyListeners();
      case Right<Failure, Team>(:final value):
        _teamDetailState = OrgTeamDetailLoaded(value);
        notifyListeners();
    }
  }

  Future<void> listTeamMembers(int id, {int? page, int? limit}) async {
    _teamDetailState = const OrgLoading();
    notifyListeners();

    final result = await _listTeamMembersUseCase.call(
      ListTeamMembersParams(id: id, page: page, limit: limit),
    );
    switch (result) {
      case Left<Failure, List<User>>(:final value):
        _teamDetailState = OrgError(value.message);
        notifyListeners();
      case Right<Failure, List<User>>(:final value):
        _teamDetailState = OrgTeamMembersLoaded(value);
        notifyListeners();
    }
  }

  Future<void> listTeamRepos(int id, {int? page, int? limit}) async {
    _teamDetailState = const OrgLoading();
    notifyListeners();

    final result = await _listTeamReposUseCase.call(
      ListTeamReposParams(id: id, page: page, limit: limit),
    );
    switch (result) {
      case Left<Failure, List<Repository>>(:final value):
        _teamDetailState = OrgError(value.message);
        notifyListeners();
      case Right<Failure, List<Repository>>(:final value):
        _teamDetailState = OrgTeamReposLoaded(value);
        notifyListeners();
    }
  }

  Future<void> editOrg(String org, Map<String, dynamic> body) async {
    _state = const OrgLoading();
    notifyListeners();

    final result = await _editOrgUseCase.call(EditOrgParams(org: org, body: body));
    switch (result) {
      case Left<Failure, Organization>(:final value):
        _state = OrgError(value.message);
        notifyListeners();
      case Right<Failure, Organization>(:final value):
        _state = OrgLoaded(value);
        notifyListeners();
    }
  }

  Future<void> createOrg(Map<String, dynamic> body) async {
    _state = const OrgLoading();
    notifyListeners();

    final result = await _createOrgUseCase.call(body);
    switch (result) {
      case Left<Failure, Organization>(:final value):
        _state = OrgError(value.message);
        notifyListeners();
      case Right<Failure, Organization>(:final value):
        _state = OrgLoaded(value);
        notifyListeners();
    }
  }
}
