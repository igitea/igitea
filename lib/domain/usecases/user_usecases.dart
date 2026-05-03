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

class GetUserActivitiesParams {
  final String username;
  final int? page;
  final int? limit;

  const GetUserActivitiesParams({required this.username, this.page, this.limit});
}

class GetUserActivitiesUseCase {
  final UserRepository _repository;

  GetUserActivitiesUseCase({required UserRepository repository})
    : _repository = repository;

  Future<Either<Failure, List<Activity>>> call(GetUserActivitiesParams params) async {
    return _repository.getUserActivities(
      params.username,
      page: params.page,
      limit: params.limit,
    );
  }
}

class ListStarredReposParams {
  final int? page;
  final int? limit;

  const ListStarredReposParams({this.page, this.limit});
}

class ListStarredReposUseCase {
  final UserRepository _repository;

  ListStarredReposUseCase({required UserRepository repository})
    : _repository = repository;

  Future<Either<Failure, List<Repository>>> call(ListStarredReposParams params) async {
    return _repository.listStarredRepos(
      page: params.page,
      limit: params.limit,
    );
  }
}

class SearchPublicUsersParams {
  final String? q;
  final int? uid;
  final int? page;
  final int? limit;

  const SearchPublicUsersParams({this.q, this.uid, this.page, this.limit});
}

class SearchPublicUsersUseCase {
  final UserRepository _repository;

  SearchPublicUsersUseCase({required UserRepository repository})
    : _repository = repository;

  Future<Either<Failure, List<User>>> call(SearchPublicUsersParams params) async {
    return _repository.searchUsers(
      q: params.q,
      uid: params.uid,
      page: params.page,
      limit: params.limit,
    );
  }
}
