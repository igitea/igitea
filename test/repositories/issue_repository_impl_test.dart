import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:igitea/core/errors/failures.dart';
import 'package:igitea/core/utils/either.dart';
import 'package:igitea/data/datasources/remote/api_client.dart';
import 'package:igitea/data/datasources/remote/gitea_api_service.dart';
import 'package:igitea/data/models/generated/generated_models.dart';
import 'package:igitea/data/repositories/issue_repository_impl.dart';

void main() {
  group('IssueRepositoryImpl', () {
    late IssueRepositoryImpl repository;

    ApiClient makeClient(MockClient mock) {
      return ApiClient(baseUrl: 'https://gitea.example.com', client: mock);
    }

    group('listIssues', () {
      test('returns Right(List<Issue>) on 200', () async {
        final mock = MockClient((request) async {
          expect(request.url.path, '/api/v1/repos/owner/repo/issues');
          expect(request.url.queryParameters['state'], 'open');
          return http.Response(
            jsonEncode([
              {'id': 1, 'title': 'Bug', 'number': 1},
              {'id': 2, 'title': 'Feature', 'number': 2},
            ]),
            200,
          );
        });
        repository = IssueRepositoryImpl(
          apiService: GiteaApiService(client: makeClient(mock)),
        );
        final result = await repository.listIssues(
          'owner',
          'repo',
          state: 'open',
        );
        expect(result.isRight, isTrue);
        final issues = (result as Right<Failure, List<Issue>>).value;
        expect(issues.length, 2);
        expect(issues.first.title, 'Bug');
      });

      test('returns Left(AuthenticationFailure) on 401', () async {
        final mock = MockClient((request) async {
          return http.Response(jsonEncode({'message': 'Unauthorized'}), 401);
        });
        repository = IssueRepositoryImpl(
          apiService: GiteaApiService(client: makeClient(mock)),
        );
        final result = await repository.listIssues('owner', 'repo');
        expect(result.isLeft, isTrue);
        final failure = (result as Left<Failure, List<Issue>>).value;
        expect(failure, isA<AuthenticationFailure>());
      });
    });

    group('getIssue', () {
      test('returns Right(Issue) on 200', () async {
        final mock = MockClient((request) async {
          expect(request.url.path, '/api/v1/repos/owner/repo/issues/1');
          return http.Response(
            jsonEncode({'id': 1, 'title': 'Bug', 'number': 1}),
            200,
          );
        });
        repository = IssueRepositoryImpl(
          apiService: GiteaApiService(client: makeClient(mock)),
        );
        final result = await repository.getIssue('owner', 'repo', 1);
        expect(result.isRight, isTrue);
        final issue = (result as Right<Failure, Issue>).value;
        expect(issue.title, 'Bug');
        expect(issue.number, 1);
      });
    });

    group('createIssue', () {
      test('returns Right(Issue) on 201', () async {
        final mock = MockClient((request) async {
          expect(request.method, 'POST');
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          expect(body['title'], 'New Issue');
          return http.Response(
            jsonEncode({'id': 5, 'title': 'New Issue', 'number': 3}),
            201,
          );
        });
        repository = IssueRepositoryImpl(
          apiService: GiteaApiService(client: makeClient(mock)),
        );
        final result = await repository.createIssue('owner', 'repo', {
          'title': 'New Issue',
        });
        expect(result.isRight, isTrue);
        final issue = (result as Right<Failure, Issue>).value;
        expect(issue.title, 'New Issue');
      });
    });

    group('deleteIssue', () {
      test('returns Right(null) on 204', () async {
        final mock = MockClient((request) async {
          expect(request.method, 'DELETE');
          expect(request.url.path, '/api/v1/repos/owner/repo/issues/1');
          return http.Response('', 204);
        });
        repository = IssueRepositoryImpl(
          apiService: GiteaApiService(client: makeClient(mock)),
        );
        final result = await repository.deleteIssue('owner', 'repo', 1);
        expect(result.isRight, isTrue);
      });
    });

    group('listLabels', () {
      test('returns Right(List<Label>) on 200', () async {
        final mock = MockClient((request) async {
          expect(request.url.path, '/api/v1/repos/owner/repo/labels');
          return http.Response(
            jsonEncode([
              {'id': 1, 'name': 'bug', 'color': 'ff0000'},
              {'id': 2, 'name': 'enhancement', 'color': '00ff00'},
            ]),
            200,
          );
        });
        repository = IssueRepositoryImpl(
          apiService: GiteaApiService(client: makeClient(mock)),
        );
        final result = await repository.listLabels('owner', 'repo');
        expect(result.isRight, isTrue);
        final labels = (result as Right<Failure, List<Label>>).value;
        expect(labels.length, 2);
        expect(labels.first.name, 'bug');
        expect(labels.first.color, 'ff0000');
      });
    });

    group('listMilestones', () {
      test('returns Right(List<Milestone>) on 200', () async {
        final mock = MockClient((request) async {
          expect(request.url.path, '/api/v1/repos/owner/repo/milestones');
          return http.Response(
            jsonEncode([
              {'id': 1, 'title': 'v1.0', 'state': {}},
              {'id': 2, 'title': 'v2.0', 'state': {}},
            ]),
            200,
          );
        });
        repository = IssueRepositoryImpl(
          apiService: GiteaApiService(client: makeClient(mock)),
        );
        final result = await repository.listMilestones('owner', 'repo');
        expect(result.isRight, isTrue);
        final milestones = (result as Right<Failure, List<Milestone>>).value;
        expect(milestones.length, 2);
        expect(milestones.first.title, 'v1.0');
      });
    });

    group('network and server errors', () {
      test('returns Left(NetworkFailure) on NetworkException', () async {
        final mock = MockClient((request) async {
          throw http.ClientException(
            'No internet',
            Uri.parse('https://example.com'),
          );
        });
        repository = IssueRepositoryImpl(
          apiService: GiteaApiService(client: makeClient(mock)),
        );
        final result = await repository.listIssues('owner', 'repo');
        expect(result.isLeft, isTrue);
        final failure = (result as Left<Failure, List<Issue>>).value;
        expect(failure, isA<NetworkFailure>());
      });

      test('returns Left(ServerFailure) on 500', () async {
        final mock = MockClient((request) async {
          return http.Response(
            jsonEncode({'message': 'internal server error'}),
            500,
          );
        });
        repository = IssueRepositoryImpl(
          apiService: GiteaApiService(client: makeClient(mock)),
        );
        final result = await repository.getIssue('owner', 'repo', 1);
        expect(result.isLeft, isTrue);
        final failure = (result as Left<Failure, Issue>).value;
        expect(failure, isA<ServerFailure>());
      });
    });
  });
}
