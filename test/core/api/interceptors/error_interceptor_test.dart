import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/core/api/interceptors/error_interceptor.dart';
import 'package:starter_app/core/api/interceptors/network_error_handler.dart';
import 'package:starter_app/core/error/exceptions/exceptions.dart';

import '../../../helpers/mock_helpers.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(
      Request(
        'GET',
        Uri.parse('http://example.com'),
        Uri.parse('http://example.com'),
      ),
    );
  });

  group('ErrorInterceptor', () {
    late MockChain mockChain;
    late NetworkErrorHandler networkErrorHandler;

    setUp(() {
      mockChain = MockChain();
      networkErrorHandler = const NetworkErrorHandler();
    });

    group('successful responses', () {
      test('returns successful response without modification', () async {
        final interceptor = ErrorInterceptor(networkErrorHandler);
        final request = Request(
          'GET',
          Uri.parse('https://example.com/api/test'),
          Uri.parse('https://example.com'),
        );
        final response = Response(
          http.Response('{"data": "test"}', 200),
          const {'data': 'test'},
        );

        when(() => mockChain.request).thenReturn(request);
        when(() => mockChain.proceed(any())).thenAnswer((_) async => response);

        final result = await interceptor.intercept(mockChain);

        expect(result, response);
        expect(result.isSuccessful, true);
      });
    });

    group('error responses', () {
      test('throws ServerException for 4xx status codes', () async {
        final interceptor = ErrorInterceptor(networkErrorHandler);
        final request = Request(
          'GET',
          Uri.parse('https://example.com/api/test'),
          Uri.parse('https://example.com'),
        );
        final httpResponse = http.Response('{"message": "Not Found"}', 404);
        final response = Response(
          httpResponse,
          null,
          error: const {'message': 'Not Found'},
        );

        when(() => mockChain.request).thenReturn(request);
        when(() => mockChain.proceed(any())).thenAnswer((_) async => response);

        expect(
          () => interceptor.intercept(mockChain),
          throwsA(
            isA<NetworkException>().having(
              (e) => e.originalError,
              'originalError',
              isA<ServerException>()
                  .having(
                    (s) => s.message,
                    'message',
                    'Not Found',
                  )
                  .having(
                    (s) => s.statusCode,
                    'statusCode',
                    404,
                  ),
            ),
          ),
        );
      });

      test('throws ServerException for 5xx status codes', () async {
        final interceptor = ErrorInterceptor(networkErrorHandler);
        final request = Request(
          'GET',
          Uri.parse('https://example.com/api/test'),
          Uri.parse('https://example.com'),
        );
        final httpResponse = http.Response(
          '{"message": "Internal Server Error"}',
          500,
        );
        final response = Response(
          httpResponse,
          null,
          error: const {'message': 'Internal Server Error'},
        );

        when(() => mockChain.request).thenReturn(request);
        when(() => mockChain.proceed(any())).thenAnswer((_) async => response);

        expect(
          () => interceptor.intercept(mockChain),
          throwsA(
            isA<NetworkException>().having(
              (e) => e.originalError,
              'originalError',
              isA<ServerException>()
                  .having(
                    (s) => s.message,
                    'message',
                    'Internal Server Error',
                  )
                  .having(
                    (s) => s.statusCode,
                    'statusCode',
                    500,
                  ),
            ),
          ),
        );
      });

      test('extracts error message from Map error data', () async {
        final interceptor = ErrorInterceptor(networkErrorHandler);
        final request = Request(
          'GET',
          Uri.parse('https://example.com/api/test'),
          Uri.parse('https://example.com'),
        );
        final httpResponse = http.Response('', 400);
        final response = Response(
          httpResponse,
          null,
          error: const {'message': 'Bad Request', 'code': 'INVALID_INPUT'},
        );

        when(() => mockChain.request).thenReturn(request);
        when(() => mockChain.proceed(any())).thenAnswer((_) async => response);

        expect(
          () => interceptor.intercept(mockChain),
          throwsA(
            isA<NetworkException>().having(
              (e) => e.originalError,
              'originalError',
              isA<ServerException>().having(
                (s) => s.message,
                'message',
                'Bad Request',
              ),
            ),
          ),
        );
      });

      test('extracts error message from String error data', () async {
        final interceptor = ErrorInterceptor(networkErrorHandler);
        final request = Request(
          'GET',
          Uri.parse('https://example.com/api/test'),
          Uri.parse('https://example.com'),
        );
        final httpResponse = http.Response('', 400);
        final response = Response(httpResponse, null, error: 'Invalid request');

        when(() => mockChain.request).thenReturn(request);
        when(() => mockChain.proceed(any())).thenAnswer((_) async => response);

        expect(
          () => interceptor.intercept(mockChain),
          throwsA(
            isA<NetworkException>().having(
              (e) => e.originalError,
              'originalError',
              isA<ServerException>().having(
                (s) => s.message,
                'message',
                'Invalid request',
              ),
            ),
          ),
        );
      });

      test(
        'uses reason phrase as fallback when error message is missing',
        () async {
          final interceptor = ErrorInterceptor(networkErrorHandler);
          final request = Request(
            'GET',
            Uri.parse('https://example.com/api/test'),
            Uri.parse('https://example.com'),
          );
          final httpResponse = http.Response(
            '',
            404,
            reasonPhrase: 'Not Found',
          );
          final response = Response(httpResponse, null);

          when(() => mockChain.request).thenReturn(request);
          when(
            () => mockChain.proceed(any()),
          ).thenAnswer((_) async => response);

          expect(
            () => interceptor.intercept(mockChain),
            throwsA(
              isA<NetworkException>().having(
                (e) => e.originalError,
                'originalError',
                isA<ServerException>().having(
                  (s) => s.message,
                  'message',
                  'Not Found',
                ),
              ),
            ),
          );
        },
      );

      test(
        'uses default message when error message and reason phrase are missing',
        () async {
          final interceptor = ErrorInterceptor(networkErrorHandler);
          final request = Request(
            'GET',
            Uri.parse('https://example.com/api/test'),
            Uri.parse('https://example.com'),
          );
          final httpResponse = http.Response('', 400);
          final response = Response(httpResponse, null);

          when(() => mockChain.request).thenReturn(request);
          when(
            () => mockChain.proceed(any()),
          ).thenAnswer((_) async => response);

          expect(
            () => interceptor.intercept(mockChain),
            throwsA(
              isA<NetworkException>().having(
                (e) => e.originalError,
                'originalError',
                isA<ServerException>().having(
                  (s) => s.message,
                  'message',
                  'HTTP Error',
                ),
              ),
            ),
          );
        },
      );
    });

    group('network errors', () {
      test('delegates to NetworkErrorHandler for connection errors', () async {
        final interceptor = ErrorInterceptor(networkErrorHandler);
        final request = Request(
          'GET',
          Uri.parse('https://example.com/api/test'),
          Uri.parse('https://example.com'),
        );
        const socketException = SocketException('No internet connection');

        when(() => mockChain.request).thenReturn(request);
        when(() => mockChain.proceed(any())).thenThrow(socketException);

        expect(
          () => interceptor.intercept(mockChain),
          throwsA(isA<NetworkException>()),
        );
      });

      test('delegates to NetworkErrorHandler for timeout errors', () async {
        final interceptor = ErrorInterceptor(networkErrorHandler);
        final request = Request(
          'GET',
          Uri.parse('https://example.com/api/test'),
          Uri.parse('https://example.com'),
        );
        // Use ChopperException instead since
        //ChopperTimeoutException constructor is not accessible
        final timeoutException = ChopperException('Request timeout');

        when(() => mockChain.request).thenReturn(request);
        when(() => mockChain.proceed(any())).thenThrow(timeoutException);

        expect(
          () => interceptor.intercept(mockChain),
          throwsA(isA<NetworkException>()),
        );
      });
    });
  });
}
