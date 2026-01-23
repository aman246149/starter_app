import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:starter_app/core/types/types.dart';

import 'package:starter_app/features/auth/domain/value_objects/auth_token.dart';
import 'package:starter_app/features/auth/domain/value_objects/refresh_token.dart';

part 'auth_tokens_model.freezed.dart';
part 'auth_tokens_model.g.dart';

/// Data transfer object for authentication tokens.
///
/// Handles JSON serialization for token pairs returned by auth endpoints.
/// Used in login, register, and refresh token responses.
///
/// ## Usage
/// ```dart
/// // From API response
/// final model = AuthTokensModel.fromJson(json);
/// final accessToken = model.toAccessToken();
/// final refreshToken = model.toRefreshToken();
/// ```
@freezed
abstract class AuthTokensModel with _$AuthTokensModel {
  const factory AuthTokensModel({
    required String accessToken,
    required String refreshToken,
  }) = _AuthTokensModel;
  const AuthTokensModel._();

  /// Creates model from JSON.
  factory AuthTokensModel.fromJson(Json json) =>
      _$AuthTokensModelFromJson(json);

  /// Converts access token to domain value object.
  ///
  /// Uses `fromTrustedSource` since token comes from authenticated API.
  AuthToken toAccessToken() {
    return AuthToken.fromTrustedSource(accessToken);
  }

  /// Converts refresh token to domain value object.
  ///
  /// Uses `fromTrustedSource` since token comes from authenticated API.
  RefreshToken toRefreshToken() {
    return RefreshToken.fromTrustedSource(refreshToken);
  }
}
