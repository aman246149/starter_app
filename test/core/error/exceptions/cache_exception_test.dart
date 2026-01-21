import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/core/error/exceptions/cache_exception.dart';

void main() {
  group('CacheException', () {
    test('creates exception with message and original error', () {
      const exception = CacheException(
        message: 'Cache failed',
        originalError: 'Database error',
      );

      expect(exception.message, 'Cache failed');
      expect(exception.originalError, 'Database error');
    });

    test('creates exception with only message', () {
      const exception = CacheException(message: 'Cache failed');

      expect(exception.message, 'Cache failed');
      expect(exception.originalError, null);
    });

    test('creates exception with only original error', () {
      const exception = CacheException(originalError: 'Database error');

      expect(exception.message, 'Cache operation failed');
      expect(exception.originalError, 'Database error');
    });

    test('creates exception with no parameters', () {
      const exception = CacheException();

      expect(exception.message, 'Cache operation failed');
      expect(exception.originalError, null);
    });

    test('creates exception without const keyword', () {
      // ignore: prefer_const_constructors to test the non-const constructor
      final exception = CacheException(
        message: 'Cache failed',
        originalError: 'Database error',
      );

      expect(exception.message, 'Cache failed');
      expect(exception.originalError, 'Database error');
    });

    test('creates exception without const keyword and no parameters', () {
      const exception = CacheException();

      expect(exception.message, 'Cache operation failed');
      expect(exception.originalError, null);
    });

    group('toString', () {
      test('includes message when provided', () {
        const exception = CacheException(message: 'Cache failed');

        expect(exception.toString(), 'CacheException: Cache failed');
      });

      test('includes original error when provided', () {
        const exception = CacheException(
          message: 'Cache failed',
          originalError: 'DB Error',
        );

        expect(
          exception.toString(),
          'CacheException: Cache failed (Original error: DB Error)',
        );
      });

      test('shows only original error when message is null', () {
        const exception = CacheException(originalError: 'DB Error');

        expect(
          exception.toString(),
          'CacheException: Cache operation failed (Original error: DB Error)',
        );
      });

      test('shows minimal info when both are null', () {
        const exception = CacheException();

        expect(exception.toString(), 'CacheException: Cache operation failed');
      });
    });

    test('is an Exception', () {
      const exception = CacheException();

      expect(exception, isA<Exception>());
    });
  });
}
