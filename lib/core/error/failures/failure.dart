/// Base interface for all failures in the application.
///
/// Failures represent error states that can occur during operations.
/// They are returned via `Either<Failure, T>` instead of throwing exceptions.
///
/// This is an interface - all failures must extend this base class.
/// Concrete failure implementations are in:
/// - `infrastructure_failures.dart` - Server, network, cache errors
/// - `domain_failures.dart` - Validation, business rule violations
/// - Feature-specific failures in their respective domains
///
/// Example:
/// ```dart
/// // In Repository
/// Future<Either<Failure, List<Product>>> getAllProducts() async {
///   try {
///     final models = await _remoteDataSource.getAllProducts();
///     return Right(models.map((m) => m.toDomain()).toList());
///   } on ServerException catch (e) {
///     return Left(ServerFailure(
///       message: e.message ?? 'Server error',
///       statusCode: e.statusCode,
///     ));
///   } on SocketException catch (_) {
///     return Left(const NetworkFailure());
///   }
/// }
/// ```
abstract class Failure {
  /// Creates a [Failure].
  const Failure();

  /// Returns true if this failure type can be retried.
  bool get isRetryable;

  /// Returns the user-friendly error message.
  String get message;

  /// Original stack trace for debugging purposes.
  StackTrace? get stackTrace => null;
}
