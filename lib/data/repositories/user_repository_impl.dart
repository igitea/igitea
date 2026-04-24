import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../core/utils/repository_helper.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/remote/gitea_api_service.dart';
import '../models/generated/generated_models.dart';

/// Implementation of [UserRepository] using [GiteaApiService].
class UserRepositoryImpl implements UserRepository {
  final GiteaApiService _apiService;

  UserRepositoryImpl({required GiteaApiService apiService})
    : _apiService = apiService;

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    return execute(() => _apiService.userGetCurrent());
  }

  @override
  Future<Either<Failure, User>> getUser(String username) async {
    return execute(() => _apiService.userGet(username: username));
  }

  @override
  Future<Either<Failure, List<Repository>>> listUserRepos(
    String username, {
    int? page,
    int? limit,
  }) async {
    return execute(
      () => _apiService.userListRepos(
        username: username,
        page: page,
        limit: limit,
      ),
    );
  }

  @override
  Future<Either<Failure, List<Repository>>> listCurrentUserRepos({
    int? page,
    int? limit,
  }) async {
    return execute(
      () => _apiService.userCurrentListRepos(page: page, limit: limit),
    );
  }

  @override
  Future<Either<Failure, List<User>>> listFollowers(
    String username, {
    int? page,
    int? limit,
  }) async {
    return execute(
      () => _apiService.userListFollowers(
        username: username,
        page: page,
        limit: limit,
      ),
    );
  }

  @override
  Future<Either<Failure, List<User>>> listFollowing(
    String username, {
    int? page,
    int? limit,
  }) async {
    return execute(
      () => _apiService.userListFollowing(
        username: username,
        page: page,
        limit: limit,
      ),
    );
  }

  @override
  Future<Either<Failure, AccessToken>> createToken(String name) async {
    return execute(
      () => _apiService.userCreateToken(username: name, body: {'name': name}),
    );
  }

  @override
  Future<Either<Failure, List<Email>>> listEmails() async {
    return execute(() => _apiService.userListEmails());
  }

  @override
  Future<Either<Failure, void>> addEmail(List<String> emails) async {
    return execute(() => _apiService.userAddEmail(body: {'emails': emails}));
  }

  @override
  Future<Either<Failure, void>> deleteEmail(List<String> emails) async {
    return execute(() => _apiService.userDeleteEmail(body: {'emails': emails}));
  }

  @override
  Future<Either<Failure, List<PublicKey>>> listKeys(String username) async {
    return execute(() => _apiService.userListKeys(username: username));
  }

  @override
  Future<Either<Failure, List<PublicKey>>> listCurrentUserKeys() async {
    return execute(() => _apiService.userCurrentListKeys());
  }

  @override
  Future<Either<Failure, PublicKey>> addKey(String title, String key) async {
    return execute(
      () => _apiService.userCurrentPostKey(body: {'title': title, 'key': key}),
    );
  }

  @override
  Future<Either<Failure, void>> deleteKey(int id) async {
    return execute(() => _apiService.userCurrentDeleteKey(id: id));
  }

  @override
  Future<Either<Failure, List<Activity>>> getUserActivities(
    String username, {
    int? page,
    int? limit,
  }) async {
    return execute(
      () => _apiService.listUserActivities(username, page: page, limit: limit),
    );
  }
}
