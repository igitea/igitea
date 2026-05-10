import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../repositories/repo_repository.dart';

class AddRepoSubscriptionParams {
  final String owner;
  final String repo;
  const AddRepoSubscriptionParams({required this.owner, required this.repo});
}

class AddRepoSubscriptionUseCase {
  final RepoRepository _repository;
  AddRepoSubscriptionUseCase({required RepoRepository repository})
    : _repository = repository;
  Future<Either<Failure, void>> call(AddRepoSubscriptionParams params) async {
    return _repository.addRepoSubscription(params.owner, params.repo);
  }
}

class DeleteRepoSubscriptionParams {
  final String owner;
  final String repo;
  const DeleteRepoSubscriptionParams({required this.owner, required this.repo});
}

class DeleteRepoSubscriptionUseCase {
  final RepoRepository _repository;
  DeleteRepoSubscriptionUseCase({required RepoRepository repository})
    : _repository = repository;
  Future<Either<Failure, void>> call(DeleteRepoSubscriptionParams params) async {
    return _repository.deleteRepoSubscription(params.owner, params.repo);
  }
}

class CheckRepoSubscriptionParams {
  final String owner;
  final String repo;
  const CheckRepoSubscriptionParams({required this.owner, required this.repo});
}

class CheckRepoSubscriptionUseCase {
  final RepoRepository _repository;
  CheckRepoSubscriptionUseCase({required RepoRepository repository})
    : _repository = repository;
  Future<Either<Failure, bool>> call(CheckRepoSubscriptionParams params) async {
    return _repository.checkRepoSubscription(params.owner, params.repo);
  }
}
