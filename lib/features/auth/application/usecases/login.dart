import 'package:injectable/injectable.dart';

import 'package:starter_app/core/domain/base/command.dart';
import 'package:starter_app/core/domain/base/event_dispatcher.dart';
import 'package:starter_app/core/types/types.dart';
import 'package:starter_app/features/auth/domain/entities/auth_credentials.dart';
import 'package:starter_app/features/auth/domain/entities/user.dart';
import 'package:starter_app/features/auth/domain/events/auth_events.dart';
import 'package:starter_app/features/auth/domain/repositories/i_auth_repository.dart';

/// Command for authenticating a user with credentials.
///
/// This is a **write operation** (Command) that mutates application state
/// by creating an authenticated session.
///
/// Part of the email-first authentication flow.
/// Called after checkEmailExists returns true.
///
/// ## Validation Strategy
/// - Primary validation: Presentation layer (BLoC)
/// - Defensive validation: Here (Command) - safety net
///
/// ## Flow
/// 1. Validate credentials
/// 2. Call repository to authenticate
/// 3. Repository stores tokens automatically
/// 4. Dispatch UserLoggedIn event
/// 5. Return authenticated user
///
/// Example:
/// ```dart
/// final credentials = AuthCredentials(email: email, password: password);
/// final result = await login(credentials);
/// result.fold(
///   (failure) => emit(AuthState.error(failure)),
///   (user) => emit(AuthState.authenticated(user)),
/// );
/// ```
@injectable
class Login extends Command<AuthCredentials, User> {
  const Login(this._repository, this._eventDispatcher);

  final IAuthRepository _repository;
  final IEventDispatcher _eventDispatcher;

  /// Authenticates user with provided credentials.
  ///
  /// Returns:
  /// - [Right(User)] on successful authentication
  /// - [Left(Failure)] if validation fails or authentication fails
  @override
  FutureResult<User> call(AuthCredentials credentials) async {
    // Delegate to repository
    final result = await _repository.login(credentials);

    // Dispatch event on success
    return result.map((user) {
      _eventDispatcher.dispatch(UserLoggedIn(user));
      return user;
    });
  }
}
