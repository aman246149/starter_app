import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:starter_app/core/error/failures/technical_failure.dart';

part 'profile_failure.freezed.dart';

/// Profile domain failures.
///
/// Represents business logic errors specific to user profile operations.
/// Extends [TechnicalFailure] which provides [isRetryable] and [stackTrace].
@freezed
abstract class ProfileFailure extends TechnicalFailure with _$ProfileFailure {
  const ProfileFailure._();

  const factory ProfileFailure.unexpected({
    required String message,
    StackTrace? stackTrace,
  }) = _Unexpected;

  const factory ProfileFailure.serverError({
    required String message,
    StackTrace? stackTrace,
  }) = _ServerError;

  const factory ProfileFailure.notFound({
    required String message,
    StackTrace? stackTrace,
  }) = _NotFound;

  @override
  bool get isRetryable => when(
    unexpected: (_, _) => false,
    serverError: (_, _) => true,
    notFound: (_, _) => false,
  );

  // coverage:ignore-start
  @override
  StackTrace? get stackTrace => when(
    unexpected: (_, stackTrace) => stackTrace,
    serverError: (_, stackTrace) => stackTrace,
    notFound: (_, stackTrace) => stackTrace,
  );
  // coverage:ignore-end
}
