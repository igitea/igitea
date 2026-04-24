import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';

/// Repository interface for miscellaneous operations (settings, gitignore, markdown, nodeinfo, activitypub).
abstract class MiscRepository {
  /// Get general API settings.
  Future<Either<Failure, GeneralAPISettings>> getGeneralAPISettings();

  /// Get general attachment settings.
  Future<Either<Failure, GeneralAttachmentSettings>>
  getGeneralAttachmentSettings();

  /// Get general repository settings.
  Future<Either<Failure, GeneralRepoSettings>> getGeneralRepositorySettings();

  /// Get general UI settings.
  Future<Either<Failure, GeneralUISettings>> getGeneralUISettings();

  /// List available gitignore templates.
  Future<Either<Failure, List<String>>> listGitignoreTemplates();

  /// Get information about a specific gitignore template.
  Future<Either<Failure, GitignoreTemplateInfo>> getGitignoreTemplateInfo(
    String name,
  );

  /// Render markdown to HTML.
  Future<Either<Failure, String>> renderMarkdown(Map<String, dynamic> body);

  /// Render raw markdown to HTML.
  Future<Either<Failure, String>> renderMarkdownRaw(String body);

  /// Get node info.
  Future<Either<Failure, NodeInfo>> getNodeInfo();

  /// Get ActivityPub information for a user.
  Future<Either<Failure, ActivityPub>> getActivityPubPerson(int userId);

  /// Send to a user's ActivityPub inbox.
  Future<Either<Failure, void>> sendActivityPubInbox(int userId);
}
