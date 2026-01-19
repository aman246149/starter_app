import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:starter_app/core/domain/ports/i_session_manager.dart';

/// Implementation of [ISessionManager] for session lifecycle events.
///
/// This is an **adapter** in hexagonal architecture - it implements the
/// [ISessionManager] port defined in the domain layer.
///
/// Uses a broadcast [StreamController] to allow multiple listeners
/// (though typically only AuthBloc will listen).
///
/// The stream is broadcast because:
/// - Multiple listeners may be interested (analytics, logging, etc.)
/// - The stream should not buffer events if no one is listening
@Singleton(as: ISessionManager)
class SessionManagerImpl implements ISessionManager {
  SessionManagerImpl();

  final _sessionExpiredController = StreamController<void>.broadcast();

  @override
  Stream<void> get onSessionExpired => _sessionExpiredController.stream;

  @override
  void notifySessionExpired() {
    if (!_sessionExpiredController.isClosed) {
      _sessionExpiredController.add(null);
    }
  }

  @override
  @disposeMethod
  Future<void> dispose() async {
    await _sessionExpiredController.close();
  }
}
