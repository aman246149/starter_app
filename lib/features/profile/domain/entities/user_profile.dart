import 'package:starter_app/core/domain/base/aggregate_root.dart';
import 'package:starter_app/core/domain/value_objects/name.dart';
import 'package:starter_app/features/auth/domain/entities/user.dart' show User;
import 'package:starter_app/features/auth/domain/entities/user_id.dart';
import 'package:starter_app/features/profile/domain/entities/profile_id.dart';

/// User Profile Aggregate Root.
///
/// Represents the public/display information of a user.
/// Separated from the [User] auth aggregate to allow for distinct lifecycles
/// and modularity.
class UserProfile extends AggregateRoot {
  UserProfile({
    required this.id,
    required this.userId,
    required this.displayName,
  });

  /// Unique ID of the profile (often same as userId, but conceptually distinct)
  @override
  final ProfileId id;

  /// Reference to the Auth User ID
  final UserId userId;

  /// Display name of the user
  final Name displayName;

  UserProfile copyWith({
    ProfileId? id,
    UserId? userId,
    Name? displayName,
  }) {
    return UserProfile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
    );
  }
}
