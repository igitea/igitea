import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/core/errors/failures.dart';
import 'package:igitea/core/utils/either.dart';
import 'package:igitea/data/models/generated/generated_models.dart';
import 'package:igitea/domain/repositories/package_repository.dart';
import 'package:igitea/domain/usecases/package_usecases.dart';

class MockPackageRepository implements PackageRepository {
  bool shouldFail = false;
  Failure failure = const ServerFailure('error');

  @override
  Future<Either<Failure, List<Package>>> listPackages(
    String owner, {
    int? page,
    int? limit,
    String? type,
    String? q,
  }) async {
    if (shouldFail) return Left(failure);
    return const Right([Package(id: 1, name: 'pkg1', type: 'cargo')]);
  }

  @override
  Future<Either<Failure, Package>> getPackage(
    String owner,
    String type,
    String name,
    String version,
  ) async {
    if (shouldFail) return Left(failure);
    return const Right(
      Package(id: 1, name: 'pkg1', type: 'cargo', version: '1.0.0'),
    );
  }

  @override
  Future<Either<Failure, List<PackageFile>>> listPackageFiles(
    String owner,
    String type,
    String name,
    String version,
  ) => throw UnimplementedError();

  @override
  Future<Either<Failure, void>> deletePackage(
    String owner,
    String type,
    String name,
    String version,
  ) => throw UnimplementedError();
}

void main() {
  group('ListPackagesUseCase', () {
    late MockPackageRepository mockRepo;
    late ListPackagesUseCase useCase;

    setUp(() {
      mockRepo = MockPackageRepository();
      useCase = ListPackagesUseCase(repository: mockRepo);
    });

    test('returns Right(List<Package>) on success', () async {
      final params = ListPackagesParams(owner: 'testowner');
      final result = await useCase(params);
      expect(result.isRight, isTrue);
      final packages = (result as Right<Failure, List<Package>>).value;
      expect(packages.length, 1);
      expect(packages.first.name, 'pkg1');
    });

    test('returns Left(Failure) on failure', () async {
      mockRepo.shouldFail = true;
      mockRepo.failure = const ServerFailure('error');
      final params = ListPackagesParams(owner: 'testowner');
      final result = await useCase(params);
      expect(result.isLeft, isTrue);
      expect(
        (result as Left<Failure, List<Package>>).value,
        isA<ServerFailure>(),
      );
    });

    test('params store values correctly', () {
      final params = ListPackagesParams(
        owner: 'testowner',
        page: 2,
        limit: 10,
        type: 'cargo',
        q: 'search',
      );
      expect(params.owner, 'testowner');
      expect(params.page, 2);
      expect(params.limit, 10);
      expect(params.type, 'cargo');
      expect(params.q, 'search');
    });
  });

  group('GetPackageUseCase', () {
    late MockPackageRepository mockRepo;
    late GetPackageUseCase useCase;

    setUp(() {
      mockRepo = MockPackageRepository();
      useCase = GetPackageUseCase(repository: mockRepo);
    });

    test('returns Right(Package) on success', () async {
      final params = GetPackageParams(
        owner: 'testowner',
        type: 'cargo',
        name: 'pkg1',
        version: '1.0.0',
      );
      final result = await useCase(params);
      expect(result.isRight, isTrue);
      final pkg = (result as Right<Failure, Package>).value;
      expect(pkg.id, 1);
      expect(pkg.name, 'pkg1');
      expect(pkg.version, '1.0.0');
    });

    test('returns Left(Failure) on failure', () async {
      mockRepo.shouldFail = true;
      mockRepo.failure = const ServerFailure('not found');
      final params = GetPackageParams(
        owner: 'testowner',
        type: 'cargo',
        name: 'pkg1',
        version: '1.0.0',
      );
      final result = await useCase(params);
      expect(result.isLeft, isTrue);
      expect((result as Left<Failure, Package>).value, isA<ServerFailure>());
    });

    test('params store values correctly', () {
      final params = GetPackageParams(
        owner: 'testowner',
        type: 'cargo',
        name: 'pkg1',
        version: '2.0.0',
      );
      expect(params.owner, 'testowner');
      expect(params.type, 'cargo');
      expect(params.name, 'pkg1');
      expect(params.version, '2.0.0');
    });
  });
}
