import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/core/error/exceptions/network_exception.dart';

void main() {
  group('NetworkException', () {
    test('creates exception with custom message', () {
      const exception = NetworkException(message: 'Connection timeout');

      expect(exception.message, 'Connection timeout');
      expect(exception.originalError, null);
    });

    test('uses default message when not provided', () {
      const exception = NetworkException();

      expect(exception.message, 'No internet connection');
      expect(exception.originalError, null);
    });

    test('includes original error when provided', () {
      const originalError = 'SocketException';
      const exception = NetworkException(
        message: 'Network failed',
        originalError: originalError,
      );

      expect(exception.message, 'Network failed');
      expect(exception.originalError, originalError);
    });

    group('toString', () {
      test('includes message', () {
        const exception = NetworkException(message: 'Connection timeout');

        expect(exception.toString(), 'NetworkException: Connection timeout');
      });

      test('includes message with default value', () {
        const exception = NetworkException();

        expect(
          exception.toString(),
          'NetworkException: No internet connection',
        );
      });

      test('includes original error when provided', () {
        const exception = NetworkException(
          message: 'Network failed',
          originalError: 'SocketException: Connection refused',
        );

        expect(
          exception.toString(),
          'NetworkException: Network failed '
          '(Original error: SocketException: Connection refused)',
        );
      });
    });

    test('is an Exception', () {
      const exception = NetworkException();

      expect(exception, isA<Exception>());
    });
  });
}
