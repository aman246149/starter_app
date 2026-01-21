import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/core/error/exceptions/server_exception.dart';

void main() {
  group('ServerException', () {
    test('creates exception with required parameters', () {
      const exception = ServerException(
        message: 'Internal server error',
        statusCode: 500,
      );

      expect(exception.message, 'Internal server error');
      expect(exception.statusCode, 500);
      expect(exception.responseBody, null);
    });

    test('includes response body when provided', () {
      const exception = ServerException(
        message: 'Bad request',
        statusCode: 400,
        responseBody: '{"error": "Invalid input"}',
      );

      expect(exception.message, 'Bad request');
      expect(exception.statusCode, 400);
      expect(exception.responseBody, '{"error": "Invalid input"}');
    });

    group('common HTTP status codes', () {
      test('handles 400 Bad Request', () {
        const exception = ServerException(
          message: 'Bad Request',
          statusCode: 400,
        );

        expect(exception.statusCode, 400);
        expect(exception.message, 'Bad Request');
      });

      test('handles 401 Unauthorized', () {
        const exception = ServerException(
          message: 'Unauthorized',
          statusCode: 401,
        );

        expect(exception.statusCode, 401);
        expect(exception.message, 'Unauthorized');
      });

      test('handles 403 Forbidden', () {
        const exception = ServerException(
          message: 'Forbidden',
          statusCode: 403,
        );

        expect(exception.statusCode, 403);
      });

      test('handles 404 Not Found', () {
        const exception = ServerException(
          message: 'Not Found',
          statusCode: 404,
        );

        expect(exception.statusCode, 404);
      });

      test('handles 500 Internal Server Error', () {
        const exception = ServerException(
          message: 'Internal Server Error',
          statusCode: 500,
        );

        expect(exception.statusCode, 500);
      });

      test('handles 503 Service Unavailable', () {
        const exception = ServerException(
          message: 'Service Unavailable',
          statusCode: 503,
        );

        expect(exception.statusCode, 503);
      });
    });

    group('toString', () {
      test('includes status code and message', () {
        const exception = ServerException(
          message: 'Internal server error',
          statusCode: 500,
        );

        expect(
          exception.toString(),
          'ServerException [500]: Internal server error',
        );
      });

      test('works with different status codes', () {
        const exception = ServerException(
          message: 'Not found',
          statusCode: 404,
        );

        expect(
          exception.toString(),
          'ServerException [404]: Not found',
        );
      });
    });

    test('is an Exception', () {
      const exception = ServerException(
        message: 'Error',
        statusCode: 500,
      );

      expect(exception, isA<Exception>());
    });
  });
}
