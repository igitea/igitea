// ignore_for_file: non_constant_identifier_names
import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/core/errors/failures.dart';
import 'package:igitea/core/utils/either.dart';
import 'package:igitea/data/models/generated/generated_models.dart';
import 'package:igitea/domain/repositories/issue_repository.dart';
import 'package:igitea/domain/usecases/issue_usecases.dart';

class MockIssueRepository implements IssueRepository {
  bool shouldFail = false;
  Failure failure = const ServerFailure('error');

  @override
  Future<Either<Failure, List<Issue>>> listIssues(
    String owner,
    String repo, {
    String? state,
    String? labels,
    String? q,
    String? type,
    String? milestones,
    DateTime? since,
    DateTime? before,
    String? created_by,
    String? assigned_by,
    String? mentioned_by,
    int? page,
    int? limit,
  }) async {
    if (shouldFail) return Left(failure);
    return Right([const Issue(id: 1, title: 'Bug', number: 1)]);
  }

  @override
  Future<Either<Failure, Issue>> getIssue(
    String owner,
    String repo,
    int index,
  ) async {
    if (shouldFail) return Left(failure);
    return Right(const Issue(id: 1, title: 'Bug', number: 1));
  }

  @override
  Future<Either<Failure, Issue>> createIssue(
    String owner,
    String repo,
    Map<String, dynamic> body,
  ) async {
    if (shouldFail) return Left(failure);
    return Right(const Issue(id: 5, title: 'New Issue', number: 3));
  }

  @override
  Future<Either<Failure, Issue>> editIssue(
    String owner,
    String repo,
    int index,
    Map<String, dynamic> body,
  ) => throw UnimplementedError();

  @override
  Future<Either<Failure, void>> deleteIssue(
    String owner,
    String repo,
    int index,
  ) => throw UnimplementedError();

  @override
  Future<Either<Failure, List<Comment>>> listComments(
    String owner,
    String repo,
    int index, {
    DateTime? since,
    DateTime? before,
  }) async {
    if (shouldFail) return Left(failure);
    return const Right([Comment(id: 1, body: 'text')]);
  }

  @override
  Future<Either<Failure, Comment>> createComment(
    String owner,
    String repo,
    int index,
    Map<String, dynamic> body,
  ) => throw UnimplementedError();

  @override
  Future<Either<Failure, Comment>> editComment(
    String owner,
    String repo,
    int id,
    Map<String, dynamic> body,
  ) => throw UnimplementedError();

  @override
  Future<Either<Failure, void>> deleteComment(
    String owner,
    String repo,
    int id,
  ) => throw UnimplementedError();

  @override
  Future<Either<Failure, List<Label>>> listLabels(
    String owner,
    String repo, {
    int? page,
    int? limit,
  }) async {
    if (shouldFail) return Left(failure);
    return const Right([Label(id: 1, name: 'bug', color: 'ff0000')]);
  }

  @override
  Future<Either<Failure, Label>> createLabel(
    String owner,
    String repo,
    Map<String, dynamic> body,
  ) => throw UnimplementedError();

  @override
  Future<Either<Failure, Label>> getLabel(String owner, String repo, int id) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, Label>> editLabel(
    String owner,
    String repo,
    int id,
    Map<String, dynamic> body,
  ) => throw UnimplementedError();

  @override
  Future<Either<Failure, void>> deleteLabel(
    String owner,
    String repo,
    int id,
  ) => throw UnimplementedError();

  @override
  Future<Either<Failure, List<Label>>> replaceIssueLabels(
    String owner,
    String repo,
    int index,
    Map<String, dynamic> body,
  ) => throw UnimplementedError();

  @override
  Future<Either<Failure, List<Milestone>>> listMilestones(
    String owner,
    String repo, {
    String? state,
    String? name,
    int? page,
    int? limit,
  }) async {
    if (shouldFail) return Left(failure);
    return const Right([Milestone(id: 1, title: 'v1.0')]);
  }

  @override
  Future<Either<Failure, Milestone>> getMilestone(
    String owner,
    String repo,
    String id,
  ) => throw UnimplementedError();

  @override
  Future<Either<Failure, Milestone>> createMilestone(
    String owner,
    String repo,
    Map<String, dynamic> body,
  ) => throw UnimplementedError();

  @override
  Future<Either<Failure, Milestone>> editMilestone(
    String owner,
    String repo,
    String id,
    Map<String, dynamic> body,
  ) => throw UnimplementedError();

  @override
  Future<Either<Failure, void>> deleteMilestone(
    String owner,
    String repo,
    String id,
  ) => throw UnimplementedError();

  @override
  Future<Either<Failure, List<Issue>>> searchIssues({
    String? state,
    String? labels,
    String? milestones,
    String? q,
    int? priority_repo_id,
    String? type,
    DateTime? since,
    DateTime? before,
    bool? assigned,
    bool? created,
    bool? mentioned,
    bool? review_requested,
    bool? reviewed,
    String? owner,
    String? team,
    int? page,
    int? limit,
  }) async {
    if (shouldFail) return Left(failure);
    return Right([const Issue(id: 1, title: 'Bug', number: 1)]);
  }
}

void main() {
  group('ListIssuesUseCase', () {
    late MockIssueRepository mockRepo;
    late ListIssuesUseCase useCase;

    setUp(() {
      mockRepo = MockIssueRepository();
      useCase = ListIssuesUseCase(repository: mockRepo);
    });

    test('returns Right(List<Issue>) on success', () async {
      final params = ListIssuesParams(owner: 'owner', repo: 'repo');
      final result = await useCase(params);
      expect(result.isRight, isTrue);
      final issues = (result as Right<Failure, List<Issue>>).value;
      expect(issues.length, 1);
      expect(issues.first.id, 1);
      expect(issues.first.title, 'Bug');
    });

    test('returns Left(Failure) on failure', () async {
      mockRepo.shouldFail = true;
      mockRepo.failure = const ServerFailure('server error');
      final params = ListIssuesParams(owner: 'owner', repo: 'repo');
      final result = await useCase(params);
      expect(result.isLeft, isTrue);
      final failure = (result as Left<Failure, List<Issue>>).value;
      expect(failure, isA<ServerFailure>());
    });

    test('params store values correctly', () {
      final since = DateTime(2024);
      final before = DateTime(2025);
      final params = ListIssuesParams(
        owner: 'owner',
        repo: 'repo',
        state: 'open',
        labels: 'bug',
        q: 'search',
        type: 'issues',
        milestones: '1',
        since: since,
        before: before,
        created_by: 'user1',
        assigned_by: 'user2',
        mentioned_by: 'user3',
        page: 1,
        limit: 10,
      );
      expect(params.owner, 'owner');
      expect(params.repo, 'repo');
      expect(params.state, 'open');
      expect(params.labels, 'bug');
      expect(params.q, 'search');
      expect(params.type, 'issues');
      expect(params.milestones, '1');
      expect(params.since, since);
      expect(params.before, before);
      expect(params.created_by, 'user1');
      expect(params.assigned_by, 'user2');
      expect(params.mentioned_by, 'user3');
      expect(params.page, 1);
      expect(params.limit, 10);
    });
  });

  group('GetIssueUseCase', () {
    late MockIssueRepository mockRepo;
    late GetIssueUseCase useCase;

    setUp(() {
      mockRepo = MockIssueRepository();
      useCase = GetIssueUseCase(repository: mockRepo);
    });

    test('returns Right(Issue) on success', () async {
      final params = GetIssueParams(owner: 'owner', repo: 'repo', index: 1);
      final result = await useCase(params);
      expect(result.isRight, isTrue);
      final issue = (result as Right<Failure, Issue>).value;
      expect(issue.id, 1);
      expect(issue.title, 'Bug');
    });

    test('returns Left(Failure) on failure', () async {
      mockRepo.shouldFail = true;
      mockRepo.failure = const ServerFailure('not found');
      final params = GetIssueParams(owner: 'owner', repo: 'repo', index: 1);
      final result = await useCase(params);
      expect(result.isLeft, isTrue);
      expect((result as Left<Failure, Issue>).value, isA<ServerFailure>());
    });

    test('params store values correctly', () {
      final params = GetIssueParams(owner: 'owner', repo: 'repo', index: 42);
      expect(params.owner, 'owner');
      expect(params.repo, 'repo');
      expect(params.index, 42);
    });
  });

  group('CreateIssueUseCase', () {
    late MockIssueRepository mockRepo;
    late CreateIssueUseCase useCase;

    setUp(() {
      mockRepo = MockIssueRepository();
      useCase = CreateIssueUseCase(repository: mockRepo);
    });

    test('returns Right(Issue) on success', () async {
      final params = CreateIssueParams(
        owner: 'owner',
        repo: 'repo',
        body: {'title': 'New Issue'},
      );
      final result = await useCase(params);
      expect(result.isRight, isTrue);
      final issue = (result as Right<Failure, Issue>).value;
      expect(issue.id, 5);
      expect(issue.title, 'New Issue');
    });

    test('returns Left(Failure) on failure', () async {
      mockRepo.shouldFail = true;
      mockRepo.failure = const ServerFailure('bad request');
      final params = CreateIssueParams(
        owner: 'owner',
        repo: 'repo',
        body: {'title': 'New Issue'},
      );
      final result = await useCase(params);
      expect(result.isLeft, isTrue);
      expect((result as Left<Failure, Issue>).value, isA<ServerFailure>());
    });

    test('params store values correctly', () {
      final body = {'title': 'Test', 'body': 'desc'};
      final params = CreateIssueParams(
        owner: 'owner',
        repo: 'repo',
        body: body,
      );
      expect(params.owner, 'owner');
      expect(params.repo, 'repo');
      expect(params.body, body);
    });
  });

  group('ListCommentsUseCase', () {
    late MockIssueRepository mockRepo;
    late ListCommentsUseCase useCase;

    setUp(() {
      mockRepo = MockIssueRepository();
      useCase = ListCommentsUseCase(repository: mockRepo);
    });

    test('returns Right(List<Comment>) on success', () async {
      final params = ListCommentsParams(owner: 'owner', repo: 'repo', index: 1);
      final result = await useCase(params);
      expect(result.isRight, isTrue);
      final comments = (result as Right<Failure, List<Comment>>).value;
      expect(comments.length, 1);
      expect(comments.first.id, 1);
      expect(comments.first.body, 'text');
    });

    test('returns Left(Failure) on failure', () async {
      mockRepo.shouldFail = true;
      mockRepo.failure = const ServerFailure('error');
      final params = ListCommentsParams(owner: 'owner', repo: 'repo', index: 1);
      final result = await useCase(params);
      expect(result.isLeft, isTrue);
      expect(
        (result as Left<Failure, List<Comment>>).value,
        isA<ServerFailure>(),
      );
    });

    test('params store values correctly', () {
      final since = DateTime(2024);
      final before = DateTime(2025);
      final params = ListCommentsParams(
        owner: 'owner',
        repo: 'repo',
        index: 5,
        since: since,
        before: before,
      );
      expect(params.owner, 'owner');
      expect(params.repo, 'repo');
      expect(params.index, 5);
      expect(params.since, since);
      expect(params.before, before);
    });
  });

  group('ListLabelsUseCase', () {
    late MockIssueRepository mockRepo;
    late ListLabelsUseCase useCase;

    setUp(() {
      mockRepo = MockIssueRepository();
      useCase = ListLabelsUseCase(repository: mockRepo);
    });

    test('returns Right(List<Label>) on success', () async {
      final params = ListLabelsParams(owner: 'owner', repo: 'repo');
      final result = await useCase(params);
      expect(result.isRight, isTrue);
      final labels = (result as Right<Failure, List<Label>>).value;
      expect(labels.length, 1);
      expect(labels.first.name, 'bug');
      expect(labels.first.color, 'ff0000');
    });

    test('returns Left(Failure) on failure', () async {
      mockRepo.shouldFail = true;
      mockRepo.failure = const ServerFailure('error');
      final params = ListLabelsParams(owner: 'owner', repo: 'repo');
      final result = await useCase(params);
      expect(result.isLeft, isTrue);
      expect(
        (result as Left<Failure, List<Label>>).value,
        isA<ServerFailure>(),
      );
    });

    test('params store values correctly', () {
      final params = ListLabelsParams(
        owner: 'owner',
        repo: 'repo',
        page: 2,
        limit: 20,
      );
      expect(params.owner, 'owner');
      expect(params.repo, 'repo');
      expect(params.page, 2);
      expect(params.limit, 20);
    });
  });

  group('ListMilestonesUseCase', () {
    late MockIssueRepository mockRepo;
    late ListMilestonesUseCase useCase;

    setUp(() {
      mockRepo = MockIssueRepository();
      useCase = ListMilestonesUseCase(repository: mockRepo);
    });

    test('returns Right(List<Milestone>) on success', () async {
      final params = ListMilestonesParams(owner: 'owner', repo: 'repo');
      final result = await useCase(params);
      expect(result.isRight, isTrue);
      final milestones = (result as Right<Failure, List<Milestone>>).value;
      expect(milestones.length, 1);
      expect(milestones.first.title, 'v1.0');
    });

    test('returns Left(Failure) on failure', () async {
      mockRepo.shouldFail = true;
      mockRepo.failure = const ServerFailure('error');
      final params = ListMilestonesParams(owner: 'owner', repo: 'repo');
      final result = await useCase(params);
      expect(result.isLeft, isTrue);
      expect(
        (result as Left<Failure, List<Milestone>>).value,
        isA<ServerFailure>(),
      );
    });

    test('params store values correctly', () {
      final params = ListMilestonesParams(
        owner: 'owner',
        repo: 'repo',
        state: 'open',
        name: 'v1',
        page: 1,
        limit: 10,
      );
      expect(params.owner, 'owner');
      expect(params.repo, 'repo');
      expect(params.state, 'open');
      expect(params.name, 'v1');
      expect(params.page, 1);
      expect(params.limit, 10);
    });
  });
}
