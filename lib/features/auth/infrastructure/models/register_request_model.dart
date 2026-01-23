import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:starter_app/core/domain/value_objects/value_objects.dart';
import 'package:starter_app/core/types/types.dart';

import 'package:starter_app/features/auth/domain/entities/auth_credentials.dart';

part 'register_request_model.freezed.dart';
part 'register_request_model.g.dart';

/// Data transfer object for registration requests.
///
/// Converts domain credentials and name to JSON for API requests.
@freezed
abstract class RegisterRequestModel with _$RegisterRequestModel {
  const factory RegisterRequestModel({
    required String email,
    required String password,
    required String name,
  }) = _RegisterRequestModel;
  const RegisterRequestModel._();

  /// Creates model from JSON (rarely used).
  factory RegisterRequestModel.fromJson(Json json) =>
      _$RegisterRequestModelFromJson(json);

  /// Creates model from domain credentials.
  factory RegisterRequestModel.fromDomain(
    AuthCredentials credentials,
    Name name,
  ) {
    return RegisterRequestModel(
      email: credentials.emailValue,
      password: credentials.passwordValue,
      name: name.getOrCrash(),
    );
  }
}
