import 'package:starter_app/core/domain/base/domain_event.dart';
import 'package:starter_app/features/profile/domain/entities/user_profile.dart';

/// Base class for all profile-related events.
abstract class ProfileDomainEvent extends DomainEvent {
  const ProfileDomainEvent();
}

class UserProfileCreated extends ProfileDomainEvent {
  const UserProfileCreated(this.profile);
  final UserProfile profile;
}
