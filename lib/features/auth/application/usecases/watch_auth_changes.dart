import 'package:injectable/injectable.dart';

import 'package:starter_app/core/domain/base/query.dart';
import 'package:starter_app/core/types/types.dart';
import 'package:starter_app/features/auth/domain/entities/user.dart';
import 'package:starter_app/features/auth/domain/repositories/i_auth_repository.dart';

/// Query for watching real-time authentication state changes.
///
/// This is a **read operation** (Query) that streams authentication state
/// without mutating it. Streams user updates via WebSocket connection
/// or other real-time mechanism.
/// Used to keep the app's auth state in sync with the backend.
///
/// ## Flow
/// 1. Call repository to get stream of user changes
/// 2. Listen to the stream in the presentation layer (e.g., BLoC)
/// 3. Update auth state based on stream events (user, null, or failure)
///
/// Example:
/// ```dart
/// // In AuthBloc
/// _watchAuthChangesSubscription = _watchAuthChanges().listen((result) {
///   result.fold(
///     (failure) => emit(AuthState.error(failure)),
///     (user) => user != null
///       ? emit(AuthState.authenticated(user))
///       : emit(AuthState.unauthenticated()),
///   );
/// });
/// ```
@injectable
class WatchAuthChanges extends StreamQueryNoParams<User?> {
  const WatchAuthChanges(this._repository);

  final IAuthRepository _repository;

  /// Watches for real-time authentication state changes.
  ///
  /// Returns:
  /// - Stream of [Either<Failure, User?>]
  @override
  StreamResult<User?> call() {
    return _repository.watchAuthChanges();
  }
}
