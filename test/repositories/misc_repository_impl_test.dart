import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:igitea/core/errors/failures.dart';
import 'package:igitea/core/utils/either.dart';
import 'package:igitea/data/datasources/remote/api_client.dart';
import 'package:igitea/data/datasources/remote/gitea_api_service.dart';
import 'package:igitea/data/models/generated/generated_models.dart';
import 'package:igitea/data/repositories/misc_repository_impl.dart';

void main() {
  group('MiscRepositoryImpl', () {
    late MiscRepositoryImpl repository;

    ApiClient makeClient(MockClient mock) {
      return ApiClient(baseUrl: 'https://gitea.example.com', client: mock);
    }

    test(
      'getGeneralAPISettings returns Right(GeneralAPISettings) on 200',
      () async {
        final mock = MockClient((request) async {
          return http.Response(
            jsonEncode({
              'default_git_trees_per_page': 30,
              'max_response_items': 50,
            }),
            200,
          );
        });
        repository = MiscRepositoryImpl(
          apiService: GiteaApiService(client: makeClient(mock)),
        );
        final result = await repository.getGeneralAPISettings();
        expect(result.isRight, isTrue);
        final settings = (result as Right<Failure, GeneralAPISettings>).value;
        expect(settings.default_git_trees_per_page, 30);
        expect(settings.max_response_items, 50);
      },
    );

    test('renderMarkdown returns Right(String) on 200', () async {
      final mock = MockClient((request) async {
        return http.Response('<h1>Title</h1>', 200);
      });
      repository = MiscRepositoryImpl(
        apiService: GiteaApiService(client: makeClient(mock)),
      );
      final result = await repository.renderMarkdown({'Text': '# Title'});
      expect(result.isRight, isTrue);
      final html = (result as Right<Failure, String>).value;
      expect(html, '<h1>Title</h1>');
    });

    test('listGitignoreTemplates returns Right(List<String>) on 200', () async {
      final mock = MockClient((request) async {
        return http.Response(jsonEncode(['Go', 'Python', 'Java']), 200);
      });
      repository = MiscRepositoryImpl(
        apiService: GiteaApiService(client: makeClient(mock)),
      );
      final result = await repository.listGitignoreTemplates();
      expect(result.isRight, isTrue);
      final templates = (result as Right<Failure, List<String>>).value;
      expect(templates.length, 3);
      expect(templates, ['Go', 'Python', 'Java']);
    });

    test('getGeneralAPISettings returns Left(ServerFailure) on 500', () async {
      final mock = MockClient((request) async {
        return http.Response(
          jsonEncode({'message': 'internal server error'}),
          500,
        );
      });
      repository = MiscRepositoryImpl(
        apiService: GiteaApiService(client: makeClient(mock)),
      );
      final result = await repository.getGeneralAPISettings();
      expect(result.isLeft, isTrue);
      final failure = (result as Left<Failure, GeneralAPISettings>).value;
      expect(failure, isA<ServerFailure>());
    });

    test(
      'getGeneralAPISettings returns Left(NetworkFailure) on NetworkException',
      () async {
        final mock = MockClient((request) async {
          throw http.ClientException(
            'No internet',
            Uri.parse('https://example.com'),
          );
        });
        repository = MiscRepositoryImpl(
          apiService: GiteaApiService(client: makeClient(mock)),
        );
        final result = await repository.getGeneralAPISettings();
        expect(result.isLeft, isTrue);
        final failure = (result as Left<Failure, GeneralAPISettings>).value;
        expect(failure, isA<NetworkFailure>());
      },
    );
  });
}
