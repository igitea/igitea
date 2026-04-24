import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:igitea/core/errors/failures.dart';
import 'package:igitea/core/utils/either.dart';
import 'package:igitea/data/datasources/remote/api_client.dart';
import 'package:igitea/data/datasources/remote/gitea_api_service.dart';
import 'package:igitea/data/models/generated/generated_models.dart';
import 'package:igitea/data/repositories/user_repository_impl.dart';

void main() {
  group('UserRepositoryImpl', () {
    late UserRepositoryImpl repository;

    ApiClient makeClient(MockClient mock) {
      return ApiClient(baseUrl: 'https://gitea.example.com', client: mock);
    }

    group('getCurrentUser', () {
      test('returns Right(User) on 200', () async {
        final mock = MockClient((request) async {
          expect(request.url.path, '/api/v1/user');
          return http.Response(jsonEncode({'id': 1, 'login': 'gitea'}), 200);
        });
        repository = UserRepositoryImpl(
          apiService: GiteaApiService(client: makeClient(mock)),
        );
        final result = await repository.getCurrentUser();
        expect(result.isRight, isTrue);
        final user = (result as Right<Failure, User>).value;
        expect(user.id, 1);
        expect(user.login, 'gitea');
      });

      test('returns Left(AuthenticationFailure) on 401', () async {
        final mock = MockClient((request) async {
          return http.Response(jsonEncode({'message': 'Unauthorized'}), 401);
        });
        repository = UserRepositoryImpl(
          apiService: GiteaApiService(client: makeClient(mock)),
        );
        final result = await repository.getCurrentUser();
        expect(result.isLeft, isTrue);
        final failure = (result as Left<Failure, User>).value;
        expect(failure, isA<AuthenticationFailure>());
      });

      test('returns Left(NetworkFailure) on NetworkException', () async {
        final mock = MockClient((request) async {
          throw http.ClientException(
            'No internet',
            Uri.parse('https://example.com'),
          );
        });
        repository = UserRepositoryImpl(
          apiService: GiteaApiService(client: makeClient(mock)),
        );
        final result = await repository.getCurrentUser();
        expect(result.isLeft, isTrue);
        final failure = (result as Left<Failure, User>).value;
        expect(failure, isA<NetworkFailure>());
      });
    });

    group('getUser', () {
      test('returns Right(User) on 200', () async {
        final mock = MockClient((request) async {
          expect(request.url.path, '/api/v1/users/alice');
          return http.Response(jsonEncode({'id': 2, 'login': 'alice'}), 200);
        });
        repository = UserRepositoryImpl(
          apiService: GiteaApiService(client: makeClient(mock)),
        );
        final result = await repository.getUser('alice');
        expect(result.isRight, isTrue);
        final user = (result as Right<Failure, User>).value;
        expect(user.id, 2);
        expect(user.login, 'alice');
      });
    });

    group('listCurrentUserRepos', () {
      test('returns Right(List<Repository>) on 200', () async {
        final mock = MockClient((request) async {
          expect(request.url.path, '/api/v1/user/repos');
          return http.Response(
            jsonEncode([
              {'id': 10, 'name': 'repo1'},
              {'id': 20, 'name': 'repo2'},
            ]),
            200,
          );
        });
        repository = UserRepositoryImpl(
          apiService: GiteaApiService(client: makeClient(mock)),
        );
        final result = await repository.listCurrentUserRepos();
        expect(result.isRight, isTrue);
        final repos = (result as Right<Failure, List<Repository>>).value;
        expect(repos.length, 2);
        expect(repos.first.name, 'repo1');
      });

      test('passes pagination parameters', () async {
        final mock = MockClient((request) async {
          expect(request.url.queryParameters['page'], '2');
          expect(request.url.queryParameters['limit'], '5');
          return http.Response('[]', 200);
        });
        repository = UserRepositoryImpl(
          apiService: GiteaApiService(client: makeClient(mock)),
        );
        final result = await repository.listCurrentUserRepos(page: 2, limit: 5);
        expect(result.isRight, isTrue);
      });

      test('returns Left(ServerFailure) on 500', () async {
        final mock = MockClient((request) async {
          return http.Response(
            jsonEncode({'message': 'internal server error'}),
            500,
          );
        });
        repository = UserRepositoryImpl(
          apiService: GiteaApiService(client: makeClient(mock)),
        );
        final result = await repository.listCurrentUserRepos();
        expect(result.isLeft, isTrue);
        final failure = (result as Left<Failure, List<Repository>>).value;
        expect(failure, isA<ServerFailure>());
      });
    });

    group('listUserRepos', () {
      test('returns Right(List<Repository>) on 200', () async {
        final mock = MockClient((request) async {
          expect(request.url.path, '/api/v1/users/alice/repos');
          return http.Response(
            jsonEncode([
              {'id': 5, 'name': 'test'},
            ]),
            200,
          );
        });
        repository = UserRepositoryImpl(
          apiService: GiteaApiService(client: makeClient(mock)),
        );
        final result = await repository.listUserRepos('alice');
        expect(result.isRight, isTrue);
        final repos = (result as Right<Failure, List<Repository>>).value;
        expect(repos.length, 1);
        expect(repos.first.name, 'test');
      });
    });
  });
}
