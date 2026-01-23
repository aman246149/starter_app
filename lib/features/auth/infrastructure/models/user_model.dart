import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:starter_app/core/domain/value_objects/email_address.dart';
import 'package:starter_app/core/types/types.dart';
import 'package:starter_app/features/auth/domain/entities/user.dart';
import 'package:starter_app/features/auth/domain/entities/user_id.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// Data transfer object for [User] entity.
///
/// Handles JSON serialization/deserialization for API communication.
/// Maps between JSON (infrastructure layer) and domain entities.
///
/// ## Usage
/// ```dart
/// // From API response
/// final model = UserModel.fromJson(json);
/// final user = model.toDomain();
///
/// // To API request (rarely needed for User)
/// final json = UserModel.fromDomain(user).toJson();
/// ```
@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
  }) = _UserModel;
  const UserModel._();

  /// Creates model from JSON.
  factory UserModel.fromJson(Json json) => _$UserModelFromJson(json);

  /// Creates model from domain entity.
  factory UserModel.fromDomain(User user) {
    return UserModel(
      id: user.id.value.value,
      email: user.email.getOrCrash(),
    );
  }

  /// Converts model to domain entity.
  ///
  /// Uses `fromString`/`fromTrustedSource` constructors since data comes
  /// from authenticated backend API (already validated server-side).
  User toDomain() {
    return User(
      id: UserId.fromString(id),
      email: EmailAddress.fromTrustedSource(email)
    );
  }
}
