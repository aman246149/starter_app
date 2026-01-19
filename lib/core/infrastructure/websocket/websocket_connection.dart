import 'dart:async';
import 'dart:convert';
import 'dart:io' show WebSocketException;

import 'package:flutter/foundation.dart';

import 'package:starter_app/core/domain/ports/i_websocket_connection.dart';
import 'package:starter_app/core/domain/types/i_reconnection_policy.dart';
import 'package:starter_app/core/domain/types/websocket_connection_state.dart';
import 'package:starter_app/core/infrastructure/websocket/websocket_reconnection_config.dart';
import 'package:starter_app/core/logging/i_app_logger.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Represents a single WebSocket connection.
///
/// Each instance manages one WebSocket connection to a specific endpoint.
/// Multiple instances can exist simultaneously for different endpoints.
///
/// This is an **adapter** in hexagonal architecture - it implements the
/// [IWebSocketConnection] port defined in the domain layer.
///
/// Features:
/// - Independent connection lifecycle
/// - Automatic reconnection with exponential backoff and jitter
/// - Connection state management and tracking
/// - Error handling and logging
/// - Stream-based message handling
///
/// Usage:
/// ```dart
/// final connection = WebSocketConnection(
///   url: 'wss://api.example.com/ws/notifications',
///   logger: logger,
///   reconnectionConfig: WebSocketReconnectionConfig.defaultConfig,
/// );
///
/// // Listen to connection state changes
/// connection.connectionState.listen((state) {
///   print('Connection state: ${state.displayName}');
/// });
///
/// await connection.connect(headers: {'Authorization': 'Bearer $token'});
///
/// connection.messages.listen((message) {
///   print('Received: $message');
/// });
///
/// await connection.disconnect();
/// ```
/// Factory function type for creating WebSocket channels.
/// Used for dependency injection in tests.
typedef WebSocketChannelFactory =
    WebSocketChannel Function(
      Uri uri, {
      Iterable<String>? protocols,
    });

class WebSocketConnection implements IWebSocketConnection {
  WebSocketConnection({
    required String url,
    required IAppLogger logger,
    IReconnectionPolicy? reconnectionPolicy,
    this.onConnected,
    this.onDisconnected,
    this.onReconnecting,
    this.onError,
    WebSocketChannelFactory? channelFactory,
  }) : _url = url,
       _logger = logger,
       _reconnectionPolicy =
           reconnectionPolicy ?? WebSocketReconnectionConfig.defaultConfig,
       _channelFactory = channelFactory {
    _connectionStateController =
        StreamController<WebSocketConnectionState>.broadcast();
    _updateConnectionState(WebSocketConnectionState.disconnected);
  }

  final String _url;
  final IAppLogger _logger;
  final IReconnectionPolicy _reconnectionPolicy;
  final WebSocketChannelFactory? _channelFactory;

  /// Callback invoked when connection is established
  final VoidCallback? onConnected;

  /// Callback invoked when connection is closed
  final VoidCallback? onDisconnected;

  /// Callback invoked when starting reconnection attempt
  final void Function(int attempt)? onReconnecting;

  /// Callback invoked when an error occurs
  final void Function(Object error)? onError;

  WebSocketChannel? _channel;
  StreamController<String>? _messageController;
  StreamSubscription<dynamic>? _channelSubscription;
  late StreamController<WebSocketConnectionState> _connectionStateController;

  WebSocketConnectionState _connectionState =
      WebSocketConnectionState.disconnected;
  bool _isDisposed = false;
  bool _isManualDisconnect = false;
  int _reconnectionAttempt = 0;
  Timer? _reconnectionTimer;
  Map<String, String>? _lastHeaders;

  /// Stream of incoming WebSocket messages.
  ///
  /// Emits:
  /// - Raw JSON string messages from the server
  /// - Never emits errors (errors are handled internally)
  /// - Completes when connection is closed permanently
  @override
  Stream<String> get messages =>
      _messageController?.stream ?? const Stream.empty();

  /// Stream of connection state changes.
  ///
  /// Emits whenever the connection state changes:
  /// - disconnected → connecting → connected
  /// - connected → reconnecting → connected
  /// - reconnecting → failed (if max attempts exceeded)
  @override
  Stream<WebSocketConnectionState> get connectionState =>
      _connectionStateController.stream;

  /// Current connection state.
  @override
  WebSocketConnectionState get currentState => _connectionState;

  /// Returns true if WebSocket is connected and ready to send messages.
  @override
  bool get isConnected =>
      _connectionState == WebSocketConnectionState.connected;

  /// Returns true if connection is actively trying to connect or reconnect.
  @override
  bool get isConnecting => _connectionState.isConnecting;

  /// Establishes WebSocket connection.
  ///
  /// Parameters:
  /// - [headers]: Optional HTTP headers (e.g., for authentication)
  ///
  /// Throws:
  /// - [WebSocketException] if connection fails
  /// - [StateError] if already connected or disposed
  ///
  /// Returns: Future that completes when connected
  @override
  Future<void> connect({Map<String, String>? headers}) async {
    if (_isDisposed) {
      throw StateError('Cannot connect: connection is disposed');
    }

    if (_connectionState == WebSocketConnectionState.connected) {
      _logger.debug('WebSocket already connected to: $_url');
      return;
    }

    _lastHeaders = headers;
    _isManualDisconnect = false;
    _reconnectionAttempt = 0;
    await _attemptConnection();
  }

  Future<void> _attemptConnection() async {
    if (_isDisposed || _isManualDisconnect) {
      return;
    }

    try {
      _updateConnectionState(
        _reconnectionAttempt > 0
            ? WebSocketConnectionState.reconnecting
            : WebSocketConnectionState.connecting,
      );

      _logger.debug(
        'Connecting to WebSocket: $_url (attempt ${_reconnectionAttempt + 1})',
      );

      // Create message stream controller if needed
      _messageController ??= StreamController<String>.broadcast();

      // Connect to WebSocket
      final uri = Uri.parse(_url);
      final protocols = _lastHeaders != null
          ? [jsonEncode(_lastHeaders)]
          : null;
      _channel =
          _channelFactory?.call(uri, protocols: protocols) ??
          WebSocketChannel.connect(uri, protocols: protocols);

      // Wait for actual connection to be established
      // This prevents reporting "connected" before TCP handshake completes
      await _channel!.ready;

      // Listen to incoming messages
      _channelSubscription = _channel!.stream.listen(
        (dynamic data) {
          _logger.debug('WebSocket message received from $_url: $data');
          if (data is String && !_isDisposed) {
            _messageController?.add(data);
          }
        },
        onError: (Object error) async {
          _logger.error('WebSocket error on $_url', error: error);
          onError?.call(error);
          await _handleConnectionLost();
        },
        onDone: () async {
          _logger.debug('WebSocket connection closed: $_url');
          await _handleConnectionLost();
        },
        cancelOnError: false,
      );

      // Connection successful
      _reconnectionAttempt = 0;
      _updateConnectionState(WebSocketConnectionState.connected);
      _logger.info('WebSocket connected successfully to: $_url');
      onConnected?.call();
    } on Exception catch (e, stackTrace) {
      _logger.error(
        'Failed to connect WebSocket to $_url',
        error: e,
        stackTrace: stackTrace,
      );
      onError?.call(e);
      await _handleConnectionLost();
    }
  }

  Future<void> _handleConnectionLost() async {
    if (_isDisposed || _isManualDisconnect) {
      await _cleanup();
      return;
    }

    // Attempt reconnection if enabled
    if (_reconnectionPolicy.enabled &&
        _reconnectionPolicy.canRetry(_reconnectionAttempt)) {
      _scheduleReconnection();
    } else {
      // Max retries exceeded or reconnection disabled
      _updateConnectionState(WebSocketConnectionState.failed);
      _logger.warning(
        'WebSocket connection to $_url failed permanently. '
        'Max retries: ${_reconnectionPolicy.maxAttempts}',
      );
      await _cleanup();
      onDisconnected?.call();
    }
  }

  void _scheduleReconnection() {
    _reconnectionTimer?.cancel();

    final delay = _reconnectionPolicy.getDelayForAttempt(_reconnectionAttempt);

    _logger.info(
      'Scheduling reconnection attempt ${_reconnectionAttempt + 1} '
      'in ${delay.inSeconds}s for $_url',
    );

    _updateConnectionState(WebSocketConnectionState.reconnecting);
    onReconnecting?.call(_reconnectionAttempt + 1);

    _reconnectionTimer = Timer(delay, () async {
      _reconnectionAttempt++;
      await _cleanup(keepController: true);
      await _attemptConnection();
    });
  }

  /// Sends a message through the WebSocket connection.
  ///
  /// Parameters:
  /// - [message]: JSON string message to send
  ///
  /// Throws:
  /// - [StateError] if not connected or disposed
  @override
  void send(String message) {
    if (_isDisposed) {
      throw StateError('Cannot send: connection is disposed');
    }

    if (!isConnected || _channel == null) {
      throw StateError(
        '''WebSocket is not connected. Current state: ${_connectionState.displayName}''',
      );
    }

    try {
      _logger.debug('Sending WebSocket message to $_url: $message');
      _channel!.sink.add(message);
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to send WebSocket message to $_url',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Closes the WebSocket connection.
  ///
  /// Gracefully closes the connection and completes the message stream.
  /// This will prevent automatic reconnection.
  @override
  Future<void> disconnect() async {
    _logger.debug('Manually disconnecting WebSocket: $_url');
    _isManualDisconnect = true;
    _reconnectionTimer?.cancel();
    _updateConnectionState(WebSocketConnectionState.disconnected);
    await _cleanup();
    onDisconnected?.call();
  }

  /// Disposes resources and closes connection.
  ///
  /// Should be called when the connection is no longer needed.
  /// After disposal, the connection cannot be reused.
  @override
  Future<void> dispose() async {
    _logger.debug('Disposing WebSocket connection: $_url');
    _isDisposed = true;
    _isManualDisconnect = true;
    _reconnectionTimer?.cancel();
    await _cleanup();
    await _connectionStateController.close();
  }

  void _updateConnectionState(WebSocketConnectionState newState) {
    if (_connectionState != newState) {
      _connectionState = newState;
      if (!_connectionStateController.isClosed) {
        _connectionStateController.add(newState);
      }
      _logger.debug(
        'WebSocket state changed to: ${newState.displayName} for $_url',
      );
    }
  }

  Future<void> _cleanup({bool keepController = false}) async {
    await _channelSubscription?.cancel();
    _channelSubscription = null;

    await _channel?.sink.close();
    _channel = null;

    if (!keepController) {
      await _messageController?.close();
      _messageController = null;
    }
  }

  // ---------------------------------------------------------------------------
  // Test hooks
  // ---------------------------------------------------------------------------

  /// Gets the disposed flag for testing purposes.
  @visibleForTesting
  bool get debugIsDisposed => _isDisposed;

  /// Gets the manual disconnect flag for testing purposes.
  @visibleForTesting
  bool get debugIsManualDisconnect => _isManualDisconnect;

  /// Calls [_handleConnectionLost] for testing purposes.
  ///
  /// This allows tests to directly trigger the connection lost handler
  /// with controlled state flags to ensure proper cleanup execution.
  @visibleForTesting
  Future<void> debugHandleConnectionLost() => _handleConnectionLost();
}

/// Type definition for void callback
typedef VoidCallback = void Function();
