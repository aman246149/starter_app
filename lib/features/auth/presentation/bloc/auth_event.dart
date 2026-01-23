import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:starter_app/features/auth/domain/entities/user.dart';

part 'auth_event.freezed.dart';

@freezed
abstract class AuthEvent with _$AuthEvent {
  const factory AuthEvent.emailChanged(String email) = AuthEmailChanged;
  const factory AuthEvent.passwordChanged(String password) =
      AuthPasswordChanged;
  const factory AuthEvent.nameChanged(String name) = AuthNameChanged;
  const factory AuthEvent.togglePasswordVisibility() =
      AuthTogglePasswordVisibility;
  const factory AuthEvent.emailUnfocused() = AuthEmailUnfocused;
  const factory AuthEvent.passwordUnfocused() = AuthPasswordUnfocused;
  const factory AuthEvent.nameUnfocused() = AuthNameUnfocused;
  const factory AuthEvent.emailSubmitted() = AuthEmailSubmitted;
  const factory AuthEvent.loginSubmitted() = AuthLoginSubmitted;
  const factory AuthEvent.registerSubmitted() = AuthRegisterSubmitted;
  const factory AuthEvent.logoutRequested() = AuthLogoutRequested;
  const factory AuthEvent.authUserChanged(User? user) = AuthUserChanged;
  const factory AuthEvent.watchStarted() = AuthWatchStarted;
  const factory AuthEvent.getCurrentUser() = AuthGetCurrentUser;

  /// Starts watching for session expiration events.
  /// Called at app initialization to monitor token refresh failures.
  const factory AuthEvent.sessionWatchStarted() = AuthSessionWatchStarted;

  /// Fired when token refresh fails or session is forcibly expired.
  /// This triggers navigation to the Dashboard/public area.
  const factory AuthEvent.sessionExpired() = AuthSessionExpired;
}
