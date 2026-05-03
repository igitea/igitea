// ignore_for_file: non_constant_identifier_names
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../core/utils/repository_helper.dart';
import '../../domain/repositories/admin_repository.dart';
import '../datasources/remote/gitea_api_service.dart';
import '../models/generated/generated_models.dart';

class AdminRepositoryImpl implements AdminRepository {
  final GiteaApiService _apiService;

  AdminRepositoryImpl({required GiteaApiService apiService})
    : _apiService = apiService;

  @override
  Future<Either<Failure, List<User>>> searchUsers({
    int? source_id,
    String? login_name,
    int? page,
    int? limit,
  }) async {
    return execute(
      () => _apiService.adminSearchUsers(
        source_id: source_id,
        login_name: login_name,
        page: page,
        limit: limit,
      ),
    );
  }

  @override
  Future<Either<Failure, User>> createUser(Map<String, dynamic> body) async {
    return execute(() => _apiService.adminCreateUser(body: body));
  }

  @override
  Future<Either<Failure, void>> deleteUser(
    String username, {
    bool? purge,
  }) async {
    return execute(
      () => _apiService.adminDeleteUser(username: username, purge: purge),
    );
  }

  @override
  Future<Either<Failure, User>> editUser(
    String username,
    Map<String, dynamic> body,
  ) async {
    return execute(
      () => _apiService.adminEditUser(username: username, body: body),
    );
  }

  @override
  Future<Either<Failure, List<Organization>>> getAllOrgs({
    int? page,
    int? limit,
  }) async {
    return execute(() => _apiService.adminGetAllOrgs(page: page, limit: limit));
  }

  @override
  Future<Either<Failure, List<Cron>>> listCron({int? page, int? limit}) async {
    return execute(() => _apiService.adminCronList(page: page, limit: limit));
  }

  @override
  Future<Either<Failure, void>> runCron(String task) async {
    return execute(() => _apiService.adminCronRun(task: task));
  }

  @override
  Future<Either<Failure, List<Hook>>> listAdminHooks({
    int? page,
    int? limit,
    String? type,
  }) async {
    return execute(
      () => _apiService.adminListHooks(page: page, limit: limit, type: type),
    );
  }

  @override
  Future<Either<Failure, Hook>> getAdminHook(int id) async {
    return execute(() => _apiService.adminGetHook(id: id));
  }

  @override
  Future<Either<Failure, Hook>> createAdminHook(
    Map<String, dynamic> body,
  ) async {
    return execute(() => _apiService.adminCreateHook(body: body));
  }

  @override
  Future<Either<Failure, void>> deleteAdminHook(int id) async {
    return execute(() => _apiService.adminDeleteHook(id: id));
  }

  @override
  Future<Either<Failure, List<ActionRunner>>> listAdminRunners({int? page, int? limit}) async {
    return execute(() => _apiService.adminGetRunners(page: page, limit: limit));
  }

  @override
  Future<Either<Failure, ActionRunner>> getAdminRunner(int runnerId) async {
    return execute(() => _apiService.adminGetRunner(runnerId: runnerId));
  }

  @override
  Future<Either<Failure, String>> getAdminRunnerRegistrationToken() async {
    return execute(() => _apiService.adminGetRunnerRegistrationToken());
  }

  @override
  Future<Either<Failure, List<Badge>>> listUserBadges(String username) async {
    return execute(() => _apiService.adminListUserBadges(username: username));
  }

  @override
  Future<Either<Failure, Badge>> createUserBadge(String username, Map<String, dynamic> body) async {
    return execute(() => _apiService.adminCreateUserBadge(username: username, body: body));
  }

  @override
  Future<Either<Failure, void>> deleteUserBadge(String username, int badgeId) async {
    return execute(() => _apiService.adminDeleteUserBadge(username: username, badgeId: badgeId));
  }

  @override
  Future<Either<Failure, List<Email>>> listAdminEmails({int? page, int? limit}) async {
    return execute(() => _apiService.adminListEmails(page: page, limit: limit));
  }
}
