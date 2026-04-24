// ignore_for_file: non_constant_identifier_names

import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../core/utils/repository_helper.dart';
import '../../domain/repositories/issue_repository.dart';
import '../datasources/remote/gitea_api_service.dart';
import '../models/generated/generated_models.dart';

class IssueRepositoryImpl implements IssueRepository {
  final GiteaApiService _apiService;

  IssueRepositoryImpl({required GiteaApiService apiService})
    : _apiService = apiService;

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
    return execute(
      () => _apiService.issueListIssues(
        owner: owner,
        repo: repo,
        state: state,
        labels: labels,
        q: q,
        type: type,
        milestones: milestones,
        since: since,
        before: before,
        created_by: created_by,
        assigned_by: assigned_by,
        mentioned_by: mentioned_by,
        page: page,
        limit: limit,
      ),
    );
  }

  @override
  Future<Either<Failure, Issue>> getIssue(
    String owner,
    String repo,
    int index,
  ) async {
    return execute(
      () => _apiService.issueGetIssue(owner: owner, repo: repo, index: index),
    );
  }

  @override
  Future<Either<Failure, Issue>> createIssue(
    String owner,
    String repo,
    Map<String, dynamic> body,
  ) async {
    return execute(
      () => _apiService.issueCreateIssue(owner: owner, repo: repo, body: body),
    );
  }

  @override
  Future<Either<Failure, Issue>> editIssue(
    String owner,
    String repo,
    int index,
    Map<String, dynamic> body,
  ) async {
    return execute(
      () => _apiService.issueEditIssue(
        owner: owner,
        repo: repo,
        index: index,
        body: body,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> deleteIssue(
    String owner,
    String repo,
    int index,
  ) async {
    return execute(
      () => _apiService.issueDelete(owner: owner, repo: repo, index: index),
    );
  }

  @override
  Future<Either<Failure, List<Comment>>> listComments(
    String owner,
    String repo,
    int index, {
    DateTime? since,
    DateTime? before,
  }) async {
    return execute(
      () => _apiService.issueGetComments(
        owner: owner,
        repo: repo,
        index: index,
        since: since,
        before: before,
      ),
    );
  }

  @override
  Future<Either<Failure, Comment>> createComment(
    String owner,
    String repo,
    int index,
    Map<String, dynamic> body,
  ) async {
    return execute(
      () => _apiService.issueCreateComment(
        owner: owner,
        repo: repo,
        index: index,
        body: body,
      ),
    );
  }

  @override
  Future<Either<Failure, Comment>> editComment(
    String owner,
    String repo,
    int id,
    Map<String, dynamic> body,
  ) async {
    return execute(
      () => _apiService.issueEditComment(
        owner: owner,
        repo: repo,
        id: id,
        body: body,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> deleteComment(
    String owner,
    String repo,
    int id,
  ) async {
    return execute(
      () => _apiService.issueDeleteComment(owner: owner, repo: repo, id: id),
    );
  }

  @override
  Future<Either<Failure, List<Label>>> listLabels(
    String owner,
    String repo, {
    int? page,
    int? limit,
  }) async {
    return execute(
      () => _apiService.issueListLabels(
        owner: owner,
        repo: repo,
        page: page,
        limit: limit,
      ),
    );
  }

  @override
  Future<Either<Failure, Label>> createLabel(
    String owner,
    String repo,
    Map<String, dynamic> body,
  ) async {
    return execute(
      () => _apiService.issueCreateLabel(owner: owner, repo: repo, body: body),
    );
  }

  @override
  Future<Either<Failure, Label>> getLabel(
    String owner,
    String repo,
    int id,
  ) async {
    return execute(
      () => _apiService.issueGetLabel(owner: owner, repo: repo, id: id),
    );
  }

  @override
  Future<Either<Failure, Label>> editLabel(
    String owner,
    String repo,
    int id,
    Map<String, dynamic> body,
  ) async {
    return execute(
      () => _apiService.issueEditLabel(
        owner: owner,
        repo: repo,
        id: id,
        body: body,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> deleteLabel(
    String owner,
    String repo,
    int id,
  ) async {
    return execute(
      () => _apiService.issueDeleteLabel(owner: owner, repo: repo, id: id),
    );
  }

  @override
  Future<Either<Failure, List<Milestone>>> listMilestones(
    String owner,
    String repo, {
    String? state,
    String? name,
    int? page,
    int? limit,
  }) async {
    return execute(
      () => _apiService.issueGetMilestonesList(
        owner: owner,
        repo: repo,
        state: state,
        name: name,
        page: page,
        limit: limit,
      ),
    );
  }

  @override
  Future<Either<Failure, Milestone>> getMilestone(
    String owner,
    String repo,
    String id,
  ) async {
    return execute(
      () => _apiService.issueGetMilestone(owner: owner, repo: repo, id: id),
    );
  }

  @override
  Future<Either<Failure, Milestone>> createMilestone(
    String owner,
    String repo,
    Map<String, dynamic> body,
  ) async {
    return execute(
      () => _apiService.issueCreateMilestone(
        owner: owner,
        repo: repo,
        body: body,
      ),
    );
  }

  @override
  Future<Either<Failure, Milestone>> editMilestone(
    String owner,
    String repo,
    String id,
    Map<String, dynamic> body,
  ) async {
    return execute(
      () => _apiService.issueEditMilestone(
        owner: owner,
        repo: repo,
        id: id,
        body: body,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> deleteMilestone(
    String owner,
    String repo,
    String id,
  ) async {
    return execute(
      () => _apiService.issueDeleteMilestone(owner: owner, repo: repo, id: id),
    );
  }

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
    return execute(
      () => _apiService.issueSearchIssues(
        state: state,
        labels: labels,
        milestones: milestones,
        q: q,
        priority_repo_id: priority_repo_id,
        type: type,
        since: since,
        before: before,
        assigned: assigned,
        created: created,
        mentioned: mentioned,
        review_requested: review_requested,
        reviewed: reviewed,
        owner: owner,
        team: team,
        page: page,
        limit: limit,
      ),
    );
  }
}
