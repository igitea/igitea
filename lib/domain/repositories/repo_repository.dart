import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';

/// Repository interface for git repository-related operations.
abstract class RepoRepository {
  /// Get a repository by owner and name.
  Future<Either<Failure, Repository>> getRepo(String owner, String repo);

  /// Delete a repository.
  Future<Either<Failure, void>> deleteRepo(String owner, String repo);

  /// Edit a repository.
  Future<Either<Failure, Repository>> editRepo(
    String owner,
    String repo,
    Map<String, dynamic> body,
  );

  /// Migrate an external repository.
  Future<Either<Failure, Repository>> migrateRepo(Map<String, dynamic> body);

  /// List branches in a repository.
  Future<Either<Failure, List<Branch>>> listBranches(
    String owner,
    String repo, {
    int? page,
    int? limit,
  });

  /// Get a specific branch.
  Future<Either<Failure, Branch>> getBranch(
    String owner,
    String repo,
    String branch,
  );

  /// List tags in a repository.
  Future<Either<Failure, List<Tag>>> listTags(
    String owner,
    String repo, {
    int? page,
    int? limit,
  });

  /// List commits in a repository.
  Future<Either<Failure, List<Commit>>> listCommits(
    String owner,
    String repo, {
    String? sha,
    int? page,
    int? limit,
  });

  /// Get a single commit.
  Future<Either<Failure, Commit>> getCommit(
    String owner,
    String repo,
    String sha,
  );

  /// List releases in a repository.
  Future<Either<Failure, List<Release>>> listReleases(
    String owner,
    String repo, {
    int? page,
    int? limit,
  });

  /// Get a specific release.
  Future<Either<Failure, Release>> getRelease(
    String owner,
    String repo,
    int id,
  );

  /// List collaborators in a repository.
  Future<Either<Failure, List<User>>> listCollaborators(
    String owner,
    String repo, {
    int? page,
    int? limit,
  });

  /// Add a collaborator.
  Future<Either<Failure, void>> addCollaborator(
    String owner,
    String repo,
    String collaborator,
    Map<String, dynamic> body,
  );

  /// Remove a collaborator.
  Future<Either<Failure, void>> removeCollaborator(
    String owner,
    String repo,
    String collaborator,
  );

  /// List hooks in a repository.
  Future<Either<Failure, List<Hook>>> listHooks(
    String owner,
    String repo, {
    int? page,
    int? limit,
  });

  /// Create a hook in a repository.
  Future<Either<Failure, Hook>> createHook(
    String owner,
    String repo,
    Map<String, dynamic> body,
  );

  /// Delete a hook.
  Future<Either<Failure, void>> deleteHook(String owner, String repo, int id);

  /// Get repository contents (files/directories).
  Future<Either<Failure, List<ContentsResponse>>> getRepoContents(
    String owner,
    String repo, {
    String? path,
    String? ref,
  });

  /// Update a file in a repository.
  Future<Either<Failure, FileResponse>> updateFile(
    String owner,
    String repo,
    String filepath,
    UpdateFileOptions body,
  );

  /// List pull requests in a repository.
  Future<Either<Failure, List<PullRequest>>> listPullRequests(
    String owner,
    String repo, {
    String? state,
    int? page,
    int? limit,
  });

  /// Get a specific pull request.
  Future<Either<Failure, PullRequest>> getPullRequest(String owner, String repo, int index);

  /// Search repositories.
  Future<Either<Failure, SearchResults>> searchRepos({
    String? q,
    int? uid,
    int? page,
    int? limit,
  });

  /// Star a repository.
  Future<Either<Failure, void>> starRepo(String owner, String repo);

  /// Unstar a repository.
  Future<Either<Failure, void>> unstarRepo(String owner, String repo);

  /// Check if the current user has starred a repository.
  Future<Either<Failure, bool>> checkStarred(String owner, String repo);

  /// Create a pull request.
  Future<Either<Failure, PullRequest>> createPullRequest(
    String owner,
    String repo,
    Map<String, dynamic> body,
  );

  /// Merge a pull request.
  Future<Either<Failure, void>> mergePullRequest(
    String owner,
    String repo,
    int index, {
    MergePullRequestOption? body,
  });
}
