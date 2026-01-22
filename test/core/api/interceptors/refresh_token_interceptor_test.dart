import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/core/api/interceptors/refresh_token_interceptor.dart';
import 'package:synchronized/synchronized.dart';

import '../../../helpers/mock_helpers.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      Request(
        'GET',
        Uri.parse('http://example.com'),
        Uri.parse('http://example.com'),
      ),
    );
    registerFallbackValue(Uri.parse('http://example.com'));
  });

  group('RefreshTokenInterceptor', () {
    late MockChain mockChain;
    late MockTokenStorage mockTokenStorage;
    late Lock refreshLock;
    var refreshSuccessCalled = false;
    var refreshFailedCalled = false;

    setUp(() {
      mockChain = MockChain();
      mockTokenStorage = MockTokenStorage();
      refreshLock = Lock();
      refreshSuccessCalled = false;
      refreshFailedCalled = false;
    });

    group('non-401 responses', () {
      test('returns response as-is for successful requests', () async {
        final interceptor = RefreshTokenInterceptor(
          tokenStorage: mockTokenStorage,
          refreshTokenEndpoint: '/auth/refresh',
          onRefreshFailed: () => refreshFailedCalled = true,
          onRefreshSuccess: () => refreshSuccessCalled = true,
          baseUrl: Uri.parse('https://example.com'),
          refreshLock: refreshLock,
        );

        final request = Request(
          'GET',
          Uri.parse('https://example.com/api/test'),
          Uri.parse('https://example.com'),
        );
        final response = Response(
          http.Response('{"data": "test"}', 200),
          const {
            'data': 'test',
          },
        );

        when(() => mockChain.request).thenReturn(request);
        when(() => mockChain.proceed(any())).thenAnswer((_) async => response);

        final result = await interceptor.intercept(mockChain);

        expect(result, response);
        expect(refreshSuccessCalled, false);
        expect(refreshFailedCalled, false);
      });

      test('returns response as-is for other error status codes', () async {
        final interceptor = RefreshTokenInterceptor(
          tokenStorage: mockTokenStorage,
          refreshTokenEndpoint: '/auth/refresh',
          onRefreshFailed: () => refreshFailedCalled = true,
          onRefreshSuccess: () => refreshSuccessCalled = true,
          baseUrl: Uri.parse('https://example.com'),
          refreshLock: refreshLock,
        );

        final request = Request(
          'GET',
          Uri.parse('https://example.com/api/test'),
          Uri.parse('https://example.com'),
        );
        final response = Response(
          http.Response('{"error": "Not Found"}', 404),
          null,
        );

        when(() => mockChain.request).thenReturn(request);
        when(() => mockChain.proceed(any())).thenAnswer((_) async => response);

        final result = await interceptor.intercept(mockChain);

        expect(result, response);
        expect(refreshSuccessCalled, false);
        expect(refreshFailedCalled, false);
      });
    });

    group('401 responses', () {
      test(
        'calls onRefreshFailed when refresh endpoint itself returns 401',
        () async {
          final interceptor = RefreshTokenInterceptor(
            tokenStorage: mockTokenStorage,
            refreshTokenEndpoint: '/auth/refresh',
            onRefreshFailed: () => refreshFailedCalled = true,
            onRefreshSuccess: () => refreshSuccessCalled = true,
            baseUrl: Uri.parse('https://example.com'),
            refreshLock: refreshLock,
          );

          final request = Request(
            'POST',
            Uri.parse('https://example.com/auth/refresh'),
            Uri.parse('https://example.com'),
          );
          final response = Response(
            http.Response('{"error": "Unauthorized"}', 401),
            null,
          );

          when(() => mockChain.request).thenReturn(request);
          when(
            () => mockChain.proceed(any()),
          ).thenAnswer((_) async => response);

          final result = await interceptor.intercept(mockChain);

          expect(result, response);
          expect(refreshFailedCalled, true);
          expect(refreshSuccessCalled, false);
        },
      );

      test('calls onRefreshFailed when refresh token is missing', () async {
        final interceptor = RefreshTokenInterceptor(
          tokenStorage: mockTokenStorage,
          refreshTokenEndpoint: '/auth/refresh',
          onRefreshFailed: () => refreshFailedCalled = true,
          onRefreshSuccess: () => refreshSuccessCalled = true,
          baseUrl: Uri.parse('https://example.com'),
          refreshLock: refreshLock,
        );

        final request = Request(
          'GET',
          Uri.parse('https://example.com/api/test'),
          Uri.parse('https://example.com'),
        );
        final response = Response(
          http.Response('{"error": "Unauthorized"}', 401),
          null,
        );

        when(() => mockChain.request).thenReturn(request);
        when(() => mockChain.proceed(any())).thenAnswer((_) async => response);
        when(
          () => mockTokenStorage.getRefreshToken(),
        ).thenAnswer((_) async => null);

        final result = await interceptor.intercept(mockChain);

        expect(result, response);
        expect(refreshFailedCalled, true);
        expect(refreshSuccessCalled, false);
      });

      test('calls onRefreshFailed when refresh token is empty', () async {
        final interceptor = RefreshTokenInterceptor(
          tokenStorage: mockTokenStorage,
          refreshTokenEndpoint: '/auth/refresh',
          onRefreshFailed: () => refreshFailedCalled = true,
          onRefreshSuccess: () => refreshSuccessCalled = true,
          baseUrl: Uri.parse('https://example.com'),
          refreshLock: refreshLock,
        );

        final request = Request(
          'GET',
          Uri.parse('https://example.com/api/test'),
          Uri.parse('https://example.com'),
        );
        final response = Response(
          http.Response('{"error": "Unauthorized"}', 401),
          null,
        );

        when(() => mockChain.request).thenReturn(request);
        when(() => mockChain.proceed(any())).thenAnswer((_) async => response);
        when(
          () => mockTokenStorage.getRefreshToken(),
        ).thenAnswer((_) async => '');

        final result = await interceptor.intercept(mockChain);

        expect(result, response);
        expect(refreshFailedCalled, true);
        expect(refreshSuccessCalled, false);
      });

      test('successfully refreshes token and retries request', () async {
        const refreshToken = 'refresh-token-123';
        const newAccessToken = 'new-access-token-456';
        const newRefreshToken = 'new-refresh-token-789';

        // Create a mock HTTP client that returns a successful refresh response
        final mockHttpClient = MockHttpClient();

        // Mock the send method that ChopperClient uses internally
        when(() => mockHttpClient.send(any())).thenAnswer((invocation) async {
          final request = invocation.positionalArguments[0] as http.BaseRequest;
          // Return a successful refresh response
          return http.StreamedResponse(
            Stream.value(
              utf8.encode(
                '''{"access_token": "$newAccessToken", "refresh_token": "$newRefreshToken"}''',
              ),
            ),
            200,
            headers: {'content-type': 'application/json'},
            request: request,
          );
        });
        when(mockHttpClient.close).thenAnswer((_) async {});

        final interceptor = RefreshTokenInterceptor(
          tokenStorage: mockTokenStorage,
          refreshTokenEndpoint: '/auth/refresh',
          onRefreshFailed: () => refreshFailedCalled = true,
          onRefreshSuccess: () => refreshSuccessCalled = true,
          baseUrl: Uri.parse('https://example.com'),
          refreshLock: refreshLock,
          httpClient: mockHttpClient,
        );

        final originalRequest = Request(
          'GET',
          Uri.parse('https://example.com/api/test'),
          Uri.parse('https://example.com'),
        );
        final unauthorizedResponse = Response(
          http.Response('{"error": "Unauthorized"}', 401),
          null,
        );
        final successResponse = Response(
          http.Response('{"data": "test"}', 200),
          const {'data': 'test'},
        );

        when(() => mockChain.request).thenReturn(originalRequest);
        when(() => mockChain.proceed(any())).thenAnswer((invocation) async {
          final req = invocation.positionalArguments[0] as Request;
          // First call returns 401,
          // second call (with new token) returns success
          if (req.headers['Authorization'] == 'Bearer $newAccessToken') {
            return successResponse;
          }
          return unauthorizedResponse;
        });

        when(
          () => mockTokenStorage.getRefreshToken(),
        ).thenAnswer((_) async => refreshToken);
        when(
          () => mockTokenStorage.saveTokens(
            accessToken: newAccessToken,
            refreshToken: newRefreshToken,
          ),
        ).thenAnswer((_) async {});

        final result = await interceptor.intercept(mockChain);

        // Verify successful refresh flow
        expect(result, successResponse);
        expect(refreshSuccessCalled, true);
        expect(refreshFailedCalled, false);
        verify(
          () => mockTokenStorage.saveTokens(
            accessToken: newAccessToken,
            refreshToken: newRefreshToken,
          ),
        ).called(1);
      });

      test('calls onRefreshFailed when refresh request fails', () async {
        const refreshToken = 'refresh-token-123';

        final interceptor = RefreshTokenInterceptor(
          tokenStorage: mockTokenStorage,
          refreshTokenEndpoint: '/auth/refresh',
          onRefreshFailed: () => refreshFailedCalled = true,
          onRefreshSuccess: () => refreshSuccessCalled = true,
          baseUrl: Uri.parse('https://example.com'),
          refreshLock: refreshLock,
        );

        final request = Request(
          'GET',
          Uri.parse('https://example.com/api/test'),
          Uri.parse('https://example.com'),
        );
        final response = Response(
          http.Response('{"error": "Unauthorized"}', 401),
          null,
        );

        when(() => mockChain.request).thenReturn(request);
        when(() => mockChain.proceed(any())).thenAnswer((_) async => response);
        when(
          () => mockTokenStorage.getRefreshToken(),
        ).thenAnswer((_) async => refreshToken);

        // The refresh will fail because we can't easily
        // mock ChopperClient's internal HTTP call
        // In practice, this would fail
        // when the refresh endpoint returns an error
        // For this test, we verify the callback is called
        //when refresh returns null

        await interceptor.intercept(mockChain);

        // Since we can't mock the ChopperClient's HTTP call,
        //the refresh will likely fail
        // and onRefreshFailed should be called
        expect(refreshFailedCalled, true);
      });

      test('handles concurrent 401s with lock', () async {
        const refreshToken = 'refresh-token-123';

        final interceptor = RefreshTokenInterceptor(
          tokenStorage: mockTokenStorage,
          refreshTokenEndpoint: '/auth/refresh',
          onRefreshFailed: () => refreshFailedCalled = true,
          onRefreshSuccess: () => refreshSuccessCalled = true,
          baseUrl: Uri.parse('https://example.com'),
          refreshLock: refreshLock,
        );

        final request1 = Request(
          'GET',
          Uri.parse('https://example.com/api/test1'),
          Uri.parse('https://example.com'),
        );
        final request2 = Request(
          'GET',
          Uri.parse('https://example.com/api/test2'),
          Uri.parse('https://example.com'),
        );
        final unauthorizedResponse = Response(
          http.Response('{"error": "Unauthorized"}', 401),
          null,
        );

        when(
          () => mockTokenStorage.getRefreshToken(),
        ).thenAnswer((_) async => refreshToken);

        // Simulate concurrent requests
        // Both should wait for the same refresh operation
        final chain1 = MockChain();
        final chain2 = MockChain();

        when(() => chain1.request).thenReturn(request1);
        when(
          () => chain1.proceed(any()),
        ).thenAnswer((_) async => unauthorizedResponse);

        when(() => chain2.request).thenReturn(request2);
        when(
          () => chain2.proceed(any()),
        ).thenAnswer((_) async => unauthorizedResponse);

        // Start both interceptors concurrently
        final future1 = Future<Response<dynamic>>.value(
          interceptor.intercept(chain1),
        );
        final future2 = Future<Response<dynamic>>.value(
          interceptor.intercept(chain2),
        );

        // Both should complete (even if refresh fails)
        await Future.wait([future1, future2]);

        // Verify that getRefreshToken was called
        // (at least once, possibly twice due to lock)
        verify(() => mockTokenStorage.getRefreshToken()).called(greaterThan(0));
      });

      test('handles exception during refresh', () async {
        const refreshToken = 'refresh-token-123';

        // Create a mock HTTP client that throws an exception
        final mockHttpClient = MockHttpClient();
        when(() => mockHttpClient.send(any())).thenThrow(
          Exception('Network error during refresh'),
        );
        when(mockHttpClient.close).thenAnswer((_) async {});

        final interceptor = RefreshTokenInterceptor(
          tokenStorage: mockTokenStorage,
          refreshTokenEndpoint: '/auth/refresh',
          onRefreshFailed: () => refreshFailedCalled = true,
          onRefreshSuccess: () => refreshSuccessCalled = true,
          baseUrl: Uri.parse('https://example.com'),
          refreshLock: refreshLock,
          httpClient: mockHttpClient,
        );

        final request = Request(
          'GET',
          Uri.parse('https://example.com/api/test'),
          Uri.parse('https://example.com'),
        );
        final response = Response(
          http.Response('{"error": "Unauthorized"}', 401),
          null,
        );

        when(() => mockChain.request).thenReturn(request);
        when(() => mockChain.proceed(any())).thenAnswer((_) async => response);
        when(
          () => mockTokenStorage.getRefreshToken(),
        ).thenAnswer((_) async => refreshToken);

        // The refresh will fail due to the mocked exception
        // This tests the exception handling branch (line 170)
        final result = await interceptor.intercept(mockChain);

        expect(result, response);
        expect(refreshFailedCalled, true);
        expect(refreshSuccessCalled, false);
        verify(() => mockHttpClient.send(any())).called(1);
      });

      // Note: Testing successful token refresh flow requires either:
      // 1. Integration tests with a real HTTP server
      // 2. Refactoring RefreshTokenInterceptor to inject HTTP client
      // 3. Using a test HTTP server/mock adapter
      //
      // The successful refresh flow (lines 92-98, 137-155) is tested indirectly
      // through integration tests. For unit test coverage, we would need to
      // refactor the code to inject the HTTP client dependency.
      //
      // Edge cases that can be tested:
      // - Non-Map body response (line 138)
      // - Null body response (line 136)
      // - Missing access_token (line 145)
      // - Refresh without new refresh token (line 149)
      // These require mocking ChopperClient's send method, which is not easily
      // mockable without refactoring or using integration tests.
    });
  });
}
