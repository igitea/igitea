import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../repositories/package_repository.dart';

class ListPackagesUseCase {
  final PackageRepository _repository;

  ListPackagesUseCase({required PackageRepository repository})
    : _repository = repository;

  Future<Either<Failure, List<Package>>> call(ListPackagesParams params) async {
    return _repository.listPackages(
      params.owner,
      page: params.page,
      limit: params.limit,
      type: params.type,
      q: params.q,
    );
  }
}

class ListPackagesParams {
  final String owner;
  final int? page;
  final int? limit;
  final String? type;
  final String? q;

  ListPackagesParams({
    required this.owner,
    this.page,
    this.limit,
    this.type,
    this.q,
  });
}

class GetPackageUseCase {
  final PackageRepository _repository;

  GetPackageUseCase({required PackageRepository repository})
    : _repository = repository;

  Future<Either<Failure, Package>> call(GetPackageParams params) async {
    return _repository.getPackage(
      params.owner,
      params.type,
      params.name,
      params.version,
    );
  }
}

class GetPackageParams {
  final String owner;
  final String type;
  final String name;
  final String version;

  GetPackageParams({
    required this.owner,
    required this.type,
    required this.name,
    required this.version,
  });
}
