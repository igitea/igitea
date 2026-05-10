import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';

abstract class ReactionRepository {
  Future<Either<Failure, List<Reaction>>> getIssueReactions(
    String owner, String repo, int index);
  Future<Either<Failure, Reaction>> addIssueReaction(
    String owner, String repo, int index, String content);
  Future<Either<Failure, void>> deleteIssueReaction(
    String owner, String repo, int index, String content);
  Future<Either<Failure, List<Reaction>>> getCommentReactions(
    String owner, String repo, int commentId);
  Future<Either<Failure, Reaction>> addCommentReaction(
    String owner, String repo, int commentId, String content);
  Future<Either<Failure, void>> deleteCommentReaction(
    String owner, String repo, int commentId, String content);
}
