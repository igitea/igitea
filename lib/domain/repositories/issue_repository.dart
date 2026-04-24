// ignore_for_file: non_constant_identifier_names
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';

/// Repository interface for issue-related operations.
abstract class IssueRepository {
  /// List issues in a repository.
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
  });

  /// Get a single issue.
  Future<Either<Failure, Issue>> getIssue(String owner, String repo, int index);

  /// Create an issue.
  Future<Either<Failure, Issue>> createIssue(
    String owner,
    String repo,
    Map<String, dynamic> body,
  );

  /// Edit an issue.
  Future<Either<Failure, Issue>> editIssue(
    String owner,
    String repo,
    int index,
    Map<String, dynamic> body,
  );

  /// Delete an issue.
  Future<Either<Failure, void>> deleteIssue(
    String owner,
    String repo,
    int index,
  );

  /// List comments on an issue.
  Future<Either<Failure, List<Comment>>> listComments(
    String owner,
    String repo,
    int index, {
    DateTime? since,
    DateTime? before,
  });

  /// Create a comment on an issue.
  Future<Either<Failure, Comment>> createComment(
    String owner,
    String repo,
    int index,
    Map<String, dynamic> body,
  );

  /// Edit a comment.
  Future<Either<Failure, Comment>> editComment(
    String owner,
    String repo,
    int id,
    Map<String, dynamic> body,
  );

  /// Delete a comment.
  Future<Either<Failure, void>> deleteComment(
    String owner,
    String repo,
    int id,
  );

  /// List labels in a repository.
  Future<Either<Failure, List<Label>>> listLabels(
    String owner,
    String repo, {
    int? page,
    int? limit,
  });

  /// Create a label.
  Future<Either<Failure, Label>> createLabel(
    String owner,
    String repo,
    Map<String, dynamic> body,
  );

  /// Get a single label.
  Future<Either<Failure, Label>> getLabel(String owner, String repo, int id);

  /// Edit a label.
  Future<Either<Failure, Label>> editLabel(
    String owner,
    String repo,
    int id,
    Map<String, dynamic> body,
  );

  /// Delete a label.
  Future<Either<Failure, void>> deleteLabel(String owner, String repo, int id);

  /// List milestones in a repository.
  Future<Either<Failure, List<Milestone>>> listMilestones(
    String owner,
    String repo, {
    String? state,
    String? name,
    int? page,
    int? limit,
  });

  /// Get a single milestone.
  Future<Either<Failure, Milestone>> getMilestone(
    String owner,
    String repo,
    String id,
  );

  /// Create a milestone.
  Future<Either<Failure, Milestone>> createMilestone(
    String owner,
    String repo,
    Map<String, dynamic> body,
  );

  /// Edit a milestone.
  Future<Either<Failure, Milestone>> editMilestone(
    String owner,
    String repo,
    String id,
    Map<String, dynamic> body,
  );

  /// Delete a milestone.
  Future<Either<Failure, void>> deleteMilestone(
    String owner,
    String repo,
    String id,
  );

  /// Search issues across all repositories the user has access to.
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
  });
}
