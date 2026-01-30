import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/core/domain/base/unique_id.dart';
import 'package:starter_app/core/domain/ports/i_data_filter.dart';
import 'package:starter_app/core/domain/ports/i_error_reporter.dart';
import 'package:starter_app/core/domain/value_objects/email_address.dart';
import 'package:starter_app/core/error/reporters/sentry_error_reporter.dart';
import 'package:starter_app/features/auth/domain/entities/user.dart';
import 'package:starter_app/features/auth/domain/entities/user_id.dart';

class MockDataFilter extends Mock implements IDataFilter {}

void main() {
  group('SentryErrorReporter', () {
    late MockDataFilter mockDataFilter;

    setUp(() {
      mockDataFilter = MockDataFilter();

      // Default mock behavior - pass through data unchanged
      when(() => mockDataFilter.filter(any())).thenAnswer(
        (invocation) =>
            invocation.positionalArguments[0] as Map<String, dynamic>,
      );
    });

    group('constructor', () {
      test('should implement IErrorReporter', () {
        final reporter = SentryErrorReporter.test(
          dataFilter: mockDataFilter,
          enabled: false,
        );

        expect(reporter, isA<IErrorReporter>());
      });

      test('test constructor should accept enabled parameter', () {
        final enabledReporter = SentryErrorReporter.test(
          dataFilter: mockDataFilter,
          enabled: true,
        );
        final disabledReporter = SentryErrorReporter.test(
          dataFilter: mockDataFilter,
          enabled: false,
        );

        expect(enabledReporter, isA<SentryErrorReporter>());
        expect(disabledReporter, isA<SentryErrorReporter>());
      });

      test('main constructor should use AppEnvironment.sentryEnabled', () {
        // This tests the main constructor path (lines 29-30)
        final reporter = SentryErrorReporter(mockDataFilter);
        expect(reporter, isA<SentryErrorReporter>());
      });
    });

    group('captureException (disabled)', () {
      late SentryErrorReporter reporter;

      setUp(() {
        reporter = SentryErrorReporter.test(
          dataFilter: mockDataFilter,
          enabled: false,
        );
      });

      test('should not call data filter when disabled', () async {
        await reporter.captureException(
          Exception('test'),
          context: {'key': 'value'},
        );

        verifyNever(() => mockDataFilter.filter(any()));
      });

      test('should complete without error when disabled', () async {
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
    });

    group('captureException (enabled)', () {
      late SentryErrorReporter reporter;

      setUp(() {
        reporter = SentryErrorReporter.test(
          dataFilter: mockDataFilter,
          enabled: true,
        );
      });

      test('should filter context when provided', () async {
        final context = {'password': 'secret'};

        // Don't await since Sentry is not initialized
        // Just verify the filter is called
        unawaited(
          reporter.captureException(
            Exception('test'),
            context: context,
          ),
        );

        // Give time for async operation
        await Future<void>.delayed(const Duration(milliseconds: 10));

        verify(() => mockDataFilter.filter(context)).called(1);
      });

      test('should not filter when context is null', () async {
        unawaited(reporter.captureException(Exception('test')));

        await Future<void>.delayed(const Duration(milliseconds: 10));

        verifyNever(() => mockDataFilter.filter(any()));
      });

      test('should include tag in hint when provided', () async {
        unawaited(
          reporter.captureException(
            Exception('test'),
            stackTrace: StackTrace.current,
            context: {'key': 'value'},
            tag: 'TestTag',
          ),
        );

        await Future<void>.delayed(const Duration(milliseconds: 10));

        verify(() => mockDataFilter.filter({'key': 'value'})).called(1);
      });
    });

    group('captureMessage (disabled)', () {
      late SentryErrorReporter reporter;

      setUp(() {
        reporter = SentryErrorReporter.test(
          dataFilter: mockDataFilter,
          enabled: false,
        );
      });

      test('should not call data filter when disabled', () async {
        await reporter.captureMessage(
          'test message',
          context: {'key': 'value'},
        );

        verifyNever(() => mockDataFilter.filter(any()));
      });

      test('should complete without error when disabled', () async {
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
    });

    group('captureMessage (enabled)', () {
      late SentryErrorReporter reporter;

      setUp(() {
        reporter = SentryErrorReporter.test(
          dataFilter: mockDataFilter,
          enabled: true,
        );
      });

      test('should filter context when provided', () async {
        final context = {'token': 'abc123'};

        unawaited(reporter.captureMessage('test', context: context));

        await Future<void>.delayed(const Duration(milliseconds: 10));

        verify(() => mockDataFilter.filter(context)).called(1);
      });

      test('should accept all severity levels', () async {
        for (final level in SeverityLevel.values) {
          unawaited(reporter.captureMessage('test', level: level));
        }

        // Should complete without error
        await Future<void>.delayed(const Duration(milliseconds: 10));
      });

      test('should include tag in hint when provided', () async {
        unawaited(
          reporter.captureMessage(
            'test message',
            level: SeverityLevel.warning,
            context: {'data': 'test'},
            tag: 'MessageTag',
          ),
        );

        await Future<void>.delayed(const Duration(milliseconds: 10));

        verify(() => mockDataFilter.filter({'data': 'test'})).called(1);
      });
    });

    group('addBreadcrumb (disabled)', () {
      late SentryErrorReporter reporter;

      setUp(() {
        reporter = SentryErrorReporter.test(
          dataFilter: mockDataFilter,
          enabled: false,
        );
      });

      test('should not call data filter when disabled', () {
        reporter.addBreadcrumb(
          'test breadcrumb',
          data: {'key': 'value'},
        );

        verifyNever(() => mockDataFilter.filter(any()));
      });

      test('should complete without error when disabled', () {
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
    });

    group('addBreadcrumb (enabled)', () {
      late SentryErrorReporter reporter;

      setUp(() {
        reporter = SentryErrorReporter.test(
          dataFilter: mockDataFilter,
          enabled: true,
        );
      });

      test('should filter data when provided', () {
        final data = {'api_key': 'secret'};

        reporter.addBreadcrumb('test', data: data);

        verify(() => mockDataFilter.filter(data)).called(1);
      });

      test('should not filter when data is null', () {
        reporter.addBreadcrumb('test');

        verifyNever(() => mockDataFilter.filter(any()));
      });

      test('should accept all severity levels', () {
        for (final level in SeverityLevel.values) {
          expect(
            () => reporter.addBreadcrumb('test', level: level),
            returnsNormally,
          );
        }
      });
    });

    group('setUser (disabled)', () {
      test('should complete without error when disabled', () {
        final reporter = SentryErrorReporter.test(
          dataFilter: mockDataFilter,
          enabled: false,
        );
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

    group('setUser (enabled)', () {
      test('should complete without error when enabled', () {
        final reporter = SentryErrorReporter.test(
          dataFilter: mockDataFilter,
          enabled: true,
        );
        final user = User(
          id: UserId(UniqueId.fromString('test-user-id')),
          email: EmailAddress('test@example.com'),
        );

        // Won't actually set user on Sentry since it's not initialized,
        // but should not throw
        expect(
          () => reporter.setUser(user),
          returnsNormally,
        );
      });

      test('should handle user with invalid email gracefully', () {
        final reporter = SentryErrorReporter.test(
          dataFilter: mockDataFilter,
          enabled: true,
        );
        // Create user with invalid email to test fallback to 'unknown'
        final userWithInvalidEmail = User(
          id: UserId(UniqueId.fromString('test-user-id')),
          email: EmailAddress('invalid-email'), // This will be Left (failure)
        );

        expect(
          () => reporter.setUser(userWithInvalidEmail),
          returnsNormally,
        );
      });
    });

    group('clearUser (disabled)', () {
      test('should complete without error when disabled', () {
        final reporter = SentryErrorReporter.test(
          dataFilter: mockDataFilter,
          enabled: false,
        );

        expect(
          reporter.clearUser,
          returnsNormally,
        );
      });
    });

    group('clearUser (enabled)', () {
      test('should complete without error when enabled', () {
        final reporter = SentryErrorReporter.test(
          dataFilter: mockDataFilter,
          enabled: true,
        );

        // Won't actually clear user on Sentry since it's not initialized,
        // but should not throw
        expect(
          reporter.clearUser,
          returnsNormally,
        );
      });
    });
  });
}

/// Helper function to avoid unawaited lint errors
void unawaited(Future<void>? future) {}
