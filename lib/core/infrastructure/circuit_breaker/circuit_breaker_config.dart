/// Configuration for the Circuit Breaker pattern.
///
/// Defines behavior for:
/// - Failure thresholds
/// - Reset timeouts
/// - Enabled/Disabled state
class CircuitBreakerConfig {
  const CircuitBreakerConfig({
    this.enabled = true,
    this.failureThreshold = 3,
    this.resetTimeout = const Duration(seconds: 30),
  });

  /// Whether the circuit breaker is enabled.
  final bool enabled;

  /// Number of failures allowed before opening the circuit.
  final int failureThreshold;

  /// Duration to wait before attempting to reset (Half-Open state).
  final Duration resetTimeout;

  /// Default configuration for production use.
  static const CircuitBreakerConfig defaultConfig = CircuitBreakerConfig();

  /// Aggressive configuration (fails fast, retries quickly).
  static const CircuitBreakerConfig aggressive = CircuitBreakerConfig(
    failureThreshold: 2,
    resetTimeout: Duration(seconds: 10),
  );

  /// Conservative configuration (tolerant to failures, slow to retry).
  static const CircuitBreakerConfig conservative = CircuitBreakerConfig(
    failureThreshold: 5,
    resetTimeout: Duration(minutes: 1),
  );
}
