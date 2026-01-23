import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:starter_app/core/types/types.dart';

import 'package:starter_app/features/auth/domain/entities/auth_credentials.dart';

part 'login_request_model.freezed.dart';
part 'login_request_model.g.dart';

/// Data transfer object for login requests.
///
/// Converts domain credentials to JSON for API requests.
///
/// ## Usage
/// ```dart
/// final model = LoginRequestModel.fromDomain(credentials);
/// final json = model.toJson();
/// await dio.post('/auth/login', data: json);
/// ```
@freezed
abstract class LoginRequestModel with _$LoginRequestModel {
  const factory LoginRequestModel({
    required String email,
    required String password,
  }) = _LoginRequestModel;
  const LoginRequestModel._();

  /// Creates model from JSON (rarely used).
  factory LoginRequestModel.fromJson(Json json) =>
      _$LoginRequestModelFromJson(json);

  /// Creates model from domain credentials.
  factory LoginRequestModel.fromDomain(AuthCredentials credentials) {
    return LoginRequestModel(
      email: credentials.emailValue,
      password: credentials.passwordValue,
    );
  }
}
