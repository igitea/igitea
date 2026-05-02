import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';

/// Repository interface for package-related operations.
abstract class PackageRepository {
  /// List packages for an owner.
  Future<Either<Failure, List<Package>>> listPackages(
    String owner, {
    int? page,
    int? limit,
    String? type,
    String? q,
  });

  /// List all versions of a package.
  Future<Either<Failure, List<Package>>> listPackageVersions(
    String owner,
    String type,
    String name, {
    int? page,
    int? limit,
  });

  /// Get a specific package.
  Future<Either<Failure, Package>> getPackage(
    String owner,
    String type,
    String name,
    String version,
  );

  /// List files for a specific package version.
  Future<Either<Failure, List<PackageFile>>> listPackageFiles(
    String owner,
    String type,
    String name,
    String version,
  );

  /// Delete a specific package version.
  Future<Either<Failure, void>> deletePackage(
    String owner,
    String type,
    String name,
    String version,
  );
}
