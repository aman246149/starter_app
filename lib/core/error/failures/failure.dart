/// Base interface for all failures in the application.
///
/// Failures represent error states that can occur during operations.
/// They are returned via `Either<Failure, T>` instead of throwing exceptions.
///
/// This is the root of the failure hierarchy:
/// ```text
/// Failure (abstract) - has message
/// ├── TechnicalFailure (abstract) - adds isRetryable, stackTrace
/// │   ├── InfrastructureFailure
/// │   └── AuthFailure
/// └── ValueFailure<T> (abstract) - domain validation
///     ├── PasswordFailure
///     ├── EmailFailure
///     └── ...
/// ```
///
/// Example:
/// ```dart
/// // In Repository
/// Future<Either<Failure, List<Product>>> getAllProducts() async {
///   try {
///     final models = await _remoteDataSource.getAllProducts();
///     return Right(models.map((m) => m.toDomain()).toList());
///   } on ServerException catch (e) {
///     return Left(InfrastructureFailure.server(
///       message: e.message ?? 'Server error',
///       statusCode: e.statusCode,
///     ));
///   } on SocketException catch (_) {
///     return Left(const InfrastructureFailure.network());
///   }
/// }
/// ```
abstract class Failure {
  /// Creates a [Failure].
  const Failure();

  /// User-friendly error message describing the failure.
  String get message;
}
