// ignore_for_file: non_constant_identifier_names
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../repositories/issue_repository.dart';

class ListIssuesUseCase {
  final IssueRepository _repository;

  ListIssuesUseCase({required IssueRepository repository})
    : _repository = repository;

  Future<Either<Failure, List<Issue>>> call(ListIssuesParams params) async {
    return _repository.listIssues(
      params.owner,
      params.repo,
      state: params.state,
      labels: params.labels,
      q: params.q,
      type: params.type,
      milestones: params.milestones,
      since: params.since,
      before: params.before,
      created_by: params.created_by,
      assigned_by: params.assigned_by,
      mentioned_by: params.mentioned_by,
      page: params.page,
      limit: params.limit,
    );
  }
}

class ListIssuesParams {
  final String owner;
  final String repo;
  final String? state;
  final String? labels;
  final String? q;
  final String? type;
  final String? milestones;
  final DateTime? since;
  final DateTime? before;
  final String? created_by;
  final String? assigned_by;
  final String? mentioned_by;
  final int? page;
  final int? limit;

  ListIssuesParams({
    required this.owner,
    required this.repo,
    this.state,
    this.labels,
    this.q,
    this.type,
    this.milestones,
    this.since,
    this.before,
    this.created_by,
    this.assigned_by,
    this.mentioned_by,
    this.page,
    this.limit,
  });
}

class GetIssueUseCase {
  final IssueRepository _repository;

  GetIssueUseCase({required IssueRepository repository})
    : _repository = repository;

  Future<Either<Failure, Issue>> call(GetIssueParams params) async {
    return _repository.getIssue(params.owner, params.repo, params.index);
  }
}

class GetIssueParams {
  final String owner;
  final String repo;
  final int index;

  GetIssueParams({
    required this.owner,
    required this.repo,
    required this.index,
  });
}

class CreateIssueUseCase {
  final IssueRepository _repository;

  CreateIssueUseCase({required IssueRepository repository})
    : _repository = repository;

  Future<Either<Failure, Issue>> call(CreateIssueParams params) async {
    return _repository.createIssue(params.owner, params.repo, params.body);
  }
}

class CreateIssueParams {
  final String owner;
  final String repo;
  final Map<String, dynamic> body;

  CreateIssueParams({
    required this.owner,
    required this.repo,
    required this.body,
  });
}

class EditIssueUseCase {
  final IssueRepository _repository;

  EditIssueUseCase({required IssueRepository repository})
    : _repository = repository;

  Future<Either<Failure, Issue>> call(EditIssueParams params) async {
    return _repository.editIssue(
      params.owner,
      params.repo,
      params.index,
      params.body,
    );
  }
}

class EditIssueParams {
  final String owner;
  final String repo;
  final int index;
  final Map<String, dynamic> body;

  EditIssueParams({
    required this.owner,
    required this.repo,
    required this.index,
    required this.body,
  });
}

class ListCommentsUseCase {
  final IssueRepository _repository;

  ListCommentsUseCase({required IssueRepository repository})
    : _repository = repository;

  Future<Either<Failure, List<Comment>>> call(ListCommentsParams params) async {
    return _repository.listComments(
      params.owner,
      params.repo,
      params.index,
      since: params.since,
      before: params.before,
    );
  }
}

class ListCommentsParams {
  final String owner;
  final String repo;
  final int index;
  final DateTime? since;
  final DateTime? before;

  ListCommentsParams({
    required this.owner,
    required this.repo,
    required this.index,
    this.since,
    this.before,
  });
}

class CreateCommentUseCase {
  final IssueRepository _repository;

  CreateCommentUseCase({required IssueRepository repository})
    : _repository = repository;

  Future<Either<Failure, Comment>> call(CreateCommentParams params) async {
    return _repository.createComment(
      params.owner,
      params.repo,
      params.index,
      params.body,
    );
  }
}

class CreateCommentParams {
  final String owner;
  final String repo;
  final int index;
  final Map<String, dynamic> body;

  CreateCommentParams({
    required this.owner,
    required this.repo,
    required this.index,
    required this.body,
  });
}

class ListLabelsUseCase {
  final IssueRepository _repository;

  ListLabelsUseCase({required IssueRepository repository})
    : _repository = repository;

  Future<Either<Failure, List<Label>>> call(ListLabelsParams params) async {
    return _repository.listLabels(
      params.owner,
      params.repo,
      page: params.page,
      limit: params.limit,
    );
  }
}

class ListLabelsParams {
  final String owner;
  final String repo;
  final int? page;
  final int? limit;

  ListLabelsParams({
    required this.owner,
    required this.repo,
    this.page,
    this.limit,
  });
}

class CreateLabelUseCase {
  final IssueRepository _repository;

  CreateLabelUseCase({required IssueRepository repository})
    : _repository = repository;

  Future<Either<Failure, Label>> call(CreateLabelParams params) async {
    return _repository.createLabel(params.owner, params.repo, params.body);
  }
}

class CreateLabelParams {
  final String owner;
  final String repo;
  final Map<String, dynamic> body;

  CreateLabelParams({
    required this.owner,
    required this.repo,
    required this.body,
  });
}

class ListMilestonesUseCase {
  final IssueRepository _repository;

  ListMilestonesUseCase({required IssueRepository repository})
    : _repository = repository;

  Future<Either<Failure, List<Milestone>>> call(
    ListMilestonesParams params,
  ) async {
    return _repository.listMilestones(
      params.owner,
      params.repo,
      state: params.state,
      name: params.name,
      page: params.page,
      limit: params.limit,
    );
  }
}

class ListMilestonesParams {
  final String owner;
  final String repo;
  final String? state;
  final String? name;
  final int? page;
  final int? limit;

  ListMilestonesParams({
    required this.owner,
    required this.repo,
    this.state,
    this.name,
    this.page,
    this.limit,
  });
}

class CreateMilestoneUseCase {
  final IssueRepository _repository;

  CreateMilestoneUseCase({required IssueRepository repository})
    : _repository = repository;

  Future<Either<Failure, Milestone>> call(CreateMilestoneParams params) async {
    return _repository.createMilestone(params.owner, params.repo, params.body);
  }
}

class CreateMilestoneParams {
  final String owner;
  final String repo;
  final Map<String, dynamic> body;

  CreateMilestoneParams({
    required this.owner,
    required this.repo,
    required this.body,
  });
}

class GetMilestoneUseCase {
  final IssueRepository _repository;

  GetMilestoneUseCase({required IssueRepository repository})
    : _repository = repository;

  Future<Either<Failure, Milestone>> call(GetMilestoneParams params) async {
    return _repository.getMilestone(params.owner, params.repo, params.id);
  }
}

class GetMilestoneParams {
  final String owner;
  final String repo;
  final String id;

  GetMilestoneParams({
    required this.owner,
    required this.repo,
    required this.id,
  });
}

class EditMilestoneUseCase {
  final IssueRepository _repository;

  EditMilestoneUseCase({required IssueRepository repository})
    : _repository = repository;

  Future<Either<Failure, Milestone>> call(EditMilestoneParams params) async {
    return _repository.editMilestone(
      params.owner,
      params.repo,
      params.id,
      params.body,
    );
  }
}

class EditMilestoneParams {
  final String owner;
  final String repo;
  final String id;
  final Map<String, dynamic> body;

  EditMilestoneParams({
    required this.owner,
    required this.repo,
    required this.id,
    required this.body,
  });
}

class DeleteMilestoneUseCase {
  final IssueRepository _repository;

  DeleteMilestoneUseCase({required IssueRepository repository})
    : _repository = repository;

  Future<Either<Failure, void>> call(DeleteMilestoneParams params) async {
    return _repository.deleteMilestone(
      params.owner,
      params.repo,
      params.id.toString(),
    );
  }
}

class DeleteMilestoneParams {
  final String owner;
  final String repo;
  final int id;

  DeleteMilestoneParams({
    required this.owner,
    required this.repo,
    required this.id,
  });
}

class SearchIssuesUseCase {
  final IssueRepository _repository;

  SearchIssuesUseCase({required IssueRepository repository})
    : _repository = repository;

  Future<Either<Failure, List<Issue>>> call(SearchIssuesParams params) async {
    return _repository.searchIssues(
      state: params.state,
      labels: params.labels,
      milestones: params.milestones,
      q: params.q,
      priority_repo_id: params.priority_repo_id,
      type: params.type,
      since: params.since,
      before: params.before,
      assigned: params.assigned,
      created: params.created,
      mentioned: params.mentioned,
      review_requested: params.review_requested,
      reviewed: params.reviewed,
      owner: params.owner,
      team: params.team,
      page: params.page,
      limit: params.limit,
    );
  }
}

class SearchIssuesParams {
  final String? state;
  final String? labels;
  final String? milestones;
  final String? q;
  final int? priority_repo_id;
  final String? type;
  final DateTime? since;
  final DateTime? before;
  final bool? assigned;
  final bool? created;
  final bool? mentioned;
  final bool? review_requested;
  final bool? reviewed;
  final String? owner;
  final String? team;
  final int? page;
  final int? limit;

  SearchIssuesParams({
    this.state,
    this.labels,
    this.milestones,
    this.q,
    this.priority_repo_id,
    this.type,
    this.since,
    this.before,
    this.assigned,
    this.created,
    this.mentioned,
    this.review_requested,
    this.reviewed,
    this.owner,
    this.team,
    this.page,
    this.limit,
  });
}
