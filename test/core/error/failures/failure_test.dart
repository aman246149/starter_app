import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/core/error/failures/failure.dart';
import 'package:starter_app/core/error/failures/technical_failure.dart';

/// Test implementation of TechnicalFailure for testing purposes.
class TestTechnicalFailure extends TechnicalFailure {
  const TestTechnicalFailure({
    this.testMessage = 'Test message',
    this.testIsRetryable = false,
    this.testStackTrace,
  });

  final String testMessage;
  final bool testIsRetryable;
  final StackTrace? testStackTrace;

  /// Message for testing (not from base class).
  String get message => testMessage;

  @override
  bool get isRetryable => testIsRetryable;

  @override
  StackTrace? get stackTrace => testStackTrace;
}

void main() {
  group('Failure', () {
    test('Failure is abstract base class', () {
      // Failure is abstract and should not be instantiated directly
      // This test verifies the hierarchy structure
      const failure = TestTechnicalFailure();
      expect(failure, isA<Failure>());
      expect(failure, isA<TechnicalFailure>());
    });
  });

  group('TechnicalFailure', () {
    test('has message property', () {
      const failure = TestTechnicalFailure(testMessage: 'Error occurred');

      expect(failure.message, 'Error occurred');
    });

    test('has isRetryable property', () {
      const retryable = TestTechnicalFailure(testIsRetryable: true);
      const notRetryable = TestTechnicalFailure();

      expect(retryable.isRetryable, true);
      expect(notRetryable.isRetryable, false);
    });

    test('has optional stackTrace', () {
      const failure = TestTechnicalFailure();
      expect(failure.stackTrace, isNull);

      final stackTrace = StackTrace.current;
      final failureWithStack = TestTechnicalFailure(testStackTrace: stackTrace);
      expect(failureWithStack.stackTrace, stackTrace);
    });
  });
}
