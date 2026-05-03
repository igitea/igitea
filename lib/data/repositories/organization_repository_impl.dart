import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../core/utils/repository_helper.dart';
import '../../domain/repositories/organization_repository.dart';
import '../datasources/remote/gitea_api_service.dart';
import '../models/generated/generated_models.dart';

class OrganizationRepositoryImpl implements OrganizationRepository {
  final GiteaApiService _apiService;

  OrganizationRepositoryImpl({required GiteaApiService apiService})
    : _apiService = apiService;

  @override
  Future<Either<Failure, Organization>> getOrg(String org) async {
    return execute(() => _apiService.orgGet(org: org));
  }

  @override
  Future<Either<Failure, List<Organization>>> listCurrentUserOrgs({
    int? page,
    int? limit,
  }) async {
    return execute(
      () => _apiService.orgListCurrentUserOrgs(page: page, limit: limit),
    );
  }

  @override
  Future<Either<Failure, List<Organization>>> listUserOrgs(
    String username, {
    int? page,
    int? limit,
  }) async {
    return execute(
      () => _apiService.orgListUserOrgs(
        username: username,
        page: page,
        limit: limit,
      ),
    );
  }

  @override
  Future<Either<Failure, Organization>> createOrg(
    Map<String, dynamic> body,
  ) async {
    return execute(() => _apiService.orgCreate(body: body));
  }

  @override
  Future<Either<Failure, Organization>> editOrg(
    String org,
    Map<String, dynamic> body,
  ) async {
    return execute(() => _apiService.orgEdit(org: org, body: body));
  }

  @override
  Future<Either<Failure, void>> deleteOrg(String org) async {
    return execute(() => _apiService.orgDelete(org: org));
  }

  @override
  Future<Either<Failure, List<Repository>>> listOrgRepos(
    String org, {
    int? page,
    int? limit,
  }) async {
    return execute(
      () => _apiService.orgListRepos(org: org, page: page, limit: limit),
    );
  }

  @override
  Future<Either<Failure, List<Team>>> listOrgTeams(
    String org, {
    int? page,
    int? limit,
  }) async {
    return execute(
      () => _apiService.orgListTeams(org: org, page: page, limit: limit),
    );
  }

  @override
  Future<Either<Failure, Team>> getTeam(int id) async {
    return execute(() => _apiService.orgGetTeam(id: id));
  }

  @override
  Future<Either<Failure, List<User>>> listTeamMembers(
    int id, {
    int? page,
    int? limit,
  }) async {
    return execute(
      () => _apiService.orgListTeamMembers(id: id, page: page, limit: limit),
    );
  }

  @override
  Future<Either<Failure, List<Repository>>> listTeamRepos(
    int id, {
    int? page,
    int? limit,
  }) async {
    return execute(
      () => _apiService.orgListTeamRepos(id: id, page: page, limit: limit),
    );
  }

  @override
  Future<Either<Failure, Team>> createTeam(
    String org,
    CreateTeamOption option,
  ) async {
    return execute(
      () => _apiService.orgCreateTeam(org: org, body: option),
    );
  }

  @override
  Future<Either<Failure, Team>> editTeam(
    int id,
    EditTeamOption option,
  ) async {
    return execute(
      () => _apiService.orgEditTeam(id: id, body: option),
    );
  }

  @override
  Future<Either<Failure, void>> deleteTeam(int id) async {
    return execute(() => _apiService.orgDeleteTeam(id: id));
  }

  @override
  Future<Either<Failure, void>> addTeamMember(
    int id,
    String username,
  ) async {
    return execute(() => _apiService.orgAddTeamMember(id: id, username: username));
  }

  @override
  Future<Either<Failure, void>> removeTeamMember(
    int id,
    String username,
  ) async {
    return execute(() => _apiService.orgRemoveTeamMember(id: id, username: username));
  }

  @override
  Future<Either<Failure, List<Secret>>> listOrgActionsSecrets(String org) async {
    return execute(() => _apiService.orgListActionsSecrets(org));
  }

  @override
  Future<Either<Failure, void>> createOrUpdateOrgActionsSecret(
    String org,
    String secretName,
    Map<String, dynamic> body,
  ) async {
    return execute(() => _apiService.orgCreateOrUpdateActionsSecret(org, secretName, body));
  }

  @override
  Future<Either<Failure, void>> deleteOrgActionsSecret(
    String org,
    String secretName,
  ) async {
    return execute(() => _apiService.orgDeleteActionsSecret(org, secretName));
  }

  @override
  Future<Either<Failure, List<ActionVariable>>> listOrgActionsVariables(String org) async {
    return execute(() => _apiService.orgListActionsVariables(org));
  }

  @override
  Future<Either<Failure, ActionVariable>> getOrgActionsVariable(
    String org,
    String variableName,
  ) async {
    return execute(() => _apiService.orgGetActionsVariable(org, variableName));
  }

  @override
  Future<Either<Failure, void>> createOrUpdateOrgActionsVariable(
    String org,
    String variableName,
    Map<String, dynamic> body,
  ) async {
    return execute(() => _apiService.orgCreateOrUpdateActionsVariable(org, variableName, body));
  }

  @override
  Future<Either<Failure, void>> deleteOrgActionsVariable(
    String org,
    String variableName,
  ) async {
    return execute(() => _apiService.orgDeleteActionsVariable(org, variableName));
  }
}
