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
