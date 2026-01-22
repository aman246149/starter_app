import 'package:chopper/chopper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/core/api/interceptors/circuit_breaker_interceptor.dart';
import 'package:starter_app/core/domain/ports/ports.dart';
import 'package:starter_app/core/error/exceptions/circuit_breaker_exception.dart';
import 'package:starter_app/core/infrastructure/circuit_breaker/circuit_breaker_config.dart';
import 'package:starter_app/core/infrastructure/circuit_breaker/circuit_breaker_impl.dart';
import 'package:starter_app/core/logging/i_app_logger.dart';

class MockAppLogger extends Mock implements IAppLogger {}

class MockChain extends Mock implements Chain<dynamic> {}

void main() {
  group('CircuitBreakerImpl', () {
    late CircuitBreakerImpl circuitBreaker;
    late MockAppLogger mockLogger;

    setUp(() {
      mockLogger = MockAppLogger();
      circuitBreaker = CircuitBreakerImpl(
        logger: mockLogger,
        config: const CircuitBreakerConfig(
          failureThreshold: 2,
          resetTimeout: Duration(milliseconds: 100),
        ),
      );
    });

    test('should implement ICircuitBreaker', () {
      expect(circuitBreaker, isA<ICircuitBreaker>());
    });

    test('should start in closed state', () {
      expect(circuitBreaker.isOpen, false);
    });

    test('should stay closed on success', () {
      circuitBreaker.onSuccess();
      expect(circuitBreaker.isOpen, false);
    });

    test('should open after threshold failures', () {
      circuitBreaker.onFailure('error 1');
      expect(circuitBreaker.isOpen, false);

      circuitBreaker.onFailure('error 2');
      expect(circuitBreaker.isOpen, true);
      verify(() => mockLogger.error(any())).called(1);
    });

    test('should transition to half-open after timeout', () async {
      // Trip the circuit
      circuitBreaker
        ..onFailure('error 1')
        ..onFailure('error 2');
      expect(circuitBreaker.isOpen, true);

      // Wait for reset timeout
      await Future<void>.delayed(const Duration(milliseconds: 150));

      // Should allow one probe request (returns false for isOpen)
      expect(circuitBreaker.isOpen, false);
      verify(() => mockLogger.info(any(that: contains('HALF-OPEN')))).called(1);
    });

    test('should close circuit on success in half-open state', () async {
      // Trip the circuit
      circuitBreaker
        ..onFailure('error 1')
        ..onFailure('error 2');
      await Future<void>.delayed(const Duration(milliseconds: 150));

      // Probe request
      expect(circuitBreaker.isOpen, false); // Transitions to half-open

      // Success
      circuitBreaker.onSuccess();

      expect(circuitBreaker.isOpen, false);
      verify(() => mockLogger.info(any(that: contains('CLOSED')))).called(1);
    });

    test('should re-open circuit on failure in half-open state', () async {
      // Trip the circuit
      circuitBreaker
        ..onFailure('error 1')
        ..onFailure('error 2');
      await Future<void>.delayed(const Duration(milliseconds: 150));

      // Probe request
      expect(circuitBreaker.isOpen, false); // Transitions to half-open

      // Failure
      circuitBreaker.onFailure('probe failed');

      expect(circuitBreaker.isOpen, true);
      verify(() => mockLogger.error(any())).called(2); // Initial open + re-open
    });
  });

  group('CircuitBreakerInterceptor', () {
    late CircuitBreakerInterceptor interceptor;
    late MockChain mockChain;
    late CircuitBreakerImpl circuitBreaker;
    late MockAppLogger mockLogger;

    setUp(() {
      mockLogger = MockAppLogger();
      circuitBreaker = CircuitBreakerImpl(
        logger: mockLogger,
        config: const CircuitBreakerConfig(
          failureThreshold: 2,
          resetTimeout: Duration(milliseconds: 100),
        ),
      );
      interceptor = CircuitBreakerInterceptor(circuitBreaker);
      mockChain = MockChain();

      registerFallbackValue(
        Request(
          'GET',
          Uri.parse('https://example.com'),
          Uri.parse('https://example.com'),
        ),
      );
      when(() => mockChain.request).thenReturn(
        Request(
          'GET',
          Uri.parse('https://example.com'),
          Uri.parse('https://example.com'),
        ),
      );
    });

    test('should throw CircuitBreakerException if circuit is open', () async {
      // Trip circuit
      circuitBreaker
        ..onFailure('e1')
        ..onFailure('e2');

      expect(
        () => interceptor.intercept(mockChain),
        throwsA(isA<CircuitBreakerException>()),
      );
      verifyNever(() => mockChain.proceed(any()));
    });

    test('should proceed if circuit is closed', () async {
      final response = Response(http.Response('ok', 200), 'ok');
      when(() => mockChain.proceed(any())).thenAnswer((_) async => response);

      await interceptor.intercept(mockChain);

      verify(() => mockChain.proceed(any())).called(1);
    });

    test('should record failure on 500 response', () async {
      final response = Response(http.Response('error', 500), 'error');
      when(() => mockChain.proceed(any())).thenAnswer((_) async => response);

      await interceptor.intercept(mockChain);

      verify(() => mockLogger.warning(any(that: contains('500')))).called(1);
    });

    test('should record failure on exception', () async {
      when(
        () => mockChain.proceed(any()),
      ).thenThrow(Exception('Network error'));

      await expectLater(
        () => interceptor.intercept(mockChain),
        throwsA(isA<Exception>()),
      );

      verify(
        () => mockLogger.warning(any(that: contains('Network error'))),
      ).called(1);
    });
  });
}
