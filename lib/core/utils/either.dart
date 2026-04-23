/// A simple Either type representing one of two values: [Left] or [Right].
///
/// Used throughout the domain layer to represent success ([Right])
/// or failure ([Left]) without throwing exceptions.
sealed class Either<L, R> {
  const Either();

  /// Returns true if this is a [Left] value.
  bool get isLeft => this is Left<L, R>;

  /// Returns true if this is a [Right] value.
  bool get isRight => this is Right<L, R>;

  /// Extracts the [Left] value or returns [orElse].
  L getLeftOrElse(L orElse) {
    if (this is Left<L, R>) return (this as Left<L, R>).value;
    return orElse;
  }

  /// Extracts the [Right] value or returns [orElse].
  R getRightOrElse(R orElse) {
    if (this is Right<L, R>) return (this as Right<L, R>).value;
    return orElse;
  }
}

/// The left side of [Either], conventionally used for failures.
final class Left<L, R> extends Either<L, R> {
  final L value;

  const Left(this.value);
}

/// The right side of [Either], conventionally used for successes.
final class Right<L, R> extends Either<L, R> {
  final R value;

  const Right(this.value);
}
