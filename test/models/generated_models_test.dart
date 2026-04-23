import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/data/models/generated/generated_models.dart';

void main() {
  group('AccessToken', () {
    test('fromJson parses all fields', () {
      final json = {
        'id': 42,
        'name': 'test-token',
        'sha1': 'abc123',
        'token_last_eight': '12345678',
        'scopes': ['read:repository'],
        'created_at': '2026-04-23T10:00:00Z',
        'last_used_at': '2026-04-23T12:00:00Z',
      };
      final token = AccessToken.fromJson(json);
      expect(token.id, 42);
      expect(token.name, 'test-token');
      expect(token.sha1, 'abc123');
      expect(token.token_last_eight, '12345678');
      expect(token.scopes, ['read:repository']);
      expect(token.created_at, isNotNull);
      expect(token.last_used_at, isNotNull);
    });

    test('toJson serializes all fields', () {
      final token = AccessToken(
        id: 1,
        name: 'token',
        sha1: 'sha',
        scopes: ['all'],
      );
      final json = token.toJson();
      expect(json['id'], 1);
      expect(json['name'], 'token');
      expect(json['sha1'], 'sha');
      expect(json['scopes'], ['all']);
    });

    test('round-trip preserves values', () {
      final original = AccessToken(
        id: 99,
        name: 'round',
        sha1: 'trip',
      );
      final restored = AccessToken.fromJson(original.toJson());
      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.sha1, original.sha1);
    });
  });

  group('User', () {
    test('fromJson parses basic fields', () {
      final json = {
        'id': 1,
        'login': 'gitea',
        'email': 'gitea@example.com',
        'full_name': 'Gitea User',
        'avatar_url': 'https://example.com/avatar.png',
        'is_admin': true,
      };
      final user = User.fromJson(json);
      expect(user.id, 1);
      expect(user.login, 'gitea');
      expect(user.email, 'gitea@example.com');
      expect(user.is_admin, true);
    });

    test('toJson serializes nested objects', () {
      final user = User(
        id: 2,
        login: 'test',
      );
      final json = user.toJson();
      expect(json['id'], 2);
      expect(json['login'], 'test');
    });
  });

  group('Repository', () {
    test('fromJson parses with nested owner', () {
      final json = {
        'id': 100,
        'name': 'hello-world',
        'full_name': 'gitea/hello-world',
        'owner': {
          'id': 1,
          'login': 'gitea',
        },
        'private': false,
        'fork': false,
      };
      final repo = Repository.fromJson(json);
      expect(repo.id, 100);
      expect(repo.name, 'hello-world');
      expect(repo.owner, isNotNull);
      expect(repo.owner!.login, 'gitea');
      expect(repo.private, false);
    });

    test('toJson round-trip with owner', () {
      final repo = Repository(
        id: 101,
        name: 'repo',
        owner: User(id: 1, login: 'owner'),
      );
      final json = repo.toJson();
      expect(json['id'], 101);
      expect(json['name'], 'repo');
      expect(json['owner'], isA<Map<String, dynamic>>());
    });
  });

  group('Issue', () {
    test('fromJson parses labels list', () {
      final json = <String, dynamic>{
        'id': 10,
        'title': 'Bug report',
        'number': 1,
        'state': <String, dynamic>{},
        'labels': [
          <String, dynamic>{'id': 1, 'name': 'bug', 'color': 'ff0000'},
        ],
      };
      final issue = Issue.fromJson(json);
      expect(issue.id, 10);
      expect(issue.title, 'Bug report');
      expect(issue.labels, isNotNull);
      expect(issue.labels!.length, 1);
      expect(issue.labels!.first.name, 'bug');
    });

    test('toJson serializes labels', () {
      final issue = Issue(
        id: 11,
        title: 'Feature',
        labels: [Label(id: 2, name: 'feature')],
      );
      final json = issue.toJson();
      expect(json['labels'], isA<List>());
      expect((json['labels'] as List).length, 1);
    });
  });

  group('APIError', () {
    test('fromJson and toJson round-trip', () {
      final original = APIError(message: 'Not Found', url: '/api/v1/repos/1');
      final json = original.toJson();
      expect(json['message'], 'Not Found');
      expect(json['url'], '/api/v1/repos/1');

      final restored = APIError.fromJson(json);
      expect(restored.message, original.message);
      expect(restored.url, original.url);
    });
  });
}
