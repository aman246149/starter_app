/// WebSocket infrastructure for real-time communication.
///
/// Provides WebSocket connections for establishing persistent connections
/// with the backend for real-time updates.
///
/// This module follows **hexagonal architecture**:
/// - Ports (interfaces) are in `lib/core/domain/ports/`
/// - Adapters (implementations) are here in infrastructure
///
/// Usage:
/// ```dart
/// // Import interfaces from domain
/// import 'package:starter_app/core/domain/ports/ports.dart';
///
/// // Import implementations from infrastructure
/// import 'package:starter_app/core/infrastructure/websocket/websocket.dart';
///
/// // Use via dependency injection
/// final manager = getIt<IWebSocketManager>();
/// final connection = manager.createConnection('/ws/notifications');
/// ```
library;

// Re-export domain interfaces for convenience
export 'package:starter_app/core/domain/ports/i_websocket_connection.dart';
export 'package:starter_app/core/domain/ports/i_websocket_manager.dart';
export 'package:starter_app/core/domain/types/i_reconnection_policy.dart';
export 'package:starter_app/core/domain/types/websocket_connection_state.dart';

// Infrastructure implementations
export 'websocket_connection.dart';
export 'websocket_manager.dart';
export 'websocket_reconnection_config.dart';
