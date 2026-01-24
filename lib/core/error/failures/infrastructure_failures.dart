import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:starter_app/core/error/failures/technical_failure.dart';

part 'infrastructure_failures.freezed.dart';

/// Infrastructure layer failures.
///
/// These represent technical errors from external systems (API, DB, Network).
/// Extends [TechnicalFailure] which provides [isRetryable] and [stackTrace].
///
/// Repositories map Exceptions → InfrastructureFailure when no specific
/// domain mapping is available.
///
/// Example in repository:
/// ```dart
/// try {
///   final product = await _api.getProduct(id);
///   return Right(product);
/// } on ServerException catch (e) {
///   // Map generic server errors
///   return Left(InfrastructureFailure.server(
///     message: e.message,
///     statusCode: e.statusCode,
///   ));
/// } on NetworkException catch (e) {
///   return Left(InfrastructureFailure.network(message: e.message));
/// }
/// ```
///
/// In UI, use FailureMessageService for localized messages:
/// ```dart
/// final messageService = context.read<FailureMessageService>();
/// final message = messageService.getLocalizedMessage(context, failure);
/// ```
@freezed
abstract class InfrastructureFailure extends TechnicalFailure
    with _$InfrastructureFailure {
  const InfrastructureFailure._();

  /// Server error.
  /// Map from ServerException in repository.
  const factory InfrastructureFailure.server({
    required String message,
    int? statusCode,
    StackTrace? stackTrace,
  }) = ServerFailure;

  /// Network error.
  /// Map from NetworkException in repository.
  const factory InfrastructureFailure.network({
    @Default('Network error') String message,
    StackTrace? stackTrace,
  }) = NetworkFailure;

  /// Cache error.
  /// Map from CacheException in repository.
  const factory InfrastructureFailure.cache({
    @Default('Cache error') String message,
    StackTrace? stackTrace,
  }) = CacheFailure;

  /// Parse error.
  /// Map from ParseException in repository.
  const factory InfrastructureFailure.parse({
    @Default('Parse error') String message,
    StackTrace? stackTrace,
  }) = ParseFailure;

  /// Circuit breaker open error.
  /// Map from CircuitBreakerException in repository.
  const factory InfrastructureFailure.circuitBreaker({
    @Default('Service temporarily unavailable') String message,
    StackTrace? stackTrace,
  }) = CircuitBreakerFailure;

  @override
  bool get isRetryable => when(
    server: (_, _, _) => true,
    network: (_, _) => true,
    cache: (_, _) => false,
    parse: (_, _) => false,
    circuitBreaker: (_, _) => true,
  );

  // coverage:ignore-start
  @override
  StackTrace? get stackTrace => when(
    server: (_, _, stackTrace) => stackTrace,
    network: (_, stackTrace) => stackTrace,
    cache: (_, stackTrace) => stackTrace,
    parse: (_, stackTrace) => stackTrace,
    circuitBreaker: (_, stackTrace) => stackTrace,
  );
  // coverage:ignore-end
}
