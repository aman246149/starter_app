import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:starter_app/features/auth/infrastructure/models/user_model.dart';

part 'auth_ws_event_model.freezed.dart';
part 'auth_ws_event_model.g.dart';

/// WebSocket event model for authentication state changes.
///
/// Represents different types of auth events received via WebSocket:
/// - User authenticated (login, registration)
/// - User updated (profile changes)
/// - User logged out (session ended)
/// - Session expired (token invalidated)
///
/// Example JSON:
/// ```json
/// {
///   "event": "user_authenticated",
///   "data": {
///     "id": "123",
///     "name": "John Doe",
///     "email": "john@example.com"
///   }
/// }
/// ```
@freezed
abstract class AuthWsEventModel with _$AuthWsEventModel {
  const factory AuthWsEventModel({
    /// Event type (
    /// e.g., 'user_authenticated', 'user_updated', 'user_logged_out')
    required String event,

    /// Event data (user object or null)
    UserModel? data,

    /// Optional timestamp of the event
    DateTime? timestamp,
  }) = _AuthWsEventModel;

  factory AuthWsEventModel.fromJson(Map<String, dynamic> json) =>
      _$AuthWsEventModelFromJson(json);
}

/// Extension to determine event types
extension AuthWsEventTypeX on AuthWsEventModel {
  /// Check if event represents user authentication
  bool get isAuthenticated =>
      event == 'user_authenticated' || event == 'user_updated';

  /// Check if event represents user logout
  bool get isLoggedOut =>
      event == 'user_logged_out' || event == 'session_expired';

  /// Check if event represents user profile update
  bool get isUpdated => event == 'user_updated';
}
