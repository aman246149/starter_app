import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:starter_app/core/domain/value_objects/email_address.dart';
import 'package:starter_app/core/domain/value_objects/name.dart';
import 'package:starter_app/core/domain/value_objects/password.dart';
import 'package:starter_app/core/presentation/models/error_model.dart';
import 'package:starter_app/features/auth/domain/entities/user.dart';
import 'package:starter_app/features/auth/presentation/bloc/field_validation_state.dart';

part 'auth_state.freezed.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState.initial({
    required EmailAddress email,
    required bool isSubmitting,
    required FieldValidationState validation,
    ErrorModel? error,
  }) = Initial;

  const factory AuthState.unauthenticated() = Unauthenticated;

  const factory AuthState.registrationRequired({
    required EmailAddress email,
    required Password password,
    required Name name,
    required bool isSubmitting,
    required FieldValidationState validation,
    @Default(false) bool passwordVisible,
    ErrorModel? error,
  }) = RegistrationRequired;

  const factory AuthState.loginRequired({
    required EmailAddress email,
    required Password password,
    required bool isSubmitting,
    required FieldValidationState validation,
    @Default(false) bool passwordVisible,
    ErrorModel? error,
  }) = LoginRequired;

  const factory AuthState.authenticated(User user) = Authenticated;

  /// Creates an empty initial state ready for authentication.
  /// Used for BLoC initialization and reset after logout/email change.
  factory AuthState.empty() => AuthState.initial(
    email: EmailAddress(''),
    isSubmitting: false,
    validation: FieldValidationState.initial(),
  );
}
