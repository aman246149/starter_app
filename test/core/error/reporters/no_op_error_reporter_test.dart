import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/core/domain/base/unique_id.dart';
import 'package:starter_app/core/domain/ports/i_error_reporter.dart';
import 'package:starter_app/core/domain/value_objects/email_address.dart';
import 'package:starter_app/core/error/reporters/no_op_error_reporter.dart';
import 'package:starter_app/features/auth/domain/entities/user.dart';
import 'package:starter_app/features/auth/domain/entities/user_id.dart';

void main() {
  group('NoOpErrorReporter', () {
    late NoOpErrorReporter reporter;

    setUp(() {
      reporter = const NoOpErrorReporter();
    });

    group('constructor', () {
      test('should be const constructible', () {
        const reporter1 = NoOpErrorReporter();
        const reporter2 = NoOpErrorReporter();
        expect(reporter1, equals(reporter2));
      });

      test('should implement IErrorReporter', () {
        expect(reporter, isA<IErrorReporter>());
      });
    });

    group('captureException', () {
      test('should complete without error', () async {
        await expectLater(
          reporter.captureException(
            Exception('test'),
            stackTrace: StackTrace.current,
            context: {'key': 'value'},
            tag: 'test',
          ),
          completes,
        );
      });

      test('should complete without optional parameters', () async {
        await expectLater(
          reporter.captureException(Exception('test')),
          completes,
        );
      });
    });

    group('captureMessage', () {
      test('should complete without error', () async {
        await expectLater(
          reporter.captureMessage(
            'test message',
            level: SeverityLevel.error,
            context: {'key': 'value'},
            tag: 'test',
          ),
          completes,
        );
      });

      test('should complete without optional parameters', () async {
        await expectLater(
          reporter.captureMessage('test message'),
          completes,
        );
      });

      test('should accept all severity levels', () async {
        for (final level in SeverityLevel.values) {
          await expectLater(
            reporter.captureMessage('test', level: level),
            completes,
          );
        }
      });
    });

    group('addBreadcrumb', () {
      test('should complete without error', () {
        expect(
          () => reporter.addBreadcrumb(
            'test breadcrumb',
            category: 'navigation',
            data: {'key': 'value'},
            level: SeverityLevel.info,
          ),
          returnsNormally,
        );
      });

      test('should complete without optional parameters', () {
        expect(
          () => reporter.addBreadcrumb('test breadcrumb'),
          returnsNormally,
        );
      });
    });

    group('setUser', () {
      test('should complete without error', () {
        final user = User(
          id: UserId(UniqueId.fromString('test-user-id')),
          email: EmailAddress('test@example.com'),
        );

        expect(
          () => reporter.setUser(user),
          returnsNormally,
        );
      });
    });

    group('clearUser', () {
      test('should complete without error', () {
        expect(
          () => reporter.clearUser(),
          returnsNormally,
        );
      });
    });
  });
}
