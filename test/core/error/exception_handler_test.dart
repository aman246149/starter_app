import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:starter_app/core/error/exception_handler.dart';
import 'package:starter_app/core/error/exceptions/exceptions.dart';
import 'package:starter_app/core/error/failures/failures.dart';

void main() {
  group('ExceptionHandler', () {
    late ExceptionHandler exceptionHandler;

    setUp(() {
      exceptionHandler = const ExceptionHandler();
    });

    group('handle', () {
      test('returns Right when operation succeeds', () async {
        final result = await exceptionHandler.handle(
          operation: () async => 'success',
        );

        expect(result, isA<Right<Failure, String>>());
        expect(result.getOrElse((l) => 'failed'), 'success');
      });

      test('maps ServerException to InfrastructureFailure.server', () async {
        final result = await exceptionHandler.handle(
          operation: () async => throw const ServerException(
            message: 'Server error',
            statusCode: 500,
          ),
        );

        expect(result, isA<Left<Failure, dynamic>>());
        result.fold(
          (failure) {
            expect(failure, isA<InfrastructureFailure>());
            expect(failure.message, 'Server error');
            expect(
              (failure as InfrastructureFailure).when(
                server: (msg, code, _) => code,
                network: (_, _) => null,
                cache: (_, _) => null,
                parse: (_, _) => null,
                circuitBreaker: (_, _) => null,
              ),
              500,
            );
          },
          (r) => fail('Should be Left'),
        );
      });

      test('uses custom serverExceptionMapper when provided', () async {
        final result = await exceptionHandler.handle(
          operation: () async => throw const ServerException(
            message: 'Not found',
            statusCode: 404,
          ),
          serverExceptionMapper: (e) {
            if (e.statusCode == 404) {
              return const InfrastructureFailure.server(
                message: 'Custom 404 message',
                statusCode: 404,
              );
            }
            return InfrastructureFailure.server(
              message: e.message,
              statusCode: e.statusCode,
            );
          },
        );

        expect(result, isA<Left<Failure, dynamic>>());
        result.fold(
          (failure) {
            expect(failure.message, 'Custom 404 message');
          },
          (r) => fail('Should be Left'),
        );
      });

      test('maps NetworkException to InfrastructureFailure.network', () async {
        final result = await exceptionHandler.handle(
          operation: () async => throw const NetworkException(
            message: 'No internet',
          ),
        );

        expect(result, isA<Left<Failure, dynamic>>());
        result.fold(
          (failure) {
            expect(failure, isA<InfrastructureFailure>());
            expect(failure.message, 'No internet');
          },
          (r) => fail('Should be Left'),
        );
      });

      test('maps CacheException to InfrastructureFailure.cache', () async {
        final result = await exceptionHandler.handle(
          operation: () async => throw const CacheException(
            message: 'Cache read failed',
          ),
        );

        expect(result, isA<Left<Failure, dynamic>>());
        result.fold(
          (failure) {
            expect(failure, isA<InfrastructureFailure>());
            expect(failure.message, 'Cache read failed');
          },
          (r) => fail('Should be Left'),
        );
      });

      test('uses default message for CacheException without message', () async {
        final result = await exceptionHandler.handle(
          operation: () async => throw const CacheException(),
        );

        expect(result, isA<Left<Failure, dynamic>>());
        result.fold(
          (failure) {
            expect(failure.message, 'Cache operation failed');
          },
          (r) => fail('Should be Left'),
        );
      });

      test('maps FormatException to InfrastructureFailure.parse', () async {
        final result = await exceptionHandler.handle(
          operation: () async => throw const FormatException('Invalid JSON'),
        );

        expect(result, isA<Left<Failure, dynamic>>());
        result.fold(
          (failure) {
            expect(failure, isA<InfrastructureFailure>());
            expect(failure.message, 'Invalid JSON');
          },
          (r) => fail('Should be Left'),
        );
      });

      test('maps generic Exception to InfrastructureFailure.parse', () async {
        final result = await exceptionHandler.handle(
          operation: () async => throw Exception('Generic error'),
        );

        expect(result, isA<Left<Failure, dynamic>>());
        result.fold(
          (failure) {
            expect(failure, isA<InfrastructureFailure>());
            expect(
              failure.message,
              contains('An unexpected error occurred'),
            );
          },
          (r) => fail('Should be Left'),
        );
      });

      test(
        'maps CircuitBreakerException to InfrastructureFailure.circuitBreaker',
        () async {
          final result = await exceptionHandler.handle(
            operation: () async => throw const CircuitBreakerException(
              'Service unavailable',
            ),
          );

          expect(result, isA<Left<Failure, dynamic>>());
          result.fold(
            (failure) {
              expect(failure, isA<InfrastructureFailure>());
              expect(failure, isA<CircuitBreakerFailure>());
              expect(failure.message, 'Service unavailable');
            },
            (r) => fail('Should be Left'),
          );
        },
      );

      test('preserves generic type from operation', () async {
        final intResult = await exceptionHandler.handle<int>(
          operation: () async => 42,
        );

        final stringResult = await exceptionHandler.handle<String>(
          operation: () async => 'hello',
        );

        expect(intResult, isA<Right<Failure, int>>());
        expect(stringResult, isA<Right<Failure, String>>());
      });

      test('handles async operations correctly', () async {
        final result = await exceptionHandler.handle(
          operation: () async {
            await Future<void>.delayed(const Duration(milliseconds: 10));
            return 'delayed success';
          },
        );

        expect(result.getOrElse((l) => 'failed'), 'delayed success');
      });

      test('handles multiple exception types in sequence', () async {
        final results = <Either<Failure, String>>[
          await exceptionHandler.handle(
            operation: () async => throw const NetworkException(),
          ),
          await exceptionHandler.handle(
            operation: () async => throw const CacheException(),
          ),
          await exceptionHandler.handle(
            operation: () async => throw const ServerException(
              message: 'Error',
              statusCode: 500,
            ),
          ),
        ];

        expect(results.length, 3);
        expect(results[0], isA<Left<Failure, String>>());
        expect(results[1], isA<Left<Failure, String>>());
        expect(results[2], isA<Left<Failure, String>>());
      });
    });
  });
}
