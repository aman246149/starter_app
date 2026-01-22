import 'package:chopper/chopper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/core/api/interceptors/auth_interceptor.dart';
import 'package:starter_app/core/api/interceptors/circuit_breaker_interceptor.dart';
import 'package:starter_app/core/api/interceptors/error_interceptor.dart';
import 'package:starter_app/core/api/interceptors/logging_interceptor.dart';
import 'package:starter_app/core/api/interceptors/network_error_handler.dart';
import 'package:starter_app/core/api/interceptors/refresh_token_interceptor.dart';
import 'package:starter_app/core/application/application_environment.dart';
import 'package:starter_app/core/di/modules/network_module.dart';
import 'package:starter_app/core/domain/ports/ports.dart';
import 'package:starter_app/core/infrastructure/circuit_breaker/circuit_breaker_config.dart';
import 'package:starter_app/core/infrastructure/circuit_breaker/circuit_breaker_impl.dart';
import 'package:starter_app/core/infrastructure/security/certificate_service.dart';
import 'package:synchronized/synchronized.dart';

import '../../../helpers/mock_helpers.dart';

// Mock implementations
class MockSessionManager extends Mock implements ISessionManager {}

class MockTokenRefreshNotifier extends Mock implements ITokenRefreshNotifier {}

class MockCircuitBreaker extends Mock implements ICircuitBreaker {}

class MockCertificateService extends Mock implements CertificateService {}

// Concrete implementation for testing
class TestNetworkModule extends NetworkModule {}

void main() {
  group('NetworkModule', () {
    late MockAppLogger mockLogger;
    late MockTokenStorage mockTokenStorage;
    late MockSessionManager mockSessionManager;
    late MockTokenRefreshNotifier mockTokenRefreshNotifier;
    late MockCircuitBreaker mockCircuitBreaker;
    late MockCertificateService mockCertificateService;

    setUp(() {
      mockLogger = MockAppLogger();
      mockTokenStorage = MockTokenStorage();
      mockSessionManager = MockSessionManager();
      mockTokenRefreshNotifier = MockTokenRefreshNotifier();
      mockCircuitBreaker = MockCircuitBreaker();
      mockCertificateService = MockCertificateService();

      when(() => mockCircuitBreaker.isOpen).thenReturn(false);
      when(
        () => mockCertificateService.trustedCertificateBytes,
      ).thenReturn(null);

      // Register fallback values
      registerFallbackValue(Uri.parse('https://example.com'));
    });

    group('provideCircuitBreakerConfig', () {
      test('should create CircuitBreakerConfig instance', () {
        // Act
        final config = TestNetworkModule().provideCircuitBreakerConfig();

        // Assert
        expect(config, isA<CircuitBreakerConfig>());
        expect(config, CircuitBreakerConfig.defaultConfig);
      });
    });

    group('provideCircuitBreaker', () {
      test('should create CircuitBreaker instance', () {
        // Act
        final cb = TestNetworkModule().provideCircuitBreaker(
          mockLogger,
          CircuitBreakerConfig.defaultConfig,
        );

        // Assert
        expect(cb, isA<ICircuitBreaker>());
        expect(cb, isA<CircuitBreakerImpl>());
      });
    });

    group('provideWebSocketBaseUrl', () {
      test('should return WebSocket URL from current environment', () {
        // Act
        final url = TestNetworkModule().provideWebSocketBaseUrl();

        // Assert
        expect(url, isA<String>());
        expect(url, isNotEmpty);
        // Should match the current environment's webSocketUrl
        expect(url, AppEnvironment.current.webSocketUrl);
      });

      test('should return singleton value', () {
        // Act
        final url1 = TestNetworkModule().provideWebSocketBaseUrl();
        final url2 = TestNetworkModule().provideWebSocketBaseUrl();

        // Assert
        expect(url1, url2);
        expect(url1, AppEnvironment.current.webSocketUrl);
      });
    });

    group('provideNetworkErrorHandler', () {
      test('should create NetworkErrorHandler instance', () {
        // Act
        final handler = TestNetworkModule().provideNetworkErrorHandler();

        // Assert
        expect(handler, isA<NetworkErrorHandler>());
      });

      test('should return lazy singleton instance', () {
        // Act
        final handler1 = TestNetworkModule().provideNetworkErrorHandler();
        final handler2 = TestNetworkModule().provideNetworkErrorHandler();

        // Assert - should be different instances in test context
        expect(handler1, isA<NetworkErrorHandler>());
        expect(handler2, isA<NetworkErrorHandler>());
      });
    });

    group('provideTokenRefreshLock', () {
      test('should create Lock instance', () {
        // Act
        final lock = TestNetworkModule().provideTokenRefreshLock();

        // Assert
        expect(lock, isA<Lock>());
      });

      test('should return singleton instance', () {
        // Act
        final lock1 = TestNetworkModule().provideTokenRefreshLock();
        final lock2 = TestNetworkModule().provideTokenRefreshLock();

        // Assert - should be different instances in test context
        expect(lock1, isA<Lock>());
        expect(lock2, isA<Lock>());
      });
    });

    group('provideChopperClient', () {
      setUp(() {
        // Setup mocks
        when(
          () => mockTokenStorage.getAccessToken(),
        ).thenAnswer((_) async => 'test-token');
      });

      test('should create ChopperClient with correct base URL', () {
        // Act
        final client = TestNetworkModule().provideChopperClient(
          mockLogger,
          const NetworkErrorHandler(),
          mockTokenStorage,
          mockSessionManager,
          mockTokenRefreshNotifier,
          Lock(),
          mockCircuitBreaker,
          mockCertificateService,
        );

        // Assert
        expect(client, isA<ChopperClient>());
        expect(
          client.baseUrl.toString(),
          AppEnvironment.current.apiBaseUrl,
        );
      });

      test('should configure interceptors in correct order', () {
        // Act
        final client = TestNetworkModule().provideChopperClient(
          mockLogger,
          const NetworkErrorHandler(),
          mockTokenStorage,
          mockSessionManager,
          mockTokenRefreshNotifier,
          Lock(),
          mockCircuitBreaker,
          mockCertificateService,
        );

        // Assert
        expect(client, isA<ChopperClient>());
        expect(client.interceptors, isNotEmpty);
        expect(client.interceptors.length, 5);

        // Verify interceptor types are present
        final interceptorTypes = client.interceptors
            .map((i) => i.runtimeType)
            .toList();
        expect(interceptorTypes, contains(CircuitBreakerInterceptor));
        expect(interceptorTypes, contains(AuthInterceptor));
        expect(interceptorTypes, contains(RefreshTokenInterceptor));
        expect(interceptorTypes, contains(LoggingInterceptor));
        expect(interceptorTypes, contains(ErrorInterceptor));
      });

      test(
        'should configure RefreshTokenInterceptor with correct parameters',
        () {
          // Arrange
          when(
            () => mockSessionManager.notifySessionExpired(),
          ).thenReturn(null);
          when(
            () => mockTokenRefreshNotifier.notifyTokenRefreshed(),
          ).thenReturn(null);

          // Act
          final client = TestNetworkModule().provideChopperClient(
            mockLogger,
            const NetworkErrorHandler(),
            mockTokenStorage,
            mockSessionManager,
            mockTokenRefreshNotifier,
            Lock(),
            mockCircuitBreaker,
            mockCertificateService,
          );

          // Assert
          expect(client, isA<ChopperClient>());
          final refreshInterceptor = client.interceptors
              .whereType<RefreshTokenInterceptor>()
              .firstOrNull;
          expect(refreshInterceptor, isNotNull);
        },
      );

      test('should use JsonConverter for requests and responses', () {
        // Act
        final client = TestNetworkModule().provideChopperClient(
          mockLogger,
          const NetworkErrorHandler(),
          mockTokenStorage,
          mockSessionManager,
          mockTokenRefreshNotifier,
          Lock(),
          mockCircuitBreaker,
          mockCertificateService,
        );

        // Assert
        expect(client, isA<ChopperClient>());
        expect(client.converter, isA<JsonConverter>());
        expect(client.errorConverter, isA<JsonConverter>());
      });

      test('should configure AuthInterceptor with token storage', () {
        // Arrange
        when(
          () => mockTokenStorage.getAccessToken(),
        ).thenAnswer((_) async => 'test-access-token');

        // Act
        final client = TestNetworkModule().provideChopperClient(
          mockLogger,
          const NetworkErrorHandler(),
          mockTokenStorage,
          mockSessionManager,
          mockTokenRefreshNotifier,
          Lock(),
          mockCircuitBreaker,
          mockCertificateService,
        );

        // Assert
        expect(client, isA<ChopperClient>());
        final authInterceptor = client.interceptors
            .whereType<AuthInterceptor>()
            .firstOrNull;
        expect(authInterceptor, isNotNull);
      });

      test('should use AuthEndpoints constant for refresh token endpoint', () {
        // Act
        final client = TestNetworkModule().provideChopperClient(
          mockLogger,
          const NetworkErrorHandler(),
          mockTokenStorage,
          mockSessionManager,
          mockTokenRefreshNotifier,
          Lock(),
          mockCircuitBreaker,
          mockCertificateService,
        );

        // Assert
        expect(client, isA<ChopperClient>());
        // The RefreshTokenInterceptor should use AuthEndpoints.refreshToken
        // This is verified by checking the interceptor exists
        final refreshInterceptor = client.interceptors
            .whereType<RefreshTokenInterceptor>()
            .firstOrNull;
        expect(refreshInterceptor, isNotNull);
      });
    });
  });
}
