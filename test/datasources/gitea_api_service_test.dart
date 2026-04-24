import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:igitea/data/datasources/remote/api_client.dart';
import 'package:igitea/data/datasources/remote/gitea_api_service.dart';
import 'package:igitea/data/models/generated/generated_models.dart';

void main() {
  group('GiteaApiService', () {
    late GiteaApiService service;

    ApiClient makeClient(MockClient mock) {
      return ApiClient(baseUrl: 'https://gitea.example.com', client: mock);
    }

    group('Settings', () {
      test('getGeneralAPISettings parses response', () async {
        final mock = MockClient((request) async {
          expect(request.url.path, '/api/v1/settings/api');
          return http.Response('{"default_git_trees_per_page":30}', 200);
        });
        service = GiteaApiService(client: makeClient(mock));
        final result = await service.getGeneralAPISettings();
        expect(result, isA<GeneralAPISettings>());
      });
    });

    group('User', () {
      test('userGetCurrent returns User', () async {
        final mock = MockClient((request) async {
          expect(request.url.path, '/api/v1/user');
          return http.Response(jsonEncode({'id': 1, 'login': 'gitea'}), 200);
        });
        service = GiteaApiService(client: makeClient(mock));
        final user = await service.userGetCurrent();
        expect(user.id, 1);
        expect(user.login, 'gitea');
      });

      test('userGet returns User by username', () async {
        final mock = MockClient((request) async {
          expect(request.url.path, '/api/v1/users/testuser');
          return http.Response(jsonEncode({'id': 2, 'login': 'testuser'}), 200);
        });
        service = GiteaApiService(client: makeClient(mock));
        final user = await service.userGet(username: 'testuser');
        expect(user.id, 2);
        expect(user.login, 'testuser');
      });

      test('userListRepos returns list of repositories', () async {
        final mock = MockClient((request) async {
          expect(request.url.path, '/api/v1/users/testuser/repos');
          return http.Response(
            jsonEncode([
              {'id': 10, 'name': 'repo1'},
              {'id': 20, 'name': 'repo2'},
            ]),
            200,
          );
        });
        service = GiteaApiService(client: makeClient(mock));
        final repos = await service.userListRepos(username: 'testuser');
        expect(repos.length, 2);
        expect(repos.first.name, 'repo1');
      });

      test('userCurrentListRepos passes pagination', () async {
        final mock = MockClient((request) async {
          expect(request.url.queryParameters['page'], '2');
          expect(request.url.queryParameters['limit'], '10');
          return http.Response('[]', 200);
        });
        service = GiteaApiService(client: makeClient(mock));
        final repos = await service.userCurrentListRepos(page: 2, limit: 10);
        expect(repos, isEmpty);
      });
    });

    group('Repository', () {
      test('repoGet returns Repository', () async {
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
        service = GiteaApiService(client: makeClient(mock));
        final repo = await service.repoGet(owner: 'owner', repo: 'repo');
        expect(repo.id, 100);
        expect(repo.name, 'repo');
        expect(repo.owner, isNotNull);
      });

      test('repoDelete sends DELETE request', () async {
        final mock = MockClient((request) async {
          expect(request.method, 'DELETE');
          expect(request.url.path, '/api/v1/repos/owner/repo');
          return http.Response('', 204);
        });
        service = GiteaApiService(client: makeClient(mock));
        await service.repoDelete(owner: 'owner', repo: 'repo');
      });

      test('repoListBranches returns list', () async {
        final mock = MockClient((request) async {
          return http.Response(
            jsonEncode([
              {'name': 'main'},
              {'name': 'develop'},
            ]),
            200,
          );
        });
        service = GiteaApiService(client: makeClient(mock));
        final branches = await service.repoListBranches(owner: 'o', repo: 'r');
        expect(branches.length, 2);
        expect(branches.first.name, 'main');
      });
    });

    group('Issue', () {
      test('issueListIssues returns list of issues', () async {
        final mock = MockClient((request) async {
          expect(request.url.queryParameters['state'], 'open');
          return http.Response(
            jsonEncode([
              {'id': 1, 'title': 'Bug', 'number': 1},
            ]),
            200,
          );
        });
        service = GiteaApiService(client: makeClient(mock));
        final issues = await service.issueListIssues(
          owner: 'o',
          repo: 'r',
          state: 'open',
        );
        expect(issues.length, 1);
        expect(issues.first.title, 'Bug');
      });

      test('issueGetIssue returns Issue', () async {
        final mock = MockClient((request) async {
          expect(request.url.path, '/api/v1/repos/o/r/issues/1');
          return http.Response(
            jsonEncode({'id': 1, 'title': 'Bug', 'number': 1}),
            200,
          );
        });
        service = GiteaApiService(client: makeClient(mock));
        final issue = await service.issueGetIssue(
          owner: 'o',
          repo: 'r',
          index: 1,
        );
        expect(issue.title, 'Bug');
      });

      test('issueCreateIssue sends POST with body', () async {
        final mock = MockClient((request) async {
          expect(request.method, 'POST');
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          expect(body['title'], 'New Issue');
          return http.Response(
            jsonEncode({'id': 5, 'title': 'New Issue'}),
            201,
          );
        });
        service = GiteaApiService(client: makeClient(mock));
        final issue = await service.issueCreateIssue(
          owner: 'o',
          repo: 'r',
          body: {'title': 'New Issue'},
        );
        expect(issue.title, 'New Issue');
      });

      test('issueDelete sends DELETE', () async {
        final mock = MockClient((request) async {
          expect(request.method, 'DELETE');
          return http.Response('', 204);
        });
        service = GiteaApiService(client: makeClient(mock));
        await service.issueDelete(owner: 'o', repo: 'r', index: 1);
      });
    });

    group('Organization', () {
      test('orgGet returns Organization', () async {
        final mock = MockClient((request) async {
          return http.Response(jsonEncode({'id': 1, 'name': 'myorg'}), 200);
        });
        service = GiteaApiService(client: makeClient(mock));
        final org = await service.orgGet(org: 'myorg');
        expect(org.name, 'myorg');
      });

      test('orgListCurrentUserOrgs returns list', () async {
        final mock = MockClient((request) async {
          return http.Response('[]', 200);
        });
        service = GiteaApiService(client: makeClient(mock));
        final orgs = await service.orgListCurrentUserOrgs();
        expect(orgs, isEmpty);
      });
    });

    group('Notification', () {
      test('notifyGetList returns notifications', () async {
        final mock = MockClient((request) async {
          return http.Response('[]', 200);
        });
        service = GiteaApiService(client: makeClient(mock));
        final notifications = await service.notifyGetList();
        expect(notifications, isEmpty);
      });

      test('notifyNewAvailable returns count', () async {
        final mock = MockClient((request) async {
          return http.Response('{"new": 5}', 200);
        });
        service = GiteaApiService(client: makeClient(mock));
        final count = await service.notifyNewAvailable();
        expect(count.new_, 5);
      });
    });

    group('Package', () {
      test('listPackages returns list', () async {
        final mock = MockClient((request) async {
          return http.Response('[]', 200);
        });
        service = GiteaApiService(client: makeClient(mock));
        final packages = await service.listPackages(owner: 'test');
        expect(packages, isEmpty);
      });
    });

    group('Admin', () {
      test('adminSearchUsers returns list', () async {
        final mock = MockClient((request) async {
          return http.Response('[]', 200);
        });
        service = GiteaApiService(client: makeClient(mock));
        final users = await service.adminSearchUsers();
        expect(users, isEmpty);
      });

      test('adminCronList returns list', () async {
        final mock = MockClient((request) async {
          return http.Response('[]', 200);
        });
        service = GiteaApiService(client: makeClient(mock));
        final cron = await service.adminCronList();
        expect(cron, isEmpty);
      });
    });

    group('Miscellaneous', () {
      test('renderMarkdown returns rendered HTML', () async {
        final mock = MockClient((request) async {
          expect(request.method, 'POST');
          return http.Response('<h1>Title</h1>', 200);
        });
        service = GiteaApiService(client: makeClient(mock));
        final html = await service.renderMarkdown(body: {'Text': '# Title'});
        expect(html, '<h1>Title</h1>');
      });
    });

    group('ActivityPub', () {
      test('activitypubPerson returns ActivityPub', () async {
        final mock = MockClient((request) async {
          expect(request.url.path, '/api/v1/activitypub/user-id/42');
          return http.Response('{"at_context": "context"}', 200);
        });
        service = GiteaApiService(client: makeClient(mock));
        final person = await service.activitypubPerson(user_id: 42);
        expect(person, isA<ActivityPub>());
      });
    });
  });
}
