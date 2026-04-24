import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/core/errors/failures.dart';
import 'package:igitea/core/utils/either.dart';
import 'package:igitea/data/models/generated/generated_models.dart';
import 'package:igitea/domain/repositories/misc_repository.dart';
import 'package:igitea/domain/usecases/misc_usecases.dart';

class MockMiscRepository implements MiscRepository {
  bool shouldFail = false;
  Failure failure = const ServerFailure('error');

  @override
  Future<Either<Failure, List<String>>> listGitignoreTemplates() async {
    if (shouldFail) return Left(failure);
    return const Right(['Go', 'Python', 'Java']);
  }

  @override
  Future<Either<Failure, String>> renderMarkdown(
    Map<String, dynamic> body,
  ) async {
    if (shouldFail) return Left(failure);
    return const Right('<h1>Hello</h1>');
  }

  @override
  Future<Either<Failure, NodeInfo>> getNodeInfo() async {
    if (shouldFail) return Left(failure);
    return const Right(NodeInfo(version: '2.0'));
  }

  @override
  Future<Either<Failure, GeneralAPISettings>> getGeneralAPISettings() =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, GeneralAttachmentSettings>>
  getGeneralAttachmentSettings() => throw UnimplementedError();

  @override
  Future<Either<Failure, GeneralRepoSettings>> getGeneralRepositorySettings() =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, GeneralUISettings>> getGeneralUISettings() =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, GitignoreTemplateInfo>> getGitignoreTemplateInfo(
    String name,
  ) => throw UnimplementedError();

  @override
  Future<Either<Failure, String>> renderMarkdownRaw(String body) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, ActivityPub>> getActivityPubPerson(int userId) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, void>> sendActivityPubInbox(int userId) =>
      throw UnimplementedError();
}

void main() {
  group('GetGitignoreTemplatesUseCase', () {
    late MockMiscRepository mockRepo;
    late GetGitignoreTemplatesUseCase useCase;

    setUp(() {
      mockRepo = MockMiscRepository();
      useCase = GetGitignoreTemplatesUseCase(repository: mockRepo);
    });

    test('returns Right(List<String>) on success', () async {
      final result = await useCase();
      expect(result.isRight, isTrue);
      final templates = (result as Right<Failure, List<String>>).value;
      expect(templates.length, 3);
      expect(templates, ['Go', 'Python', 'Java']);
    });

    test('returns Left(Failure) on failure', () async {
      mockRepo.shouldFail = true;
      mockRepo.failure = const ServerFailure('error');
      final result = await useCase();
      expect(result.isLeft, isTrue);
      expect(
        (result as Left<Failure, List<String>>).value,
        isA<ServerFailure>(),
      );
    });
  });

  group('RenderMarkdownUseCase', () {
    late MockMiscRepository mockRepo;
    late RenderMarkdownUseCase useCase;

    setUp(() {
      mockRepo = MockMiscRepository();
      useCase = RenderMarkdownUseCase(repository: mockRepo);
    });

    test('returns Right(String) on success', () async {
      final body = {'text': '# Hello'};
      final result = await useCase(body);
      expect(result.isRight, isTrue);
      final html = (result as Right<Failure, String>).value;
      expect(html, '<h1>Hello</h1>');
    });

    test('returns Left(Failure) on failure', () async {
      mockRepo.shouldFail = true;
      mockRepo.failure = const ServerFailure('error');
      final body = {'text': '# Hello'};
      final result = await useCase(body);
      expect(result.isLeft, isTrue);
      expect((result as Left<Failure, String>).value, isA<ServerFailure>());
    });
  });

  group('GetNodeInfoUseCase', () {
    late MockMiscRepository mockRepo;
    late GetNodeInfoUseCase useCase;

    setUp(() {
      mockRepo = MockMiscRepository();
      useCase = GetNodeInfoUseCase(repository: mockRepo);
    });

    test('returns Right(NodeInfo) on success', () async {
      final result = await useCase();
      expect(result.isRight, isTrue);
      final nodeInfo = (result as Right<Failure, NodeInfo>).value;
      expect(nodeInfo.version, '2.0');
    });

    test('returns Left(Failure) on failure', () async {
      mockRepo.shouldFail = true;
      mockRepo.failure = const ServerFailure('error');
      final result = await useCase();
      expect(result.isLeft, isTrue);
      expect((result as Left<Failure, NodeInfo>).value, isA<ServerFailure>());
    });
  });
}
