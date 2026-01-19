import 'package:flutter/foundation.dart';
import 'package:starter_app/core/error/exception_handler.dart';
import 'package:starter_app/core/error/exceptions/server_exception.dart';
import 'package:starter_app/core/error/failures/failure.dart';
import 'package:starter_app/core/error/failures/infrastructure_failures.dart';
import 'package:starter_app/core/error/i_exception_mapper.dart';
import 'package:starter_app/core/types/types.dart';

/// Base class for all repository implementations.
///
/// Provides common exception handling functionality through [ExceptionHandler]
/// and optional feature-specific failure mapping through [IExceptionMapper].
///
/// All repository implementations should extend this class to eliminate
/// repetitive exception handling code.
///
/// Usage:
/// ```dart
/// @LazySingleton(as: IProductRepository)
/// class ProductRepositoryImpl extends BaseRepository
///     implements IProductRepository {
///   ProductRepositoryImpl(
///     this._remoteDataSource,
///     super.exceptionHandler,
///     super.failureMapper, // Optional: feature-specific mapper
///   );
///
///   final IProductRemoteDataSource _remoteDataSource;
///
///   @override
///   Future<Either<Failure, Product>> getProduct(String id) =>
///     execute(() async {
///       final model = await _remoteDataSource.getProduct(id);
///       return model.toDomain();
///     });
/// }
/// ```
abstract class BaseRepository {
  /// Creates a [BaseRepository] with the given [exceptionHandler] and
  /// optional [failureMapper].
  ///
  /// Parameters:
  /// - [exceptionHandler]: Handles exception-to-failure conversion
  /// - [failureMapper]: Optional feature-specific mapper for [ServerException]
  const BaseRepository(this.exceptionHandler, [this.failureMapper]);

  /// The exception handler used to convert exceptions to failures.
  @protected
  final ExceptionHandler exceptionHandler;

  /// Optional feature-specific failure mapper.
  ///
  /// If provided, this mapper will be used to convert [ServerException]
  /// to domain-specific failures. If null, defaults to infrastructure failures.
  @protected
  final IExceptionMapper? failureMapper;

  /// Executes a repository operation with automatic exception handling.
  ///
  /// This method wraps the given [operation] with exception handling logic,
  /// converting any thrown exceptions into appropriate [Failure] objects.
  ///
  /// If a [failureMapper] was provided during construction, it will be used
  /// to map [ServerException] to domain-specific failures. Otherwise, defaults
  /// to [InfrastructureFailure.server].
  ///
  /// Parameters:
  /// - [operation]: The async operation to execute (a data source call)
  ///
  /// Returns:
  /// - [Right(T)] if operation succeeds
  /// - [Left(Failure)] if operation fails
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Future<Either<Failure, User>> login(Credentials creds) =>
  ///   execute(() async {
  ///     final result = await _remoteDataSource.login(creds);
  ///     await _tokenStorage.save(result.tokens);
  ///     return result.user.toDomain();
  ///   });
  /// ```
  @protected
  FutureResult<T> execute<T>(
    Future<T> Function() operation,
  ) => exceptionHandler.handle(
    operation: operation,
    serverExceptionMapper: failureMapper?.mapToFailure,
  );
}
