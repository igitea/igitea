import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../repositories/misc_repository.dart';
import '../repositories/user_repository.dart';

class LoginUseCase {
  final UserRepository _repository;

  LoginUseCase({required UserRepository repository}) : _repository = repository;

  Future<Either<Failure, User>> call() async {
    return _repository.getCurrentUser();
  }
}

class GetSettingsUseCase {
  final MiscRepository _repository;

  GetSettingsUseCase({required MiscRepository repository})
    : _repository = repository;

  Future<Either<Failure, GeneralAPISettings>> call() async {
    return _repository.getGeneralAPISettings();
  }
}
