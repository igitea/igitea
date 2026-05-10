import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../repositories/reaction_repository.dart';

class GetIssueReactionsUseCase {
  final ReactionRepository _repository;
  GetIssueReactionsUseCase({required ReactionRepository repository})
    : _repository = repository;
  Future<Either<Failure, List<Reaction>>> call(
    String owner, String repo, int index) {
    return _repository.getIssueReactions(owner, repo, index);
  }
}

class AddIssueReactionUseCase {
  final ReactionRepository _repository;
  AddIssueReactionUseCase({required ReactionRepository repository})
    : _repository = repository;
  Future<Either<Failure, Reaction>> call(
    String owner, String repo, int index, String content) {
    return _repository.addIssueReaction(owner, repo, index, content);
  }
}

class DeleteIssueReactionUseCase {
  final ReactionRepository _repository;
  DeleteIssueReactionUseCase({required ReactionRepository repository})
    : _repository = repository;
  Future<Either<Failure, void>> call(
    String owner, String repo, int index, String content) {
    return _repository.deleteIssueReaction(owner, repo, index, content);
  }
}

class GetCommentReactionsUseCase {
  final ReactionRepository _repository;
  GetCommentReactionsUseCase({required ReactionRepository repository})
    : _repository = repository;
  Future<Either<Failure, List<Reaction>>> call(
    String owner, String repo, int commentId) {
    return _repository.getCommentReactions(owner, repo, commentId);
  }
}

class AddCommentReactionUseCase {
  final ReactionRepository _repository;
  AddCommentReactionUseCase({required ReactionRepository repository})
    : _repository = repository;
  Future<Either<Failure, Reaction>> call(
    String owner, String repo, int commentId, String content) {
    return _repository.addCommentReaction(owner, repo, commentId, content);
  }
}

class DeleteCommentReactionUseCase {
  final ReactionRepository _repository;
  DeleteCommentReactionUseCase({required ReactionRepository repository})
    : _repository = repository;
  Future<Either<Failure, void>> call(
    String owner, String repo, int commentId, String content) {
    return _repository.deleteCommentReaction(owner, repo, commentId, content);
  }
}
