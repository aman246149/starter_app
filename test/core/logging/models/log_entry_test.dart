import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/core/logging/models/log_entry.dart';
import 'package:starter_app/core/logging/models/log_level.dart';

void main() {
  group('LogEntry', () {
    final testTimestamp = DateTime(2024, 1, 1, 12);
    final testError = Exception('Test error');
    final testStackTrace = StackTrace.current;
    final testData = {'key': 'value', 'number': 42};
    const testTag = 'TEST';

    group('constructor', () {
      test('creates entry with required fields only', () {
        final entry = LogEntry(
          level: LogLevel.info,
          message: 'Test message',
          timestamp: testTimestamp,
        );

        expect(entry.level, LogLevel.info);
        expect(entry.message, 'Test message');
        expect(entry.timestamp, testTimestamp);
        expect(entry.error, isNull);
        expect(entry.stackTrace, isNull);
        expect(entry.data, isNull);
        expect(entry.tag, isNull);
      });

      test('creates entry with all fields', () {
        final entry = LogEntry(
          level: LogLevel.error,
          message: 'Error message',
          timestamp: testTimestamp,
          error: testError,
          stackTrace: testStackTrace,
          data: testData,
          tag: testTag,
        );

        expect(entry.level, LogLevel.error);
        expect(entry.message, 'Error message');
        expect(entry.timestamp, testTimestamp);
        expect(entry.error, testError);
        expect(entry.stackTrace, testStackTrace);
        expect(entry.data, testData);
        expect(entry.tag, testTag);
      });

      test('creates entry with optional error only', () {
        final entry = LogEntry(
          level: LogLevel.warning,
          message: 'Warning message',
          timestamp: testTimestamp,
          error: testError,
        );

        expect(entry.error, testError);
        expect(entry.stackTrace, isNull);
        expect(entry.data, isNull);
        expect(entry.tag, isNull);
      });

      test('creates entry with optional stackTrace only', () {
        final entry = LogEntry(
          level: LogLevel.debug,
          message: 'Debug message',
          timestamp: testTimestamp,
          stackTrace: testStackTrace,
        );

        expect(entry.error, isNull);
        expect(entry.stackTrace, testStackTrace);
        expect(entry.data, isNull);
        expect(entry.tag, isNull);
      });

      test('creates entry with optional data only', () {
        final entry = LogEntry(
          level: LogLevel.info,
          message: 'Info message',
          timestamp: testTimestamp,
          data: testData,
        );

        expect(entry.error, isNull);
        expect(entry.stackTrace, isNull);
        expect(entry.data, testData);
        expect(entry.tag, isNull);
      });

      test('creates entry with optional tag only', () {
        final entry = LogEntry(
          level: LogLevel.info,
          message: 'Info message',
          timestamp: testTimestamp,
          tag: testTag,
        );

        expect(entry.error, isNull);
        expect(entry.stackTrace, isNull);
        expect(entry.data, isNull);
        expect(entry.tag, testTag);
      });
    });

    group('LogEntry.now factory', () {
      test('creates entry with current timestamp', () {
        final before = DateTime.now();
        final entry = LogEntry.now(
          level: LogLevel.info,
          message: 'Test message',
        );
        final after = DateTime.now();

        expect(entry.level, LogLevel.info);
        expect(entry.message, 'Test message');
        expect(
          entry.timestamp.isAfter(before.subtract(const Duration(seconds: 1))),
          isTrue,
        );
        expect(
          entry.timestamp.isBefore(after.add(const Duration(seconds: 1))),
          isTrue,
        );
        expect(entry.error, isNull);
        expect(entry.stackTrace, isNull);
        expect(entry.data, isNull);
        expect(entry.tag, isNull);
      });

      test('creates entry with all optional fields', () {
        final entry = LogEntry.now(
          level: LogLevel.error,
          message: 'Error message',
          error: testError,
          stackTrace: testStackTrace,
          data: testData,
          tag: testTag,
        );

        expect(entry.level, LogLevel.error);
        expect(entry.message, 'Error message');
        expect(entry.error, testError);
        expect(entry.stackTrace, testStackTrace);
        expect(entry.data, testData);
        expect(entry.tag, testTag);
        expect(entry.timestamp, isA<DateTime>());
      });

      test('creates entry with error only', () {
        final entry = LogEntry.now(
          level: LogLevel.warning,
          message: 'Warning message',
          error: testError,
        );

        expect(entry.error, testError);
        expect(entry.stackTrace, isNull);
        expect(entry.data, isNull);
        expect(entry.tag, isNull);
      });

      test('creates entry with stackTrace only', () {
        final entry = LogEntry.now(
          level: LogLevel.debug,
          message: 'Debug message',
          stackTrace: testStackTrace,
        );

        expect(entry.error, isNull);
        expect(entry.stackTrace, testStackTrace);
        expect(entry.data, isNull);
        expect(entry.tag, isNull);
      });

      test('creates entry with data only', () {
        final entry = LogEntry.now(
          level: LogLevel.info,
          message: 'Info message',
          data: testData,
        );

        expect(entry.error, isNull);
        expect(entry.stackTrace, isNull);
        expect(entry.data, testData);
        expect(entry.tag, isNull);
      });

      test('creates entry with tag only', () {
        final entry = LogEntry.now(
          level: LogLevel.info,
          message: 'Info message',
          tag: testTag,
        );

        expect(entry.error, isNull);
        expect(entry.stackTrace, isNull);
        expect(entry.data, isNull);
        expect(entry.tag, testTag);
      });
    });

    group('toJson', () {
      test('converts entry with required fields only', () {
        final entry = LogEntry(
          level: LogLevel.info,
          message: 'Test message',
          timestamp: testTimestamp,
        );

        final json = entry.toJson();

        expect(json['level'], 'info');
        expect(json['message'], 'Test message');
        expect(json['timestamp'], testTimestamp.toIso8601String());
        expect(json.containsKey('error'), isFalse);
        expect(json.containsKey('stackTrace'), isFalse);
        expect(json.containsKey('data'), isFalse);
        expect(json.containsKey('tag'), isFalse);
      });

      test('converts entry with all fields', () {
        final entry = LogEntry(
          level: LogLevel.error,
          message: 'Error message',
          timestamp: testTimestamp,
          error: testError,
          stackTrace: testStackTrace,
          data: testData,
          tag: testTag,
        );

        final json = entry.toJson();

        expect(json['level'], 'error');
        expect(json['message'], 'Error message');
        expect(json['timestamp'], testTimestamp.toIso8601String());
        expect(json['error'], testError.toString());
        expect(json['stackTrace'], testStackTrace.toString());
        expect(json['data'], testData);
        expect(json['tag'], testTag);
      });

      test('converts entry with error only', () {
        final entry = LogEntry(
          level: LogLevel.warning,
          message: 'Warning message',
          timestamp: testTimestamp,
          error: testError,
        );

        final json = entry.toJson();

        expect(json['error'], testError.toString());
        expect(json.containsKey('stackTrace'), isFalse);
        expect(json.containsKey('data'), isFalse);
        expect(json.containsKey('tag'), isFalse);
      });

      test('converts entry with stackTrace only', () {
        final entry = LogEntry(
          level: LogLevel.debug,
          message: 'Debug message',
          timestamp: testTimestamp,
          stackTrace: testStackTrace,
        );

        final json = entry.toJson();

        expect(json.containsKey('error'), isFalse);
        expect(json['stackTrace'], testStackTrace.toString());
        expect(json.containsKey('data'), isFalse);
        expect(json.containsKey('tag'), isFalse);
      });

      test('converts entry with data only', () {
        final entry = LogEntry(
          level: LogLevel.info,
          message: 'Info message',
          timestamp: testTimestamp,
          data: testData,
        );

        final json = entry.toJson();

        expect(json.containsKey('error'), isFalse);
        expect(json.containsKey('stackTrace'), isFalse);
        expect(json['data'], testData);
        expect(json.containsKey('tag'), isFalse);
      });

      test('converts entry with tag only', () {
        final entry = LogEntry(
          level: LogLevel.info,
          message: 'Info message',
          timestamp: testTimestamp,
          tag: testTag,
        );

        final json = entry.toJson();

        expect(json.containsKey('error'), isFalse);
        expect(json.containsKey('stackTrace'), isFalse);
        expect(json.containsKey('data'), isFalse);
        expect(json['tag'], testTag);
      });

      test('converts entry with empty data map', () {
        final entry = LogEntry(
          level: LogLevel.info,
          message: 'Info message',
          timestamp: testTimestamp,
          data: <String, dynamic>{},
        );

        final json = entry.toJson();

        expect(json['data'], <String, dynamic>{});
      });

      test('converts entry with complex data', () {
        final complexData = {
          'string': 'value',
          'number': 42,
          'boolean': true,
          'list': [1, 2, 3],
          'nested': {'key': 'value'},
        };
        final entry = LogEntry(
          level: LogLevel.info,
          message: 'Info message',
          timestamp: testTimestamp,
          data: complexData,
        );

        final json = entry.toJson();

        expect(json['data'], complexData);
      });
    });

    group('toString', () {
      test('returns string with required fields only', () {
        final entry = LogEntry(
          level: LogLevel.info,
          message: 'Test message',
          timestamp: testTimestamp,
        );

        final result = entry.toString();

        expect(result, '[INFO] Test message');
      });

      test('returns string with tag', () {
        final entry = LogEntry(
          level: LogLevel.info,
          message: 'Test message',
          timestamp: testTimestamp,
          tag: testTag,
        );

        final result = entry.toString();

        expect(result, '[INFO] [$testTag] Test message');
      });

      test('returns string with data', () {
        final entry = LogEntry(
          level: LogLevel.info,
          message: 'Test message',
          timestamp: testTimestamp,
          data: testData,
        );

        final result = entry.toString();

        expect(result, '[INFO] Test message | Data: $testData');
      });

      test('returns string with error', () {
        final entry = LogEntry(
          level: LogLevel.error,
          message: 'Error message',
          timestamp: testTimestamp,
          error: testError,
        );

        final result = entry.toString();

        expect(result, '[ERROR] Error message | Error: $testError');
      });

      test('returns string with all fields', () {
        final entry = LogEntry(
          level: LogLevel.error,
          message: 'Error message',
          timestamp: testTimestamp,
          error: testError,
          stackTrace: testStackTrace,
          data: testData,
          tag: testTag,
        );

        final result = entry.toString();

        expect(
          result,
          '''[ERROR] [$testTag] Error message | Data: $testData | Error: $testError''',
        );
      });

      test('returns string with different log levels', () {
        final debugEntry = LogEntry(
          level: LogLevel.debug,
          message: 'Debug message',
          timestamp: testTimestamp,
        );
        final warningEntry = LogEntry(
          level: LogLevel.warning,
          message: 'Warning message',
          timestamp: testTimestamp,
        );
        final fatalEntry = LogEntry(
          level: LogLevel.fatal,
          message: 'Fatal message',
          timestamp: testTimestamp,
        );

        expect(debugEntry.toString(), '[DEBUG] Debug message');
        expect(warningEntry.toString(), '[WARN] Warning message');
        expect(fatalEntry.toString(), '[FATAL] Fatal message');
      });

      test('returns string with empty data map (not included)', () {
        final entry = LogEntry(
          level: LogLevel.info,
          message: 'Info message',
          timestamp: testTimestamp,
          data: <String, dynamic>{},
        );

        final result = entry.toString();

        // Empty data map is not included in toString output
        expect(result, '[INFO] Info message');
      });

      test('returns string with tag and data but no error', () {
        final entry = LogEntry(
          level: LogLevel.info,
          message: 'Info message',
          timestamp: testTimestamp,
          tag: testTag,
          data: testData,
        );

        final result = entry.toString();

        expect(result, '[INFO] [$testTag] Info message | Data: $testData');
      });

      test('returns string with tag and error but no data', () {
        final entry = LogEntry(
          level: LogLevel.error,
          message: 'Error message',
          timestamp: testTimestamp,
          tag: testTag,
          error: testError,
        );

        final result = entry.toString();

        expect(result, '[ERROR] [$testTag] Error message | Error: $testError');
      });
    });
  });
}
