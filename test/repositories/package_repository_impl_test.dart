import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:igitea/core/errors/failures.dart';
import 'package:igitea/core/utils/either.dart';
import 'package:igitea/data/datasources/remote/api_client.dart';
import 'package:igitea/data/datasources/remote/gitea_api_service.dart';
import 'package:igitea/data/models/generated/generated_models.dart';
import 'package:igitea/data/repositories/package_repository_impl.dart';

void main() {
  group('PackageRepositoryImpl', () {
    late PackageRepositoryImpl repository;

    ApiClient makeClient(MockClient mock) {
      return ApiClient(baseUrl: 'https://gitea.example.com', client: mock);
    }

    test('listPackages returns Right(List<Package>) on 200', () async {
      final mock = MockClient((request) async {
        return http.Response(
          jsonEncode([
            {'id': 1, 'name': 'pkg1', 'type': 'npm', 'version': '1.0.0'},
            {'id': 2, 'name': 'pkg2', 'type': 'cargo', 'version': '0.1.0'},
          ]),
          200,
        );
      });
      repository = PackageRepositoryImpl(
        apiService: GiteaApiService(client: makeClient(mock)),
      );
      final result = await repository.listPackages('testowner');
      expect(result.isRight, isTrue);
      final packages = (result as Right<Failure, List<Package>>).value;
      expect(packages.length, 2);
      expect(packages.first.name, 'pkg1');
    });

    test('getPackage returns Right(Package) on 200', () async {
      final mock = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'id': 1,
            'name': 'mypkg',
            'type': 'npm',
            'version': '2.0.0',
          }),
          200,
        );
      });
      repository = PackageRepositoryImpl(
        apiService: GiteaApiService(client: makeClient(mock)),
      );
      final result = await repository.getPackage(
        'testowner',
        'npm',
        'mypkg',
        '2.0.0',
      );
      expect(result.isRight, isTrue);
      final pkg = (result as Right<Failure, Package>).value;
      expect(pkg.name, 'mypkg');
      expect(pkg.version, '2.0.0');
    });

    test('deletePackage returns Right(null) on 204', () async {
      final mock = MockClient((request) async {
        return http.Response('', 204);
      });
      repository = PackageRepositoryImpl(
        apiService: GiteaApiService(client: makeClient(mock)),
      );
      final result = await repository.deletePackage(
        'testowner',
        'npm',
        'mypkg',
        '1.0.0',
      );
      expect(result.isRight, isTrue);
    });

    test('listPackages returns Left(ServerFailure) on 500', () async {
      final mock = MockClient((request) async {
        return http.Response(
          jsonEncode({'message': 'internal server error'}),
          500,
        );
      });
      repository = PackageRepositoryImpl(
        apiService: GiteaApiService(client: makeClient(mock)),
      );
      final result = await repository.listPackages('testowner');
      expect(result.isLeft, isTrue);
      final failure = (result as Left<Failure, List<Package>>).value;
      expect(failure, isA<ServerFailure>());
    });

    test(
      'listPackages returns Left(NetworkFailure) on NetworkException',
      () async {
        final mock = MockClient((request) async {
          throw http.ClientException(
            'No internet',
            Uri.parse('https://example.com'),
          );
        });
        repository = PackageRepositoryImpl(
          apiService: GiteaApiService(client: makeClient(mock)),
        );
        final result = await repository.listPackages('testowner');
        expect(result.isLeft, isTrue);
        final failure = (result as Left<Failure, List<Package>>).value;
        expect(failure, isA<NetworkFailure>());
      },
    );
  });
}
