import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:igitea/core/errors/failures.dart';
import 'package:igitea/core/utils/either.dart';
import 'package:igitea/data/datasources/remote/api_client.dart';
import 'package:igitea/data/datasources/remote/gitea_api_service.dart';
import 'package:igitea/data/models/generated/generated_models.dart';
import 'package:igitea/data/repositories/admin_repository_impl.dart';

void main() {
  group('AdminRepositoryImpl', () {
    late AdminRepositoryImpl repository;

    ApiClient makeClient(MockClient mock) {
      return ApiClient(baseUrl: 'https://gitea.example.com', client: mock);
    }

    test('searchUsers returns Right(List<User>) on 200', () async {
      final mock = MockClient((request) async {
        return http.Response(
          jsonEncode([
            {'id': 1, 'login': 'user1'},
            {'id': 2, 'login': 'user2'},
          ]),
          200,
        );
      });
      repository = AdminRepositoryImpl(
        apiService: GiteaApiService(client: makeClient(mock)),
      );
      final result = await repository.searchUsers();
      expect(result.isRight, isTrue);
      final users = (result as Right<Failure, List<User>>).value;
      expect(users.length, 2);
      expect(users.first.login, 'user1');
    });

    test('createUser returns Right(User) on 201', () async {
      final mock = MockClient((request) async {
        return http.Response(jsonEncode({'id': 3, 'login': 'newuser'}), 201);
      });
      repository = AdminRepositoryImpl(
        apiService: GiteaApiService(client: makeClient(mock)),
      );
      final result = await repository.createUser({'login': 'newuser'});
      expect(result.isRight, isTrue);
      final user = (result as Right<Failure, User>).value;
      expect(user.id, 3);
      expect(user.login, 'newuser');
    });

    test('deleteUser returns Right(null) on 204', () async {
      final mock = MockClient((request) async {
        return http.Response('', 204);
      });
      repository = AdminRepositoryImpl(
        apiService: GiteaApiService(client: makeClient(mock)),
      );
      final result = await repository.deleteUser('testuser');
      expect(result.isRight, isTrue);
    });

    test('searchUsers returns Left(AuthenticationFailure) on 403', () async {
      final mock = MockClient((request) async {
        return http.Response(jsonEncode({'message': 'forbidden'}), 403);
      });
      repository = AdminRepositoryImpl(
        apiService: GiteaApiService(client: makeClient(mock)),
      );
      final result = await repository.searchUsers();
      expect(result.isLeft, isTrue);
      final failure = (result as Left<Failure, List<User>>).value;
      expect(failure, isA<AuthenticationFailure>());
    });

    test(
      'searchUsers returns Left(NetworkFailure) on NetworkException',
      () async {
        final mock = MockClient((request) async {
          throw http.ClientException(
            'No internet',
            Uri.parse('https://example.com'),
          );
        });
        repository = AdminRepositoryImpl(
          apiService: GiteaApiService(client: makeClient(mock)),
        );
        final result = await repository.searchUsers();
        expect(result.isLeft, isTrue);
        final failure = (result as Left<Failure, List<User>>).value;
        expect(failure, isA<NetworkFailure>());
      },
    );
  });
}
