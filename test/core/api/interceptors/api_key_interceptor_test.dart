import 'package:chopper/chopper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/core/api/interceptors/api_key_interceptor.dart';

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

  group('ApiKeyInterceptor', () {
    late MockChain mockChain;
    const apiKey = 'test-api-key-123';

    setUp(() {
      mockChain = MockChain();
    });

    group('header mode', () {
      test('adds API key as header with default header name', () async {
        const interceptor = ApiKeyInterceptor(
          apiKey: apiKey,
        );
        final request = Request(
          'GET',
          Uri.parse('https://example.com/api/test'),
          Uri.parse('https://example.com'),
        );
        final response = Response(http.Response('', 200), null);

        when(() => mockChain.request).thenReturn(request);
        when(() => mockChain.proceed(any())).thenAnswer((_) async => response);

        await interceptor.intercept(mockChain);

        verify(
          () => mockChain.proceed(
            any(
              that: predicate<Request>((req) {
                return req.headers['X-API-Key'] == apiKey;
              }),
            ),
          ),
        ).called(1);
      });

      test('adds API key as header with custom header name', () async {
        const customHeaderName = 'X-Custom-Key';
        const interceptor = ApiKeyInterceptor(
          apiKey: apiKey,
          headerName: customHeaderName,
        );
        final request = Request(
          'GET',
          Uri.parse('https://example.com/api/test'),
          Uri.parse('https://example.com'),
        );
        final response = Response(http.Response('', 200), null);

        when(() => mockChain.request).thenReturn(request);
        when(() => mockChain.proceed(any())).thenAnswer((_) async => response);

        await interceptor.intercept(mockChain);

        verify(
          () => mockChain.proceed(
            any(
              that: predicate<Request>((req) {
                return req.headers[customHeaderName] == apiKey &&
                    !req.headers.containsKey('X-API-Key');
              }),
            ),
          ),
        ).called(1);
      });
    });

    group('query parameter mode', () {
      test('adds API key as query parameter', () async {
        const interceptor = ApiKeyInterceptor(
          apiKey: apiKey,
          useHeader: false,
        );
        final request = Request(
          'GET',
          Uri.parse('https://example.com/api/test'),
          Uri.parse('https://example.com'),
        );
        final response = Response(http.Response('', 200), null);

        when(() => mockChain.request).thenReturn(request);
        when(() => mockChain.proceed(any())).thenAnswer((_) async => response);

        await interceptor.intercept(mockChain);

        verify(
          () => mockChain.proceed(
            any(
              that: predicate<Request>((req) {
                return req.url.queryParameters['api_key'] == apiKey &&
                    !req.headers.containsKey('X-API-Key');
              }),
            ),
          ),
        ).called(1);
      });

      test('preserves existing query parameters when adding API key', () async {
        const interceptor = ApiKeyInterceptor(
          apiKey: apiKey,
          useHeader: false,
        );
        final request = Request(
          'GET',
          Uri.parse('https://example.com/api/test?foo=bar&baz=qux'),
          Uri.parse('https://example.com'),
        );
        final response = Response(http.Response('', 200), null);

        when(() => mockChain.request).thenReturn(request);
        when(() => mockChain.proceed(any())).thenAnswer((_) async => response);

        await interceptor.intercept(mockChain);

        verify(
          () => mockChain.proceed(
            any(
              that: predicate<Request>((req) {
                return req.url.queryParameters['api_key'] == apiKey &&
                    req.url.queryParameters['foo'] == 'bar' &&
                    req.url.queryParameters['baz'] == 'qux';
              }),
            ),
          ),
        ).called(1);
      });

      test('overwrites existing api_key query parameter', () async {
        const interceptor = ApiKeyInterceptor(
          apiKey: apiKey,
          useHeader: false,
        );
        final request = Request(
          'GET',
          Uri.parse('https://example.com/api/test?api_key=old-key'),
          Uri.parse('https://example.com'),
        );
        final response = Response(http.Response('', 200), null);

        Request? capturedRequest;
        when(() => mockChain.request).thenReturn(request);
        when(() => mockChain.proceed(any())).thenAnswer((invocation) async {
          capturedRequest = invocation.positionalArguments[0] as Request;
          return response;
        });

        await interceptor.intercept(mockChain);

        verify(() => mockChain.proceed(any())).called(1);
        expect(capturedRequest, isNotNull);
        // Verify the new API key is set (old-key should be replaced)
        // Check the URL string directly
        // this is what will be used for the HTTP request
        // Note: Chopper's Request.copyWith
        // may preserve internal queryParameters state,
        // but the actual URL string used
        // for HTTP requests should have the new value
        final urlString = capturedRequest!.url.toString();
        // The URL string should contain the new API key
        expect(urlString, contains('api_key=$apiKey'));
        // And should not contain the old key
        // (unless it's part of another parameter value)
        expect(
          urlString.split('?').last.split('&'),
          isNot(contains('api_key=old-key')),
        );
      });
    });
  });
}
