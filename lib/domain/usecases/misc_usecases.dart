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
