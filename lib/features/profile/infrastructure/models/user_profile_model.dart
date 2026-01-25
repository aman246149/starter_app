import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:starter_app/core/domain/value_objects/name.dart';
import 'package:starter_app/core/types/types.dart';
import 'package:starter_app/features/auth/domain/entities/user_id.dart';
import 'package:starter_app/features/profile/domain/entities/profile_id.dart';
import 'package:starter_app/features/profile/domain/entities/user_profile.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

/// Data transfer object for [UserProfile].
@freezed
abstract class UserProfileModel with _$UserProfileModel {
  const factory UserProfileModel({
    required String id,
    required String userId,
    required String displayName,
    String? avatarUrl,
  }) = _UserProfileModel;
  const UserProfileModel._();

  factory UserProfileModel.fromJson(Json json) =>
      _$UserProfileModelFromJson(json);

  factory UserProfileModel.fromDomain(UserProfile profile) {
    return UserProfileModel(
      id: profile.id.value.value,
      userId: profile.userId.value.value,
      displayName: profile.displayName.getOrCrash(),
    );
  }

  UserProfile toDomain() {
    return UserProfile(
      id: ProfileId.fromString(id),
      userId: UserId.fromString(userId),
      displayName: Name.fromTrustedSource(displayName),
    );
  }
}
