import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:igitea/core/errors/failures.dart';
import 'package:igitea/core/utils/either.dart';
import 'package:igitea/data/datasources/remote/api_client.dart';
import 'package:igitea/data/datasources/remote/gitea_api_service.dart';
import 'package:igitea/data/models/generated/generated_models.dart';
import 'package:igitea/data/repositories/repo_repository_impl.dart';

void main() {
  group('RepoRepositoryImpl', () {
    late RepoRepositoryImpl repository;

    ApiClient makeClient(MockClient mock) {
      return ApiClient(baseUrl: 'https://gitea.example.com', client: mock);
    }

    group('getRepo', () {
      test('returns Right(Repository) on 200', () async {
        final mock = MockClient((request) async {
          expect(request.url.path, '/api/v1/repos/owner/repo');
          return http.Response(
            jsonEncode({
              'id': 100,
              'name': 'repo',
              'owner': {'id': 1, 'login': 'owner'},
            }),
            200,
          );
        });
        repository = RepoRepositoryImpl(
          apiService: GiteaApiService(client: makeClient(mock)),
        );
        final result = await repository.getRepo('owner', 'repo');
        expect(result.isRight, isTrue);
        final repo = (result as Right<Failure, Repository>).value;
        expect(repo.id, 100);
        expect(repo.name, 'repo');
      });

      test('returns Left(ServerFailure) on 404', () async {
        final mock = MockClient((request) async {
          return http.Response(jsonEncode({'message': 'Not Found'}), 404);
        });
        repository = RepoRepositoryImpl(
          apiService: GiteaApiService(client: makeClient(mock)),
        );
        final result = await repository.getRepo('owner', 'missing');
        expect(result.isLeft, isTrue);
        final failure = (result as Left<Failure, Repository>).value;
        expect(failure, isA<ServerFailure>());
      });
    });

    group('deleteRepo', () {
      test('returns Right(null) on 204', () async {
        final mock = MockClient((request) async {
          expect(request.method, 'DELETE');
          expect(request.url.path, '/api/v1/repos/owner/repo');
          return http.Response('', 204);
        });
        repository = RepoRepositoryImpl(
          apiService: GiteaApiService(client: makeClient(mock)),
        );
        final result = await repository.deleteRepo('owner', 'repo');
        expect(result.isRight, isTrue);
      });

      test('returns Left(AuthenticationFailure) on 403', () async {
        final mock = MockClient((request) async {
          return http.Response(jsonEncode({'message': 'Forbidden'}), 403);
        });
        repository = RepoRepositoryImpl(
          apiService: GiteaApiService(client: makeClient(mock)),
        );
        final result = await repository.deleteRepo('owner', 'repo');
        expect(result.isLeft, isTrue);
        final failure = (result as Left<Failure, void>).value;
        expect(failure, isA<AuthenticationFailure>());
      });
    });

    group('searchRepos', () {
      test('returns Right(SearchResults) on 200', () async {
        final mock = MockClient((request) async {
          expect(request.url.path, '/api/v1/repos/search');
          return http.Response(
            jsonEncode({
              'ok': true,
              'data': [
                {'id': 1, 'name': 'found-repo'},
              ],
            }),
            200,
          );
        });
        repository = RepoRepositoryImpl(
          apiService: GiteaApiService(client: makeClient(mock)),
        );
        final result = await repository.searchRepos(q: 'test');
        expect(result.isRight, isTrue);
        final search = (result as Right<Failure, SearchResults>).value;
        expect(search.ok, true);
        expect(search.data?.length, 1);
        expect(search.data?.first.name, 'found-repo');
      });
    });

    group('listBranches', () {
      test('returns Right(List<Branch>) on 200', () async {
        final mock = MockClient((request) async {
          return http.Response(
            jsonEncode([
              {'name': 'main'},
              {'name': 'develop'},
            ]),
            200,
          );
        });
        repository = RepoRepositoryImpl(
          apiService: GiteaApiService(client: makeClient(mock)),
        );
        final result = await repository.listBranches('owner', 'repo');
        expect(result.isRight, isTrue);
        final branches = (result as Right<Failure, List<Branch>>).value;
        expect(branches.length, 2);
        expect(branches.first.name, 'main');
      });
    });

    group('listCommits', () {
      test('returns Right(List<Commit>) on 200', () async {
        final mock = MockClient((request) async {
          return http.Response(
            jsonEncode([
              {
                'sha': 'abc123',
                'commit': {
                  'message': 'initial commit',
                  'author': {'name': 'dev'},
                },
              },
            ]),
            200,
          );
        });
        repository = RepoRepositoryImpl(
          apiService: GiteaApiService(client: makeClient(mock)),
        );
        final result = await repository.listCommits('owner', 'repo');
        expect(result.isRight, isTrue);
      });

      test('returns Left(ServerFailure) on 500', () async {
        final mock = MockClient((request) async {
          return http.Response(
            jsonEncode({'message': 'internal server error'}),
            500,
          );
        });
        repository = RepoRepositoryImpl(
          apiService: GiteaApiService(client: makeClient(mock)),
        );
        final result = await repository.listCommits('owner', 'repo');
        expect(result.isLeft, isTrue);
        final failure = (result as Left<Failure, List<Commit>>).value;
        expect(failure, isA<ServerFailure>());
      });
    });

    group('network errors', () {
      test('returns Left(NetworkFailure) on NetworkException', () async {
        final mock = MockClient((request) async {
          throw http.ClientException(
            'No internet',
            Uri.parse('https://example.com'),
          );
        });
        repository = RepoRepositoryImpl(
          apiService: GiteaApiService(client: makeClient(mock)),
        );
        final result = await repository.getRepo('owner', 'repo');
        expect(result.isLeft, isTrue);
        final failure = (result as Left<Failure, Repository>).value;
        expect(failure, isA<NetworkFailure>());
      });
    });
  });
}
