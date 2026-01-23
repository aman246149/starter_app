import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/core/error/failures/failure.dart';
import 'package:starter_app/features/auth/domain/failure/auth_failure.dart';

void main() {
  group('AuthFailure', () {
    group('notFound', () {
      test('creates failure with message', () {
        const failure = AuthFailure.notFound(message: 'User not found');

        expect(failure.message, 'User not found');
        expect(failure.isRetryable, false);
        expect(failure.stackTrace, isNull);
      });

      test('creates failure with stackTrace', () {
        final stackTrace = StackTrace.current;
        final failure = AuthFailure.notFound(
          message: 'User not found',
          stackTrace: stackTrace,
        );

        expect(failure.stackTrace, stackTrace);
      });

      test('extends Failure', () {
        const failure = AuthFailure.notFound(message: 'test');
        expect(failure, isA<Failure>());
      });
    });

    group('unauthorized', () {
      test('creates failure with message', () {
        const failure = AuthFailure.unauthorized(
          message: 'Invalid credentials',
        );

        expect(failure.message, 'Invalid credentials');
        expect(failure.isRetryable, false);
        expect(failure.stackTrace, isNull);
      });

      test('creates failure with stackTrace', () {
        final stackTrace = StackTrace.current;
        final failure = AuthFailure.unauthorized(
          message: 'Invalid credentials',
          stackTrace: stackTrace,
        );

        expect(failure.stackTrace, stackTrace);
      });
    });

    group('forbidden', () {
      test('creates failure with message', () {
        const failure = AuthFailure.forbidden(message: 'Account suspended');

        expect(failure.message, 'Account suspended');
        expect(failure.isRetryable, false);
        expect(failure.stackTrace, isNull);
      });

      test('creates failure with stackTrace', () {
        final stackTrace = StackTrace.current;
        final failure = AuthFailure.forbidden(
          message: 'Account suspended',
          stackTrace: stackTrace,
        );

        expect(failure.stackTrace, stackTrace);
      });
    });

    group('emailAlreadyInUse', () {
      test('creates failure with default message', () {
        const failure = AuthFailure.emailAlreadyInUse();

        expect(failure.message, 'Email already in use');
        expect(failure.isRetryable, false);
        expect(failure.stackTrace, isNull);
      });

      test('creates failure with custom message', () {
        const failure = AuthFailure.emailAlreadyInUse(
          message: 'This email is taken',
        );

        expect(failure.message, 'This email is taken');
      });

      test('creates failure with stackTrace', () {
        final stackTrace = StackTrace.current;
        final failure = AuthFailure.emailAlreadyInUse(stackTrace: stackTrace);

        expect(failure.stackTrace, stackTrace);
      });
    });

    group('invalidInput', () {
      test('creates failure with message', () {
        const failure = AuthFailure.invalidInput(
          message: 'Invalid email format',
        );

        expect(failure.message, 'Invalid email format');
        expect(failure.isRetryable, false);
        expect(failure.stackTrace, isNull);
      });

      test('creates failure with stackTrace', () {
        final stackTrace = StackTrace.current;
        final failure = AuthFailure.invalidInput(
          message: 'Invalid email format',
          stackTrace: stackTrace,
        );

        expect(failure.stackTrace, stackTrace);
      });
    });

    group('isRetryable', () {
      test('all failure types are not retryable', () {
        expect(
          const AuthFailure.notFound(message: 'test').isRetryable,
          false,
        );
        expect(
          const AuthFailure.unauthorized(message: 'test').isRetryable,
          false,
        );
        expect(
          const AuthFailure.forbidden(message: 'test').isRetryable,
          false,
        );
        expect(
          const AuthFailure.emailAlreadyInUse().isRetryable,
          false,
        );
        expect(
          const AuthFailure.invalidInput(message: 'test').isRetryable,
          false,
        );
      });
    });

    group('message getter (via base type)', () {
      test('returns correct message for all failure types', () {
        // Test through base AuthFailure type to exercise the when() pattern
        AuthFailure failure;

        failure = const AuthFailure.notFound(message: 'not found msg');
        expect(failure.message, 'not found msg');

        failure = const AuthFailure.unauthorized(message: 'unauthorized msg');
        expect(failure.message, 'unauthorized msg');

        failure = const AuthFailure.forbidden(message: 'forbidden msg');
        expect(failure.message, 'forbidden msg');

        failure = const AuthFailure.emailAlreadyInUse(message: 'email msg');
        expect(failure.message, 'email msg');

        failure = const AuthFailure.invalidInput(message: 'invalid msg');
        expect(failure.message, 'invalid msg');
      });
    });

    group('stackTrace getter (via base type)', () {
      test('returns correct stackTrace for all failure types', () {
        final stackTrace = StackTrace.current;
        AuthFailure failure;

        failure = AuthFailure.notFound(message: 'test', stackTrace: stackTrace);
        expect(failure.stackTrace, stackTrace);

        failure = AuthFailure.unauthorized(
          message: 'test',
          stackTrace: stackTrace,
        );
        expect(failure.stackTrace, stackTrace);

        failure = AuthFailure.forbidden(
          message: 'test',
          stackTrace: stackTrace,
        );
        expect(failure.stackTrace, stackTrace);

        failure = AuthFailure.emailAlreadyInUse(stackTrace: stackTrace);
        expect(failure.stackTrace, stackTrace);

        failure = AuthFailure.invalidInput(
          message: 'test',
          stackTrace: stackTrace,
        );
        expect(failure.stackTrace, stackTrace);
      });

      test('returns null stackTrace when not provided', () {
        AuthFailure failure;

        failure = const AuthFailure.notFound(message: 'test');
        expect(failure.stackTrace, isNull);

        failure = const AuthFailure.unauthorized(message: 'test');
        expect(failure.stackTrace, isNull);

        failure = const AuthFailure.forbidden(message: 'test');
        expect(failure.stackTrace, isNull);

        failure = const AuthFailure.emailAlreadyInUse();
        expect(failure.stackTrace, isNull);

        failure = const AuthFailure.invalidInput(message: 'test');
        expect(failure.stackTrace, isNull);
      });
    });
  });
}
