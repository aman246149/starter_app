import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/core/di/modules/logging_module.dart';
import 'package:starter_app/core/logging/i_app_logger.dart';
import 'package:starter_app/core/logging/loggers/console_logger.dart';

class TestLoggingModule extends LoggingModule {}

void main() {
  group('LoggingModule', () {
    late TestLoggingModule module;

    setUp(() {
      module = TestLoggingModule();
    });

    group('provideLogger', () {
      test('should return ConsoleLogger', () {
        final logger = module.provideLogger();
        expect(logger, isA<ConsoleLogger>());
        expect(logger, isA<IAppLogger>());
      });
    });
  });
}
