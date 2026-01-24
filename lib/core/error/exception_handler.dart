import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:starter_app/core/error/exceptions/exceptions.dart';
import 'package:starter_app/core/error/failures/failures.dart';
import 'package:starter_app/core/types/types.dart';

/// Generic exception handler for repositories.
///
/// Provides reusable exception-to-failure mapping logic that follows
/// Clean Architecture principles by converting infrastructure exceptions
/// to appropriate failure types.
///
/// This is an injectable service that should be injected into repositories
/// for proper dependency injection and testability.
///
/// Usage in repositories:
/// ```dart
/// @LazySingleton(as: IAuthRepository)
/// class AuthRepositoryImpl implements IAuthRepository {
///   AuthRepositoryImpl(
///     this._remoteDataSource,
///     this._tokenStorage,
///     this._exceptionHandler,
///   );
///
///   final IAuthRemoteDataSource _remoteDataSource;
///   final ITokenStorage _tokenStorage;
///   final ExceptionHandler _exceptionHandler;
///
///   @override
///   Future<Either<Failure, User>> login(AuthCredentials credentials) {
///     return _exceptionHandler.handle(
///       operation: () async {
///         final result = await _remoteDataSource.login(...);
///         return result.user.toDomain();
///       },
///       serverExceptionMapper: (e) => _mapServerException(e),
///     );
///   }
/// }
/// ```
@lazySingleton
class ExceptionHandler {
  const ExceptionHandler();

  /// Handles exceptions from repository operations.
  ///
  /// Maps common infrastructure exceptions to failures:
  /// - [NetworkException] → [InfrastructureFailure.network]
  /// - [CacheException] → [InfrastructureFailure.cache]
  /// - [CircuitBreakerException] → [InfrastructureFailure.circuitBreaker]
  /// - [ServerException] → Uses custom [serverExceptionMapper] if provided,
  ///   otherwise maps to [InfrastructureFailure.server]
  /// - [FormatException] → [InfrastructureFailure.parse]
  /// - Other exceptions → [InfrastructureFailure.parse]
  ///
  /// Parameters:
  /// - [operation]: The async operation to execute
  /// - [serverExceptionMapper]: Optional custom mapper for [ServerException]
  ///   (used for domain-specific status code handling)
  FutureResult<T> handle<T>({
    required Future<T> Function() operation,
    Failure Function(ServerException)? serverExceptionMapper,
  }) async {
    try {
      final result = await operation();
      return Right(result);
    } on ServerException catch (e, stackTrace) {
      // Use custom mapper if provided, otherwise default mapping
      if (serverExceptionMapper != null) {
        return Left(serverExceptionMapper(e));
      }
      return Left(
        InfrastructureFailure.server(
          message: e.message,
          statusCode: e.statusCode,
          stackTrace: stackTrace,
        ),
      );
    } on NetworkException catch (e, stackTrace) {
      return Left(
        InfrastructureFailure.network(
          message: e.message,
          stackTrace: stackTrace,
        ),
      );
    } on CacheException catch (e, stackTrace) {
      return Left(
        InfrastructureFailure.cache(
          message: e.message,
          stackTrace: stackTrace,
        ),
      );
    } on CircuitBreakerException catch (e, stackTrace) {
      return Left(
        InfrastructureFailure.circuitBreaker(
          message: e.message,
          stackTrace: stackTrace,
        ),
      );
    } on FormatException catch (e, stackTrace) {
      return Left(
        InfrastructureFailure.parse(
          message: e.message,
          stackTrace: stackTrace,
        ),
      );
    } on Exception catch (e, stackTrace) {
      return Left(
        InfrastructureFailure.parse(
          message: 'An unexpected error occurred: $e',
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
