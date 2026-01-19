import 'dart:math';

import 'package:starter_app/core/domain/types/i_reconnection_policy.dart';

/// Exponential backoff reconnection policy for WebSocket connections.
///
/// This is an **infrastructure implementation** of [IReconnectionPolicy]
/// that uses exponential backoff with jitter.
///
/// Features:
/// - Exponential backoff with configurable multiplier
/// - Random jitter to prevent thundering herd problem
/// - Configurable max delay cap
/// - Optional max retry attempts
///
/// Example:
/// ```dart
/// final config = WebSocketReconnectionConfig(
///   enabled: true,
///   maxAttempts: 5,
///   initialDelay: Duration(seconds: 1),
///   maxDelay: Duration(seconds: 30),
///   backoffMultiplier: 2.0,
///   jitterFactor: 0.25,
/// );
/// ```
class WebSocketReconnectionConfig implements IReconnectionPolicy {
  /// Creates a reconnection configuration.
  ///
  /// Parameters:
  /// - [enabled]: Whether automatic reconnection is enabled
  /// - [maxAttempts]: Maximum number of reconnection attempts (null = infinite)
  /// - [initialDelay]: Delay before first reconnection attempt
  /// - [maxDelay]: Maximum delay between reconnection attempts
  /// - [backoffMultiplier]: Multiplier for exponential backoff
  /// - [jitterFactor]: Random variation (0.0-1.0, default 0.25 = ±25%)
  const WebSocketReconnectionConfig({
    this.enabled = true,
    this.maxAttempts = 10,
    this.initialDelay = const Duration(seconds: 1),
    this.maxDelay = const Duration(seconds: 30),
    this.backoffMultiplier = 2.0,
    this.jitterFactor = 0.25,
  });

  @override
  final bool enabled;

  @override
  final int? maxAttempts;

  /// Initial delay before the first reconnection attempt.
  ///
  /// Subsequent attempts use exponential backoff based on this value.
  final Duration initialDelay;

  /// Maximum delay between reconnection attempts.
  ///
  /// Prevents exponential backoff from growing indefinitely.
  final Duration maxDelay;

  /// Multiplier for exponential backoff.
  ///
  /// Each retry delay is multiplied by this value.
  /// Example: With multiplier 2.0 and initial delay 1s:
  /// - Attempt 1: ~1s (with jitter)
  /// - Attempt 2: ~2s (with jitter)
  /// - Attempt 3: ~4s (with jitter)
  /// - Attempt 4: ~8s (with jitter)
  /// - etc.
  final double backoffMultiplier;

  /// Random jitter factor to prevent thundering herd problem.
  ///
  /// Adds random variation to the delay to prevent multiple clients
  /// from reconnecting at the exact same time after a server restart.
  ///
  /// Value between 0.0 and 1.0:
  /// - 0.0: No jitter (exact exponential backoff)
  /// - 0.25: ±25% random variation (default, recommended)
  /// - 0.5: ±50% random variation
  /// - 1.0: 0% to 200% of calculated delay
  final double jitterFactor;

  /// Default configuration for production use.
  ///
  /// - Enabled: true
  /// - Max attempts: 10
  /// - Initial delay: 1 second
  /// - Max delay: 30 seconds
  /// - Backoff multiplier: 2.0
  static const WebSocketReconnectionConfig defaultConfig =
      WebSocketReconnectionConfig();

  /// Configuration with reconnection disabled.
  static const WebSocketReconnectionConfig noReconnection =
      WebSocketReconnectionConfig(enabled: false);

  /// Aggressive reconnection configuration.
  ///
  /// Attempts to reconnect quickly with shorter delays.
  /// Useful for critical real-time features.
  static const WebSocketReconnectionConfig aggressive =
      WebSocketReconnectionConfig(
        maxAttempts: 20,
        initialDelay: Duration(milliseconds: 500),
        maxDelay: Duration(seconds: 10),
        backoffMultiplier: 1.5,
        jitterFactor: 0.2,
      );

  /// Conservative reconnection configuration.
  ///
  /// Attempts reconnection slowly to avoid overwhelming the server.
  /// Useful for non-critical features or when server is under load.
  static const WebSocketReconnectionConfig conservative =
      WebSocketReconnectionConfig(
        maxAttempts: 5,
        initialDelay: Duration(seconds: 5),
        maxDelay: Duration(minutes: 2),
        backoffMultiplier: 3,
        jitterFactor: 0.3,
      );

  /// Random number generator for jitter calculation.
  static final Random _random = Random();

  @override
  Duration getDelayForAttempt(int attempt) {
    if (attempt < 0) {
      return _applyJitter(initialDelay.inMilliseconds.toDouble());
    }

    // Calculate exponential backoff
    final delayMs =
        initialDelay.inMilliseconds * (backoffMultiplier * (attempt + 1));

    // Cap at max delay
    final cappedDelayMs = delayMs.clamp(
      initialDelay.inMilliseconds.toDouble(),
      maxDelay.inMilliseconds.toDouble(),
    );

    // Apply jitter
    return _applyJitter(cappedDelayMs);
  }

  /// Applies random jitter to the delay.
  ///
  /// Returns a Duration with the delay varied by ±[jitterFactor].
  Duration _applyJitter(double delayMs) {
    if (jitterFactor <= 0) {
      return Duration(milliseconds: delayMs.toInt());
    }

    // Calculate jitter range: -jitterFactor to +jitterFactor
    // e.g., with jitterFactor 0.25: multiply by 0.75 to 1.25
    final jitterMultiplier =
        1.0 + (_random.nextDouble() * 2 - 1) * jitterFactor;
    final jitteredDelayMs = delayMs * jitterMultiplier;

    // Ensure delay is at least 1ms
    return Duration(
      milliseconds: jitteredDelayMs.toInt().clamp(1, delayMs.toInt() * 2),
    );
  }

  @override
  bool canRetry(int currentAttempt) {
    if (!enabled) return false;
    if (maxAttempts == null) return true;
    return currentAttempt < maxAttempts!;
  }

  @override
  String toString() {
    return 'WebSocketReconnectionConfig('
        'enabled: $enabled, '
        'maxAttempts: $maxAttempts, '
        'initialDelay: ${initialDelay.inSeconds}s, '
        'maxDelay: ${maxDelay.inSeconds}s, '
        'backoffMultiplier: $backoffMultiplier, '
        'jitterFactor: $jitterFactor'
        ')';
  }
}
