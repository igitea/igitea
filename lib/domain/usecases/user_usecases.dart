import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../repositories/user_repository.dart';

class GetCurrentUserUseCase {
  final UserRepository _repository;

  GetCurrentUserUseCase({required UserRepository repository})
    : _repository = repository;

  Future<Either<Failure, User>> call() async {
    return _repository.getCurrentUser();
  }
}

class GetUserUseCase {
  final UserRepository _repository;

  GetUserUseCase({required UserRepository repository})
    : _repository = repository;

  Future<Either<Failure, User>> call(String username) async {
    return _repository.getUser(username);
  }
}

class ListUserReposParams {
  final String username;
  final int? page;
  final int? limit;

  const ListUserReposParams({required this.username, this.page, this.limit});
}

class ListUserReposUseCase {
  final UserRepository _repository;

  ListUserReposUseCase({required UserRepository repository})
    : _repository = repository;

  Future<Either<Failure, List<Repository>>> call(
    ListUserReposParams params,
  ) async {
    return _repository.listUserRepos(
      params.username,
      page: params.page,
      limit: params.limit,
    );
  }
}

class ListCurrentUserReposParams {
  final int? page;
  final int? limit;

  const ListCurrentUserReposParams({this.page, this.limit});
}

class ListCurrentUserReposUseCase {
  final UserRepository _repository;

  ListCurrentUserReposUseCase({required UserRepository repository})
    : _repository = repository;

  Future<Either<Failure, List<Repository>>> call(
    ListCurrentUserReposParams params,
  ) async {
    return _repository.listCurrentUserRepos(
      page: params.page,
      limit: params.limit,
    );
  }
}

class ListFollowersParams {
  final String username;
  final int? page;
  final int? limit;

  const ListFollowersParams({required this.username, this.page, this.limit});
}

class ListFollowersUseCase {
  final UserRepository _repository;

  ListFollowersUseCase({required UserRepository repository})
    : _repository = repository;

  Future<Either<Failure, List<User>>> call(ListFollowersParams params) async {
    return _repository.listFollowers(
      params.username,
      page: params.page,
      limit: params.limit,
    );
  }
}

class ListFollowingParams {
  final String username;
  final int? page;
  final int? limit;

  const ListFollowingParams({required this.username, this.page, this.limit});
}

class ListFollowingUseCase {
  final UserRepository _repository;

  ListFollowingUseCase({required UserRepository repository})
    : _repository = repository;

  Future<Either<Failure, List<User>>> call(ListFollowingParams params) async {
    return _repository.listFollowing(
      params.username,
      page: params.page,
      limit: params.limit,
    );
  }
}
