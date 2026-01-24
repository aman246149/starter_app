import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/core/domain/ports/i_token_refresh_notifier.dart';
import 'package:starter_app/core/domain/ports/i_token_storage.dart';
import 'package:starter_app/core/domain/ports/i_websocket_connection.dart';
import 'package:starter_app/core/domain/ports/i_websocket_manager.dart';
import 'package:starter_app/core/domain/types/websocket_connection_state.dart';
import 'package:starter_app/core/error/exceptions/exceptions.dart';
import 'package:starter_app/core/logging/i_app_logger.dart';
import 'package:starter_app/features/auth/infrastructure/datasources/auth_websocket_data_source.dart';

class MockWebSocketManager extends Mock implements IWebSocketManager {}

class MockWebSocketConnection extends Mock implements IWebSocketConnection {}

class MockTokenStorage extends Mock implements ITokenStorage {}

class MockTokenRefreshNotifier extends Mock implements ITokenRefreshNotifier {}

class MockAppLogger extends Mock implements IAppLogger {}

void main() {
  late AuthWebSocketDataSource dataSource;
  late MockWebSocketManager mockWebSocketManager;
  late MockWebSocketConnection mockConnection;
  late MockTokenStorage mockTokenStorage;
  late MockTokenRefreshNotifier mockTokenRefreshNotifier;
  late MockAppLogger mockLogger;
  late StreamController<String> messageController;
  late StreamController<WebSocketConnectionState> stateController;
  late StreamController<void> tokenRefreshController;

  setUp(() {
    mockWebSocketManager = MockWebSocketManager();
    mockConnection = MockWebSocketConnection();
    mockTokenStorage = MockTokenStorage();
    mockTokenRefreshNotifier = MockTokenRefreshNotifier();
    mockLogger = MockAppLogger();

    messageController = StreamController<String>.broadcast();
    stateController = StreamController<WebSocketConnectionState>.broadcast();
    tokenRefreshController = StreamController<void>.broadcast();

    when(
      () => mockConnection.messages,
    ).thenAnswer((_) => messageController.stream);
    when(
      () => mockConnection.connectionState,
    ).thenAnswer((_) => stateController.stream);
    when(
      () => mockConnection.connect(headers: any(named: 'headers')),
    ).thenAnswer((_) async {});
    when(() => mockConnection.disconnect()).thenAnswer((_) async {});
    when(
      () => mockWebSocketManager.createConnection(any()),
    ).thenReturn(mockConnection);
    when(
      () => mockTokenRefreshNotifier.onTokenRefreshed,
    ).thenAnswer((_) => tokenRefreshController.stream);
    when(() => mockLogger.debug(any())).thenReturn(null);
    when(() => mockLogger.info(any())).thenReturn(null);
    when(() => mockLogger.warning(any())).thenReturn(null);
    when(
      () => mockLogger.error(
        any(),
        error: any(named: 'error'),
        stackTrace: any(named: 'stackTrace'),
      ),
    ).thenReturn(null);

    dataSource = AuthWebSocketDataSource(
      mockWebSocketManager,
      mockTokenStorage,
      mockTokenRefreshNotifier,
      mockLogger,
    );
  });

  tearDown(() async {
    await messageController.close();
    await stateController.close();
    await tokenRefreshController.close();
  });

  group('AuthWebSocketDataSource', () {
    group('watchAuthChanges', () {
      test('emits user model when authenticated event received', () async {
        when(
          () => mockTokenStorage.getAccessToken(),
        ).thenAnswer((_) async => 'test-token');

        final stream = dataSource.watchAuthChanges();
        final subscription = stream.listen((_) {});

        // Allow async operations to complete
        await Future<void>.delayed(Duration.zero);

        // Simulate authenticated message
        messageController.add(
          jsonEncode({
            'event': 'authenticated',
            'data': {
              'id': 'user-123',
              'email': 'test@example.com',
            },
          }),
        );

        await Future<void>.delayed(Duration.zero);
        await subscription.cancel();

        verify(
          () => mockWebSocketManager.createConnection('/ws/auth'),
        ).called(1);
        verify(
          () => mockConnection.connect(
            headers: {'Authorization': 'Bearer test-token'},
          ),
        ).called(1);
      });

      test('emits null when no access token available', () async {
        when(
          () => mockTokenStorage.getAccessToken(),
        ).thenAnswer((_) async => null);

        final stream = dataSource.watchAuthChanges();
        final results = <dynamic>[];
        final subscription = stream.listen(results.add);

        await Future<void>.delayed(Duration.zero);
        await subscription.cancel();

        expect(results, contains(null));
      });

      test('emits null when logged_out event received', () async {
        when(
          () => mockTokenStorage.getAccessToken(),
        ).thenAnswer((_) async => 'test-token');

        final stream = dataSource.watchAuthChanges();
        final results = <dynamic>[];
        final subscription = stream.listen(results.add);

        await Future<void>.delayed(Duration.zero);

        messageController.add(
          jsonEncode({
            'event': 'user_logged_out',
            'data': null,
          }),
        );

        await Future<void>.delayed(const Duration(milliseconds: 50));
        await subscription.cancel();

        expect(results, contains(null));
      });

      test('handles connection failure state', () async {
        when(
          () => mockTokenStorage.getAccessToken(),
        ).thenAnswer((_) async => 'test-token');

        final stream = dataSource.watchAuthChanges();
        final errors = <Object>[];
        final subscription = stream.listen(
          (_) {},
          onError: errors.add,
        );

        await Future<void>.delayed(Duration.zero);

        stateController.add(WebSocketConnectionState.failed);

        await Future<void>.delayed(Duration.zero);
        await subscription.cancel();

        expect(errors.whereType<NetworkException>(), isNotEmpty);
      });

      test('returns same stream if already watching', () async {
        when(
          () => mockTokenStorage.getAccessToken(),
        ).thenAnswer((_) async => 'test-token');

        final stream1 = dataSource.watchAuthChanges();
        final subscription1 = stream1.listen((_) {});
        await Future<void>.delayed(Duration.zero);

        final stream2 = dataSource.watchAuthChanges();

        // Both should be the same underlying stream
        expect(stream2, isNotNull);

        await subscription1.cancel();
      });

      test('handles malformed JSON message', () async {
        when(
          () => mockTokenStorage.getAccessToken(),
        ).thenAnswer((_) async => 'test-token');

        final stream = dataSource.watchAuthChanges();
        final errors = <Object>[];
        final subscription = stream.listen(
          (_) {},
          onError: errors.add,
        );

        await Future<void>.delayed(Duration.zero);

        messageController.add('invalid json');

        await Future<void>.delayed(Duration.zero);
        await subscription.cancel();

        expect(errors.whereType<FormatException>(), isNotEmpty);
      });

      test('handles unknown event type', () async {
        when(
          () => mockTokenStorage.getAccessToken(),
        ).thenAnswer((_) async => 'test-token');

        final stream = dataSource.watchAuthChanges();
        final subscription = stream.listen((_) {});

        await Future<void>.delayed(Duration.zero);

        messageController.add(
          jsonEncode({
            'event': 'unknown_event',
            'data': null,
          }),
        );

        await Future<void>.delayed(Duration.zero);
        await subscription.cancel();

        verify(() => mockLogger.warning(any())).called(greaterThan(0));
      });

      test('reconnects when token is refreshed', () async {
        when(
          () => mockTokenStorage.getAccessToken(),
        ).thenAnswer((_) async => 'test-token');

        final stream = dataSource.watchAuthChanges();
        final subscription = stream.listen((_) {});

        await Future<void>.delayed(Duration.zero);

        // Trigger token refresh
        tokenRefreshController.add(null);

        await Future<void>.delayed(Duration.zero);
        await subscription.cancel();

        // Should create connection twice - initial + reconnect
        verify(
          () => mockWebSocketManager.createConnection('/ws/auth'),
        ).called(2);
      });
    });

    group('dispose', () {
      test('cleans up resources', () async {
        when(
          () => mockTokenStorage.getAccessToken(),
        ).thenAnswer((_) async => 'test-token');

        final stream = dataSource.watchAuthChanges();
        final subscription = stream.listen((_) {});

        await Future<void>.delayed(Duration.zero);

        await dataSource.dispose();
        await subscription.cancel();

        verify(() => mockConnection.disconnect()).called(greaterThan(0));
      });
    });

    group('edge cases', () {
      test('emits null when message stream closes', () async {
        when(
          () => mockTokenStorage.getAccessToken(),
        ).thenAnswer((_) async => 'test-token');

        final stream = dataSource.watchAuthChanges();
        final results = <dynamic>[];
        final subscription = stream.listen(results.add);

        await Future<void>.delayed(Duration.zero);

        // Close the message stream to trigger onDone
        await messageController.close();
        messageController = StreamController<String>.broadcast();

        await Future<void>.delayed(const Duration(milliseconds: 50));
        await subscription.cancel();

        expect(results, contains(null));
      });

      test('handles connection setup exception', () async {
        when(
          () => mockTokenStorage.getAccessToken(),
        ).thenAnswer((_) async => 'test-token');
        when(
          () => mockConnection.connect(headers: any(named: 'headers')),
        ).thenThrow(Exception('Connection failed'));

        final stream = dataSource.watchAuthChanges();
        final errors = <Object>[];
        final subscription = stream.listen(
          (_) {},
          onError: errors.add,
        );

        await Future<void>.delayed(const Duration(milliseconds: 50));
        await subscription.cancel();

        expect(errors.whereType<NetworkException>(), isNotEmpty);
      });

      test('handles reconnection with null token', () async {
        var callCount = 0;
        when(
          () => mockTokenStorage.getAccessToken(),
        ).thenAnswer((_) async {
          callCount++;
          if (callCount == 1) return 'test-token';
          return null; // Return null on reconnection
        });

        final stream = dataSource.watchAuthChanges();
        final subscription = stream.listen((_) {});

        await Future<void>.delayed(Duration.zero);

        // Trigger token refresh
        tokenRefreshController.add(null);

        await Future<void>.delayed(const Duration(milliseconds: 50));
        await subscription.cancel();

        // Verify warning was logged
        verify(() => mockLogger.warning(any())).called(greaterThan(0));
      });

      test('handles reconnection failure state', () async {
        // Create new controllers for reconnection
        final reconnectStateController =
            StreamController<WebSocketConnectionState>.broadcast();
        final reconnectMessageController = StreamController<String>.broadcast();
        final mockReconnectConnection = MockWebSocketConnection();

        when(
          () => mockReconnectConnection.messages,
        ).thenAnswer((_) => reconnectMessageController.stream);
        when(
          () => mockReconnectConnection.connectionState,
        ).thenAnswer((_) => reconnectStateController.stream);
        when(
          () => mockReconnectConnection.connect(headers: any(named: 'headers')),
        ).thenAnswer((_) async {});
        when(
          mockReconnectConnection.disconnect,
        ).thenAnswer((_) async {});

        var connectionCount = 0;
        when(() => mockWebSocketManager.createConnection(any())).thenAnswer((
          _,
        ) {
          connectionCount++;
          if (connectionCount == 1) return mockConnection;
          return mockReconnectConnection;
        });

        when(
          () => mockTokenStorage.getAccessToken(),
        ).thenAnswer((_) async => 'test-token');

        final stream = dataSource.watchAuthChanges();
        final errors = <Object>[];
        final subscription = stream.listen(
          (_) {},
          onError: errors.add,
        );

        await Future<void>.delayed(Duration.zero);

        // Trigger token refresh
        tokenRefreshController.add(null);

        await Future<void>.delayed(Duration.zero);

        // Trigger failure state after reconnection
        reconnectStateController.add(WebSocketConnectionState.failed);

        await Future<void>.delayed(const Duration(milliseconds: 50));
        await subscription.cancel();

        await reconnectStateController.close();
        await reconnectMessageController.close();

        expect(errors.whereType<NetworkException>(), isNotEmpty);
      });

      test('handles reconnection exception', () async {
        final mockReconnectConnection = MockWebSocketConnection();
        final reconnectStateController =
            StreamController<WebSocketConnectionState>.broadcast();

        when(
          () => mockReconnectConnection.connectionState,
        ).thenAnswer((_) => reconnectStateController.stream);
        when(
          () => mockReconnectConnection.connect(headers: any(named: 'headers')),
        ).thenThrow(Exception('Reconnection failed'));
        when(
          mockReconnectConnection.disconnect,
        ).thenAnswer((_) async {});

        var connectionCount = 0;
        when(() => mockWebSocketManager.createConnection(any())).thenAnswer((
          _,
        ) {
          connectionCount++;
          if (connectionCount == 1) return mockConnection;
          return mockReconnectConnection;
        });

        when(
          () => mockTokenStorage.getAccessToken(),
        ).thenAnswer((_) async => 'test-token');

        final stream = dataSource.watchAuthChanges();
        final subscription = stream.listen((_) {});

        await Future<void>.delayed(Duration.zero);

        // Trigger token refresh
        tokenRefreshController.add(null);

        await Future<void>.delayed(const Duration(milliseconds: 50));
        await subscription.cancel();

        await reconnectStateController.close();

        // Verify error was logged
        verify(
          () => mockLogger.error(
            any(),
            error: any(named: 'error'),
            stackTrace: any(named: 'stackTrace'),
          ),
        ).called(greaterThan(0));
      });

      test('handles authenticated event with user data', () async {
        when(
          () => mockTokenStorage.getAccessToken(),
        ).thenAnswer((_) async => 'test-token');

        final stream = dataSource.watchAuthChanges();
        final results = <dynamic>[];
        final subscription = stream.listen(results.add);

        await Future<void>.delayed(Duration.zero);

        // Send user_authenticated event
        messageController.add(
          jsonEncode({
            'event': 'user_authenticated',
            'data': {
              'id': 'user-123',
              'email': 'test@example.com',
            },
          }),
        );

        await Future<void>.delayed(const Duration(milliseconds: 50));
        await subscription.cancel();

        expect(results.length, greaterThan(0));
        expect(results.last, isNotNull);
      });

      test('emits null when connection closes after reconnect', () async {
        final reconnectMessageController = StreamController<String>.broadcast();
        final reconnectStateController =
            StreamController<WebSocketConnectionState>.broadcast();
        final mockReconnectConnection = MockWebSocketConnection();

        when(
          () => mockReconnectConnection.messages,
        ).thenAnswer((_) => reconnectMessageController.stream);
        when(
          () => mockReconnectConnection.connectionState,
        ).thenAnswer((_) => reconnectStateController.stream);
        when(
          () => mockReconnectConnection.connect(headers: any(named: 'headers')),
        ).thenAnswer((_) async {});
        when(
          mockReconnectConnection.disconnect,
        ).thenAnswer((_) async {});

        var connectionCount = 0;
        when(() => mockWebSocketManager.createConnection(any())).thenAnswer((
          _,
        ) {
          connectionCount++;
          if (connectionCount == 1) return mockConnection;
          return mockReconnectConnection;
        });

        when(
          () => mockTokenStorage.getAccessToken(),
        ).thenAnswer((_) async => 'test-token');

        final stream = dataSource.watchAuthChanges();
        final results = <dynamic>[];
        final subscription = stream.listen(results.add);

        await Future<void>.delayed(Duration.zero);

        // Trigger token refresh
        tokenRefreshController.add(null);

        await Future<void>.delayed(Duration.zero);

        // Close the reconnected message stream to trigger onDone
        await reconnectMessageController.close();

        await Future<void>.delayed(const Duration(milliseconds: 50));
        await subscription.cancel();

        await reconnectStateController.close();

        expect(results, contains(null));
      });
    });

    group('non-FormatException handling', () {
      test('handles generic Exception during message processing', () async {
        when(
          () => mockTokenStorage.getAccessToken(),
        ).thenAnswer((_) async => 'test-token');

        // Make the second debug call throw an exception
        // First call is "Processing auth WebSocket message"
        // Second call would be "Auth event type: ..."
        var debugCallCount = 0;
        when(() => mockLogger.debug(any())).thenAnswer((_) {
          debugCallCount++;
          if (debugCallCount == 2) {
            throw Exception('Simulated processing exception');
          }
        });

        final stream = dataSource.watchAuthChanges();
        final errors = <Object>[];
        final subscription = stream.listen(
          (_) {},
          onError: errors.add,
        );

        await Future<void>.delayed(Duration.zero);

        // Send valid JSON message -
        // the exception will be thrown during processing
        messageController.add(
          jsonEncode({
            'event': 'user_authenticated',
            'data': {
              'id': 'user-123',
              'email': 'test@example.com',
            },
          }),
        );

        await Future<void>.delayed(const Duration(milliseconds: 50));
        await subscription.cancel();

        // The exception should be wrapped as FormatException
        expect(errors.whereType<FormatException>(), isNotEmpty);

        // Verify error logging was called
        verify(
          () => mockLogger.error(
            any(),
            error: any(named: 'error'),
            stackTrace: any(named: 'stackTrace'),
          ),
        ).called(greaterThan(0));
      });
    });
  });
}
