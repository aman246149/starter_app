import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/core/domain/types/websocket_connection_state.dart';
import 'package:starter_app/core/infrastructure/websocket/websocket_connection.dart';
import 'package:starter_app/core/infrastructure/websocket/websocket_reconnection_config.dart';

import '../../../helpers/mock_helpers.dart';

void main() {
  group('WebSocketConnection._handleConnectionLost cleanup branch', () {
    late MockAppLogger mockLogger;
    const testUrl = 'wss://api.example.com/ws/test';

    setUp(() {
      mockLogger = MockAppLogger();
    });

    test(
      'calls _cleanup() and returns early when _isManualDisconnect is true',
      () async {
        final channel = FakeWebSocketChannel();
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
          reconnectionPolicy: WebSocketReconnectionConfig.noReconnection,
          channelFactory: (uri, {protocols}) => channel,
        );

        await connection.connect();
        expect(connection.currentState, WebSocketConnectionState.connected);

        // Force the guarded branch in _handleConnectionLost.
        expect(connection.debugIsManualDisconnect, false);
        await connection.disconnect();
        expect(connection.debugIsManualDisconnect, true);
        await connection.debugHandleConnectionLost();

        // _cleanup() should have closed the sink and nulled out the channel.
        expect((channel.sink as FakeWebSocketSink).isClosed, true);

        // State is updated by disconnect()
        expect(connection.currentState, WebSocketConnectionState.disconnected);
        expect(() => connection.send('x'), throwsA(isA<StateError>()));

        await connection.dispose();
        await channel.closeStream();
      },
    );

    test(
      'calls _cleanup() and returns early when _isDisposed is true',
      () async {
        final channel = FakeWebSocketChannel();
        final connection = WebSocketConnection(
          url: testUrl,
          logger: mockLogger,
          reconnectionPolicy: WebSocketReconnectionConfig.noReconnection,
          channelFactory: (uri, {protocols}) => channel,
        );

        await connection.connect();
        expect(connection.currentState, WebSocketConnectionState.connected);

        // Force the guarded branch in _handleConnectionLost.
        expect(connection.debugIsDisposed, false);
        await connection.dispose();
        expect(connection.debugIsDisposed, true);
        await connection.debugHandleConnectionLost();

        expect((channel.sink as FakeWebSocketSink).isClosed, true);
        expect(() => connection.send('x'), throwsA(isA<StateError>()));

        // Already disposed
        await channel.closeStream();
      },
    );
  });
}
