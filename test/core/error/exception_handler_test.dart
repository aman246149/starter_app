import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/core/error/exception_handler.dart';
import 'package:starter_app/core/error/exceptions/exceptions.dart';
import 'package:starter_app/core/error/failures/infrastructure_failures.dart';

void main() {
  late ExceptionHandler handler;

  setUp(() {
    handler = const ExceptionHandler();
  });

  group('ExceptionHandler', () {
    group('handle', () {
      test('returns Right with result on success', () async {
        // Arrange
        const expectedValue = 'success';

        // Act
        final result = await handler.handle(
          operation: () async => expectedValue,
        );

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should be Right'),
          (value) => expect(value, expectedValue),
        );
      });

      test('maps ServerException to InfrastructureFailure.server', () async {
        // Arrange
        const exception = ServerException(
          message: 'Server error',
          statusCode: 500,
        );

        // Act
        final result = await handler.handle<String>(
          operation: () async => throw exception,
        );

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<InfrastructureFailure>());
            final infraFailure = failure as InfrastructureFailure;
            expect(infraFailure.message, contains('Server error'));
          },
          (_) => fail('Should be Left'),
        );
      });

      test('uses custom serverExceptionMapper when provided', () async {
        // Arrange
        const exception = ServerException(
          message: 'Auth error',
          statusCode: 401,
        );
        const customFailure = InfrastructureFailure.network(
          message: 'Custom mapped failure',
        );

        // Act
        final result = await handler.handle<String>(
          operation: () async => throw exception,
          serverExceptionMapper: (_) => customFailure,
        );

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, customFailure);
          },
          (_) => fail('Should be Left'),
        );
      });

      test('maps NetworkException to InfrastructureFailure.network', () async {
        // Arrange
        const exception = NetworkException(message: 'No internet');

        // Act
        final result = await handler.handle<String>(
          operation: () async => throw exception,
        );

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<InfrastructureFailure>());
            final infraFailure = failure as InfrastructureFailure;
            expect(infraFailure.message, contains('No internet'));
          },
          (_) => fail('Should be Left'),
        );
      });

      test('maps CacheException to InfrastructureFailure.cache', () async {
        // Arrange
        const exception = CacheException(message: 'Cache miss');

        // Act
        final result = await handler.handle<String>(
          operation: () async => throw exception,
        );

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<InfrastructureFailure>());
            final infraFailure = failure as InfrastructureFailure;
            expect(infraFailure.message, contains('Cache miss'));
          },
          (_) => fail('Should be Left'),
        );
      });

      test(
        'maps CircuitBreakerException to InfrastructureFailure.circuitBreaker',
        () async {
          // Arrange
          const exception = CircuitBreakerException('Circuit open');

          // Act
          final result = await handler.handle<String>(
            operation: () async => throw exception,
          );

          // Assert
          expect(result.isLeft(), true);
          result.fold(
            (failure) {
              expect(failure, isA<InfrastructureFailure>());
              final infraFailure = failure as InfrastructureFailure;
              expect(infraFailure.message, contains('Circuit open'));
            },
            (_) => fail('Should be Left'),
          );
        },
      );

      test('maps FormatException to InfrastructureFailure.parse', () async {
        // Arrange
        const exception = FormatException('Invalid JSON');

        // Act
        final result = await handler.handle<String>(
          operation: () async => throw exception,
        );

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<InfrastructureFailure>());
            final infraFailure = failure as InfrastructureFailure;
            expect(infraFailure.message, contains('Invalid JSON'));
          },
          (_) => fail('Should be Left'),
        );
      });

      test('maps unknown Exception to InfrastructureFailure.parse', () async {
        // Arrange
        final exception = Exception('Unknown error');

        // Act
        final result = await handler.handle<String>(
          operation: () async => throw exception,
        );

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<InfrastructureFailure>());
            final infraFailure = failure as InfrastructureFailure;
            expect(infraFailure.message, contains('unexpected error'));
          },
          (_) => fail('Should be Left'),
        );
      });
    });
  });
}
