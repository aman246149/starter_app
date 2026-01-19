import 'package:injectable/injectable.dart';

import 'package:starter_app/core/domain/ports/i_websocket_connection.dart';
import 'package:starter_app/core/domain/ports/i_websocket_manager.dart';
import 'package:starter_app/core/domain/types/i_reconnection_policy.dart';
import 'package:starter_app/core/infrastructure/websocket/websocket_connection.dart';
import 'package:starter_app/core/logging/i_app_logger.dart';

/// Manages multiple WebSocket connections.
///
/// This is an **adapter** in hexagonal architecture - it implements the
/// [IWebSocketManager] port defined in the domain layer.
///
/// Factory for creating WebSocket connections to different endpoints.
/// Each connection is independent and can be used simultaneously.
///
/// Features:
/// - Create multiple concurrent connections
/// - Connection lifecycle management
/// - Automatic cleanup on disposal
///
/// Usage:
/// ```dart
/// final manager = getIt<IWebSocketManager>();
///
/// // Create connection to auth endpoint
/// final authConnection = manager.createConnection('/ws/auth');
/// await authConnection.connect(headers: {'Authorization': 'Bearer $token'});
///
/// // Create connection to notifications endpoint
/// final notifConnection = manager.createConnection('/ws/notifications');
/// await notifConnection.connect(headers: {'Authorization': 'Bearer $token'});
///
/// // Both connections work independently
/// authConnection.messages.listen((msg) => print('Auth: $msg'));
/// notifConnection.messages.listen((msg) => print('Notif: $msg'));
/// ```
@LazySingleton(as: IWebSocketManager)
class WebSocketManager implements IWebSocketManager {
  WebSocketManager(
    @Named('websocketBaseUrl') this._baseUrl,
    this._logger,
  );

  final String _baseUrl;
  final IAppLogger _logger;
  final List<WebSocketConnection> _connections = [];

  @override
  IWebSocketConnection createConnection(
    String path, {
    IReconnectionPolicy? reconnectionPolicy,
  }) {
    final url = '$_baseUrl$path';
    _logger.debug('Creating WebSocket connection for: $url');

    late final WebSocketConnection connection;
    connection = WebSocketConnection(
      url: url,
      logger: _logger,
      reconnectionPolicy: reconnectionPolicy,
      onDisconnected: () => _handleConnectionDisconnected(connection),
    );

    _connections.add(connection);
    return connection;
  }

  @override
  IWebSocketConnection createConnectionWithUrl(
    String url, {
    IReconnectionPolicy? reconnectionPolicy,
  }) {
    _logger.debug('Creating WebSocket connection for custom URL: $url');

    late final WebSocketConnection connection;
    connection = WebSocketConnection(
      url: url,
      logger: _logger,
      reconnectionPolicy: reconnectionPolicy,
      onDisconnected: () => _handleConnectionDisconnected(connection),
    );

    _connections.add(connection);
    return connection;
  }

  @override
  Future<void> disconnectAll() async {
    _logger.debug('Disconnecting all WebSocket connections');

    final futures = _connections.map((c) => c.disconnect()).toList();
    await Future.wait(futures);

    _connections.clear();
  }

  @override
  Future<void> dispose() async {
    _logger.debug('Disposing WebSocket manager');

    final futures = _connections.map((c) => c.dispose()).toList();
    await Future.wait(futures);

    _connections.clear();
  }

  void _handleConnectionDisconnected(WebSocketConnection connection) {
    _connections.remove(connection);
    _logger.debug(
      'WebSocket connection removed from manager. '
      'Active connections: ${_connections.length}',
    );
  }

  @override
  int get activeConnectionCount => _connections.length;

  @override
  List<IWebSocketConnection> get activeConnections =>
      List.unmodifiable(_connections);
}
