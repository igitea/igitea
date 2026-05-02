import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../core/utils/repository_helper.dart';
import '../../domain/repositories/package_repository.dart';
import '../datasources/remote/gitea_api_service.dart';
import '../models/generated/generated_models.dart';

class PackageRepositoryImpl implements PackageRepository {
  final GiteaApiService _apiService;

  PackageRepositoryImpl({required GiteaApiService apiService})
    : _apiService = apiService;

  @override
  Future<Either<Failure, List<Package>>> listPackages(
    String owner, {
    int? page,
    int? limit,
    String? type,
    String? q,
  }) async {
    return execute(
      () => _apiService.listPackages(
        owner: owner,
        page: page,
        limit: limit,
        type: type,
        q: q,
      ),
    );
  }

  @override
  Future<Either<Failure, List<Package>>> listPackageVersions(
    String owner,
    String type,
    String name, {
    int? page,
    int? limit,
  }) async {
    return execute(
      () => _apiService.listPackageVersions(
        owner: owner,
        type: type,
        name: name,
        page: page,
        limit: limit,
      ),
    );
  }

  @override
  Future<Either<Failure, Package>> getPackage(
    String owner,
    String type,
    String name,
    String version,
  ) async {
    return execute(
      () => _apiService.getPackage(
        owner: owner,
        type: type,
        name: name,
        version: version,
      ),
    );
  }

  @override
  Future<Either<Failure, List<PackageFile>>> listPackageFiles(
    String owner,
    String type,
    String name,
    String version,
  ) async {
    return execute(
      () => _apiService.listPackageFiles(
        owner: owner,
        type: type,
        name: name,
        version: version,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> deletePackage(
    String owner,
    String type,
    String name,
    String version,
  ) async {
    return execute(
      () => _apiService.deletePackage(
        owner: owner,
        type: type,
        name: name,
        version: version,
      ),
    );
  }
}
