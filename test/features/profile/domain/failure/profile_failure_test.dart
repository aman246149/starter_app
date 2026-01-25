import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/features/profile/domain/failure/profile_failure.dart';

void main() {
  group('ProfileFailure', () {
    const message = 'Test message';
    final stackTrace = StackTrace.current;

    group('unexpected', () {
      test('should have correct properties', () {
        final failure = ProfileFailure.unexpected(
          message: message,
          stackTrace: stackTrace,
        );

        expect(failure.message, equals(message));
        expect(failure.stackTrace, equals(stackTrace));
      });

      test('isRetryable should be false', () {
        const failure = ProfileFailure.unexpected(message: message);
        expect(failure.isRetryable, isFalse);
      });
    });

    group('serverError', () {
      test('should have correct properties', () {
        final failure = ProfileFailure.serverError(
          message: message,
          stackTrace: stackTrace,
        );

        expect(failure.message, equals(message));
        expect(failure.stackTrace, equals(stackTrace));
      });

      test('isRetryable should be true', () {
        const failure = ProfileFailure.serverError(message: message);
        expect(failure.isRetryable, isTrue);
      });
    });

    group('notFound', () {
      test('should have correct properties', () {
        final failure = ProfileFailure.notFound(
          message: message,
          stackTrace: stackTrace,
        );

        expect(failure.message, equals(message));
        expect(failure.stackTrace, equals(stackTrace));
      });

      test('isRetryable should be false', () {
        const failure = ProfileFailure.notFound(message: message);
        expect(failure.isRetryable, isFalse);
      });
    });
  });
}
