import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../repositories/organization_repository.dart';

class GetOrgUseCase {
  final OrganizationRepository _repository;

  GetOrgUseCase({required OrganizationRepository repository})
    : _repository = repository;

  Future<Either<Failure, Organization>> call(String org) async {
    return _repository.getOrg(org);
  }
}

class ListCurrentUserOrgsUseCase {
  final OrganizationRepository _repository;

  ListCurrentUserOrgsUseCase({required OrganizationRepository repository})
    : _repository = repository;

  Future<Either<Failure, List<Organization>>> call({
    int? page,
    int? limit,
  }) async {
    return _repository.listCurrentUserOrgs(page: page, limit: limit);
  }
}

class ListOrgReposUseCase {
  final OrganizationRepository _repository;

  ListOrgReposUseCase({required OrganizationRepository repository})
    : _repository = repository;

  Future<Either<Failure, List<Repository>>> call(
    ListOrgReposParams params,
  ) async {
    return _repository.listOrgRepos(
      params.org,
      page: params.page,
      limit: params.limit,
    );
  }
}

class ListOrgReposParams {
  final String org;
  final int? page;
  final int? limit;

  ListOrgReposParams({required this.org, this.page, this.limit});
}

class ListOrgTeamsUseCase {
  final OrganizationRepository _repository;

  ListOrgTeamsUseCase({required OrganizationRepository repository})
    : _repository = repository;

  Future<Either<Failure, List<Team>>> call(ListOrgTeamsParams params) async {
    return _repository.listOrgTeams(
      params.org,
      page: params.page,
      limit: params.limit,
    );
  }
}

class ListOrgTeamsParams {
  final String org;
  final int? page;
  final int? limit;

  ListOrgTeamsParams({required this.org, this.page, this.limit});
}

class GetTeamUseCase {
  final OrganizationRepository _repository;

  GetTeamUseCase({required OrganizationRepository repository})
    : _repository = repository;

  Future<Either<Failure, Team>> call(int id) async {
    return _repository.getTeam(id);
  }
}

class ListTeamMembersUseCase {
  final OrganizationRepository _repository;

  ListTeamMembersUseCase({required OrganizationRepository repository})
    : _repository = repository;

  Future<Either<Failure, List<User>>> call(ListTeamMembersParams params) async {
    return _repository.listTeamMembers(
      params.id,
      page: params.page,
      limit: params.limit,
    );
  }
}

class ListTeamMembersParams {
  final int id;
  final int? page;
  final int? limit;

  ListTeamMembersParams({required this.id, this.page, this.limit});
}

class ListTeamReposUseCase {
  final OrganizationRepository _repository;

  ListTeamReposUseCase({required OrganizationRepository repository})
    : _repository = repository;

  Future<Either<Failure, List<Repository>>> call(ListTeamReposParams params) async {
    return _repository.listTeamRepos(
      params.id,
      page: params.page,
      limit: params.limit,
    );
  }
}

class ListTeamReposParams {
  final int id;
  final int? page;
  final int? limit;

  ListTeamReposParams({required this.id, this.page, this.limit});
}

class EditOrgUseCase {
  final OrganizationRepository _repository;

  EditOrgUseCase({required OrganizationRepository repository})
    : _repository = repository;

  Future<Either<Failure, Organization>> call(EditOrgParams params) async {
    return _repository.editOrg(
      params.org,
      params.body,
    );
  }
}

class EditOrgParams {
  final String org;
  final Map<String, dynamic> body;

  EditOrgParams({required this.org, required this.body});
}

class CreateOrgUseCase {
  final OrganizationRepository _repository;

  CreateOrgUseCase({required OrganizationRepository repository})
    : _repository = repository;

  Future<Either<Failure, Organization>> call(Map<String, dynamic> body) async {
    return _repository.createOrg(body);
  }
}

class CreateTeamUseCase {
  final OrganizationRepository _repository;

  CreateTeamUseCase({required OrganizationRepository repository})
    : _repository = repository;

  Future<Either<Failure, Team>> call(CreateTeamParams params) async {
    return _repository.createTeam(params.org, params.option);
  }
}

class CreateTeamParams {
  final String org;
  final CreateTeamOption option;

  CreateTeamParams({required this.org, required this.option});
}

class EditTeamUseCase {
  final OrganizationRepository _repository;

  EditTeamUseCase({required OrganizationRepository repository})
    : _repository = repository;

  Future<Either<Failure, Team>> call(EditTeamParams params) async {
    return _repository.editTeam(params.id, params.option);
  }
}

class EditTeamParams {
  final int id;
  final EditTeamOption option;

  EditTeamParams({required this.id, required this.option});
}

class DeleteTeamUseCase {
  final OrganizationRepository _repository;

  DeleteTeamUseCase({required OrganizationRepository repository})
    : _repository = repository;

  Future<Either<Failure, void>> call(DeleteTeamParams params) async {
    return _repository.deleteTeam(params.id);
  }
}

class DeleteTeamParams {
  final int id;
  DeleteTeamParams({required this.id});
}

class AddTeamMemberUseCase {
  final OrganizationRepository _repository;

  AddTeamMemberUseCase({required OrganizationRepository repository})
    : _repository = repository;

  Future<Either<Failure, void>> call(AddTeamMemberParams params) async {
    return _repository.addTeamMember(params.id, params.username);
  }
}

class AddTeamMemberParams {
  final int id;
  final String username;

  AddTeamMemberParams({required this.id, required this.username});
}

class RemoveTeamMemberUseCase {
  final OrganizationRepository _repository;

  RemoveTeamMemberUseCase({required OrganizationRepository repository})
    : _repository = repository;

  Future<Either<Failure, void>> call(RemoveTeamMemberParams params) async {
    return _repository.removeTeamMember(params.id, params.username);
  }
}

class RemoveTeamMemberParams {
  final int id;
  final String username;

  RemoveTeamMemberParams({required this.id, required this.username});
}
