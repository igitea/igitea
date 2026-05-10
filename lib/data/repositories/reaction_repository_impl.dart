import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../core/utils/repository_helper.dart';
import '../../domain/repositories/reaction_repository.dart';
import '../datasources/remote/gitea_api_service.dart';
import '../models/generated/generated_models.dart';

class ReactionRepositoryImpl implements ReactionRepository {
  final GiteaApiService _apiService;

  ReactionRepositoryImpl({required GiteaApiService apiService})
    : _apiService = apiService;

  @override
  Future<Either<Failure, List<Reaction>>> getIssueReactions(
    String owner, String repo, int index) async {
    return execute(() async {
      final data = await _apiService.issueListReactions(
        owner: owner, repo: repo, index: index);
      return data.map((e) => Reaction.fromJson(e as Map<String, dynamic>)).toList();
    });
  }

  @override
  Future<Either<Failure, Reaction>> addIssueReaction(
    String owner, String repo, int index, String content) async {
    return execute(() async {
      final data = await _apiService.issueAddReaction(
        owner: owner, repo: repo, index: index, content: content);
      return Reaction.fromJson(data);
    });
  }

  @override
  Future<Either<Failure, void>> deleteIssueReaction(
    String owner, String repo, int index, String content) async {
    return execute(() => _apiService.issueDeleteReaction(
      owner: owner, repo: repo, index: index, content: content));
  }

  @override
  Future<Either<Failure, List<Reaction>>> getCommentReactions(
    String owner, String repo, int commentId) async {
    return execute(() async {
      final data = await _apiService.issueListCommentReactions(
        owner: owner, repo: repo, commentId: commentId);
      return data.map((e) => Reaction.fromJson(e as Map<String, dynamic>)).toList();
    });
  }

  @override
  Future<Either<Failure, Reaction>> addCommentReaction(
    String owner, String repo, int commentId, String content) async {
    return execute(() async {
      final data = await _apiService.issueAddCommentReaction(
        owner: owner, repo: repo, commentId: commentId, content: content);
      return Reaction.fromJson(data);
    });
  }

  @override
  Future<Either<Failure, void>> deleteCommentReaction(
    String owner, String repo, int commentId, String content) async {
    return execute(() => _apiService.issueDeleteCommentReaction(
      owner: owner, repo: repo, commentId: commentId, content: content));
  }
}
