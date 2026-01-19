import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:starter_app/core/domain/ports/i_token_refresh_notifier.dart';

/// Implementation of [ITokenRefreshNotifier] for token refresh events.
///
/// This is an **adapter** in hexagonal architecture - it implements the
/// [ITokenRefreshNotifier] port defined in the domain layer.
///
/// Uses a broadcast [StreamController] to allow multiple listeners
/// (e.g., multiple WebSocket connections).
@Singleton(as: ITokenRefreshNotifier)
class TokenRefreshNotifierImpl implements ITokenRefreshNotifier {
  TokenRefreshNotifierImpl();

  final _tokenRefreshedController = StreamController<void>.broadcast();

  @override
  Stream<void> get onTokenRefreshed => _tokenRefreshedController.stream;

  @override
  void notifyTokenRefreshed() {
    if (!_tokenRefreshedController.isClosed) {
      _tokenRefreshedController.add(null);
    }
  }

  @override
  @disposeMethod
  Future<void> dispose() async {
    await _tokenRefreshedController.close();
  }
}
