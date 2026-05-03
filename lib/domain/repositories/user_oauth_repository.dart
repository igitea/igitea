import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';

abstract class UserOAuthRepository {
  Future<Either<Failure, List<OAuth2Application>>> listOAuth2Apps({int? page, int? limit});
  Future<Either<Failure, OAuth2Application>> createOAuth2App(Map<String, dynamic> body);
  Future<Either<Failure, OAuth2Application>> getOAuth2App(int id);
  Future<Either<Failure, void>> deleteOAuth2App(int id);
}
