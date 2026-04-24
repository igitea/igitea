import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:igitea/core/errors/failures.dart';
import 'package:igitea/core/utils/either.dart';
import 'package:igitea/data/datasources/remote/api_client.dart';
import 'package:igitea/data/datasources/remote/gitea_api_service.dart';
import 'package:igitea/data/models/generated/generated_models.dart';
import 'package:igitea/data/repositories/organization_repository_impl.dart';

void main() {
  group('OrganizationRepositoryImpl', () {
    late OrganizationRepositoryImpl repository;

    ApiClient makeClient(MockClient mock) {
      return ApiClient(baseUrl: 'https://gitea.example.com', client: mock);
    }

    test('getOrg returns Right(Organization) on 200', () async {
      final mock = MockClient((request) async {
        return http.Response(jsonEncode({'id': 1, 'name': 'myorg'}), 200);
      });
      repository = OrganizationRepositoryImpl(
        apiService: GiteaApiService(client: makeClient(mock)),
      );
      final result = await repository.getOrg('myorg');
      expect(result.isRight, isTrue);
      final org = (result as Right<Failure, Organization>).value;
      expect(org.id, 1);
      expect(org.name, 'myorg');
    });

    test(
      'listCurrentUserOrgs returns Right(List<Organization>) on 200',
      () async {
        final mock = MockClient((request) async {
          return http.Response(
            jsonEncode([
              {'id': 1, 'name': 'org1'},
              {'id': 2, 'name': 'org2'},
            ]),
            200,
          );
        });
        repository = OrganizationRepositoryImpl(
          apiService: GiteaApiService(client: makeClient(mock)),
        );
        final result = await repository.listCurrentUserOrgs();
        expect(result.isRight, isTrue);
        final orgs = (result as Right<Failure, List<Organization>>).value;
        expect(orgs.length, 2);
        expect(orgs.first.name, 'org1');
      },
    );

    test('deleteOrg returns Right(null) on 204', () async {
      final mock = MockClient((request) async {
        return http.Response('', 204);
      });
      repository = OrganizationRepositoryImpl(
        apiService: GiteaApiService(client: makeClient(mock)),
      );
      final result = await repository.deleteOrg('myorg');
      expect(result.isRight, isTrue);
    });

    test('getOrg returns Left(ServerFailure) on 500', () async {
      final mock = MockClient((request) async {
        return http.Response(
          jsonEncode({'message': 'internal server error'}),
          500,
        );
      });
      repository = OrganizationRepositoryImpl(
        apiService: GiteaApiService(client: makeClient(mock)),
      );
      final result = await repository.getOrg('myorg');
      expect(result.isLeft, isTrue);
      final failure = (result as Left<Failure, Organization>).value;
      expect(failure, isA<ServerFailure>());
    });

    test('getOrg returns Left(NetworkFailure) on NetworkException', () async {
      final mock = MockClient((request) async {
        throw http.ClientException(
          'No internet',
          Uri.parse('https://example.com'),
        );
      });
      repository = OrganizationRepositoryImpl(
        apiService: GiteaApiService(client: makeClient(mock)),
      );
      final result = await repository.getOrg('myorg');
      expect(result.isLeft, isTrue);
      final failure = (result as Left<Failure, Organization>).value;
      expect(failure, isA<NetworkFailure>());
    });
  });
}
