import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:igitea/core/errors/failures.dart';
import 'package:igitea/core/utils/either.dart';
import 'package:igitea/data/datasources/remote/api_client.dart';
import 'package:igitea/data/datasources/remote/gitea_api_service.dart';
import 'package:igitea/data/models/generated/generated_models.dart';
import 'package:igitea/data/repositories/notification_repository_impl.dart';

void main() {
  group('NotificationRepositoryImpl', () {
    late NotificationRepositoryImpl repository;

    ApiClient makeClient(MockClient mock) {
      return ApiClient(baseUrl: 'https://gitea.example.com', client: mock);
    }

    test(
      'listNotifications returns Right(List<NotificationThread>) on 200',
      () async {
        final mock = MockClient((request) async {
          return http.Response(
            jsonEncode([
              {'id': 1, 'unread': true},
              {'id': 2, 'unread': false},
            ]),
            200,
          );
        });
        repository = NotificationRepositoryImpl(
          apiService: GiteaApiService(client: makeClient(mock)),
        );
        final result = await repository.listNotifications();
        expect(result.isRight, isTrue);
        final notifications =
            (result as Right<Failure, List<NotificationThread>>).value;
        expect(notifications.length, 2);
        expect(notifications.first.id, 1);
      },
    );

    test('checkNewAvailable returns Right(NotificationCount) on 200', () async {
      final mock = MockClient((request) async {
        return http.Response(jsonEncode({'new': 5}), 200);
      });
      repository = NotificationRepositoryImpl(
        apiService: GiteaApiService(client: makeClient(mock)),
      );
      final result = await repository.checkNewAvailable();
      expect(result.isRight, isTrue);
      final count = (result as Right<Failure, NotificationCount>).value;
      expect(count.new_, 5);
    });

    test('markThreadRead returns Right(null) on 205', () async {
      final mock = MockClient((request) async {
        return http.Response('', 205);
      });
      repository = NotificationRepositoryImpl(
        apiService: GiteaApiService(client: makeClient(mock)),
      );
      final result = await repository.markThreadRead('123');
      expect(result.isRight, isTrue);
    });

    test(
      'listNotifications returns Left(AuthenticationFailure) on 401',
      () async {
        final mock = MockClient((request) async {
          return http.Response(jsonEncode({'message': 'unauthorized'}), 401);
        });
        repository = NotificationRepositoryImpl(
          apiService: GiteaApiService(client: makeClient(mock)),
        );
        final result = await repository.listNotifications();
        expect(result.isLeft, isTrue);
        final failure =
            (result as Left<Failure, List<NotificationThread>>).value;
        expect(failure, isA<AuthenticationFailure>());
      },
    );

    test(
      'listNotifications returns Left(NetworkFailure) on NetworkException',
      () async {
        final mock = MockClient((request) async {
          throw http.ClientException(
            'No internet',
            Uri.parse('https://example.com'),
          );
        });
        repository = NotificationRepositoryImpl(
          apiService: GiteaApiService(client: makeClient(mock)),
        );
        final result = await repository.listNotifications();
        expect(result.isLeft, isTrue);
        final failure =
            (result as Left<Failure, List<NotificationThread>>).value;
        expect(failure, isA<NetworkFailure>());
      },
    );
  });
}
