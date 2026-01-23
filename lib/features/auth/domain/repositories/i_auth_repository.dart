import 'package:fpdart/fpdart.dart';

import 'package:starter_app/core/domain/value_objects/email_address.dart';
import 'package:starter_app/core/types/types.dart';
import 'package:starter_app/features/auth/domain/entities/auth_credentials.dart';
import 'package:starter_app/features/auth/domain/entities/user.dart';
import 'package:starter_app/features/auth/domain/value_objects/auth_token.dart';
import 'package:starter_app/features/auth/domain/value_objects/refresh_token.dart';

/// Repository interface for authentication operations.
///
/// Defines the contract for all authentication-related data operations.
/// Implementation is in the infrastructure layer.
///
/// All methods return [Either<Failure, T>] for functional error handling.
///
/// ## Email-First Flow
/// 1. [checkUserExists] - Check if email is registered
/// 2. [login] or [register] - Based on email existence
/// 3. [watchAuthChanges] - Listen for real-time auth state changes (WebSocket)
/// 4. [refreshToken] - Refresh expired tokens
/// 5. [logout] - End session
///
/// Example:
/// ```dart
/// // In Use Case
/// final emailExists = await repository.checkEmailExists(email);
/// final result = emailExists.fold(
///   (failure) => left(failure),
///   (exists) => exists
///     ? repository.login(credentials)
///     : repository.register(credentials, name),
/// );
/// ```
abstract class IAuthRepository {
  /// Checks if a user exists for the given email.
  ///
  /// Used in email-first flow to determine whether to show
  /// login or registration form.
  ///
  /// Returns:
  /// - [Right(true)] if email exists (show login form)
  /// - [Right(false)] if email doesn't exist (show registration form)
  /// - [Left(Failure)] if check fails
  FutureResult<bool> checkUserExists(EmailAddress email);

  /// Authenticates user with credentials.
  ///
  /// Validates credentials with backend and returns authenticated user.
  /// Tokens are stored automatically by the implementation.
  ///
  /// Returns:
  /// - [Right(User)] on successful login
  /// - [Left(Failure)] on authentication failure
  FutureResult<User> login(AuthCredentials credentials);

  /// Registers a new user account.
  ///
  /// Creates new account with provided credentials (including name).
  /// Automatically logs in the user after registration.
  /// Backend handles profile creation.
  ///
  /// Parameters:
  /// - [credentials]: Validated credentials with name
  ///
  /// Returns:
  /// - [Right(User)] on successful registration
  /// - [Left(Failure)] if registration fails (e.g., email taken)
  FutureResult<User> register(AuthCredentials credentials);

  /// Ends the current user session.
  ///
  /// Invalidates tokens on backend, clears local session, and disposes
  /// WebSocket connections. This ensures a fresh connection is created
  /// on subsequent logins.
  ///
  /// Returns:
  /// - [Right(Unit)] on successful logout
  /// - [Left(Failure)] if logout fails
  FutureResult<Unit> logout();

  /// Refreshes an expired access token.
  ///
  /// Uses refresh token to obtain a new access token.
  /// Called automatically when access token expires.
  ///
  /// Returns:
  /// - [Right(AuthToken)] with new access token
  /// - [Left(Failure)] if refresh fails (user must re-login)
  FutureResult<AuthToken> refreshToken(RefreshToken token);

  /// Gets the currently authenticated user.
  ///
  /// Fetches fresh user data from backend or cache.
  ///
  /// Returns:
  /// - [Right(User)] if user is authenticated
  /// - [Right(null)] if no user is authenticated
  /// - [Left(Failure)] if fetch fails
  FutureResult<User?> getCurrentUser();

  /// Watches for real-time authentication state changes.
  ///
  /// Streams user updates via WebSocket connection.
  /// Emits when:
  /// - User logs in
  /// - User logs out
  /// - User profile is updated
  /// - Session expires
  ///
  /// Returns:
  /// - Stream of [User?] (null when logged out)
  ///
  /// Example:
  /// ```dart
  /// repository.watchAuthChanges().listen((user) {
  ///   if (user == null) {
  ///     // Navigate to login
  ///   } else {
  ///     // Update UI with user data
  ///   }
  /// });
  /// ```
  StreamResult<User?> watchAuthChanges();
}
