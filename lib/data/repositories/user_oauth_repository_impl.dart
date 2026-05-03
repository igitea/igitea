import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../core/utils/repository_helper.dart';
import '../../data/datasources/remote/gitea_api_service.dart';
import '../../data/models/generated/generated_models.dart';
import '../../domain/repositories/user_oauth_repository.dart';

class UserOAuthRepositoryImpl implements UserOAuthRepository {
  final GiteaApiService _apiService;

  UserOAuthRepositoryImpl({required GiteaApiService apiService})
    : _apiService = apiService;

  @override
  Future<Either<Failure, List<OAuth2Application>>> listOAuth2Apps({int? page, int? limit}) async {
    return execute(() => _apiService.userListOAuth2Apps(page: page, limit: limit));
  }

  @override
  Future<Either<Failure, OAuth2Application>> createOAuth2App(Map<String, dynamic> body) async {
    return execute(() => _apiService.userCreateOAuth2App(body));
  }

  @override
  Future<Either<Failure, OAuth2Application>> getOAuth2App(int id) async {
    return execute(() => _apiService.userGetOAuth2App(id));
  }

  @override
  Future<Either<Failure, void>> deleteOAuth2App(int id) async {
    return execute(() => _apiService.userDeleteOAuth2App(id));
  }
}
