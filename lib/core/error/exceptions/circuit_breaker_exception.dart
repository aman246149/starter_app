/// Exception thrown when the Circuit Breaker is open.
final class CircuitBreakerException implements Exception {
  const CircuitBreakerException([
    this.message = 'Service temporarily unavailable due to repeated failures',
  ]);

  final String message;

  @override
  String toString() => 'CircuitBreakerException: $message';
}
