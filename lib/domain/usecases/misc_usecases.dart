import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../repositories/misc_repository.dart';

class GetGitignoreTemplatesUseCase {
  final MiscRepository _repository;

  GetGitignoreTemplatesUseCase({required MiscRepository repository})
    : _repository = repository;

  Future<Either<Failure, List<String>>> call() async {
    return _repository.listGitignoreTemplates();
  }
}

class RenderMarkdownUseCase {
  final MiscRepository _repository;

  RenderMarkdownUseCase({required MiscRepository repository})
    : _repository = repository;

  Future<Either<Failure, String>> call(Map<String, dynamic> body) async {
    return _repository.renderMarkdown(body);
  }
}

class GetNodeInfoUseCase {
  final MiscRepository _repository;

  GetNodeInfoUseCase({required MiscRepository repository})
    : _repository = repository;

  Future<Either<Failure, NodeInfo>> call() async {
    return _repository.getNodeInfo();
  }
}

class GetGeneralAPISettingsUseCase {
  final MiscRepository _repository;

  GetGeneralAPISettingsUseCase({required MiscRepository repository})
    : _repository = repository;

  Future<Either<Failure, GeneralAPISettings>> call() async {
    return _repository.getGeneralAPISettings();
  }
}

class GetGeneralUISettingsUseCase {
  final MiscRepository _repository;

  GetGeneralUISettingsUseCase({required MiscRepository repository})
    : _repository = repository;

  Future<Either<Failure, GeneralUISettings>> call() async {
    return _repository.getGeneralUISettings();
  }
}

class GetGeneralAttachmentSettingsUseCase {
  final MiscRepository _repository;

  GetGeneralAttachmentSettingsUseCase({required MiscRepository repository})
    : _repository = repository;

  Future<Either<Failure, GeneralAttachmentSettings>> call() async {
    return _repository.getGeneralAttachmentSettings();
  }
}

class GetGeneralRepoSettingsUseCase {
  final MiscRepository _repository;

  GetGeneralRepoSettingsUseCase({required MiscRepository repository})
    : _repository = repository;

  Future<Either<Failure, GeneralRepoSettings>> call() async {
    return _repository.getGeneralRepositorySettings();
  }
}
