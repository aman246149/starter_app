import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:starter_app/core/types/types.dart';

import 'package:starter_app/features/auth/infrastructure/models/auth_tokens_model.dart';
import 'package:starter_app/features/auth/infrastructure/models/user_model.dart';

part 'auth_response_model.freezed.dart';
part 'auth_response_model.g.dart';

/// Data transfer object for authentication responses.
///
/// Combines user data with authentication tokens.
/// Returned by login and register endpoints.
///
/// ## Usage
/// ```dart
/// // From API response
/// final model = AuthResponseModel.fromJson(json);
/// final user = model.user.toDomain();
/// final accessToken = model.tokens.toAccessToken();
/// final refreshToken = model.tokens.toRefreshToken();
/// ```
@freezed
abstract class AuthResponseModel with _$AuthResponseModel {
  const factory AuthResponseModel({
    required UserModel user,
    required AuthTokensModel tokens,
  }) = _AuthResponseModel;
  const AuthResponseModel._();

  /// Creates model from JSON.
  factory AuthResponseModel.fromJson(Json json) =>
      _$AuthResponseModelFromJson(json);
}
