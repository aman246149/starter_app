import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:starter_app/core/domain/base/query.dart';
import 'package:starter_app/core/domain/ports/i_session_manager.dart';
import 'package:starter_app/core/types/types.dart';

/// Query for watching session expiration events.
///
/// This is a **read operation** (Query) that streams session expiration
/// notifications without mutating state.
///
/// Streams session expiration notifications from the infrastructure layer.
/// This decouples the presentation layer (AuthBloc) from the infrastructure
/// (SessionManager) following hexagonal architecture.
///
/// ## When Session Expires
/// - Token refresh fails (expired/invalid refresh token)
/// - Server explicitly invalidates the session
///
/// ## Flow
/// 1. Network layer detects auth failure
/// 2. SessionManager emits expiration event
/// 3. This query forwards the stream to the presentation layer
/// 4. AuthBloc handles the event and navigates appropriately
///
/// Example:
/// ```dart
/// // In AuthBloc
/// await emit.onEach<Either<Failure, void>>(
///   _watchSessionExpired(),
///   onData: (result) => result.fold(
///     (failure) => emit(AuthState.error(failure)),
///     (_) => add(const AuthEvent.sessionExpired()),
///   ),
/// );
/// ```
@injectable
class WatchSessionExpired extends StreamQueryNoParams<void> {
  const WatchSessionExpired(this._sessionManager);

  final ISessionManager _sessionManager;

  /// Watches for session expiration events.
  ///
  /// Returns a stream that emits [Right(Unit)] when:
  /// - Token refresh fails
  /// - Session is invalidated by the server
  ///
  /// The stream never emits errors; all errors are wrapped in [Left(Failure)].
  @override
  StreamResult<void> call() {
    return _sessionManager.onSessionExpired.map(Right.new);
  }
}
