import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/core/di/modules/error_module.dart';
import 'package:starter_app/core/domain/ports/i_data_filter.dart';
import 'package:starter_app/core/domain/ports/i_error_reporter.dart';
import 'package:starter_app/core/error/reporters/no_op_error_reporter.dart';
import 'package:starter_app/core/error/reporters/sentry_error_reporter.dart';

class MockDataFilter extends Mock implements IDataFilter {}

class TestErrorModule extends ErrorModule {}

void main() {
  group('ErrorModule', () {
    late TestErrorModule module;
    late MockDataFilter mockDataFilter;

    setUp(() {
      module = TestErrorModule();
      mockDataFilter = MockDataFilter();
    });

    group('provideDevelopmentReporter', () {
      test('should return NoOpErrorReporter', () {
        final reporter = module.provideDevelopmentReporter();

        expect(reporter, isA<NoOpErrorReporter>());
        expect(reporter, isA<IErrorReporter>());
      });

      test('should return const instance', () {
        final reporter1 = module.provideDevelopmentReporter();
        final reporter2 = module.provideDevelopmentReporter();

        expect(reporter1, equals(reporter2));
      });
    });

    group('provideStagingReporter', () {
      test('should return SentryErrorReporter', () {
        final reporter = module.provideStagingReporter(mockDataFilter);

        expect(reporter, isA<SentryErrorReporter>());
        expect(reporter, isA<IErrorReporter>());
      });

      test('should inject data filter', () {
        final reporter = module.provideStagingReporter(mockDataFilter);

        expect(reporter, isA<SentryErrorReporter>());
      });
    });
  });
}
