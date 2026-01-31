import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/core/error/failures/failures.dart';

void main() {
  group('InfrastructureFailure', () {
    group('ServerFailure', () {
      test('creates server failure with message and status code', () {
        const failure = InfrastructureFailure.server(
          message: 'Internal server error',
          statusCode: 500,
        );

        expect(failure, isA<ServerFailure>());
        expect(failure.message, 'Internal server error');
        expect(failure.isRetryable, true);
        expect(failure.stackTrace, isNull);
      });

      test('creates server failure with stackTrace', () {
        final stackTrace = StackTrace.current;
        final failure = InfrastructureFailure.server(
          message: 'Error',
          statusCode: 500,
          stackTrace: stackTrace,
        );

        expect(failure.stackTrace, stackTrace);
      });

      test('creates server failure with only message', () {
        const failure = InfrastructureFailure.server(
          message: 'Server error',
        );

        expect(failure.message, 'Server error');
      });

      test('equals another server failure with same values', () {
        const failure1 = InfrastructureFailure.server(
          message: 'Error',
          statusCode: 500,
        );
        const failure2 = InfrastructureFailure.server(
          message: 'Error',
          statusCode: 500,
        );

        expect(failure1, failure2);
      });

      test('not equals server failure with different message', () {
        const failure1 = InfrastructureFailure.server(
          message: 'Error 1',
          statusCode: 500,
        );
        const failure2 = InfrastructureFailure.server(
          message: 'Error 2',
          statusCode: 500,
        );

        expect(failure1, isNot(failure2));
      });

      test('not equals server failure with different status code', () {
        const failure1 = InfrastructureFailure.server(
          message: 'Error',
          statusCode: 500,
        );
        const failure2 = InfrastructureFailure.server(
          message: 'Error',
          statusCode: 404,
        );

        expect(failure1, isNot(failure2));
      });

      test('not equals server failure when one has null status code', () {
        const failure1 = InfrastructureFailure.server(
          message: 'Error',
        );
        const failure2 = InfrastructureFailure.server(
          message: 'Error',
          statusCode: 500,
        );

        expect(failure1, isNot(failure2));
      });

      test('equals server failure when both have null status code', () {
        const failure1 = InfrastructureFailure.server(
          message: 'Error',
        );
        const failure2 = InfrastructureFailure.server(
          message: 'Error',
        );

        expect(failure1, failure2);
      });

      test('has consistent hashCode for equal instances', () {
        const failure1 = InfrastructureFailure.server(
          message: 'Error',
          statusCode: 500,
        );
        const failure2 = InfrastructureFailure.server(
          message: 'Error',
          statusCode: 500,
        );

        expect(failure1.hashCode, failure2.hashCode);
      });

      test('has different hashCode for different instances', () {
        const failure1 = InfrastructureFailure.server(
          message: 'Error 1',
          statusCode: 500,
        );
        const failure2 = InfrastructureFailure.server(
          message: 'Error 2',
          statusCode: 500,
        );

        expect(failure1.hashCode, isNot(failure2.hashCode));
      });

      test('copyWith creates new instance with updated message', () {
        const original = InfrastructureFailure.server(
          message: 'Original',
          statusCode: 500,
        );
        final updated = original.copyWith(
          message: 'Updated',
        );

        expect(updated.message, 'Updated');
        expect(
          updated.when(
            server: (msg, code, _) => code,
            network: (_, _) => null,
            cache: (_, _) => null,
            parse: (_, _) => null,
            circuitBreaker: (_, _) => null,
            unexpected: (_, _) => null,
          ),
          500,
        );
        expect(original.message, 'Original');
      });

      test('copyWith creates new instance with partial updates', () {
        const original = InfrastructureFailure.server(
          message: 'Original',
          statusCode: 500,
        );
        final updated = original.copyWith(message: 'Updated');

        expect(updated.message, 'Updated');
        expect(
          updated.when(
            server: (msg, code, _) => code,
            network: (_, _) => null,
            cache: (_, _) => null,
            parse: (_, _) => null,
            circuitBreaker: (_, _) => null,
            unexpected: (_, _) => null,
          ),
          500,
        );
      });

      test('is a Failure', () {
        const failure = InfrastructureFailure.server(
          message: 'Error',
          statusCode: 500,
        );

        expect(failure, isA<Failure>());
      });
    });

    group('NetworkFailure', () {
      test('creates network failure with default message', () {
        const failure = InfrastructureFailure.network();

        expect(failure, isA<NetworkFailure>());
        expect(failure.message, 'Network error');
        expect(failure.isRetryable, true);
        expect(failure.stackTrace, isNull);
      });

      test('creates network failure with stackTrace', () {
        final stackTrace = StackTrace.current;
        final failure = InfrastructureFailure.network(
          stackTrace: stackTrace,
        );

        expect(failure.stackTrace, stackTrace);
      });

      test('creates network failure with custom message', () {
        const failure = InfrastructureFailure.network(
          message: 'No internet connection',
        );

        expect(failure.message, 'No internet connection');
      });

      test('equals another network failure with same message', () {
        const failure1 = InfrastructureFailure.network(
          message: 'Connection timeout',
        );
        const failure2 = InfrastructureFailure.network(
          message: 'Connection timeout',
        );

        expect(failure1, failure2);
      });

      test('not equals network failure with different message', () {
        const failure1 = InfrastructureFailure.network(
          message: 'Connection timeout',
        );
        const failure2 = InfrastructureFailure.network(
          message: 'No internet',
        );

        expect(failure1, isNot(failure2));
      });

      test('has consistent hashCode for equal instances', () {
        const failure1 = InfrastructureFailure.network(
          message: 'Connection timeout',
        );
        const failure2 = InfrastructureFailure.network(
          message: 'Connection timeout',
        );

        expect(failure1.hashCode, failure2.hashCode);
      });

      test('has different hashCode for different messages', () {
        const failure1 = InfrastructureFailure.network(
          message: 'Connection timeout',
        );
        const failure2 = InfrastructureFailure.network(
          message: 'No internet',
        );

        expect(failure1.hashCode, isNot(failure2.hashCode));
      });

      test('copyWith creates new instance with updated message', () {
        const original = InfrastructureFailure.network(
          message: 'Original',
        );
        final updated = original.copyWith(message: 'Updated');

        expect(updated.message, 'Updated');
        expect(original.message, 'Original');
      });

      test('is retryable', () {
        const failure = InfrastructureFailure.network();

        expect(failure.isRetryable, true);
      });
    });

    group('CacheFailure', () {
      test('creates cache failure with default message', () {
        const failure = InfrastructureFailure.cache();

        expect(failure, isA<CacheFailure>());
        expect(failure.message, 'Cache error');
        expect(failure.isRetryable, false);
        expect(failure.stackTrace, isNull);
      });

      test('creates cache failure with stackTrace', () {
        final stackTrace = StackTrace.current;
        final failure = InfrastructureFailure.cache(
          stackTrace: stackTrace,
        );

        expect(failure.stackTrace, stackTrace);
      });

      test('creates cache failure with custom message', () {
        const failure = InfrastructureFailure.cache(
          message: 'Failed to read from cache',
        );

        expect(failure.message, 'Failed to read from cache');
      });

      test('is not retryable', () {
        const failure = InfrastructureFailure.cache();

        expect(failure.isRetryable, false);
      });

      test('equals another cache failure with same message', () {
        const failure1 = InfrastructureFailure.cache();
        const failure2 = InfrastructureFailure.cache();

        expect(failure1, failure2);
      });

      test('equals another cache failure with same custom message', () {
        const failure1 = InfrastructureFailure.cache(
          message: 'Custom cache error',
        );
        const failure2 = InfrastructureFailure.cache(
          message: 'Custom cache error',
        );

        expect(failure1, failure2);
      });

      test('not equals cache failure with different message', () {
        const failure1 = InfrastructureFailure.cache(
          message: 'Error 1',
        );
        const failure2 = InfrastructureFailure.cache(
          message: 'Error 2',
        );

        expect(failure1, isNot(failure2));
      });

      test('has consistent hashCode for equal instances', () {
        const failure1 = InfrastructureFailure.cache();
        const failure2 = InfrastructureFailure.cache();

        expect(failure1.hashCode, failure2.hashCode);
      });

      test('has different hashCode for different messages', () {
        const failure1 = InfrastructureFailure.cache(
          message: 'Error 1',
        );
        const failure2 = InfrastructureFailure.cache(
          message: 'Error 2',
        );

        expect(failure1.hashCode, isNot(failure2.hashCode));
      });

      test('copyWith creates new instance with updated message', () {
        const original = InfrastructureFailure.cache(
          message: 'Original',
        );
        final updated = original.copyWith(message: 'Updated');

        expect(updated.message, 'Updated');
        expect(original.message, 'Original');
      });
    });

    group('ParseFailure', () {
      test('creates parse failure with default message', () {
        const failure = InfrastructureFailure.parse();

        expect(failure, isA<ParseFailure>());
        expect(failure.message, 'Parse error');
        expect(failure.isRetryable, false);
        expect(failure.stackTrace, isNull);
      });

      test('creates parse failure with stackTrace', () {
        final stackTrace = StackTrace.current;
        final failure = InfrastructureFailure.parse(
          stackTrace: stackTrace,
        );

        expect(failure.stackTrace, stackTrace);
      });

      test('creates parse failure with custom message', () {
        const failure = InfrastructureFailure.parse(
          message: 'Failed to parse JSON',
        );

        expect(failure.message, 'Failed to parse JSON');
      });

      test('is not retryable', () {
        const failure = InfrastructureFailure.parse();

        expect(failure.isRetryable, false);
      });

      test('equals another parse failure with same message', () {
        const failure1 = InfrastructureFailure.parse();
        const failure2 = InfrastructureFailure.parse();

        expect(failure1, failure2);
      });

      test('equals another parse failure with same custom message', () {
        const failure1 = InfrastructureFailure.parse(
          message: 'Custom parse error',
        );
        const failure2 = InfrastructureFailure.parse(
          message: 'Custom parse error',
        );

        expect(failure1, failure2);
      });

      test('not equals parse failure with different message', () {
        const failure1 = InfrastructureFailure.parse(
          message: 'Error 1',
        );
        const failure2 = InfrastructureFailure.parse(
          message: 'Error 2',
        );

        expect(failure1, isNot(failure2));
      });

      test('has consistent hashCode for equal instances', () {
        const failure1 = InfrastructureFailure.parse();
        const failure2 = InfrastructureFailure.parse();

        expect(failure1.hashCode, failure2.hashCode);
      });

      test('has different hashCode for different messages', () {
        const failure1 = InfrastructureFailure.parse(
          message: 'Error 1',
        );
        const failure2 = InfrastructureFailure.parse(
          message: 'Error 2',
        );

        expect(failure1.hashCode, isNot(failure2.hashCode));
      });

      test('copyWith creates new instance with updated message', () {
        const original = InfrastructureFailure.parse(
          message: 'Original',
        );
        final updated = original.copyWith(message: 'Updated');

        expect(updated.message, 'Updated');
        expect(original.message, 'Original');
      });
    });

    group('CircuitBreakerFailure', () {
      test('creates circuit breaker failure with default message', () {
        const failure = InfrastructureFailure.circuitBreaker();

        expect(failure, isA<CircuitBreakerFailure>());
        expect(failure.message, 'Service temporarily unavailable');
        expect(failure.isRetryable, true);
        expect(failure.stackTrace, isNull);
      });

      test('creates circuit breaker failure with stackTrace', () {
        final stackTrace = StackTrace.current;
        final failure = InfrastructureFailure.circuitBreaker(
          stackTrace: stackTrace,
        );

        expect(failure.stackTrace, stackTrace);
      });

      test('creates circuit breaker failure with custom message', () {
        const failure = InfrastructureFailure.circuitBreaker(
          message: 'Circuit is open, try again later',
        );

        expect(failure.message, 'Circuit is open, try again later');
      });

      test('is retryable', () {
        const failure = InfrastructureFailure.circuitBreaker();

        expect(failure.isRetryable, true);
      });

      test('equals another circuit breaker failure with same message', () {
        const failure1 = InfrastructureFailure.circuitBreaker();
        const failure2 = InfrastructureFailure.circuitBreaker();

        expect(failure1, failure2);
      });

      test(
        'equals another circuit breaker failure with same custom message',
        () {
          const failure1 = InfrastructureFailure.circuitBreaker(
            message: 'Custom circuit breaker error',
          );
          const failure2 = InfrastructureFailure.circuitBreaker(
            message: 'Custom circuit breaker error',
          );

          expect(failure1, failure2);
        },
      );

      test('not equals circuit breaker failure with different message', () {
        const failure1 = InfrastructureFailure.circuitBreaker(
          message: 'Error 1',
        );
        const failure2 = InfrastructureFailure.circuitBreaker(
          message: 'Error 2',
        );

        expect(failure1, isNot(failure2));
      });

      test('has consistent hashCode for equal instances', () {
        const failure1 = InfrastructureFailure.circuitBreaker();
        const failure2 = InfrastructureFailure.circuitBreaker();

        expect(failure1.hashCode, failure2.hashCode);
      });

      test('has different hashCode for different messages', () {
        const failure1 = InfrastructureFailure.circuitBreaker(
          message: 'Error 1',
        );
        const failure2 = InfrastructureFailure.circuitBreaker(
          message: 'Error 2',
        );

        expect(failure1.hashCode, isNot(failure2.hashCode));
      });

      test('copyWith creates new instance with updated message', () {
        const original = InfrastructureFailure.circuitBreaker(
          message: 'Original',
        );
        final updated = original.copyWith(message: 'Updated');

        expect(updated.message, 'Updated');
        expect(original.message, 'Original');
      });
    });

    group('UnexpectedFailure', () {
      test('creates unexpected failure with default message', () {
        const failure = InfrastructureFailure.unexpected();

        expect(failure, isA<UnexpectedFailure>());
        expect(failure.message, 'An unexpected error occurred');
        expect(failure.isRetryable, false);
        expect(failure.stackTrace, isNull);
      });

      test('creates unexpected failure with stackTrace', () {
        final stackTrace = StackTrace.current;
        final failure = InfrastructureFailure.unexpected(
          stackTrace: stackTrace,
        );

        expect(failure.stackTrace, stackTrace);
      });

      test('creates unexpected failure with custom message', () {
        const failure = InfrastructureFailure.unexpected(
          message: 'Something went wrong',
        );

        expect(failure.message, 'Something went wrong');
      });

      test('is not retryable', () {
        const failure = InfrastructureFailure.unexpected();

        expect(failure.isRetryable, false);
      });

      test('equals another unexpected failure with same message', () {
        const failure1 = InfrastructureFailure.unexpected();
        const failure2 = InfrastructureFailure.unexpected();

        expect(failure1, failure2);
      });

      test('not equals unexpected failure with different message', () {
        const failure1 = InfrastructureFailure.unexpected(
          message: 'Error 1',
        );
        const failure2 = InfrastructureFailure.unexpected(
          message: 'Error 2',
        );

        expect(failure1, isNot(failure2));
      });

      test('copyWith creates new instance with updated message', () {
        const original = InfrastructureFailure.unexpected(
          message: 'Original',
        );
        final updated = original.copyWith(message: 'Updated');

        expect(updated.message, 'Updated');
        expect(original.message, 'Original');
      });
    });

    group('when pattern matching', () {
      test('matches server failure', () {
        const failure = InfrastructureFailure.server(
          message: 'Server error',
          statusCode: 500,
        );

        final result = failure.when(
          server: (message, statusCode, _) => 'Server: $message',
          network: (message, _) => 'Network: $message',
          cache: (message, _) => 'Cache: $message',
          parse: (message, _) => 'Parse: $message',
          circuitBreaker: (message, _) => 'CircuitBreaker: $message',
          unexpected: (message, _) => 'Unexpected: $message',
        );

        expect(result, 'Server: Server error');
      });

      test('matches server failure with null status code', () {
        const failure = InfrastructureFailure.server(
          message: 'Server error',
        );

        final result = failure.when(
          server: (message, statusCode, _) =>
              'Server: $message (code: $statusCode)',
          network: (message, _) => 'Network: $message',
          cache: (message, _) => 'Cache: $message',
          parse: (message, _) => 'Parse: $message',
          circuitBreaker: (message, _) => 'CircuitBreaker: $message',
          unexpected: (message, _) => 'Unexpected: $message',
        );

        expect(result, 'Server: Server error (code: null)');
      });

      test('matches network failure', () {
        const failure = InfrastructureFailure.network(
          message: 'No connection',
        );

        final result = failure.when(
          server: (message, statusCode, _) => 'Server',
          network: (message, _) => 'Network: $message',
          cache: (message, _) => 'Cache',
          parse: (message, _) => 'Parse',
          circuitBreaker: (message, _) => 'CircuitBreaker',
          unexpected: (message, _) => 'Unexpected',
        );

        expect(result, 'Network: No connection');
      });

      test('matches cache failure', () {
        const failure = InfrastructureFailure.cache(message: 'Cache failed');

        final result = failure.when(
          server: (message, statusCode, _) => 'Server',
          network: (message, _) => 'Network',
          cache: (message, _) => 'Cache: $message',
          parse: (message, _) => 'Parse',
          circuitBreaker: (message, _) => 'CircuitBreaker',
          unexpected: (message, _) => 'Unexpected',
        );

        expect(result, 'Cache: Cache failed');
      });

      test('matches parse failure', () {
        const failure = InfrastructureFailure.parse(message: 'Parse failed');

        final result = failure.when(
          server: (message, statusCode, _) => 'Server',
          network: (message, _) => 'Network',
          cache: (message, _) => 'Cache',
          parse: (message, _) => 'Parse: $message',
          circuitBreaker: (message, _) => 'CircuitBreaker',
          unexpected: (message, _) => 'Unexpected',
        );

        expect(result, 'Parse: Parse failed');
      });

      test('matches circuit breaker failure', () {
        const failure = InfrastructureFailure.circuitBreaker(
          message: 'Circuit open',
        );

        final result = failure.when(
          server: (message, statusCode, _) => 'Server',
          network: (message, _) => 'Network',
          cache: (message, _) => 'Cache',
          parse: (message, _) => 'Parse',
          circuitBreaker: (message, _) => 'CircuitBreaker: $message',
          unexpected: (message, _) => 'Unexpected: $message',
        );

        expect(result, 'CircuitBreaker: Circuit open');
      });
    });

    group('maybeWhen pattern matching', () {
      test('matches server failure with maybeWhen', () {
        const failure = InfrastructureFailure.server(
          message: 'Server error',
          statusCode: 500,
        );

        final result = failure.maybeWhen(
          server: (message, statusCode, _) => 'Server: $message',
          orElse: () => 'Other',
        );

        expect(result, 'Server: Server error');
      });

      test('matches network failure with maybeWhen', () {
        const failure = InfrastructureFailure.network(
          message: 'No connection',
        );

        final result = failure.maybeWhen(
          network: (message, _) => 'Network: $message',
          orElse: () => 'Other',
        );

        expect(result, 'Network: No connection');
      });

      test('matches cache failure with maybeWhen', () {
        const failure = InfrastructureFailure.cache(message: 'Cache failed');

        final result = failure.maybeWhen(
          cache: (message, _) => 'Cache: $message',
          orElse: () => 'Other',
        );

        expect(result, 'Cache: Cache failed');
      });

      test('matches parse failure with maybeWhen', () {
        const failure = InfrastructureFailure.parse(message: 'Parse failed');

        final result = failure.maybeWhen(
          parse: (message, _) => 'Parse: $message',
          orElse: () => 'Other',
        );

        expect(result, 'Parse: Parse failed');
      });

      test('returns orElse when no match in maybeWhen', () {
        const failure = InfrastructureFailure.network(
          message: 'No connection',
        );

        final result = failure.maybeWhen(
          server: (message, statusCode, _) => 'Server',
          orElse: () => 'Other',
        );

        expect(result, 'Other');
      });

      test('matches circuit breaker failure with maybeWhen', () {
        const failure = InfrastructureFailure.circuitBreaker(
          message: 'Circuit open',
        );

        final result = failure.maybeWhen(
          circuitBreaker: (message, _) => 'CircuitBreaker: $message',
          unexpected: (message, _) => 'Unexpected: $message',
          orElse: () => 'Other',
        );

        expect(result, 'CircuitBreaker: Circuit open');
      });
    });

    group('message getter', () {
      test('returns correct message for server failure', () {
        const failure = InfrastructureFailure.server(
          message: 'Server message',
          statusCode: 500,
        );

        // Explicitly access message getter to ensure coverage
        final message = failure.message;
        expect(message, 'Server message');
        expect(failure.message, 'Server message');
      });

      test(
        'returns correct message for server failure with null status code',
        () {
          const failure = InfrastructureFailure.server(
            message: 'Server message without code',
          );

          // Explicitly access message getter to ensure coverage
          final message = failure.message;
          expect(message, 'Server message without code');
          expect(failure.message, 'Server message without code');
        },
      );

      test('returns correct message for network failure', () {
        const failure = InfrastructureFailure.network(
          message: 'Network message',
        );

        // Explicitly access message getter to ensure coverage
        final message = failure.message;
        expect(message, 'Network message');
        expect(failure.message, 'Network message');
      });

      test('returns default message for network failure', () {
        const failure = InfrastructureFailure.network();

        // Explicitly access message getter to ensure coverage
        final message = failure.message;
        expect(message, 'Network error');
        expect(failure.message, 'Network error');
      });

      test('returns correct message for cache failure', () {
        const failure = InfrastructureFailure.cache(
          message: 'Cache message',
        );

        // Explicitly access message getter to ensure coverage
        final message = failure.message;
        expect(message, 'Cache message');
        expect(failure.message, 'Cache message');
      });

      test('returns default message for cache failure', () {
        const failure = InfrastructureFailure.cache();

        // Explicitly access message getter to ensure coverage
        final message = failure.message;
        expect(message, 'Cache error');
        expect(failure.message, 'Cache error');
      });

      test('returns correct message for parse failure', () {
        const failure = InfrastructureFailure.parse(
          message: 'Parse message',
        );

        // Explicitly access message getter to ensure coverage
        final message = failure.message;
        expect(message, 'Parse message');
        expect(failure.message, 'Parse message');
      });

      test('returns default message for parse failure', () {
        const failure = InfrastructureFailure.parse();

        // Explicitly access message getter to ensure coverage
        final message = failure.message;
        expect(message, 'Parse error');
        expect(failure.message, 'Parse error');
      });

      test('returns correct message for circuit breaker failure', () {
        const failure = InfrastructureFailure.circuitBreaker(
          message: 'Circuit breaker message',
        );

        final message = failure.message;
        expect(message, 'Circuit breaker message');
        expect(failure.message, 'Circuit breaker message');
      });

      test('returns default message for circuit breaker failure', () {
        const failure = InfrastructureFailure.circuitBreaker();

        final message = failure.message;
        expect(message, 'Service temporarily unavailable');
        expect(failure.message, 'Service temporarily unavailable');
      });
    });

    group('isRetryable getter', () {
      test('returns true for retryable failures', () {
        const server = InfrastructureFailure.server(
          message: 'Error',
          statusCode: 500,
        );
        const network = InfrastructureFailure.network();

        expect(server.isRetryable, true);
        expect(network.isRetryable, true);
      });

      test('returns false for non-retryable failures', () {
        const cache = InfrastructureFailure.cache();
        const parse = InfrastructureFailure.parse();

        expect(cache.isRetryable, false);
        expect(parse.isRetryable, false);
      });

      test('returns true for circuit breaker failure', () {
        const circuitBreaker = InfrastructureFailure.circuitBreaker();

        expect(circuitBreaker.isRetryable, true);
      });
    });

    group('toString', () {
      test('returns string representation for server failure', () {
        const failure = InfrastructureFailure.server(
          message: 'Server error',
          statusCode: 500,
        );

        final string = failure.toString();
        expect(string, contains('InfrastructureFailure.server'));
        expect(string, contains('Server error'));
        expect(string, contains('500'));
      });

      test(
        'returns string representation for server failure without status code',
        () {
          const failure = InfrastructureFailure.server(
            message: 'Server error',
          );

          final string = failure.toString();
          expect(string, contains('InfrastructureFailure.server'));
          expect(string, contains('Server error'));
        },
      );

      test('returns string representation for network failure', () {
        const failure = InfrastructureFailure.network();

        final string = failure.toString();
        expect(string, contains('InfrastructureFailure.network'));
        expect(string, contains('Network error'));
      });

      test('returns string representation for cache failure', () {
        const failure = InfrastructureFailure.cache();

        final string = failure.toString();
        expect(string, contains('InfrastructureFailure.cache'));
        expect(string, contains('Cache error'));
      });

      test('returns string representation for parse failure', () {
        const failure = InfrastructureFailure.parse();

        final string = failure.toString();
        expect(string, contains('InfrastructureFailure.parse'));
        expect(string, contains('Parse error'));
      });

      test('returns string representation for circuit breaker failure', () {
        const failure = InfrastructureFailure.circuitBreaker();

        final string = failure.toString();
        expect(string, contains('InfrastructureFailure.circuitBreaker'));
        expect(string, contains('Service temporarily unavailable'));
      });
    });

    group('type safety', () {
      test('different failure types are not equal', () {
        const server = InfrastructureFailure.server(
          message: 'Error',
          statusCode: 500,
        );
        const network = InfrastructureFailure.network(message: 'Error');
        const cache = InfrastructureFailure.cache(message: 'Error');
        const parse = InfrastructureFailure.parse(message: 'Error');

        expect(server, isNot(network));
        expect(server, isNot(cache));
        expect(server, isNot(parse));
        expect(network, isNot(cache));
        expect(network, isNot(parse));
        expect(cache, isNot(parse));
      });

      test('all failure types implement Failure interface', () {
        const server = InfrastructureFailure.server(
          message: 'Error',
          statusCode: 500,
        );
        const network = InfrastructureFailure.network();
        const cache = InfrastructureFailure.cache();
        const parse = InfrastructureFailure.parse();
        const circuitBreaker = InfrastructureFailure.circuitBreaker();

        expect(server, isA<Failure>());
        expect(network, isA<Failure>());
        expect(cache, isA<Failure>());
        expect(parse, isA<Failure>());
        expect(circuitBreaker, isA<Failure>());
      });
    });
  });
}
