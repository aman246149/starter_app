# WebSocket Automatic Reconnection

Complete guide to automatic reconnection with exponential backoff, jitter, and connection state management.

## Overview

The WebSocket infrastructure includes built-in automatic reconnection that:

- ✅ Automatically reconnects when connection is lost
- ✅ Uses exponential backoff to avoid overwhelming the server
- ✅ Adds jitter to prevent thundering herd problem
- ✅ Tracks connection state (disconnected, connecting, connected, reconnecting, failed)
- ✅ Emits state changes via streams for reactive UI updates
- ✅ Configurable retry strategies (aggressive, default, conservative, custom)

## Quick Start

### Basic Usage with Default Reconnection

```dart
final manager = getIt<IWebSocketManager>();

// Create connection with default reconnection config
final connection = manager.createConnection('/ws/notifications');

// Listen to connection state changes
connection.connectionState.listen((state) {
  print('Connection state: ${state.displayName}');
  
  switch (state) {
    case WebSocketConnectionState.connecting:
      showLoadingIndicator();
      break;
    case WebSocketConnectionState.connected:
      hideLoadingIndicator();
      showSuccessMessage();
      break;
    case WebSocketConnectionState.reconnecting:
      showReconnectingBanner();
      break;
    case WebSocketConnectionState.failed:
      showErrorMessage('Connection failed. Please try again.');
      break;
    case WebSocketConnectionState.disconnected:
      // Manually disconnected
      break;
  }
});

await connection.connect(headers: {'Authorization': 'Bearer $token'});
```

## Reconnection Configurations

### 1. Default Configuration (Recommended)

Balanced approach suitable for most use cases:

```dart
final connection = manager.createConnection(
  '/ws/notifications',
  reconnectionConfig: WebSocketReconnectionConfig.defaultConfig,
);

// Settings:
// - Max attempts: 10
// - Initial delay: 1 second
// - Max delay: 30 seconds
// - Backoff multiplier: 2.0
// - Jitter factor: 0.25 (±25% random variation)
```

**Retry Schedule (approximate, varies due to jitter):**

- Attempt 1: ~1s delay (0.75s - 1.25s with jitter)
- Attempt 2: ~2s delay
- Attempt 3: ~4s delay
- Attempt 4: ~8s delay
- Attempt 5: ~16s delay
- Attempt 6: ~30s delay (capped at maxDelay)
- Attempts 7-10: ~30s delay each

### 2. Aggressive Configuration

For critical real-time features that need fast reconnection:

```dart
final connection = manager.createConnection(
  '/ws/chat',
  reconnectionConfig: WebSocketReconnectionConfig.aggressive,
);

// Settings:
// - Max attempts: 20
// - Initial delay: 500ms
// - Max delay: 10 seconds
// - Backoff multiplier: 1.5
// - Jitter factor: 0.2 (±20% random variation)
```

**Use cases:**

- Live chat applications
- Real-time trading/stock tickers
- Live gaming
- Critical notifications

### 3. Conservative Configuration

For non-critical features or when server is under load:

```dart
final connection = manager.createConnection(
  '/ws/analytics',
  reconnectionConfig: WebSocketReconnectionConfig.conservative,
);

// Settings:
// - Max attempts: 5
// - Initial delay: 5 seconds
// - Max delay: 2 minutes
// - Backoff multiplier: 3.0
// - Jitter factor: 0.3 (±30% random variation)
```

**Use cases:**

- Analytics tracking
- Non-critical notifications
- Background sync
- Server-side events

### 4. No Reconnection

Disable automatic reconnection completely:

```dart
final connection = manager.createConnection(
  '/ws/one-time',
  reconnectionConfig: WebSocketReconnectionConfig.noReconnection,
);

// Settings:
// - Enabled: false
```

**Use cases:**

- One-time data fetch via WebSocket
- User-initiated connections only
- Testing scenarios

### 5. Custom Configuration

Create your own reconnection strategy:

```dart
final customConfig = WebSocketReconnectionConfig(
  enabled: true,
  maxAttempts: 15,
  initialDelay: Duration(milliseconds: 800),
  maxDelay: Duration(seconds: 45),
  backoffMultiplier: 2.5,
  jitterFactor: 0.3, // ±30% random variation
);

final connection = manager.createConnection(
  '/ws/custom',
  reconnectionConfig: customConfig,
);
```

## Jitter: Preventing Thundering Herd

### What is Jitter?

Jitter adds random variation to reconnection delays to prevent the "thundering herd" problem - when many clients try to reconnect at exactly the same time (e.g., after a server restart), overwhelming the server.

### How Jitter Works

```dart
// Without jitter: All 1000 clients reconnect at exactly 1s, 2s, 4s...
// Server gets hammered with 1000 simultaneous connections!

// With jitter (0.25): Clients reconnect between 0.75s-1.25s, 1.5s-2.5s...
// Connections spread out naturally, server handles load gracefully
```

### Jitter Factor Values

| Factor | Variation | Example (1s base) | Use Case |
|--------|-----------|-------------------|----------|
| 0.0 | None | Exactly 1.0s | Testing only |
| 0.1 | ±10% | 0.9s - 1.1s | Minimal spread |
| 0.25 | ±25% | 0.75s - 1.25s | Default (recommended) |
| 0.5 | ±50% | 0.5s - 1.5s | High traffic systems |

## Connection State Management

### Connection State Enum

```dart
enum WebSocketConnectionState {
  disconnected,   // Not connected, not attempting
  connecting,     // First connection attempt
  connected,      // Successfully connected
  reconnecting,   // Lost connection, retrying
  failed,         // Max retries exceeded
}
```

### Listening to State Changes

```dart
final connection = manager.createConnection('/ws/notifications');

connection.connectionState.listen((state) {
  switch (state) {
    case WebSocketConnectionState.disconnected:
      // Initial state or manually disconnected
      print('Not connected');
      break;
      
    case WebSocketConnectionState.connecting:
      // First connection attempt in progress
      print('Connecting...');
      showLoadingSpinner();
      break;
      
    case WebSocketConnectionState.connected:
      // Successfully connected and ready
      print('Connected!');
      hideLoadingSpinner();
      enableSendButton();
      break;
      
    case WebSocketConnectionState.reconnecting:
      // Connection lost, attempting to reconnect
      print('Reconnecting...');
      showReconnectingBanner('Trying to reconnect...');
      disableSendButton();
      break;
      
    case WebSocketConnectionState.failed:
      // Max reconnection attempts exceeded
      print('Connection failed permanently');
      showErrorDialog('Unable to connect. Please try again later.');
      break;
  }
});
```

### State Helper Methods

```dart
final connection = manager.createConnection('/ws/chat');

// Check if can send messages
if (connection.currentState.canSendMessages) {
  connection.send(jsonEncode({'message': 'Hello!'}));
}

// Check if actively connecting
if (connection.currentState.isConnecting) {
  print('Please wait, connecting...');
}

// Check if connected
if (connection.currentState.isConnected) {
  print('Ready to chat!');
}

// Check if failed
if (connection.currentState.isFailed) {
  print('Connection failed. Manual retry needed.');
}
```

## Callbacks for Connection Events

### onConnected

Called when connection is successfully established:

```dart
final connection = WebSocketConnection(
  url: 'wss://api.example.com/ws/chat',
  logger: logger,
  onConnected: () {
    print('Connected! Ready to send messages.');
    showSuccessToast('Connected');
  },
);
```

### onDisconnected

Called when connection is closed (manual or after failed retries):

```dart
final connection = WebSocketConnection(
  url: 'wss://api.example.com/ws/chat',
  logger: logger,
  onDisconnected: () {
    print('Disconnected from server');
    clearMessageQueue();
  },
);
```

### onReconnecting

Called when starting a reconnection attempt:

```dart
final connection = WebSocketConnection(
  url: 'wss://api.example.com/ws/chat',
  logger: logger,
  onReconnecting: (attemptNumber) {
    print('Reconnection attempt #$attemptNumber');
    showReconnectingBanner('Reconnecting... (Attempt $attemptNumber)');
  },
);
```

### onError

Called when an error occurs:

```dart
final connection = WebSocketConnection(
  url: 'wss://api.example.com/ws/chat',
  logger: logger,
  onError: (error) {
    print('WebSocket error: $error');
    logErrorToAnalytics(error);
  },
);
```

## Complete Example: Chat with Reconnection

```dart
class ChatService {
  ChatService(this._webSocketManager, this._tokenStorage, this._logger);

  final IWebSocketManager _webSocketManager;
  final ITokenStorage _tokenStorage;
  final IAppLogger _logger;

  IWebSocketConnection? _connection;
  final _messagesController = StreamController<ChatMessage>.broadcast();
  final _connectionStatusController = StreamController<String>.broadcast();

  Stream<ChatMessage> get messages => _messagesController.stream;
  Stream<String> get connectionStatus => _connectionStatusController.stream;

  Future<void> connect(String roomId) async {
    final token = await _tokenStorage.getAccessToken();
    
    _connection = _webSocketManager.createConnection(
      '/ws/chat/$roomId',
      reconnectionConfig: WebSocketReconnectionConfig.aggressive,
    );

    // Listen to connection state
    _connection!.connectionState.listen((state) {
      switch (state) {
        case WebSocketConnectionState.connecting:
          _connectionStatusController.add('Connecting...');
          break;
        case WebSocketConnectionState.connected:
          _connectionStatusController.add('Connected');
          break;
        case WebSocketConnectionState.reconnecting:
          _connectionStatusController.add('Reconnecting...');
          break;
        case WebSocketConnectionState.failed:
          _connectionStatusController.add('Connection failed');
          break;
        case WebSocketConnectionState.disconnected:
          _connectionStatusController.add('Disconnected');
          break;
      }
    });

    // Listen to messages
    _connection!.messages.listen((message) {
      final chatMessage = ChatMessage.fromJson(jsonDecode(message));
      _messagesController.add(chatMessage);
    });

    await _connection!.connect(
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  void sendMessage(String text) {
    if (_connection == null || !_connection!.isConnected) {
      throw StateError('Not connected to chat');
    }

    final message = jsonEncode({
      'type': 'message',
      'text': text,
      'timestamp': DateTime.now().toIso8601String(),
    });

    _connection!.send(message);
  }

  Future<void> disconnect() async {
    await _connection?.disconnect();
    _connection = null;
  }

  Future<void> dispose() async {
    await _connection?.dispose();
    await _messagesController.close();
    await _connectionStatusController.close();
  }
}
```

## UI Integration Examples

### Flutter Widget with Connection Status

```dart
class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final ChatService _chatService;
  WebSocketConnectionState _connectionState = WebSocketConnectionState.disconnected;

  @override
  void initState() {
    super.initState();
    _chatService = getIt<ChatService>();
    _setupConnection();
  }

  void _setupConnection() {
    final connection = _chatService.connection;
    
    connection?.connectionState.listen((state) {
      setState(() {
        _connectionState = state;
      });
    });

    _chatService.connect('room-123');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        actions: [_buildConnectionIndicator()],
      ),
      body: Column(
        children: [
          if (_connectionState == WebSocketConnectionState.reconnecting)
            _buildReconnectingBanner(),
          if (_connectionState == WebSocketConnectionState.failed)
            _buildFailedBanner(),
          Expanded(child: _buildMessageList()),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildConnectionIndicator() {
    return Container(
      margin: EdgeInsets.only(right: 16),
      child: Row(
        children: [
          Icon(
            _connectionState.isConnected ? Icons.circle : Icons.circle_outlined,
            color: _getStatusColor(),
            size: 12,
          ),
          SizedBox(width: 8),
          Text(_connectionState.displayName),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (_connectionState) {
      case WebSocketConnectionState.connected:
        return Colors.green;
      case WebSocketConnectionState.connecting:
      case WebSocketConnectionState.reconnecting:
        return Colors.orange;
      case WebSocketConnectionState.failed:
        return Colors.red;
      case WebSocketConnectionState.disconnected:
        return Colors.grey;
    }
  }

  Widget _buildReconnectingBanner() {
    return Container(
      color: Colors.orange.shade100,
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 12),
          Text('Reconnecting to server...'),
        ],
      ),
    );
  }

  Widget _buildFailedBanner() {
    return Container(
      color: Colors.red.shade100,
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Connection failed'),
          TextButton(
            onPressed: () => _chatService.connect('room-123'),
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  // ... rest of the widget
}
```

## Testing Reconnection

### Manual Testing

1. **Test automatic reconnection:**
   - Connect to WebSocket
   - Kill the backend server
   - Observe reconnection attempts in logs
   - Restart backend server
   - Connection should restore automatically

2. **Test exponential backoff with jitter:**
   - Monitor delay between reconnection attempts
   - Should increase exponentially with some random variation
   - Should cap at maxDelay

3. **Test max retries:**
   - Keep backend offline for extended period
   - After max attempts, state should become `failed`

### Unit Testing

```dart
test('should reconnect automatically on connection loss', () async {
  final mockLogger = MockIAppLogger();
  final config = WebSocketReconnectionConfig(
    maxAttempts: 3,
    initialDelay: Duration(milliseconds: 100),
    jitterFactor: 0.0, // No jitter for predictable testing
  );

  final connection = WebSocketConnection(
    url: 'wss://test.example.com/ws',
    logger: mockLogger,
    reconnectionConfig: config,
  );

  final states = <WebSocketConnectionState>[];
  connection.connectionState.listen(states.add);

  // Simulate connection loss
  // ... test implementation

  expect(states, contains(WebSocketConnectionState.reconnecting));
});
```

## Best Practices

1. **Choose appropriate config for your use case:**
   - Critical features → Aggressive
   - Standard features → Default
   - Background features → Conservative

2. **Monitor connection state in UI:**
   - Show loading indicators during connecting/reconnecting
   - Disable send actions when not connected
   - Show retry button when failed

3. **Handle failed state gracefully:**
   - Provide manual retry option
   - Save unsent messages locally
   - Inform user of connection issues

4. **Log reconnection attempts:**
   - Use `onReconnecting` callback for analytics
   - Track success/failure rates
   - Monitor backoff delays

5. **Test with poor network conditions:**
   - Use network throttling tools
   - Test with intermittent connectivity
   - Verify exponential backoff works correctly

## Troubleshooting

### Connection keeps failing

- Check server is running and accessible
- Verify WebSocket URL is correct
- Check authentication token is valid
- Review max attempts configuration

### Too many reconnection attempts

- Increase `initialDelay` and `maxDelay`
- Reduce `backoffMultiplier`
- Consider using conservative configuration
- Increase `jitterFactor` to spread out reconnections

### Reconnection too slow

- Decrease `initialDelay`
- Use aggressive configuration
- Reduce `backoffMultiplier`

### State not updating in UI

- Ensure you're listening to `connectionState` stream
- Check setState() is called in Flutter widgets
- Verify stream subscription is active
