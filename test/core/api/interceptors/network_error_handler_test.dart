import 'dart:async';
import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:starter_app/core/api/interceptors/network_error_handler.dart';
import 'package:starter_app/core/error/exceptions/exceptions.dart';

void main() {
  group('NetworkErrorHandler', () {
    const handler = NetworkErrorHandler();

    test('converts SocketException to NetworkException', () {
      const socketException = SocketException('No internet connection');

      expect(
        () => handler.handleError(socketException, StackTrace.current),
        throwsA(
          isA<NetworkException>().having(
            (e) => e.message,
            'message',
            'No internet connection. Please check your network.',
          ),
        ),
      );
    });

    test('converts CircuitBreakerException to NetworkException', () {
      const circuitException = CircuitBreakerException('Service unavailable');

      expect(
        () => handler.handleError(circuitException, StackTrace.current),
        throwsA(
          isA<NetworkException>().having(
            (e) => e.message,
            'message',
            'Service unavailable',
          ),
        ),
      );
    });

    test('converts TimeoutException to NetworkException', () {
      final timeoutException = TimeoutException(
        'Operation timed out',
        const Duration(seconds: 5),
      );

      expect(
        () => handler.handleError(timeoutException, StackTrace.current),
        throwsA(
          isA<NetworkException>().having(
            (e) => e.message,
            'message',
            'Request timeout. Please try again.',
          ),
        ),
      );
    });

    test('converts ChopperHttpException to NetworkException', () {
      final httpException = ChopperHttpException(
        Response(
          http.Response('', 500),
          null,
          error: 'Internal Server Error',
        ),
      );

      expect(
        () => handler.handleError(httpException, StackTrace.current),
        throwsA(
          isA<NetworkException>().having(
            (e) => e.message,
            'message',
            contains('Network error'),
          ),
        ),
      );
    });

    test('converts ChopperException to NetworkException', () {
      final chopperException = ChopperException('Connection failed');

      expect(
        () => handler.handleError(chopperException, StackTrace.current),
        throwsA(
          isA<NetworkException>().having(
            (e) => e.message,
            'message',
            'Network error: Connection failed',
          ),
        ),
      );
    });

    test('converts unknown errors to NetworkException', () {
      final unknownError = Exception('Unexpected error');

      expect(
        () => handler.handleError(unknownError, StackTrace.current),
        throwsA(
          isA<NetworkException>().having(
            (e) => e.message,
            'message',
            'An unexpected network error occurred',
          ),
        ),
      );
    });

    test('preserves original error in NetworkException', () {
      const socketException = SocketException('No internet connection');
      late NetworkException caughtException;

      try {
        handler.handleError(socketException, StackTrace.current);
      } on NetworkException catch (e) {
        caughtException = e;
      }

      expect(caughtException.originalError, socketException);
    });
  });
}
