import 'package:injectable/injectable.dart';

import 'package:starter_app/core/domain/base/event_dispatcher.dart';
import 'package:starter_app/core/domain/base/query.dart';
import 'package:starter_app/core/types/types.dart';
import 'package:starter_app/features/auth/domain/entities/user.dart';
import 'package:starter_app/features/auth/domain/events/auth_events.dart';
import 'package:starter_app/features/auth/domain/repositories/i_auth_repository.dart';

/// Query for getting the currently authenticated user.
///
/// This is a **read operation** (Query) that doesn't mutate application state.
/// Fetches fresh user data from backend or cache.
/// Used on app startup to restore auth state.
///
/// ## Flow
/// 1. Call repository to get current user
/// 2. If user exists, dispatch [UserSessionRestored] event
/// 3. Return user or null if not authenticated
///
/// Example:
/// ```dart
/// // On app startup
/// final result = await getCurrentUser();
/// result.fold(
///   (failure) => emit(AuthState.error(failure)),
///   (user) => user != null
///     ? emit(AuthState.authenticated(user))
///     : emit(AuthState.unauthenticated()),
/// );
/// ```
@injectable
class GetCurrentUser extends QueryNoParams<User?> {
  const GetCurrentUser(this._repository, this._eventDispatcher);

  final IAuthRepository _repository;
  final IEventDispatcher _eventDispatcher;

  /// Gets the currently authenticated user.
  ///
  /// Returns:
  /// - [Right(User)] if user is authenticated
  /// - [Right(null)] if no user is authenticated
  /// - [Left(Failure)] if fetch fails
  @override
  FutureResult<User?> call() async {
    final result = await _repository.getCurrentUser();

    // Dispatch event when session is restored
    return result.map((user) {
      if (user != null) {
        _eventDispatcher.dispatch(UserSessionRestored(user));
      }
      return user;
    });
  }
}
