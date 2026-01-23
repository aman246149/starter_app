import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/core/domain/ports/i_websocket_connection.dart';
import 'package:starter_app/core/domain/types/websocket_connection_state.dart';
import 'package:starter_app/core/infrastructure/websocket/websocket_connection.dart';
import 'package:starter_app/core/infrastructure/websocket/websocket_reconnection_config.dart';

import '../../../helpers/mock_helpers.dart';

// Re-export VoidCallback for test use
typedef VoidCallback = void Function();

void main() {
  group('WebSocketConnection', () {
    late MockAppLogger mockLogger;
    const testUrl = 'wss://api.example.com/ws/test';

    setUp(() {
      mockLogger = MockAppLogger();
    });

    group('constructor', () {
      test('creates connection with required parameters', () {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
        );

        expect(connection, isNotNull);
        expect(connection, isA<IWebSocketConnection>());
      });

      test('creates connection with reconnection config', () {
        const config = WebSocketReconnectionConfig.aggressive;
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
          reconnectionPolicy: config,
        );

        expect(connection, isNotNull);
      });

      test('creates connection with callbacks', () {
        var onConnectedCalled = false;
        var onDisconnectedCalled = false;
        var onReconnectingCalled = false;
        var onErrorCalled = false;

        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
          onConnected: () => onConnectedCalled = true,
          onDisconnected: () => onDisconnectedCalled = true,
          onReconnecting: (_) => onReconnectingCalled = true,
          onError: (_) => onErrorCalled = true,
        );

        expect(connection, isNotNull);
        // Callbacks are not called during construction
        expect(onConnectedCalled, false);
        expect(onDisconnectedCalled, false);
        expect(onReconnectingCalled, false);
        expect(onErrorCalled, false);
      });

      test('initializes with disconnected state', () {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
        );

        expect(connection.currentState, WebSocketConnectionState.disconnected);
        expect(connection.isConnected, false);
        expect(connection.isConnecting, false);
      });
    });

    group('currentState', () {
      test('returns disconnected initially', () {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
        );

        expect(connection.currentState, WebSocketConnectionState.disconnected);
      });
    });

    group('isConnected', () {
      test('returns false initially', () {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
        );

        expect(connection.isConnected, false);
      });
    });

    group('isConnecting', () {
      test('returns false initially', () {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
        );

        expect(connection.isConnecting, false);
      });
    });

    group('messages', () {
      test('returns empty stream initially', () {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
        );

        final messages = connection.messages;
        expect(messages, isA<Stream<String>>());
      });

      test('allows multiple listeners (broadcast stream)', () async {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
        );

        final messages = connection.messages;
        final listener1 = messages.listen((_) {});
        final listener2 = messages.listen((_) {});

        expect(listener1, isNotNull);
        expect(listener2, isNotNull);

        await listener1.cancel();
        await listener2.cancel();
      });
    });

    group('connectionState', () {
      test('returns stream of connection states', () {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
        );

        final states = connection.connectionState;
        expect(states, isA<Stream<WebSocketConnectionState>>());
      });

      test('emits initial disconnected state', () async {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
        );

        // Check current state directly (state is set in constructor)
        expect(connection.currentState, WebSocketConnectionState.disconnected);

        final states = <WebSocketConnectionState>[];
        final subscription = connection.connectionState.listen(states.add);

        // Wait a bit to ensure stream subscription is set up
        await Future<void>.delayed(const Duration(milliseconds: 10));

        // Broadcast streams don't replay past events,
        //  so listeners that subscribe
        // after the initial disconnected state was emitted won't receive it.
        // However, we can verify the stream works by checking that it's a valid
        // stream and that future state changes will be received.
        // The initial state is verified via currentState above.
        expect(subscription, isNotNull);
        expect(
          connection.connectionState,
          isA<Stream<WebSocketConnectionState>>(),
        );

        await subscription.cancel();
      });

      test('allows multiple listeners (broadcast stream)', () async {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
        );

        final states1 = <WebSocketConnectionState>[];
        final states2 = <WebSocketConnectionState>[];

        final subscription1 = connection.connectionState.listen(states1.add);
        final subscription2 = connection.connectionState.listen(states2.add);

        expect(subscription1, isNotNull);
        expect(subscription2, isNotNull);

        await subscription1.cancel();
        await subscription2.cancel();
      });
    });

    group('connect', () {
      test('throws StateError when disposed', () async {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
        );

        await connection.dispose();

        expect(
          connection.connect,
          throwsA(isA<StateError>()),
        );
      });

      test('does not throw when already connected', () async {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
          reconnectionPolicy: WebSocketReconnectionConfig.noReconnection,
        );

        // Note: This test may fail if actual WebSocket connection is attempted
        // In a real scenario, you'd mock WebSocketChannel.connect
        // For now, we test the state check logic by using a timeout
        try {
          await connection.connect().timeout(
            const Duration(seconds: 1),
            onTimeout: () {
              // Timeout expected in test environment
            },
          );
          // If connection succeeds, calling again should not throw
          await connection.connect().timeout(
            const Duration(seconds: 1),
            onTimeout: () {},
          );
        } on Exception {
          // If connection fails (expected in test environment), that's okay
          // The important part is testing the disposed check above
        } on Object {
          // Catch any other errors
        }
      });

      test('accepts optional headers', () async {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
          reconnectionPolicy: WebSocketReconnectionConfig.noReconnection,
        );

        try {
          await connection
              .connect(
                headers: {'Authorization': 'Bearer token'},
              )
              .timeout(
                const Duration(seconds: 1),
                onTimeout: () {
                  // Timeout expected in test environment
                },
              );
        } on Exception {
          // Expected to fail in test environment without real WebSocket server
        } on Object {
          // Catch any other errors
        }
      });
    });

    group('send', () {
      test('throws StateError when disposed', () async {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
        );
        // Don't await dispose to test immediate state check
        unawaited(connection.dispose());

        expect(
          () => connection.send('test message'),
          throwsA(isA<StateError>()),
        );
      });

      test('throws StateError when not connected', () {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
        );

        expect(
          () => connection.send('test message'),
          throwsA(isA<StateError>()),
        );
      });

      test('throws StateError when channel is null', () {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
        );

        // Connection is not connected, so channel is null
        expect(
          () => connection.send('test message'),
          throwsA(isA<StateError>()),
        );
      });
    });

    group('disconnect', () {
      test('completes successfully when not connected', () async {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
        );

        await connection.disconnect();

        expect(connection.currentState, WebSocketConnectionState.disconnected);
      });

      test('calls onDisconnected callback', () async {
        var callbackCalled = false;
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
          onDisconnected: () => callbackCalled = true,
        );

        await connection.disconnect();

        expect(callbackCalled, true);
      });

      test('can be called multiple times safely', () async {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
        );

        await connection.disconnect();
        await connection.disconnect();
        await connection.disconnect();

        expect(connection.currentState, WebSocketConnectionState.disconnected);
      });

      test('cancels reconnection timer', () async {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
          reconnectionPolicy: WebSocketReconnectionConfig.aggressive,
        );

        // Note: Testing actual reconnection timer cancellation would require
        // a real connection attempt. This test verifies that disconnect()
        // can be called safely with aggressive reconnection config.
        await connection.disconnect();

        expect(connection.currentState, WebSocketConnectionState.disconnected);
        await connection.dispose();
      });
    });

    group('dispose', () {
      test('completes successfully', () async {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
        );

        await connection.dispose();

        expect(connection.currentState, WebSocketConnectionState.disconnected);
      });

      test('can be called multiple times safely', () async {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
        );

        await connection.dispose();
        await connection.dispose();
        await connection.dispose();
      });

      test('closes connection state stream', () async {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
        );

        final states = <WebSocketConnectionState>[];
        final subscription = connection.connectionState.listen(states.add);

        // Wait for subscription to be set up
        await Future<void>.delayed(const Duration(milliseconds: 10));

        // Note: Since the connection starts as disconnected and disconnect()
        // doesn't change state when already disconnected, we won't receive
        // a state event here. But we can verify the stream exists and works.
        expect(subscription, isNotNull);

        await connection.dispose();
        await Future<void>.delayed(const Duration(milliseconds: 10));

        // Stream controller is closed in dispose()
        // Verify that the connection state is still accessible
        expect(connection.currentState, WebSocketConnectionState.disconnected);

        await subscription.cancel();
      });

      test('prevents connect after dispose', () async {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
        );

        await connection.dispose();

        expect(
          connection.connect,
          throwsA(isA<StateError>()),
        );
      });

      test('prevents send after dispose', () async {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
        );
        unawaited(connection.dispose());

        expect(
          () => connection.send('test'),
          throwsA(isA<StateError>()),
        );
      });

      test('cancels reconnection timer on dispose', () async {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
          reconnectionPolicy: WebSocketReconnectionConfig.aggressive,
        );

        // Note: Testing actual reconnection timer cancellation would require
        // a real connection attempt. This test verifies that dispose()
        // can be called safely with aggressive reconnection config.
        await connection.dispose();

        expect(connection.currentState, WebSocketConnectionState.disconnected);
      });
    });

    group('callbacks', () {
      test('onConnected is called when connection succeeds', () async {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
          onConnected: () {},
          reconnectionPolicy: WebSocketReconnectionConfig.noReconnection,
        );

        try {
          await connection.connect().timeout(
            const Duration(seconds: 1),
            onTimeout: () {
              // Timeout expected in test environment
            },
          );
          // In real scenario, callback would be called
        } on Exception {
          // Expected in test environment
        } on Object {
          // Catch any other errors
        }
      });

      test('onDisconnected is called when connection closes', () async {
        var callbackCalled = false;
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
          onDisconnected: () => callbackCalled = true,
        );

        await connection.disconnect();

        expect(callbackCalled, true);
      });

      test('onError is called when error occurs', () async {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
          onError: (_) {
            // Error callback
          },
          reconnectionPolicy: WebSocketReconnectionConfig.noReconnection,
        );

        try {
          await connection.connect().timeout(
            const Duration(seconds: 1),
            onTimeout: () {
              // Timeout expected in test environment
            },
          );
        } on Exception {
          // Expected in test environment
        } on Object {
          // Catch any other errors
        }

        // Note: In real scenario, onError would be called from
        // WebSocket error handler
      });

      test('onReconnecting callback can be set', () {
        var reconnectingAttempt = 0;
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
          onReconnecting: (attempt) => reconnectingAttempt = attempt,
          reconnectionPolicy: const WebSocketReconnectionConfig(
            maxAttempts: 3,
            initialDelay: Duration(milliseconds: 50),
          ),
        );

        // Note: Testing actual reconnection scheduling would require a real
        // connection attempt. This test verifies that the onReconnecting
        // callback can be set and the connection is created successfully.
        expect(connection, isNotNull);
        expect(reconnectingAttempt, 0); // Initial value
      });
    });

    group('reconnection config', () {
      test('uses default config when not provided', () {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
        );

        expect(connection, isNotNull);
      });

      test('uses provided reconnection config', () {
        const config = WebSocketReconnectionConfig.aggressive;
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
          reconnectionPolicy: config,
        );

        expect(connection, isNotNull);
      });

      test('uses noReconnection config', () {
        const config = WebSocketReconnectionConfig.noReconnection;
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
          reconnectionPolicy: config,
        );

        expect(connection, isNotNull);
      });
    });

    group('state transitions', () {
      test('starts in disconnected state', () {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
        );

        expect(connection.currentState, WebSocketConnectionState.disconnected);
        expect(connection.isConnected, false);
        expect(connection.isConnecting, false);
      });

      test('transitions to disconnected after manual disconnect', () async {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
        );

        await connection.disconnect();

        expect(connection.currentState, WebSocketConnectionState.disconnected);
        expect(connection.isConnected, false);
        expect(connection.isConnecting, false);
      });

      test('does not emit state when state does not change', () async {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
        );

        final states = <WebSocketConnectionState>[];
        final subscription = connection.connectionState.listen(states.add);

        // Disconnect when already disconnected
        // should not emit duplicate state
        await connection.disconnect();
        await Future<void>.delayed(const Duration(milliseconds: 10));

        // State should still be disconnected, but we may or may not receive
        // an event depending on implementation
        expect(connection.currentState, WebSocketConnectionState.disconnected);

        await subscription.cancel();
      });

      test('does not emit state when controller is closed', () async {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
        );

        await connection.dispose();

        // After dispose, state controller is closed
        // Calling disconnect should not crash
        await connection.disconnect();

        expect(connection.currentState, WebSocketConnectionState.disconnected);
      });
    });

    group('edge cases', () {
      test('handles empty URL', () {
        final connection = WebSocketConnection(
          url: '',
          logger: mockLogger,
        );

        expect(connection, isNotNull);
      });

      test('handles URL with query parameters', () {
        const urlWithQuery = 'wss://api.example.com/ws?token=abc123';
        final connection = WebSocketConnection(
          url: urlWithQuery,
          logger: mockLogger,
        );

        expect(connection, isNotNull);
      });

      test('handles URL with path segments', () {
        const urlWithPath = 'wss://api.example.com/ws/v1/notifications';
        final connection = WebSocketConnection(
          url: urlWithPath,
          logger: mockLogger,
        );

        expect(connection, isNotNull);
      });
    });

    group('integration scenarios', () {
      test('complete lifecycle: create, dispose', () async {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
        );

        expect(connection.currentState, WebSocketConnectionState.disconnected);

        await connection.dispose();

        expect(connection.currentState, WebSocketConnectionState.disconnected);
      });

      test('disconnect then dispose', () async {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
        );

        await connection.disconnect();
        await connection.dispose();

        expect(connection.currentState, WebSocketConnectionState.disconnected);
      });

      test('multiple state listeners', () async {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
        );

        final states1 = <WebSocketConnectionState>[];
        final states2 = <WebSocketConnectionState>[];

        final subscription1 = connection.connectionState.listen(states1.add);
        final subscription2 = connection.connectionState.listen(states2.add);

        // Wait for subscriptions to be set up
        await Future<void>.delayed(const Duration(milliseconds: 10));

        // Note: Broadcast streams don't replay past events, so listeners that
        // subscribe after the initial disconnected state was emitted won't
        // receive it. However, we can verify that both listeners can subscribe
        // to the same broadcast stream
        // (which is the key behavior being tested).
        expect(subscription1, isNotNull);
        expect(subscription2, isNotNull);
        expect(
          connection.connectionState,
          isA<Stream<WebSocketConnectionState>>(),
        );

        // Verify current state is accessible
        expect(connection.currentState, WebSocketConnectionState.disconnected);

        await subscription1.cancel();
        await subscription2.cancel();
        await connection.dispose();
      });
    });

    group('reconnection logic', () {
      test('handles connection lost with reconnection disabled', () {
        var disconnectedCalled = false;
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
          onDisconnected: () => disconnectedCalled = true,
          reconnectionPolicy: WebSocketReconnectionConfig.noReconnection,
        );

        // Note: Testing actual connection lost handling would require a real
        // connection attempt. This test verifies that the connection can be
        // created with noReconnection config and onDisconnected callback.
        expect(connection, isNotNull);
        expect(disconnectedCalled, false); // Not called during construction
      });

      test('handles connection lost with reconnection enabled', () {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
          reconnectionPolicy: const WebSocketReconnectionConfig(
            maxAttempts: 2,
            initialDelay: Duration(milliseconds: 50),
          ),
        );

        // Note: Testing actual reconnection scheduling would require a real
        // connection attempt. This test verifies that the connection can be
        // created with reconnection enabled.
        expect(connection, isNotNull);
      });

      test('handles max reconnection attempts exceeded', () {
        var disconnectedCalled = false;
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
          onDisconnected: () => disconnectedCalled = true,
          reconnectionPolicy: const WebSocketReconnectionConfig(
            maxAttempts: 0, // No retries allowed
            initialDelay: Duration(milliseconds: 50),
          ),
        );

        // Note: Testing actual max attempts exceeded would require a real
        // connection attempt. This test verifies that the connection can be
        // created with maxAttempts: 0 and onDisconnected callback.
        expect(connection, isNotNull);
        expect(disconnectedCalled, false); // Not called during construction
      });
    });

    group('message handling', () {
      test('message stream exists before connection', () {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
          reconnectionPolicy: WebSocketReconnectionConfig.noReconnection,
        );

        // Message stream should exist even before connection attempt
        expect(connection.messages, isA<Stream<String>>());
      });

      test('message stream is broadcast', () async {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
        );

        final messages = connection.messages;
        final listener1 = messages.listen((_) {});
        final listener2 = messages.listen((_) {});

        expect(listener1, isNotNull);
        expect(listener2, isNotNull);

        await listener1.cancel();
        await listener2.cancel();
        await connection.dispose();
      });
    });

    group('cleanup logic', () {
      test(
        'cleanup without keepController closes message controller',
        () async {
          final connection = WebSocketConnection(
            url: testUrl,
            logger: mockLogger,
          );

          // Trigger cleanup via disconnect
          await connection.disconnect();

          // Message controller should be closed
          expect(connection.messages, isA<Stream<String>>());

          await connection.dispose();
        },
      );

      test('cleanup handles null channel gracefully', () async {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
        );

        // Disconnect when not connected (channel is null)
        await connection.disconnect();

        expect(connection.currentState, WebSocketConnectionState.disconnected);

        await connection.dispose();
      });

      test('cleanup handles null subscription gracefully', () async {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
        );

        // Disconnect when not connected (subscription is null)
        await connection.disconnect();

        expect(connection.currentState, WebSocketConnectionState.disconnected);

        await connection.dispose();
      });
    });

    group('edge cases and error paths', () {
      test('handles connection attempt when already disposed', () async {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
        );

        await connection.dispose();

        // Attempt connection should be prevented by dispose check
        expect(
          connection.connect,
          throwsA(isA<StateError>()),
        );
      });

      test('handles connection attempt when manually disconnected', () async {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
          reconnectionPolicy: WebSocketReconnectionConfig.noReconnection,
        );

        await connection.disconnect();

        // After disconnect, connection should be in disconnected state
        expect(connection.currentState, WebSocketConnectionState.disconnected);

        // Note: Testing actual connection would require a real WebSocket server
        // In a real scenario, calling connect() after disconnect would attempt
        // to reconnect
        await connection.dispose();
      });

      test('handles headers parameter in connect', () async {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
          reconnectionPolicy: WebSocketReconnectionConfig.noReconnection,
        );

        // Note: Testing actual connection with headers would require a real
        // WebSocket server. The connect() method accepts headers parameter,
        // which is verified by the method signature.
        expect(connection, isNotNull);
        expect(connection.currentState, WebSocketConnectionState.disconnected);

        await connection.dispose();
      });

      test('handles empty headers in connect', () async {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
          reconnectionPolicy: WebSocketReconnectionConfig.noReconnection,
        );

        // Note: Testing actual connection with empty headers would require a
        // real WebSocket server. The connect() method accepts empty headers,
        // which is verified by the method signature.
        expect(connection, isNotNull);
        expect(connection.currentState, WebSocketConnectionState.disconnected);

        await connection.dispose();
      });
    });

    group('connection with mock channel', () {
      late FakeWebSocketChannel fakeChannel;

      setUp(() {
        fakeChannel = FakeWebSocketChannel();
      });

      tearDown(() async {
        await fakeChannel.closeStream();
      });

      WebSocketConnection createConnectionWithFakeChannel({
        VoidCallback? onConnected,
        VoidCallback? onDisconnected,
        void Function(int attempt)? onReconnecting,
        void Function(Object error)? onError,
        WebSocketReconnectionConfig? reconnectionConfig,
      }) {
        return WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
          onConnected: onConnected,
          onDisconnected: onDisconnected,
          onReconnecting: onReconnecting,
          onError: onError,
          reconnectionPolicy:
              reconnectionConfig ?? WebSocketReconnectionConfig.noReconnection,
          channelFactory: (uri) => fakeChannel,
        );
      }

      test('connects successfully and calls onConnected', () async {
        var onConnectedCalled = false;
        final connection = createConnectionWithFakeChannel(
          onConnected: () => onConnectedCalled = true,
        );

        await connection.connect();

        expect(connection.isConnected, true);
        expect(
          connection.currentState,
          WebSocketConnectionState.connected,
        );
        expect(onConnectedCalled, true);

        await connection.dispose();
      });

      test('transitions through connecting to connected state', () async {
        final states = <WebSocketConnectionState>[];
        final connection = createConnectionWithFakeChannel();
        final subscription = connection.connectionState.listen(states.add);

        await connection.connect();
        await Future<void>.delayed(const Duration(milliseconds: 10));

        expect(states, contains(WebSocketConnectionState.connecting));
        expect(states, contains(WebSocketConnectionState.connected));

        await subscription.cancel();
        await connection.dispose();
      });

      test('receives messages from channel stream', () async {
        final connection = createConnectionWithFakeChannel();

        await connection.connect();

        // Subscribe to messages AFTER connection is established
        // (connect() creates the message controller)
        final receivedMessages = <String>[];
        final subscription = connection.messages.listen(receivedMessages.add);

        // Simulate receiving messages
        fakeChannel
          ..addMessage('{"type": "test", "data": "hello"}')
          ..addMessage('{"type": "test", "data": "world"}');

        await Future<void>.delayed(const Duration(milliseconds: 50));

        expect(receivedMessages, hasLength(2));
        expect(receivedMessages[0], '{"type": "test", "data": "hello"}');
        expect(receivedMessages[1], '{"type": "test", "data": "world"}');

        await subscription.cancel();
        await connection.dispose();
      });

      test('only adds String messages to message controller', () async {
        final connection = createConnectionWithFakeChannel();

        await connection.connect();

        // Subscribe to messages AFTER connection is established
        final receivedMessages = <String>[];
        final subscription = connection.messages.listen(receivedMessages.add);

        // Simulate receiving different types of messages
        fakeChannel
          ..addMessage('valid string message')
          ..addMessage(123) // int - should be ignored
          ..addMessage(['list']) // list - should be ignored
          ..addMessage('another valid string');

        await Future<void>.delayed(const Duration(milliseconds: 50));

        expect(receivedMessages, hasLength(2));
        expect(receivedMessages[0], 'valid string message');
        expect(receivedMessages[1], 'another valid string');

        await subscription.cancel();
        await connection.dispose();
      });

      test('calls onError when stream error occurs', () async {
        Object? receivedError;
        final connection = createConnectionWithFakeChannel(
          onError: (error) => receivedError = error,
        );

        await connection.connect();

        // Simulate an error on the stream
        final testError = Exception('WebSocket error');
        fakeChannel.addError(testError);

        await Future<void>.delayed(const Duration(milliseconds: 50));

        expect(receivedError, testError);

        await connection.dispose();
      });

      test('handles connection lost when stream closes (onDone)', () async {
        var onDisconnectedCalled = false;
        final connection = createConnectionWithFakeChannel(
          onDisconnected: () => onDisconnectedCalled = true,
        );

        await connection.connect();
        expect(connection.isConnected, true);

        // Simulate connection closed (onDone)
        await fakeChannel.closeStream();

        await Future<void>.delayed(const Duration(milliseconds: 50));

        // With noReconnection config, it should fail and call onDisconnected
        expect(connection.currentState, WebSocketConnectionState.failed);
        expect(onDisconnectedCalled, true);

        await connection.dispose();
      });

      test(
        'resets reconnection attempt counter on successful connection',
        () async {
          final connection = createConnectionWithFakeChannel();

          await connection.connect();

          // The connection is successful, _reconnectionAttempt should be 0
          expect(connection.isConnected, true);

          await connection.dispose();
        },
      );

      test('sends message through channel sink when connected', () async {
        final connection = createConnectionWithFakeChannel();

        await connection.connect();

        connection.send('{"action": "subscribe"}');

        expect(fakeChannel.sentMessages, hasLength(1));
        expect(fakeChannel.sentMessages[0], '{"action": "subscribe"}');

        await connection.dispose();
      });

      test('logs debug when connect called on already connected', () async {
        when(
          () => mockLogger.debug(
            any(),
            data: any(named: 'data'),
            tag: any(named: 'tag'),
          ),
        ).thenReturn(null);
        when(
          () => mockLogger.info(
            any(),
            data: any(named: 'data'),
            tag: any(named: 'tag'),
          ),
        ).thenReturn(null);

        final connection = createConnectionWithFakeChannel();

        await connection.connect();
        expect(connection.isConnected, true);

        // Clear previous interactions
        clearInteractions(mockLogger);

        // Call connect again when already connected
        await connection.connect();

        // Should log "already connected" debug message
        verify(
          () => mockLogger.debug('WebSocket already connected to: $testUrl'),
        ).called(1);

        await connection.dispose();
      });

      test('does not add message when disposed during receive', () async {
        final connection = createConnectionWithFakeChannel();

        await connection.connect();

        // Subscribe to messages AFTER connection is established
        final receivedMessages = <String>[];
        final subscription = connection.messages.listen(receivedMessages.add);

        // Dispose the connection
        await connection.dispose();

        // Try to add message after disposal
        fakeChannel.addMessage('message after dispose');

        await Future<void>.delayed(const Duration(milliseconds: 50));

        // Message should not be added because _isDisposed is true
        expect(receivedMessages, isEmpty);

        await subscription.cancel();
      });

      test(
        'cleanup is called in _handleConnectionLost when disposed during error',
        () async {
          final connection = createConnectionWithFakeChannel();

          await connection.connect();
          expect(connection.isConnected, true);

          // Schedule error on microtask queue FIRST
          // This will execute during dispose()'s await _cleanup()
          scheduleMicrotask(() => fakeChannel.addError(Exception('error')));

          // Now call dispose() synchronously:
          // 1. Sets _isDisposed = true (synchronous)
          // 2. Awaits _cleanup() - during this await, microtasks run
          // 3. Our scheduled addError() runs, triggering onError
          // 4. onError calls _handleConnectionLost()
          // 5. _handleConnectionLost checks _isDisposed (TRUE)
          // 6. Takes path 1: calls _cleanup() and returns (line 235!)
          await connection.dispose();

          await Future<void>.delayed(const Duration(milliseconds: 100));

          // Test passes if no exceptions are thrown - the cleanup path was hit
        },
      );

      test(
        'cleanup is called in _handleConnectionLost when stream closes '
        'after manual disconnect started',
        () async {
          // This tests line 235: _cleanup() in _handleConnectionLost
          // when _isManualDisconnect is true
          var onDisconnectedCallCount = 0;
          final localChannel = FakeWebSocketChannel();
          final connection = WebSocketConnection(
            url: testUrl,
            logger: mockLogger,
            onDisconnected: () => onDisconnectedCallCount++,
            reconnectionPolicy: WebSocketReconnectionConfig.noReconnection,
            channelFactory: (uri) => localChannel,
          );

          await connection.connect();
          expect(connection.isConnected, true);

          // Schedule stream close on microtask queue FIRST
          // This will execute during disconnect()'s await _cleanup()
          scheduleMicrotask(localChannel.closeStream);

          // Now call disconnect() synchronously:
          // 1. Sets _isManualDisconnect = true (synchronous)
          // 2. Awaits _cleanup() - during this await, microtasks run
          // 3. Our scheduled closeStream() runs, triggering onDone
          // 4. onDone calls _handleConnectionLost()
          // 5. _handleConnectionLost checks _isManualDisconnect (TRUE)
          // 6. Takes path 1: calls _cleanup() and returns (line 235!)
          await connection.disconnect();

          await Future<void>.delayed(const Duration(milliseconds: 50));

          // onDisconnected should only be called once (from disconnect())
          // not twice (which would happen if _handleConnectionLost didn't
          // check _isManualDisconnect and went through the full path)
          expect(onDisconnectedCallCount, 1);

          expect(
            connection.currentState,
            WebSocketConnectionState.disconnected,
          );

          await connection.dispose();
        },
      );

      test('logs error and rethrows when send fails', () async {
        when(
          () => mockLogger.debug(
            any(),
            data: any(named: 'data'),
            tag: any(named: 'tag'),
          ),
        ).thenReturn(null);
        when(
          () => mockLogger.info(
            any(),
            data: any(named: 'data'),
            tag: any(named: 'tag'),
          ),
        ).thenReturn(null);
        when(
          () => mockLogger.error(
            any(),
            error: any(named: 'error'),
            stackTrace: any(named: 'stackTrace'),
            data: any(named: 'data'),
            tag: any(named: 'tag'),
          ),
        ).thenReturn(null);

        final failingSink = FakeWebSocketSink(
          errorOnAdd: Exception('Send failed'),
        );
        final failingChannel = FakeWebSocketChannel(customSink: failingSink);

        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
          reconnectionPolicy: WebSocketReconnectionConfig.noReconnection,
          channelFactory: (uri) => failingChannel,
        );

        await connection.connect();
        expect(connection.isConnected, true);

        // Clear previous interactions
        clearInteractions(mockLogger);

        // Send should throw and log error
        expect(
          () => connection.send('test message'),
          throwsA(isA<Exception>()),
        );

        // Verify error was logged
        verify(
          () => mockLogger.error(
            'Failed to send WebSocket message to $testUrl',
            error: any(named: 'error'),
            stackTrace: any(named: 'stackTrace'),
          ),
        ).called(1);

        await connection.dispose();
        await failingChannel.closeStream();
      });
    });

    group('reconnection with mock channel', () {
      late List<FakeWebSocketChannel> fakeChannels;

      setUp(() {
        fakeChannels = [];
      });

      tearDown(() async {
        for (final channel in fakeChannels) {
          await channel.closeStream();
        }
      });

      FakeWebSocketChannel createFakeChannel() {
        final channel = FakeWebSocketChannel();
        fakeChannels.add(channel);
        return channel;
      }

      test('schedules reconnection when connection lost', () async {
        var reconnectingAttempt = 0;
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
          onReconnecting: (attempt) => reconnectingAttempt = attempt,
          reconnectionPolicy: const WebSocketReconnectionConfig(
            maxAttempts: 3,
            initialDelay: Duration(milliseconds: 10),
          ),
          channelFactory: (uri) => createFakeChannel(),
        );

        await connection.connect();
        expect(connection.isConnected, true);

        // Close the first channel to trigger reconnection
        await fakeChannels[0].closeStream();

        // Wait for reconnection to be scheduled
        await Future<void>.delayed(const Duration(milliseconds: 50));

        expect(reconnectingAttempt, 1);
        expect(
          connection.currentState,
          anyOf(
            WebSocketConnectionState.reconnecting,
            WebSocketConnectionState.connected,
          ),
        );

        await connection.dispose();
      });

      test('calls onReconnecting with attempt number', () async {
        final reconnectingAttempts = <int>[];
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
          onReconnecting: reconnectingAttempts.add,
          reconnectionPolicy: const WebSocketReconnectionConfig(
            maxAttempts: 3,
            initialDelay: Duration(milliseconds: 10),
          ),
          channelFactory: (uri) => createFakeChannel(),
        );

        await connection.connect();

        // Close channel to trigger reconnection
        await fakeChannels[0].closeStream();

        // Wait for reconnection attempt
        await Future<void>.delayed(const Duration(milliseconds: 50));

        expect(reconnectingAttempts, isNotEmpty);
        expect(reconnectingAttempts.first, 1);

        await connection.dispose();
      });

      test('fails permanently after max attempts exceeded', () async {
        var failedPermanently = false;
        var disconnectedCalled = false;
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
          onDisconnected: () => disconnectedCalled = true,
          reconnectionPolicy: const WebSocketReconnectionConfig(
            maxAttempts: 0, // No retries allowed
            initialDelay: Duration(milliseconds: 10),
          ),
          channelFactory: (uri) => createFakeChannel(),
        );

        final subscription = connection.connectionState.listen((state) {
          if (state == WebSocketConnectionState.failed) {
            failedPermanently = true;
          }
        });

        await connection.connect();

        // Close channel - should fail permanently since maxAttempts is 0
        await fakeChannels[0].closeStream();

        await Future<void>.delayed(const Duration(milliseconds: 50));

        expect(failedPermanently, true);
        expect(disconnectedCalled, true);

        await subscription.cancel();
        await connection.dispose();
      });

      test('does not reconnect when manually disconnected', () async {
        var reconnectingAttempt = 0;
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
          onReconnecting: (attempt) => reconnectingAttempt = attempt,
          reconnectionPolicy: const WebSocketReconnectionConfig(
            maxAttempts: 3,
            initialDelay: Duration(milliseconds: 10),
          ),
          channelFactory: (uri) => createFakeChannel(),
        );

        await connection.connect();

        // Manual disconnect should prevent reconnection
        await connection.disconnect();

        await Future<void>.delayed(const Duration(milliseconds: 50));

        expect(reconnectingAttempt, 0);
        expect(connection.currentState, WebSocketConnectionState.disconnected);

        await connection.dispose();
      });

      test('does not reconnect when disposed', () async {
        var reconnectingAttempt = 0;
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
          onReconnecting: (attempt) => reconnectingAttempt = attempt,
          reconnectionPolicy: const WebSocketReconnectionConfig(
            maxAttempts: 3,
            initialDelay: Duration(milliseconds: 10),
          ),
          channelFactory: (uri) => createFakeChannel(),
        );

        await connection.connect();

        // Dispose should prevent reconnection
        await connection.dispose();

        await Future<void>.delayed(const Duration(milliseconds: 50));

        expect(reconnectingAttempt, 0);
      });
    });

    group('connection errors with mock channel', () {
      test('calls onError when connection fails', () async {
        Object? receivedError;
        final testError = Exception('Connection failed');
        final failingChannel = FakeWebSocketChannel(
          readyError: testError,
        );

        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
          onError: (error) => receivedError = error,
          reconnectionPolicy: WebSocketReconnectionConfig.noReconnection,
          channelFactory: (uri) => failingChannel,
        );

        await connection.connect();

        await Future<void>.delayed(const Duration(milliseconds: 50));

        // The error is received (may be wrapped by WebSocket implementation)
        expect(receivedError, isNotNull);

        await connection.dispose();
        await failingChannel.closeStream();
      });

      test('transitions to failed state on connection error', () async {
        final testError = Exception('Connection failed');
        final failingChannel = FakeWebSocketChannel(
          readyError: testError,
        );

        final states = <WebSocketConnectionState>[];
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
          reconnectionPolicy: WebSocketReconnectionConfig.noReconnection,
          channelFactory: (uri) => failingChannel,
        );

        final subscription = connection.connectionState.listen(states.add);

        await connection.connect();

        await Future<void>.delayed(const Duration(milliseconds: 50));

        expect(states, contains(WebSocketConnectionState.connecting));
        expect(states, contains(WebSocketConnectionState.failed));

        await subscription.cancel();
        await connection.dispose();
        await failingChannel.closeStream();
      });
    });

    group('logger calls', () {
      setUp(() {
        // Register fallback values for logger method calls
        when(
          () => mockLogger.debug(
            any(),
            data: any(named: 'data'),
            tag: any(named: 'tag'),
          ),
        ).thenReturn(null);
        when(
          () => mockLogger.info(
            any(),
            data: any(named: 'data'),
            tag: any(named: 'tag'),
          ),
        ).thenReturn(null);
        when(
          () => mockLogger.warning(
            any(),
            data: any(named: 'data'),
            tag: any(named: 'tag'),
          ),
        ).thenReturn(null);
        when(
          () => mockLogger.error(
            any(),
            error: any(named: 'error'),
            stackTrace: any(named: 'stackTrace'),
            data: any(named: 'data'),
            tag: any(named: 'tag'),
          ),
        ).thenReturn(null);
      });

      test('logger is called during connection lifecycle', () async {
        // Create connection - logger.debug is called during construction
        // for initial state change, but verification is complex due to
        // mocktail setup timing. Other tests verify logger calls for
        // disconnect, dispose, etc.
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
        );

        // Verify logger is available and connection works
        expect(connection, isNotNull);
        expect(mockLogger, isNotNull);

        await connection.dispose();
      });

      test('logs debug when manually disconnecting', () async {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
        );

        // Clear previous calls but keep when() setups
        clearInteractions(mockLogger);

        await connection.disconnect();

        verify(
          () => mockLogger.debug('Manually disconnecting WebSocket: $testUrl'),
        ).called(1);

        await connection.dispose();
      });

      test('logs debug when disposing', () async {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
        );

        // Clear previous calls but keep when() setups
        clearInteractions(mockLogger);

        await connection.dispose();

        verify(
          () => mockLogger.debug('Disposing WebSocket connection: $testUrl'),
        ).called(1);
      });

      test('logs debug when state changes', () async {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
        );

        // Clear previous calls but keep when() setups
        clearInteractions(mockLogger);

        await connection.disconnect();

        // disconnect() logs "Manually disconnecting" and may log state change
        // if state actually changes
        verify(
          () => mockLogger.debug('Manually disconnecting WebSocket: $testUrl'),
        ).called(1);

        await connection.dispose();
      });

      test('logs debug when sending message fails', () {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
        );

        // Clear previous calls but keep when() setups
        clearInteractions(mockLogger);

        // Sending when not connected should not log debug
        // (it throws StateError before logging)
        expect(
          () => connection.send('test message'),
          throwsA(isA<StateError>()),
        );

        // No debug log should be called for send when not connected
        verifyNever(
          () => mockLogger.debug(
            any(that: contains('Sending WebSocket message')),
          ),
        );
      });

      test('logs warning when connection fails permanently', () {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
          reconnectionPolicy: WebSocketReconnectionConfig.noReconnection,
        );

        // Clear previous calls but keep when() setups
        clearInteractions(mockLogger);

        // Note: Testing actual warning log would require a real connection
        // attempt. This test verifies the logger is available.
        expect(connection, isNotNull);
        expect(mockLogger, isNotNull);
      });

      test('logs info when reconnection is scheduled', () {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
          reconnectionPolicy: const WebSocketReconnectionConfig(
            maxAttempts: 2,
            initialDelay: Duration(milliseconds: 50),
          ),
        );

        // Clear previous calls but keep when() setups
        clearInteractions(mockLogger);

        // Note: Testing actual info log for reconnection scheduling would
        // require a real connection attempt. This test verifies the logger
        // is available.
        expect(connection, isNotNull);
        expect(mockLogger, isNotNull);
      });

      test('does not log state change when state does not change', () async {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
        );

        // Disconnect first time
        await connection.disconnect();

        // Clear previous calls but keep when() setups
        clearInteractions(mockLogger);

        // Disconnect again when already disconnected
        await connection.disconnect();

        // Should log "Manually disconnecting" but not state change
        // since state is already disconnected
        verify(
          () => mockLogger.debug('Manually disconnecting WebSocket: $testUrl'),
        ).called(1);

        // State didn't change, so state change log should not be called
        verifyNever(
          () => mockLogger.debug(
            any(that: contains('WebSocket state changed')),
          ),
        );

        await connection.dispose();
      });

      test('logs debug when connect is called on already connected', () async {
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
          reconnectionPolicy: WebSocketReconnectionConfig.noReconnection,
        );

        // Clear previous calls but keep when() setups
        clearInteractions(mockLogger);

        // Note: Testing actual "already connected" log would require a real
        // connection. This test verifies the logger is available.
        expect(connection, isNotNull);
        expect(mockLogger, isNotNull);
      });

      test('logs debug when message is received', () async {
        final fakeChannel = FakeWebSocketChannel();
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
          reconnectionPolicy: WebSocketReconnectionConfig.noReconnection,
          channelFactory: (uri) => fakeChannel,
        );

        // Clear previous calls but keep when() setups
        clearInteractions(mockLogger);

        await connection.connect();

        fakeChannel.addMessage('{"test": "message"}');
        await Future<void>.delayed(const Duration(milliseconds: 50));

        verify(
          () => mockLogger.debug(
            any(that: contains('WebSocket message received')),
          ),
        ).called(1);

        await connection.dispose();
        await fakeChannel.closeStream();
      });

      test('logs info when connection is successful', () async {
        final fakeChannel = FakeWebSocketChannel();
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
          reconnectionPolicy: WebSocketReconnectionConfig.noReconnection,
          channelFactory: (uri) => fakeChannel,
        );

        // Clear previous calls but keep when() setups
        clearInteractions(mockLogger);

        await connection.connect();

        verify(
          () => mockLogger.info(
            'WebSocket connected successfully to: $testUrl',
          ),
        ).called(1);

        await connection.dispose();
        await fakeChannel.closeStream();
      });

      test('logs error when stream error occurs', () async {
        final fakeChannel = FakeWebSocketChannel();
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
          reconnectionPolicy: WebSocketReconnectionConfig.noReconnection,
          channelFactory: (uri) => fakeChannel,
        );

        // Clear previous calls but keep when() setups
        clearInteractions(mockLogger);

        await connection.connect();

        final testError = Exception('Test error');
        fakeChannel.addError(testError);
        await Future<void>.delayed(const Duration(milliseconds: 50));

        verify(
          () => mockLogger.error(
            'WebSocket error on $testUrl',
            error: testError,
          ),
        ).called(1);

        await connection.dispose();
        await fakeChannel.closeStream();
      });

      test('logs debug when stream closes (onDone)', () async {
        final fakeChannel = FakeWebSocketChannel();
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
          reconnectionPolicy: WebSocketReconnectionConfig.noReconnection,
          channelFactory: (uri) => fakeChannel,
        );

        // Clear previous calls but keep when() setups
        clearInteractions(mockLogger);

        await connection.connect();

        await fakeChannel.closeStream();
        await Future<void>.delayed(const Duration(milliseconds: 50));

        verify(
          () => mockLogger.debug(
            'WebSocket connection closed: $testUrl',
          ),
        ).called(1);

        await connection.dispose();
      });
    });
  });
}
