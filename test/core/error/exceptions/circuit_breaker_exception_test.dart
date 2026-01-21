import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/core/error/exceptions/circuit_breaker_exception.dart';

void main() {
  group('CircuitBreakerException', () {
    test('should use default message when none is provided', () {
      const exception = CircuitBreakerException();
      expect(
        exception.message,
        'Service temporarily unavailable due to repeated failures',
      );
    });

    test('should use provided message', () {
      const customMessage = 'Custom error message';
      const exception = CircuitBreakerException(customMessage);
      expect(exception.message, customMessage);
    });

    test('toString() should return correct string representation', () {
      const customMessage = 'Custom error message';
      const exception = CircuitBreakerException(customMessage);
      expect(
        exception.toString(),
        'CircuitBreakerException: $customMessage',
      );
    });
  });
}
