import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:starter_app/core/error/failures/infrastructure_failures.dart';
import 'package:starter_app/core/error/failures/technical_failure.dart';

part 'auth_failure.freezed.dart';

/// Authentication domain failures.
///
/// Represents business logic errors specific to authentication.
/// Extends [TechnicalFailure] which provides [isRetryable] and [stackTrace].
///
/// Infrastructure failures (network, server, etc.) should use
/// [InfrastructureFailure] instead.
///
/// Example:
/// ```dart
/// // In Repository
/// if (e.statusCode == 401) {
///   return Left(AuthFailure.unauthorized(message: 'Invalid credentials'));
/// }
/// if (e.statusCode == 403) {
///   return Left(AuthFailure.forbidden(message: 'Account suspended'));
/// }
/// if (e.statusCode == 404) {
///   return Left(AuthFailure.notFound(message: 'User not found'));
/// }
/// ```
@freezed
abstract class AuthFailure extends TechnicalFailure with _$AuthFailure {
  const AuthFailure._();

  /// User or resource not found (HTTP 404).
  const factory AuthFailure.notFound({
    required String message,
    StackTrace? stackTrace,
  }) = _NotFoundFailure;

  /// Invalid credentials or expired session (HTTP 401).
  const factory AuthFailure.unauthorized({
    required String message,
    StackTrace? stackTrace,
  }) = _UnauthorizedFailure;

  /// Access denied or account suspended (HTTP 403).
  const factory AuthFailure.forbidden({
    required String message,
    StackTrace? stackTrace,
  }) = _ForbiddenFailure;

  /// Email address is already registered (HTTP 409).
  const factory AuthFailure.emailAlreadyInUse({
    @Default('Email already in use') String message,
    StackTrace? stackTrace,
  }) = _EmailAlreadyInUseFailure;

  /// Invalid input data (HTTP 400).
  const factory AuthFailure.invalidInput({
    required String message,
    StackTrace? stackTrace,
  }) = _InvalidInputFailure;

  @override
  bool get isRetryable => when(
    notFound: (_, _) => false,
    unauthorized: (_, _) => false,
    forbidden: (_, _) => false,
    emailAlreadyInUse: (_, _) => false,
    invalidInput: (_, _) => false,
  );

  // coverage:ignore-start

  @override
  StackTrace? get stackTrace => when(
    notFound: (_, stackTrace) => stackTrace,
    unauthorized: (_, stackTrace) => stackTrace,
    forbidden: (_, stackTrace) => stackTrace,
    emailAlreadyInUse: (_, stackTrace) => stackTrace,
    invalidInput: (_, stackTrace) => stackTrace,
  );
  // coverage:ignore-end
}
