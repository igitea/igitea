import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';

/// Repository interface for organization-related operations.
abstract class OrganizationRepository {
  /// Get an organization by name.
  Future<Either<Failure, Organization>> getOrg(String org);

  /// List organizations for the current user.
  Future<Either<Failure, List<Organization>>> listCurrentUserOrgs({
    int? page,
    int? limit,
  });

  /// List organizations for a user.
  Future<Either<Failure, List<Organization>>> listUserOrgs(
    String username, {
    int? page,
    int? limit,
  });

  /// Create an organization.
  Future<Either<Failure, Organization>> createOrg(Map<String, dynamic> body);

  /// Edit an organization.
  Future<Either<Failure, Organization>> editOrg(
    String org,
    Map<String, dynamic> body,
  );

  /// Delete an organization.
  Future<Either<Failure, void>> deleteOrg(String org);

  /// List repositories in an organization.
  Future<Either<Failure, List<Repository>>> listOrgRepos(
    String org, {
    int? page,
    int? limit,
  });

  /// List teams in an organization.
  Future<Either<Failure, List<Team>>> listOrgTeams(
    String org, {
    int? page,
    int? limit,
  });

  /// Get a team by id.
  Future<Either<Failure, Team>> getTeam(int id);

  /// List members of a team.
  Future<Either<Failure, List<User>>> listTeamMembers(
    int id, {
    int? page,
    int? limit,
  });

  /// List repositories of a team.
  Future<Either<Failure, List<Repository>>> listTeamRepos(
    int id, {
    int? page,
    int? limit,
  });

  /// Create a team in an organization.
  Future<Either<Failure, Team>> createTeam(
    String org,
    CreateTeamOption option,
  );

  /// Edit a team.
  Future<Either<Failure, Team>> editTeam(
    int id,
    EditTeamOption option,
  );

  /// Delete a team.
  Future<Either<Failure, void>> deleteTeam(int id);

  /// Add a member to a team.
  Future<Either<Failure, void>> addTeamMember(
    int id,
    String username,
  );

  /// Remove a member from a team.
  Future<Either<Failure, void>> removeTeamMember(
    int id,
    String username,
  );
}
