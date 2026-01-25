import 'package:starter_app/core/types/types.dart';
import 'package:starter_app/features/profile/domain/entities/user_profile.dart';

/// Repository for managing User Profiles.
abstract interface class IUserProfileRepository {
  /// Creates a new user profile.
  FutureResult<UserProfile> create(UserProfile profile);

  /// Gets the current user's profile.
  FutureResult<UserProfile> getCurrentProfile();
}
