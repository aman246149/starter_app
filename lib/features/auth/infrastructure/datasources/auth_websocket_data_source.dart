import 'dart:async';
import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:starter_app/core/domain/ports/i_token_refresh_notifier.dart';
import 'package:starter_app/core/domain/ports/i_token_storage.dart';
import 'package:starter_app/core/domain/ports/i_websocket_connection.dart';
import 'package:starter_app/core/domain/ports/i_websocket_manager.dart';
import 'package:starter_app/core/domain/types/websocket_connection_state.dart';
import 'package:starter_app/core/error/exceptions/exceptions.dart';
import 'package:starter_app/core/logging/i_app_logger.dart';
import 'package:starter_app/features/auth/infrastructure/models/user_model.dart';
import 'package:starter_app/features/auth/infrastructure/models/websocket/auth_ws_event_model.dart';

/// Interface for authentication WebSocket data source.
abstract class IAuthWebSocketDataSource {
  /// Watches for authentication state changes via WebSocket.
  ///
  /// Returns a stream that emits:
  /// - [UserModel] when user is authenticated or updated
  /// - `null` when user is logged out or session expires
  ///
  /// Automatically handles:
  /// - Connection establishment with auth token
  /// - Message parsing and filtering
  /// - Reconnection on disconnect
  Stream<UserModel?> watchAuthChanges();

  /// Disposes WebSocket connection and resources.
  ///
  /// **Important:** Must be called during logout to reset internal state.
  /// Without calling dispose, subsequent calls to [watchAuthChanges] will
  /// return the stale stream instead of creating a fresh connection.
  Future<void> dispose();
}

/// Implementation of [IAuthWebSocketDataSource] using WebSocket manager.
///
/// Manages WebSocket connection for real-time auth state changes.
/// Access token is passed via query parameter for browser compatibility.
/// Uses its own dedicated WebSocket connection independent of other features.
///
/// ## Token Refresh Handling
///
/// Listens to [ITokenRefreshNotifier] to automatically reconnect when
/// the access token is refreshed. This ensures the WebSocket connection
/// always uses a valid token for long-lived connections.
@LazySingleton(as: IAuthWebSocketDataSource)
class AuthWebSocketDataSource implements IAuthWebSocketDataSource {
  AuthWebSocketDataSource(
    this._webSocketManager,
    this._tokenStorage,
    this._tokenRefreshNotifier,
    this._logger,
  );

  final IWebSocketManager _webSocketManager;
  final ITokenStorage _tokenStorage;
  final ITokenRefreshNotifier _tokenRefreshNotifier;
  final IAppLogger _logger;

  IWebSocketConnection? _connection;
  StreamController<UserModel?>? _authChangesController;
  StreamSubscription<String>? _messageSubscription;
  StreamSubscription<WebSocketConnectionState>? _stateSubscription;
  StreamSubscription<void>? _tokenRefreshSubscription;
  bool _isWatching = false;

  @override
  Stream<UserModel?> watchAuthChanges() {
    if (_isWatching) {
      return _authChangesController!.stream;
    }

    _authChangesController = StreamController<UserModel?>.broadcast(
      onListen: _onListen,
      onCancel: _onCancel,
    );

    _isWatching = true;
    return _authChangesController!.stream;
  }

  Future<void> _onListen() async {
    try {
      _logger.debug('Starting auth WebSocket watch');

      // Get access token for authentication
      final accessToken = await _tokenStorage.getAccessToken();

      if (accessToken == null) {
        _logger.warning('No access token available for WebSocket connection');
        _authChangesController?.add(null);
        return;
      }

      // Listen for token refresh events to reconnect with new token
      _tokenRefreshSubscription = _tokenRefreshNotifier.onTokenRefreshed.listen(
        (_) => _reconnectWithNewToken(),
      );

      // Create dedicated WebSocket connection for auth
      _connection = _webSocketManager.createConnection('/ws/auth');

      // Listen to connection state changes for error handling
      _stateSubscription = _connection!.connectionState.listen(
        (state) {
          if (state == WebSocketConnectionState.failed) {
            _logger.error('Auth WebSocket connection failed permanently');
            _authChangesController?.addError(
              const NetworkException(
                message: 'WebSocket connection failed',
              ),
            );
          }
        },
      );

      // Connect with authentication headers
      final headers = {
        'Authorization': 'Bearer $accessToken',
      };

      await _connection!.connect(headers: headers);

      // Listen to incoming messages
      // Note: messages stream never emits errors (handled via connectionState)
      _messageSubscription = _connection!.messages.listen(
        _handleMessage,
        onDone: () {
          _logger.debug('Auth WebSocket connection closed');
          // Emit null to indicate disconnection (session may have ended)
          _authChangesController?.add(null);
        },
      );
    } on Exception catch (e, stackTrace) {
      _logger.error(
        'Failed to start auth WebSocket watch',
        error: e,
        stackTrace: stackTrace,
      );
      // Propagate connection error as NetworkException
      _authChangesController?.addError(
        NetworkException(
          message: 'Failed to connect to auth WebSocket: $e',
          originalError: e,
        ),
      );
    }
  }

  /// Reconnects the WebSocket with a fresh access token.
  ///
  /// Called when the HTTP interceptor successfully refreshes the token.
  /// This ensures long-lived WebSocket connections stay authenticated.
  Future<void> _reconnectWithNewToken() async {
    if (!_isWatching || _connection == null) {
      return;
    }

    _logger.info('Token refreshed - reconnecting WebSocket with new token');

    try {
      // Get the new access token
      final newAccessToken = await _tokenStorage.getAccessToken();
      if (newAccessToken == null) {
        _logger.warning('No new access token available for reconnection');
        return;
      }

      // Disconnect existing connection (but keep listening subscriptions)
      await _messageSubscription?.cancel();
      _messageSubscription = null;
      await _stateSubscription?.cancel();
      _stateSubscription = null;
      await _connection?.disconnect();

      // Create new connection with fresh token
      _connection = _webSocketManager.createConnection('/ws/auth');

      _stateSubscription = _connection!.connectionState.listen(
        (state) {
          if (state == WebSocketConnectionState.failed) {
            _logger.error('Auth WebSocket reconnection failed permanently');
            _authChangesController?.addError(
              const NetworkException(
                message: 'WebSocket reconnection failed',
              ),
            );
          }
        },
      );

      final headers = {
        'Authorization': 'Bearer $newAccessToken',
      };

      await _connection!.connect(headers: headers);

      _messageSubscription = _connection!.messages.listen(
        _handleMessage,
        onDone: () {
          _logger.debug('Auth WebSocket connection closed after reconnect');
          _authChangesController?.add(null);
        },
      );

      _logger.info('WebSocket reconnected successfully with new token');
    } on Exception catch (e, stackTrace) {
      _logger.error(
        'Failed to reconnect WebSocket with new token',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  void _handleMessage(String message) {
    try {
      _logger.debug('Processing auth WebSocket message: $message');

      final json = jsonDecode(message);
      final event = AuthWsEventModel.fromJson(json as Map<String, dynamic>);

      _logger.debug('Auth event type: ${event.event}');

      // Handle different event types
      if (event.isAuthenticated) {
        // User authenticated or updated
        _authChangesController?.add(event.data);
      } else if (event.isLoggedOut) {
        // User logged out or session expired
        _authChangesController?.add(null);
      } else {
        _logger.warning('Unknown auth event type: ${event.event}');
      }
    } on FormatException catch (e, stackTrace) {
      _logger.error(
        'Failed to parse auth WebSocket message',
        error: e,
        stackTrace: stackTrace,
      );
      // Propagate parsing error for proper failure mapping
      _authChangesController?.addError(e);
    } on Exception catch (e, stackTrace) {
      _logger.error(
        'Failed to process auth WebSocket message',
        error: e,
        stackTrace: stackTrace,
      );
      // Wrap other exceptions as FormatException for parsing context
      _authChangesController?.addError(
        FormatException('Failed to process WebSocket message: $e'),
      );
    }
  }

  Future<void> _onCancel() async {
    _logger.debug('Cancelling auth WebSocket watch');
    await _cleanup();
  }

  @override
  Future<void> dispose() async {
    _logger.debug('Disposing auth WebSocket data source');
    await _cleanup();
  }

  Future<void> _cleanup() async {
    await _messageSubscription?.cancel();
    _messageSubscription = null;

    await _stateSubscription?.cancel();
    _stateSubscription = null;

    await _tokenRefreshSubscription?.cancel();
    _tokenRefreshSubscription = null;

    await _connection?.disconnect();
    _connection = null;

    await _authChangesController?.close();
    _authChangesController = null;

    _isWatching = false;
  }
}
