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
  Future<Either<Failure, AccessToken>> createToken(
    String username, {
    required String name,
    List<String>? scopes,
  }) async {
    return execute(
      () => _apiService.userCreateToken(
        username: username,
        body: {'name': name, if (scopes != null) 'scopes': scopes},
      ),
    );
  }

  @override
  Future<Either<Failure, List<AccessToken>>> listTokens(String username) async {
    return execute(() => _apiService.userListTokens(username: username));
  }

  @override
  Future<Either<Failure, void>> deleteToken(String username, int tokenId) async {
    return execute(
      () => _apiService.userDeleteToken(username: username, tokenId: tokenId),
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

  @override
  Future<Either<Failure, List<Repository>>> listStarredRepos({
    int? page,
    int? limit,
  }) async {
    return execute(
      () => _apiService.userCurrentListStarred(page: page, limit: limit),
    );
  }

  @override
  Future<Either<Failure, List<User>>> searchUsers({
    String? q,
    int? uid,
    int? page,
    int? limit,
  }) async {
    return execute(
      () => _apiService.userSearch(q: q, uid: uid, page: page, limit: limit),
    );
  }

  @override
  Future<Either<Failure, List<GPGKey>>> listGPGKeys() async {
    return execute(() => _apiService.userCurrentListGPGKeys());
  }

  @override
  Future<Either<Failure, GPGKey>> addGPGKey(String armoredPublicKey) async {
    return execute(() => _apiService.userCurrentPostGPGKey(armoredPublicKey: armoredPublicKey));
  }

  @override
  Future<Either<Failure, void>> deleteGPGKey(int id) async {
    return execute(() => _apiService.userCurrentDeleteGPGKey(id: id));
  }

  @override
  Future<Either<Failure, bool>> checkUserFollow(String username) async {
    return execute(() => _apiService.userCheckFollow(username: username));
  }

  @override
  Future<Either<Failure, void>> followUser(String username) async {
    return execute(() => _apiService.userFollow(username: username));
  }

  @override
  Future<Either<Failure, void>> unfollowUser(String username) async {
    return execute(() => _apiService.userUnfollow(username: username));
  }
}
