import '../errors/exceptions.dart';
import '../errors/failures.dart';
import 'either.dart';

/// Executes a data source call and maps exceptions to [Either] values.
///
/// [call] is the async operation that may throw [ServerException],
/// [AuthenticationException], or [NetworkException].
/// On success, the result is wrapped in [Right].
/// On failure, the exception is mapped to a [Failure] and wrapped in [Left].
Future<Either<Failure, T>> execute<T>(Future<T> Function() call) async {
  try {
    final result = await call();
    return Right(result);
  } on AuthenticationException catch (e) {
    return Left(AuthenticationFailure(e.message));
  } on NetworkException catch (e) {
    return Left(NetworkFailure(e.message));
  } on ServerException catch (e) {
    return Left(ServerFailure(e.message));
  } catch (e) {
    return Left(UnexpectedFailure(e.toString()));
  }
}
