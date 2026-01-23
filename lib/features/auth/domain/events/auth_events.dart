import 'package:starter_app/core/domain/base/domain_event.dart';
import 'package:starter_app/core/domain/base/event_dispatcher.dart';
import 'package:starter_app/features/auth/domain/entities/user.dart';
import 'package:starter_app/features/auth/domain/entities/user_id.dart';

/// Base class for all authentication-related domain events.
///
/// Uses Dart 3's `sealed` class feature to enable exhaustive pattern matching.
/// When handling auth events with a switch expression, the compiler ensures
/// all event types are handled:
///
/// ```dart
/// switch (event) {
///   case UserLoggedIn(): // Active login by user
///   case UserRegistered(): // New account created
///   case UserSessionRestored(): // Session restored from tokens on app restart
///   case UserLoggedOut(): // User actively logged out
///   case UserEmailVerified(): // Email verification completed
///   case UserEmailChanged(): // User changed their email
/// }
/// ```
///
/// ## Events
///
/// - [UserLoggedIn] - User actively logged in with credentials
/// - [UserRegistered] - New user account was created
/// - [UserSessionRestored] - Session restored from stored tokens (app restart)
/// - [UserLoggedOut] - User logged out (active or forced)
/// - [UserEmailVerified] - User's email was verified
/// - [UserEmailChanged] - User changed their email address
///
/// ## Usage with IEventDispatcher
///
/// Events are dispatched through [IEventDispatcher] and listened to by
/// features that need to react to auth state changes:
///
/// ```dart
/// // Dispatch
/// _eventDispatcher.dispatch(UserLoggedIn(user));
///
/// // Listen
/// _eventDispatcher.events.listen((event) {
///   if (event is! AuthDomainEvent) return;
///   switch (event) {
///     case UserLoggedIn():
///     case UserSessionRestored():
///       // Reload user data
///       break;
///     // ... handle other cases
///   }
/// });
/// ```
sealed class AuthDomainEvent extends DomainEvent {
  const AuthDomainEvent();
}

/// Event fired when a user successfully logs in.
class UserLoggedIn extends AuthDomainEvent {
  const UserLoggedIn(this.user);
  final User user;
}

/// Event fired when a user registers a new account.
class UserRegistered extends AuthDomainEvent {
  const UserRegistered(this.user);
  final User user;
}

/// Event fired when a user logs out.
class UserLoggedOut extends AuthDomainEvent {
  const UserLoggedOut(this.userId);
  final UserId userId;
}

/// Event fired when a user's email is verified.
class UserEmailVerified extends AuthDomainEvent {
  const UserEmailVerified(this.user);
  final User user;
}

/// Event fired when a user changes their email address.
class UserEmailChanged extends AuthDomainEvent {
  const UserEmailChanged(this.user, this.oldEmail);
  final User user;
  final String oldEmail;
}

/// Event fired when a user's session is restored from stored tokens.
///
/// This happens when the app starts and the user was previously logged in.
/// Listeners should use this to reload user-related data (e.g., profile).
class UserSessionRestored extends AuthDomainEvent {
  const UserSessionRestored(this.user);
  final User user;
}
