import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../core/utils/repository_helper.dart';
import '../../domain/repositories/misc_repository.dart';
import '../datasources/remote/gitea_api_service.dart';
import '../models/generated/generated_models.dart';

class MiscRepositoryImpl implements MiscRepository {
  final GiteaApiService _apiService;

  MiscRepositoryImpl({required GiteaApiService apiService})
    : _apiService = apiService;

  @override
  Future<Either<Failure, GeneralAPISettings>> getGeneralAPISettings() async {
    return execute(() => _apiService.getGeneralAPISettings());
  }

  @override
  Future<Either<Failure, GeneralAttachmentSettings>>
  getGeneralAttachmentSettings() async {
    return execute(() => _apiService.getGeneralAttachmentSettings());
  }

  @override
  Future<Either<Failure, GeneralRepoSettings>>
  getGeneralRepositorySettings() async {
    return execute(() => _apiService.getGeneralRepositorySettings());
  }

  @override
  Future<Either<Failure, GeneralUISettings>> getGeneralUISettings() async {
    return execute(() => _apiService.getGeneralUISettings());
  }

  @override
  Future<Either<Failure, List<String>>> listGitignoreTemplates() async {
    return execute(() => _apiService.listGitignoresTemplates());
  }

  @override
  Future<Either<Failure, GitignoreTemplateInfo>> getGitignoreTemplateInfo(
    String name,
  ) async {
    return execute(() => _apiService.getGitignoreTemplateInfo(name: name));
  }

  @override
  Future<Either<Failure, String>> renderMarkdown(
    Map<String, dynamic> body,
  ) async {
    return execute(() => _apiService.renderMarkdown(body: body));
  }

  @override
  Future<Either<Failure, String>> renderMarkdownRaw(String body) async {
    return execute(() => _apiService.renderMarkdownRaw(body: {'body': body}));
  }

  @override
  Future<Either<Failure, NodeInfo>> getNodeInfo() async {
    return execute(() => _apiService.getNodeInfo());
  }

  @override
  Future<Either<Failure, ActivityPub>> getActivityPubPerson(int userId) async {
    return execute(() => _apiService.activitypubPerson(user_id: userId));
  }

  @override
  Future<Either<Failure, void>> sendActivityPubInbox(int userId) async {
    return execute(() => _apiService.activitypubPersonInbox(user_id: userId));
  }
}
