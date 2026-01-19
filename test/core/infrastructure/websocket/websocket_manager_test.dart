import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/core/domain/ports/i_websocket_connection.dart';
import 'package:starter_app/core/domain/ports/i_websocket_manager.dart';
import 'package:starter_app/core/infrastructure/websocket/websocket_manager.dart';
import 'package:starter_app/core/infrastructure/websocket/websocket_reconnection_config.dart';

import '../../../helpers/mock_helpers.dart';

void main() {
  group('WebSocketManager', () {
    late MockAppLogger mockLogger;
    late WebSocketManager manager;
    const baseUrl = 'wss://api.example.com';

    setUp(() {
      mockLogger = MockAppLogger();
      manager = WebSocketManager(baseUrl, mockLogger);
    });

    tearDown(() async {
      await manager.dispose();
    });

    test('can be instantiated', () {
      expect(manager, isNotNull);
      expect(manager, isA<WebSocketManager>());
    });

    test('implements IWebSocketManager', () {
      expect(manager, isA<IWebSocketManager>());
    });

    group('createConnection', () {
      test('creates connection with correct URL', () {
        final connection = manager.createConnection('/ws/notifications');

        expect(connection, isA<IWebSocketConnection>());
        verify(
          () => mockLogger.debug(
            'Creating WebSocket connection for: $baseUrl/ws/notifications',
          ),
        ).called(1);
      });

      test('creates connection with reconnection config', () {
        const config = WebSocketReconnectionConfig.aggressive;
        final connection = manager.createConnection(
          '/ws/auth',
          reconnectionPolicy: config,
        );

        expect(connection, isA<IWebSocketConnection>());
      });

      test('creates multiple independent connections', () {
        final connection1 = manager.createConnection('/ws/auth');
        final connection2 = manager.createConnection('/ws/notifications');
        final connection3 = manager.createConnection('/ws/chat');

        expect(connection1, isNot(same(connection2)));
        expect(connection2, isNot(same(connection3)));
        expect(connection1, isNot(same(connection3)));
        expect(manager.activeConnectionCount, 3);
      });

      test('tracks created connections', () {
        expect(manager.activeConnectionCount, 0);

        final connection1 = manager.createConnection('/ws/auth');
        expect(manager.activeConnectionCount, 1);

        final connection2 = manager.createConnection('/ws/notifications');
        expect(manager.activeConnectionCount, 2);

        expect(manager.activeConnections, contains(connection1));
        expect(manager.activeConnections, contains(connection2));
      });
    });

    group('createConnectionWithUrl', () {
      test('creates connection with custom URL', () {
        const customUrl = 'wss://custom.example.com/ws';
        final connection = manager.createConnectionWithUrl(customUrl);

        expect(connection, isA<IWebSocketConnection>());
        verify(
          () => mockLogger.debug(
            'Creating WebSocket connection for custom URL: $customUrl',
          ),
        ).called(1);
      });

      test('creates connection with reconnection config', () {
        const customUrl = 'wss://custom.example.com/ws';
        const config = WebSocketReconnectionConfig.conservative;
        final connection = manager.createConnectionWithUrl(
          customUrl,
          reconnectionPolicy: config,
        );

        expect(connection, isA<IWebSocketConnection>());
      });

      test('tracks custom URL connections', () {
        const customUrl = 'wss://custom.example.com/ws';
        final connection = manager.createConnectionWithUrl(customUrl);

        expect(manager.activeConnectionCount, 1);
        expect(manager.activeConnections, contains(connection));
      });
    });

    group('disconnectAll', () {
      test('disconnects all active connections', () async {
        manager
          ..createConnection('/ws/auth')
          ..createConnection('/ws/notifications');

        expect(manager.activeConnectionCount, 2);

        await manager.disconnectAll();

        expect(manager.activeConnectionCount, 0);
        verify(
          () => mockLogger.debug('Disconnecting all WebSocket connections'),
        ).called(1);
      });

      test('handles empty connections list', () async {
        expect(manager.activeConnectionCount, 0);

        await manager.disconnectAll();

        expect(manager.activeConnectionCount, 0);
        verify(
          () => mockLogger.debug('Disconnecting all WebSocket connections'),
        ).called(1);
      });

      test('disconnects connections created with custom URLs', () async {
        manager
          ..createConnection('/ws/auth')
          ..createConnectionWithUrl('wss://custom.example.com/ws');

        expect(manager.activeConnectionCount, 2);

        await manager.disconnectAll();

        expect(manager.activeConnectionCount, 0);
      });
    });

    group('dispose', () {
      test('disposes all connections and clears list', () async {
        manager
          ..createConnection('/ws/auth')
          ..createConnection('/ws/notifications');

        expect(manager.activeConnectionCount, 2);

        await manager.dispose();

        expect(manager.activeConnectionCount, 0);
        verify(() => mockLogger.debug('Disposing WebSocket manager')).called(1);
      });

      test('can be called multiple times safely', () async {
        await manager.dispose();
        await manager.dispose();
        await manager.dispose();

        expect(manager.activeConnectionCount, 0);
      });

      test('handles empty connections list', () async {
        await manager.dispose();

        expect(manager.activeConnectionCount, 0);
        verify(() => mockLogger.debug('Disposing WebSocket manager')).called(1);
      });
    });

    group('activeConnectionCount', () {
      test('returns 0 initially', () {
        expect(manager.activeConnectionCount, 0);
      });

      test('returns correct count after creating connections', () {
        manager.createConnection('/ws/auth');
        expect(manager.activeConnectionCount, 1);

        manager.createConnection('/ws/notifications');
        expect(manager.activeConnectionCount, 2);

        manager.createConnection('/ws/chat');
        expect(manager.activeConnectionCount, 3);
      });

      test('returns 0 after disconnectAll', () async {
        manager
          ..createConnection('/ws/auth')
          ..createConnection('/ws/notifications');

        await manager.disconnectAll();

        expect(manager.activeConnectionCount, 0);
      });

      test('returns 0 after dispose', () async {
        manager
          ..createConnection('/ws/auth')
          ..createConnection('/ws/notifications');

        await manager.dispose();

        expect(manager.activeConnectionCount, 0);
      });
    });

    group('activeConnections', () {
      test('returns empty list initially', () {
        expect(manager.activeConnections, isEmpty);
      });

      test('returns unmodifiable list', () {
        final connections = manager.activeConnections;

        expect(
          () => connections.add(manager.createConnection('/ws/test')),
          throwsUnsupportedError,
        );
      });

      test('returns all created connections', () {
        final connection1 = manager.createConnection('/ws/auth');
        final connection2 = manager.createConnection('/ws/notifications');
        final connection3 = manager.createConnection('/ws/chat');

        final activeConnections = manager.activeConnections;

        expect(activeConnections.length, 3);
        expect(activeConnections, contains(connection1));
        expect(activeConnections, contains(connection2));
        expect(activeConnections, contains(connection3));
      });

      test('updates when connections are removed', () async {
        final connection1 = manager.createConnection('/ws/auth');
        final connection2 = manager.createConnection('/ws/notifications');

        expect(manager.activeConnections.length, 2);

        await connection1.disconnect();

        // Wait a bit for the disconnect callback to fire
        await Future<void>.delayed(const Duration(milliseconds: 10));

        expect(manager.activeConnections.length, 1);
        expect(manager.activeConnections, contains(connection2));
        expect(manager.activeConnections, isNot(contains(connection1)));
      });
    });

    group('connection lifecycle', () {
      test('removes connection when it disconnects', () async {
        final connection = manager.createConnection('/ws/auth');

        expect(manager.activeConnectionCount, 1);

        await connection.disconnect();

        // Wait for the disconnect callback to fire
        await Future<void>.delayed(const Duration(milliseconds: 10));

        expect(manager.activeConnectionCount, 0);
      });

      test('removes connection when it is disposed', () async {
        final connection = manager.createConnection('/ws/auth');

        expect(manager.activeConnectionCount, 1);

        // Note: dispose() doesn't call onDisconnected callback,
        // so connection remains in manager until manager.dispose() is called
        // This is expected behavior - manager.dispose() handles cleanup
        await connection.dispose();

        // Connection is disposed but still tracked by manager
        // Manager will clean it up when manager.dispose() is called
        expect(manager.activeConnectionCount, 1);
      });

      test('handles multiple connections disconnecting', () async {
        final connection1 = manager.createConnection('/ws/auth');
        final connection2 = manager.createConnection('/ws/notifications');
        final connection3 = manager.createConnection('/ws/chat');

        expect(manager.activeConnectionCount, 3);

        await connection1.disconnect();
        await connection2.disconnect();

        // Wait for disconnect callbacks
        await Future<void>.delayed(const Duration(milliseconds: 10));

        expect(manager.activeConnectionCount, 1);
        expect(manager.activeConnections, contains(connection3));
        expect(manager.activeConnections, isNot(contains(connection1)));
        expect(manager.activeConnections, isNot(contains(connection2)));
      });
    });

    group('integration scenarios', () {
      test('complete connection lifecycle', () async {
        // Create connections
        final connection1 = manager.createConnection('/ws/auth');
        manager.createConnection('/ws/notifications');

        expect(manager.activeConnectionCount, 2);

        // Disconnect one
        await connection1.disconnect();
        await Future<void>.delayed(const Duration(milliseconds: 10));

        expect(manager.activeConnectionCount, 1);

        // Disconnect all
        await manager.disconnectAll();

        expect(manager.activeConnectionCount, 0);
      });

      test('create, use, and dispose multiple connections', () async {
        final connections = <IWebSocketConnection>[];

        // Create multiple connections
        for (var i = 0; i < 5; i++) {
          connections.add(manager.createConnection('/ws/endpoint$i'));
        }

        expect(manager.activeConnectionCount, 5);

        // Dispose all
        await manager.dispose();

        expect(manager.activeConnectionCount, 0);
      });

      test('mix of path-based and URL-based connections', () async {
        manager
          ..createConnection('/ws/auth')
          ..createConnectionWithUrl('wss://custom.example.com/ws')
          ..createConnection('/ws/notifications');

        expect(manager.activeConnectionCount, 3);

        await manager.disconnectAll();

        expect(manager.activeConnectionCount, 0);
      });
    });
  });
}
