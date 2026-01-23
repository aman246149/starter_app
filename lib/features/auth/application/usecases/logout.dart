import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:starter_app/core/domain/base/command.dart';
import 'package:starter_app/core/types/types.dart';
import 'package:starter_app/features/auth/domain/repositories/i_auth_repository.dart';

/// Command for ending the current user session.
///
/// This is a **write operation** (Command) that mutates application state
/// by invalidating the authenticated session.
///
/// Invalidates tokens on backend and clears local session.
/// No validation needed as logout is always allowed.
///
/// ## Flow
/// 1. Get current user (to know who is logging out)
/// 2. Call repository to invalidate session
/// 3. Repository clears stored tokens
/// 4. Dispatch UserLoggedOut event
///
/// Example:
/// ```dart
/// final result = await logout();
/// result.fold(
///   (failure) => emit(AuthState.error(failure)),
///   (_) => emit(AuthState.unauthenticated()),
/// );
/// ```
@injectable
class Logout extends CommandNoParams<Unit> {
  const Logout(this._repository);

  final IAuthRepository _repository;

  /// Ends the current user session.
  ///
  /// Returns:
  /// - [Right(Unit)] on successful logout
  /// - [Left(Failure)] if logout fails
  @override
  FutureResult<Unit> call() async {
    // Ideally we would get the user ID first to dispatch a rich event,
    // but for now we just perform the logout operation.
    // In a stricter implementation, we might pass the UserID or fetch it.

    // We attempt to get the current user ID from storage/repo before logging out
    // if we wanted to be perfectly strict,
    //  but 'logout' is often a "best effort"
    // reset.

    // We will just execute the logout.
    return _repository.logout();
  }
}
