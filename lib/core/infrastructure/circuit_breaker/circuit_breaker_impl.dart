import 'package:starter_app/core/domain/ports/ports.dart';
import 'package:starter_app/core/infrastructure/circuit_breaker/circuit_breaker_config.dart';
import 'package:starter_app/core/logging/i_app_logger.dart';

/// Circuit breaker states for the state machine.
enum CircuitState { closed, open, halfOpen }

/// Implementation of [ICircuitBreaker] for network resilience.
///
/// This is an **adapter** in hexagonal architecture - it implements the
/// [ICircuitBreaker] port defined in the domain layer.
///
/// ## State Machine
///
/// The circuit breaker has three states:
/// - **Closed**: Normal operation, requests pass through
/// - **Open**: Circuit tripped, requests are blocked
/// - **Half-Open**: Testing if service recovered, allows probe request
///
/// ```text
/// ┌────────┐  failure >= threshold  ┌────────┐
/// │ CLOSED │ ─────────────────────► │  OPEN  │
/// └────────┘                        └────────┘
///      ▲                                 │
///      │ success                         │ timeout elapsed
///      │                                 ▼
/// ┌────────────┐    failure       ┌────────────┐
/// │ HALF-OPEN  │ ◄────────────────│ HALF-OPEN  │
/// └────────────┘ ─────────────────► └──────────┘
///       │ success                     failure
///       ▼
/// ┌────────┐
/// │ CLOSED │
/// └────────┘
/// ```
///
/// ## Usage
///
/// ```dart
/// final breaker = CircuitBreakerImpl(
///   logger: logger,
///   config: CircuitBreakerConfig.defaultConfig,
/// );
///
/// if (breaker.isOpen) {
///   return Left(InfrastructureFailure.circuitOpen());
/// }
///
/// try {
///   final result = await apiCall();
///   breaker.onSuccess();
///   return Right(result);
/// } catch (e) {
///   breaker.onFailure(e);
///   rethrow;
/// }
/// ```
class CircuitBreakerImpl implements ICircuitBreaker {
  CircuitBreakerImpl({
    required this.logger,
    this.config = CircuitBreakerConfig.defaultConfig,
  });

  final IAppLogger logger;
  final CircuitBreakerConfig config;

  CircuitState _state = CircuitState.closed;
  int _failureCount = 0;
  DateTime? _lastFailureTime;

  @override
  bool get isOpen {
    if (!config.enabled) return false;

    if (_state == CircuitState.open) {
      if (_lastFailureTime != null &&
          DateTime.now().difference(_lastFailureTime!) > config.resetTimeout) {
        _transitionToHalfOpen();
        return false; // Allow probe request
      }
      return true;
    }
    return false;
  }

  @override
  void onSuccess() {
    if (!config.enabled) return;

    if (_state == CircuitState.halfOpen) {
      _transitionToClosed();
    } else if (_state == CircuitState.closed) {
      _failureCount = 0;
    }
  }

  @override
  void onFailure(Object error) {
    if (!config.enabled) return;

    logger.warning('Circuit Breaker recorded failure: $error');

    if (_state == CircuitState.closed) {
      _failureCount++;
      if (_failureCount >= config.failureThreshold) {
        _transitionToOpen();
      }
    } else if (_state == CircuitState.halfOpen) {
      _transitionToOpen();
    }
  }

  void _transitionToOpen() {
    _state = CircuitState.open;
    _lastFailureTime = DateTime.now();
    logger.error(
      '''Circuit Breaker OPENED. Requests blocked for ${config.resetTimeout.inSeconds}s.''',
    );
  }

  void _transitionToHalfOpen() {
    _state = CircuitState.halfOpen;
    logger.info('Circuit Breaker HALF-OPEN. Probing service...');
  }

  void _transitionToClosed() {
    _state = CircuitState.closed;
    _failureCount = 0;
    _lastFailureTime = null;
    logger.info('Circuit Breaker CLOSED. Service recovered.');
  }
}
