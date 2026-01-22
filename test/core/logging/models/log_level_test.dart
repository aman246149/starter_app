import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/core/logging/models/log_level.dart';

void main() {
  group('LogLevel', () {
    group('enum values', () {
      test('has all expected enum values', () {
        expect(LogLevel.values.length, 5);
        expect(LogLevel.values, contains(LogLevel.debug));
        expect(LogLevel.values, contains(LogLevel.info));
        expect(LogLevel.values, contains(LogLevel.warning));
        expect(LogLevel.values, contains(LogLevel.error));
        expect(LogLevel.values, contains(LogLevel.fatal));
      });

      test('debug has value 0', () {
        expect(LogLevel.debug.value, 0);
      });

      test('info has value 1', () {
        expect(LogLevel.info.value, 1);
      });

      test('warning has value 2', () {
        expect(LogLevel.warning.value, 2);
      });

      test('error has value 3', () {
        expect(LogLevel.error.value, 3);
      });

      test('fatal has value 4', () {
        expect(LogLevel.fatal.value, 4);
      });
    });

    group('isEnabled', () {
      test('debug is enabled when minimum is debug', () {
        expect(LogLevel.debug.isEnabled(LogLevel.debug), isTrue);
      });

      test('debug is not enabled when minimum is info', () {
        expect(LogLevel.debug.isEnabled(LogLevel.info), isFalse);
      });

      test('info is enabled when minimum is debug', () {
        expect(LogLevel.info.isEnabled(LogLevel.debug), isTrue);
      });

      test('info is enabled when minimum is info', () {
        expect(LogLevel.info.isEnabled(LogLevel.info), isTrue);
      });

      test('info is not enabled when minimum is warning', () {
        expect(LogLevel.info.isEnabled(LogLevel.warning), isFalse);
      });

      test('warning is enabled when minimum is debug', () {
        expect(LogLevel.warning.isEnabled(LogLevel.debug), isTrue);
      });

      test('warning is enabled when minimum is warning', () {
        expect(LogLevel.warning.isEnabled(LogLevel.warning), isTrue);
      });

      test('warning is not enabled when minimum is error', () {
        expect(LogLevel.warning.isEnabled(LogLevel.error), isFalse);
      });

      test('error is enabled when minimum is debug', () {
        expect(LogLevel.error.isEnabled(LogLevel.debug), isTrue);
      });

      test('error is enabled when minimum is error', () {
        expect(LogLevel.error.isEnabled(LogLevel.error), isTrue);
      });

      test('error is not enabled when minimum is fatal', () {
        expect(LogLevel.error.isEnabled(LogLevel.fatal), isFalse);
      });

      test('fatal is enabled when minimum is debug', () {
        expect(LogLevel.fatal.isEnabled(LogLevel.debug), isTrue);
      });

      test('fatal is enabled when minimum is fatal', () {
        expect(LogLevel.fatal.isEnabled(LogLevel.fatal), isTrue);
      });

      test('fatal is enabled when minimum is error', () {
        expect(LogLevel.fatal.isEnabled(LogLevel.error), isTrue);
      });
    });

    group('emoji', () {
      test('debug returns debug emoji', () {
        expect(LogLevel.debug.emoji, '🐛');
      });

      test('info returns info emoji', () {
        expect(LogLevel.info.emoji, 'ℹ️');
      });

      test('warning returns warning emoji', () {
        expect(LogLevel.warning.emoji, '⚠️');
      });

      test('error returns error emoji', () {
        expect(LogLevel.error.emoji, '❌');
      });

      test('fatal returns fatal emoji', () {
        expect(LogLevel.fatal.emoji, '💀');
      });
    });

    group('label', () {
      test('debug returns DEBUG label', () {
        expect(LogLevel.debug.label, 'DEBUG');
      });

      test('info returns INFO label', () {
        expect(LogLevel.info.label, 'INFO');
      });

      test('warning returns WARN label', () {
        expect(LogLevel.warning.label, 'WARN');
      });

      test('error returns ERROR label', () {
        expect(LogLevel.error.label, 'ERROR');
      });

      test('fatal returns FATAL label', () {
        expect(LogLevel.fatal.label, 'FATAL');
      });
    });
  });
}
