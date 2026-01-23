import 'package:freezed_annotation/freezed_annotation.dart';

part 'field_validation_state.freezed.dart';

/// Tracks which form fields have been interacted with (touched/blurred).
///
/// This allows us to show validation errors only for fields the user
/// has interacted with, following best UX practices:
/// - Don't show errors on pristine fields
/// - Show errors only after user leaves the field or submits form
/// - Clear errors when user starts typing (field becomes untouched again)
///
/// The actual validation logic lives in ValueObjects (EmailAddress, Password).
/// This class only tracks UI interaction state.
@freezed
abstract class FieldValidationState with _$FieldValidationState {
  const factory FieldValidationState({
    @Default(false) bool emailTouched,
    @Default(false) bool passwordTouched,
    @Default(false) bool nameTouched,
  }) = _FieldValidationState;

  /// Initial state - no fields touched
  factory FieldValidationState.initial() => const FieldValidationState();

  /// All fields touched - used on form submission
  factory FieldValidationState.allTouched() => const FieldValidationState(
    emailTouched: true,
    passwordTouched: true,
    nameTouched: true,
  );
}
