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
}
