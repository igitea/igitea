import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:igitea/core/errors/exceptions.dart';
import 'package:igitea/data/datasources/remote/api_client.dart';

void main() {
  group('ApiClient', () {
    test('get sends request to correct URL with token auth', () async {
      final mock = MockClient((request) async {
        expect(request.url.toString(), 'https://gitea.example.com/api/v1/user');
        expect(request.headers['Authorization'], 'token my-token');
        return http.Response('{"id":1}', 200);
      });
      final client = ApiClient(
        baseUrl: 'https://gitea.example.com',
        client: mock,
        token: 'my-token',
      );
      final response = await client.get('/user');
      expect(response.statusCode, 200);
      expect(response.body, '{"id":1}');
    });

    test('get sends request with Basic auth', () async {
      final mock = MockClient((request) async {
        expect(request.headers['Authorization'], 'Basic dXNlcjpwYXNz');
        return http.Response('{}', 200);
      });
      final client = ApiClient(
        baseUrl: 'https://gitea.example.com',
        client: mock,
        username: 'user',
        password: 'pass',
      );
      await client.get('/user');
    });

    test('get appends query parameters', () async {
      final mock = MockClient((request) async {
        expect(
          request.url.toString(),
          'https://gitea.example.com/api/v1/repos?state=open&page=1',
        );
        return http.Response('[]', 200);
      });
      final client = ApiClient(
        baseUrl: 'https://gitea.example.com',
        client: mock,
      );
      await client.get('/repos', queryParameters: {'state': 'open', 'page': '1'});
    });

    test('post sends JSON body', () async {
      final mock = MockClient((request) async {
        expect(request.headers['Content-Type'], 'application/json');
        expect(request.body, '{"name":"test"}');
        return http.Response('{"id":2}', 201);
      });
      final client = ApiClient(
        baseUrl: 'https://gitea.example.com',
        client: mock,
      );
      final response = await client.post('/repos', body: {'name': 'test'});
      expect(response.statusCode, 201);
    });

    test('put sends JSON body', () async {
      final mock = MockClient((request) async {
        expect(request.method, 'PUT');
        expect(request.body, '{"description":"updated"}');
        return http.Response('{}', 200);
      });
      final client = ApiClient(
        baseUrl: 'https://gitea.example.com',
        client: mock,
      );
      final response = await client.put('/repos/1', body: {'description': 'updated'});
      expect(response.statusCode, 200);
    });

    test('patch sends JSON body', () async {
      final mock = MockClient((request) async {
        expect(request.method, 'PATCH');
        return http.Response('{}', 200);
      });
      final client = ApiClient(
        baseUrl: 'https://gitea.example.com',
        client: mock,
      );
      final response = await client.patch('/repos/1', body: {});
      expect(response.statusCode, 200);
    });

    test('delete returns 204 without exception', () async {
      final mock = MockClient((request) async {
        expect(request.method, 'DELETE');
        return http.Response('', 204);
      });
      final client = ApiClient(
        baseUrl: 'https://gitea.example.com',
        client: mock,
      );
      final response = await client.delete('/repos/1');
      expect(response.statusCode, 204);
    });

    test('401 throws AuthenticationException', () async {
      final mock = MockClient((request) async {
        return http.Response('{"message":"Unauthorized"}', 401);
      });
      final client = ApiClient(
        baseUrl: 'https://gitea.example.com',
        client: mock,
      );
      expect(
        () => client.get('/user'),
        throwsA(isA<AuthenticationException>()),
      );
    });

    test('403 throws AuthenticationException', () async {
      final mock = MockClient((request) async {
        return http.Response('{"message":"Forbidden"}', 403);
      });
      final client = ApiClient(
        baseUrl: 'https://gitea.example.com',
        client: mock,
      );
      expect(
        () => client.get('/admin'),
        throwsA(isA<AuthenticationException>()),
      );
    });

    test('404 throws ServerException', () async {
      final mock = MockClient((request) async {
        return http.Response('{"message":"Not Found"}', 404);
      });
      final client = ApiClient(
        baseUrl: 'https://gitea.example.com',
        client: mock,
      );
      expect(
        () => client.get('/repos/missing'),
        throwsA(isA<ServerException>()),
      );
    });

    test('500 throws ServerException', () async {
      final mock = MockClient((request) async {
        return http.Response('{"message":"Internal Server Error"}', 500);
      });
      final client = ApiClient(
        baseUrl: 'https://gitea.example.com',
        client: mock,
      );
      expect(
        () => client.get('/user'),
        throwsA(isA<ServerException>()),
      );
    });

    test('422 throws ServerException', () async {
      final mock = MockClient((request) async {
        return http.Response('{"message":"Validation Failed"}', 422);
      });
      final client = ApiClient(
        baseUrl: 'https://gitea.example.com',
        client: mock,
      );
      expect(
        () => client.post('/repos', body: {}),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
