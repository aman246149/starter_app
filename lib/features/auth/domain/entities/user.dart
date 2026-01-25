import 'package:starter_app/core/domain/base/aggregate_root.dart';
import 'package:starter_app/core/domain/value_objects/email_address.dart';
import 'package:starter_app/features/auth/domain/entities/user_id.dart';
import 'package:starter_app/features/profile/domain/entities/user_profile.dart';

/// User entity representing an authenticated user.
///
/// This is the **Auth Aggregate**.
/// It strictly handles authentication identity.
/// Profile information (name, avatar) has been moved to [UserProfile].
class User extends AggregateRoot {
  User({
    required this.id,
    required this.email,
  });

  @override
  final UserId id;
  final EmailAddress email;

  /// Creates a copy of this User with the given fields replaced.
  User copyWith({
    UserId? id,
    EmailAddress? email,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email)';
  }
}
