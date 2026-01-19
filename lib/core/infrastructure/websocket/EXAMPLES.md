# WebSocket Multiple Endpoints - Complete Examples

This guide shows practical examples of implementing multiple concurrent WebSocket connections using the interface-based hexagonal architecture approach.

## Example 1: Notifications Feature

```dart
// lib/features/notifications/infrastructure/datasources/notification_websocket_data_source.dart

import 'dart:async';
import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:starter_app/core/domain/ports/i_websocket_connection.dart';
import 'package:starter_app/core/domain/ports/i_websocket_manager.dart';
import 'package:starter_app/core/logging/app_logger.dart';
import 'package:starter_app/core/storage/i_token_storage.dart';
import 'package:starter_app/features/notifications/infrastructure/models/notification_model.dart';

abstract class INotificationWebSocketDataSource {
  Stream<NotificationModel> watchNotifications();
  Future<void> dispose();
}

@LazySingleton(as: INotificationWebSocketDataSource)
class NotificationWebSocketDataSource implements INotificationWebSocketDataSource {
  NotificationWebSocketDataSource(
    this._webSocketManager,
    this._tokenStorage,
    this._logger,
  );

  final IWebSocketManager _webSocketManager;
  final ITokenStorage _tokenStorage;
  final IAppLogger _logger;

  IWebSocketConnection? _connection;
  StreamController<NotificationModel>? _controller;

  @override
  Stream<NotificationModel> watchNotifications() {
    if (_controller != null) {
      return _controller!.stream;
    }

    _controller = StreamController<NotificationModel>.broadcast(
      onListen: _onListen,
      onCancel: _onCancel,
    );

    return _controller!.stream;
  }

  Future<void> _onListen() async {
    try {
      _logger.debug('Starting notification WebSocket watch');

      final accessToken = await _tokenStorage.getAccessToken();
      if (accessToken == null) {
        _logger.warning('No access token for notifications WebSocket');
        return;
      }

      // Create dedicated connection for notifications
      _connection = _webSocketManager.createConnection('/ws/notifications');

      await _connection!.connect(
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      _connection!.messages.listen(
        (message) {
          try {
            final json = jsonDecode(message);
            final notification = NotificationModel.fromJson(json);
            _controller?.add(notification);
          } catch (e, stackTrace) {
            _logger.error(
              'Failed to parse notification message',
              error: e,
              stackTrace: stackTrace,
            );
          }
        },
        onError: (error) {
          _logger.error('Notification WebSocket error', error: error);
        },
      );
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to start notification WebSocket',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _onCancel() async {
    await _connection?.disconnect();
    _connection = null;
    await _controller?.close();
    _controller = null;
  }

  @override
  Future<void> dispose() async {
    await _onCancel();
  }
}
```

## Example 2: Chat Feature

```dart
// lib/features/chat/infrastructure/datasources/chat_websocket_data_source.dart

import 'dart:async';
import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:starter_app/core/domain/ports/i_websocket_connection.dart';
import 'package:starter_app/core/domain/ports/i_websocket_manager.dart';
import 'package:starter_app/core/domain/types/websocket_reconnection_config.dart';
import 'package:starter_app/core/logging/app_logger.dart';
import 'package:starter_app/core/storage/i_token_storage.dart';
import 'package:starter_app/features/chat/infrastructure/models/chat_message_model.dart';

abstract class IChatWebSocketDataSource {
  Stream<ChatMessageModel> watchMessages(String roomId);
  Future<void> sendMessage(String roomId, String message);
  Future<void> dispose();
}

@LazySingleton(as: IChatWebSocketDataSource)
class ChatWebSocketDataSource implements IChatWebSocketDataSource {
  ChatWebSocketDataSource(
    this._webSocketManager,
    this._tokenStorage,
    this._logger,
  );

  final IWebSocketManager _webSocketManager;
  final ITokenStorage _tokenStorage;
  final IAppLogger _logger;

  final Map<String, IWebSocketConnection> _connections = {};
  final Map<String, StreamController<ChatMessageModel>> _controllers = {};

  @override
  Stream<ChatMessageModel> watchMessages(String roomId) {
    // Return existing stream if already watching this room
    if (_controllers.containsKey(roomId)) {
      return _controllers[roomId]!.stream;
    }

    final controller = StreamController<ChatMessageModel>.broadcast(
      onListen: () => _onListen(roomId),
      onCancel: () => _onCancel(roomId),
    );

    _controllers[roomId] = controller;
    return controller.stream;
  }

  Future<void> _onListen(String roomId) async {
    try {
      _logger.debug('Starting chat WebSocket for room: $roomId');

      final accessToken = await _tokenStorage.getAccessToken();
      if (accessToken == null) {
        _logger.warning('No access token for chat WebSocket');
        return;
      }

      // Create dedicated connection for this chat room with aggressive reconnection
      final connection = _webSocketManager.createConnection(
        '/ws/chat/$roomId',
        reconnectionConfig: WebSocketReconnectionConfig.aggressive,
      );

      await connection.connect(
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      connection.messages.listen(
        (message) {
          try {
            final json = jsonDecode(message);
            final chatMessage = ChatMessageModel.fromJson(json);
            _controllers[roomId]?.add(chatMessage);
          } catch (e, stackTrace) {
            _logger.error(
              'Failed to parse chat message',
              error: e,
              stackTrace: stackTrace,
            );
          }
        },
        onError: (error) {
          _logger.error('Chat WebSocket error for room $roomId', error: error);
        },
      );

      _connections[roomId] = connection;
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to start chat WebSocket for room $roomId',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> sendMessage(String roomId, String message) async {
    final connection = _connections[roomId];
    if (connection == null || !connection.isConnected) {
      throw StateError('Not connected to chat room: $roomId');
    }

    final payload = jsonEncode({
      'type': 'message',
      'content': message,
      'timestamp': DateTime.now().toIso8601String(),
    });

    connection.send(payload);
  }

  Future<void> _onCancel(String roomId) async {
    await _connections[roomId]?.disconnect();
    _connections.remove(roomId);

    await _controllers[roomId]?.close();
    _controllers.remove(roomId);
  }

  @override
  Future<void> dispose() async {
    final futures = _connections.values.map((c) => c.disconnect()).toList();
    await Future.wait(futures);
    _connections.clear();

    final controllerFutures = _controllers.values.map((c) => c.close()).toList();
    await Future.wait(controllerFutures);
    _controllers.clear();
  }
}
```

## Example 3: Order Tracking Feature

```dart
// lib/features/orders/infrastructure/datasources/order_websocket_data_source.dart

import 'dart:async';
import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:starter_app/core/domain/ports/i_websocket_connection.dart';
import 'package:starter_app/core/domain/ports/i_websocket_manager.dart';
import 'package:starter_app/core/logging/app_logger.dart';
import 'package:starter_app/core/storage/i_token_storage.dart';
import 'package:starter_app/features/orders/infrastructure/models/order_status_model.dart';

abstract class IOrderWebSocketDataSource {
  Stream<OrderStatusModel> watchOrderStatus(String orderId);
  Future<void> dispose();
}

@LazySingleton(as: IOrderWebSocketDataSource)
class OrderWebSocketDataSource implements IOrderWebSocketDataSource {
  OrderWebSocketDataSource(
    this._webSocketManager,
    this._tokenStorage,
    this._logger,
  );

  final IWebSocketManager _webSocketManager;
  final ITokenStorage _tokenStorage;
  final IAppLogger _logger;

  final Map<String, IWebSocketConnection> _connections = {};
  final Map<String, StreamController<OrderStatusModel>> _controllers = {};

  @override
  Stream<OrderStatusModel> watchOrderStatus(String orderId) {
    if (_controllers.containsKey(orderId)) {
      return _controllers[orderId]!.stream;
    }

    final controller = StreamController<OrderStatusModel>.broadcast(
      onListen: () => _onListen(orderId),
      onCancel: () => _onCancel(orderId),
    );

    _controllers[orderId] = controller;
    return controller.stream;
  }

  Future<void> _onListen(String orderId) async {
    try {
      _logger.debug('Starting order tracking WebSocket for: $orderId');

      final accessToken = await _tokenStorage.getAccessToken();
      if (accessToken == null) {
        _logger.warning('No access token for order tracking WebSocket');
        return;
      }

      final connection = _webSocketManager.createConnection('/ws/orders/$orderId');

      await connection.connect(
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      connection.messages.listen(
        (message) {
          try {
            final json = jsonDecode(message);
            final status = OrderStatusModel.fromJson(json);
            _controllers[orderId]?.add(status);
          } catch (e, stackTrace) {
            _logger.error(
              'Failed to parse order status message',
              error: e,
              stackTrace: stackTrace,
            );
          }
        },
        onError: (error) {
          _logger.error('Order tracking WebSocket error for $orderId', error: error);
        },
      );

      _connections[orderId] = connection;
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to start order tracking WebSocket for $orderId',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _onCancel(String orderId) async {
    await _connections[orderId]?.disconnect();
    _connections.remove(orderId);

    await _controllers[orderId]?.close();
    _controllers.remove(orderId);
  }

  @override
  Future<void> dispose() async {
    final futures = _connections.values.map((c) => c.disconnect()).toList();
    await Future.wait(futures);
    _connections.clear();

    final controllerFutures = _controllers.values.map((c) => c.close()).toList();
    await Future.wait(controllerFutures);
    _controllers.clear();
  }
}
```

## Example 4: Using All Features Together

```dart
// In your app (e.g., in a BLoC or page)

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final StreamSubscription<Either<Failure, User?>> _authSubscription;
  late final StreamSubscription<Either<Failure, NotificationModel>> _notifSubscription;
  late final StreamSubscription<Either<Failure, ChatMessageModel>> _chatSubscription;
  late final StreamSubscription<Either<Failure, OrderStatusModel>> _orderSubscription;

  @override
  void initState() {
    super.initState();
    _setupWebSocketListeners();
  }

  void _setupWebSocketListeners() {
    // 1. Listen to auth changes (Connection 1)
    final authRepo = getIt<IAuthRepository>();
    _authSubscription = authRepo.watchAuthChanges().listen((result) {
      result.fold(
        (failure) => print('Auth error: ${failure.message}'),
        (user) {
          if (user != null) {
            print('User authenticated: ${user.name}');
          } else {
            print('User logged out');
          }
        },
      );
    });

    // 2. Listen to notifications (Connection 2)
    final notifRepo = getIt<INotificationRepository>();
    _notifSubscription = notifRepo.watchNotifications().listen((result) {
      result.fold(
        (failure) => print('Notification error: ${failure.message}'),
        (notification) {
          print('New notification: ${notification.title}');
          _showNotificationSnackBar(notification);
        },
      );
    });

    // 3. Listen to chat messages (Connection 3)
    final chatRepo = getIt<IChatRepository>();
    _chatSubscription = chatRepo.watchMessages('room-123').listen((result) {
      result.fold(
        (failure) => print('Chat error: ${failure.message}'),
        (message) {
          print('New chat message: ${message.text}');
          setState(() {
            // Update chat UI
          });
        },
      );
    });

    // 4. Listen to order tracking (Connection 4)
    final orderRepo = getIt<IOrderRepository>();
    _orderSubscription = orderRepo.watchOrderStatus('order-456').listen((result) {
      result.fold(
        (failure) => print('Order error: ${failure.message}'),
        (status) {
          print('Order status: ${status.state}');
          _updateOrderStatusUI(status);
        },
      );
    });

    // All 4 WebSocket connections are now active simultaneously!
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    _notifSubscription.cancel();
    _chatSubscription.cancel();
    _orderSubscription.cancel();
    super.dispose();
  }

  // ... rest of widget
}
```

## Key Takeaways

1. **Each feature gets its own WebSocket connection** - No more sharing a single connection
2. **Independent lifecycle** - Connections connect/disconnect based on listener count
3. **Type-safe streams** - Each data source emits domain-specific models
4. **Automatic cleanup** - Connections close when no listeners remain
5. **Unlimited endpoints** - Create as many connections as needed
6. **Interface-based** - Use `IWebSocketManager` and `IWebSocketConnection` for loose coupling

## Testing Multiple Connections

```dart
class MockWebSocketConnection extends Mock implements IWebSocketConnection {}
class MockWebSocketManager extends Mock implements IWebSocketManager {}

test('should handle multiple concurrent WebSocket connections', () async {
  final mockManager = MockWebSocketManager();
  final mockConnection1 = MockWebSocketConnection();
  final mockConnection2 = MockWebSocketConnection();

  when(() => mockManager.createConnection('/ws/auth'))
      .thenReturn(mockConnection1);
  when(() => mockManager.createConnection('/ws/notifications'))
      .thenReturn(mockConnection2);

  when(() => mockConnection1.connect(headers: any(named: 'headers')))
      .thenAnswer((_) async {});
  when(() => mockConnection2.connect(headers: any(named: 'headers')))
      .thenAnswer((_) async {});

  when(() => mockConnection1.messages).thenAnswer((_) => Stream.value('auth event'));
  when(() => mockConnection2.messages).thenAnswer((_) => Stream.value('notification'));

  // Both connections should work independently
  final authDataSource = AuthWebSocketDataSource(mockManager, tokenStorage, logger);
  final notifDataSource = NotificationWebSocketDataSource(mockManager, tokenStorage, logger);

  authDataSource.watchAuthChanges();
  notifDataSource.watchNotifications();

  verify(() => mockConnection1.connect(headers: any(named: 'headers'))).called(1);
  verify(() => mockConnection2.connect(headers: any(named: 'headers'))).called(1);
});
```

## Architecture Benefits

### Before (Tight Coupling)

```dart
class MyDataSource {
  final WebSocketManager _manager;  // Concrete class
  WebSocketConnection? _connection;  // Concrete class
  
  // Hard to test, hard to mock
}
```

### After (Loose Coupling with Interfaces)

```dart
class MyDataSource {
  final IWebSocketManager _manager;  // Interface
  IWebSocketConnection? _connection;  // Interface
  
  // Easy to test, easy to mock
}
```

### Hexagonal Architecture Flow

```text
┌─────────────────────────────────────────────────────────────┐
│                      Domain Layer                           │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              Ports (Interfaces)                      │   │
│  │  IWebSocketConnection    IWebSocketManager          │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                              │
                              │ implements
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                  Infrastructure Layer                        │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              Adapters (Implementations)              │   │
│  │  WebSocketConnection      WebSocketManager           │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```
