import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:starter_app/core/error/failures/failure.dart';
import 'package:starter_app/core/presentation/services/failure_message_service.dart';

part 'error_model.freezed.dart';

/// Presentation model for displaying errors in the UI.
///
/// This model wraps a domain Failure and provides UI-friendly access
/// to error information. It acts as a boundary between domain and UI layers.
///
/// The BLoC creates this without needing BuildContext:
/// ```dart
/// // In BLoC (no BuildContext needed!)
/// result.fold(
///   (failure) {
///     final error = ErrorModel.fromFailure(failure);
///     emit(state.copyWith(error: error));
///   },
/// )
/// ```
///
/// The UI gets the localized message:
/// ```dart
/// // In UI (has BuildContext)
/// if (state.error != null) {
///   final service = context.read<FailureMessageService>();
///   final message = state.error!.getMessage(context, service);
///   showSnackBar(message);
/// }
/// ```
@freezed
abstract class ErrorModel with _$ErrorModel {
  /// Creates an error model from a domain failure.
  const factory ErrorModel({
    /// The underlying domain failure.
    required Failure failure,

    /// Whether this error can be retried by the user.
    required bool isRetryable,
  }) = _ErrorModel;

  /// Factory to create from a Failure (used by BLoC).
  factory ErrorModel.fromFailure(Failure failure) {
    return ErrorModel(
      failure: failure,
      isRetryable: failure.isRetryable,
    );
  }
}

/// Extension methods for ErrorModel.
extension ErrorModelX on ErrorModel {
  /// Gets the localized error message (called by UI with BuildContext).
  ///
  /// This method delegates to the service to translate the domain failure
  /// to a user-friendly localized message.
  String getMessage(
    BuildContext context,
    FailureMessageService service,
  ) {
    return service.getLocalizedMessage(context, failure);
  }
}
