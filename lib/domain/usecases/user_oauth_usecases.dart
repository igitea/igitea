import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../repositories/user_oauth_repository.dart';

class ListOAuth2AppsUseCase {
  final UserOAuthRepository _repository;

  ListOAuth2AppsUseCase({required UserOAuthRepository repository})
    : _repository = repository;

  Future<Either<Failure, List<OAuth2Application>>> call({int? page, int? limit}) async {
    return _repository.listOAuth2Apps(page: page, limit: limit);
  }
}

class CreateOAuth2AppUseCase {
  final UserOAuthRepository _repository;

  CreateOAuth2AppUseCase({required UserOAuthRepository repository})
    : _repository = repository;

  Future<Either<Failure, OAuth2Application>> call(Map<String, dynamic> body) async {
    return _repository.createOAuth2App(body);
  }
}

class GetOAuth2AppUseCase {
  final UserOAuthRepository _repository;

  GetOAuth2AppUseCase({required UserOAuthRepository repository})
    : _repository = repository;

  Future<Either<Failure, OAuth2Application>> call(int id) async {
    return _repository.getOAuth2App(id);
  }
}

class DeleteOAuth2AppUseCase {
  final UserOAuthRepository _repository;

  DeleteOAuth2AppUseCase({required UserOAuthRepository repository})
    : _repository = repository;

  Future<Either<Failure, void>> call(int id) async {
    return _repository.deleteOAuth2App(id);
  }
}
