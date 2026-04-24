// ignore_for_file: non_constant_identifier_names
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../repositories/admin_repository.dart';

class SearchUsersUseCase {
  final AdminRepository _repository;

  SearchUsersUseCase({required AdminRepository repository})
    : _repository = repository;

  Future<Either<Failure, List<User>>> call(SearchUsersParams params) async {
    return _repository.searchUsers(
      source_id: params.source_id,
      login_name: params.login_name,
      page: params.page,
      limit: params.limit,
    );
  }
}

class SearchUsersParams {
  final int? source_id;
  final String? login_name;
  final int? page;
  final int? limit;

  SearchUsersParams({this.source_id, this.login_name, this.page, this.limit});
}

class CreateUserUseCase {
  final AdminRepository _repository;

  CreateUserUseCase({required AdminRepository repository})
    : _repository = repository;

  Future<Either<Failure, User>> call(Map<String, dynamic> body) async {
    return _repository.createUser(body);
  }
}

class DeleteUserUseCase {
  final AdminRepository _repository;

  DeleteUserUseCase({required AdminRepository repository})
    : _repository = repository;

  Future<Either<Failure, void>> call(DeleteUserParams params) async {
    return _repository.deleteUser(params.username, purge: params.purge);
  }
}

class DeleteUserParams {
  final String username;
  final bool? purge;

  DeleteUserParams({required this.username, this.purge});
}

class ListCronTasksUseCase {
  final AdminRepository _repository;

  ListCronTasksUseCase({required AdminRepository repository})
    : _repository = repository;

  Future<Either<Failure, List<Cron>>> call({int? page, int? limit}) async {
    return _repository.listCron(page: page, limit: limit);
  }
}

class EditUserUseCase {
  final AdminRepository _repository;

  EditUserUseCase({required AdminRepository repository})
    : _repository = repository;

  Future<Either<Failure, User>> call(EditUserParams params) async {
    return _repository.editUser(params.username, params.body);
  }
}

class EditUserParams {
  final String username;
  final Map<String, dynamic> body;

  EditUserParams({required this.username, required this.body});
}

class RunCronTaskUseCase {
  final AdminRepository _repository;

  RunCronTaskUseCase({required AdminRepository repository})
    : _repository = repository;

  Future<Either<Failure, void>> call(String task) async {
    return _repository.runCron(task);
  }
}
