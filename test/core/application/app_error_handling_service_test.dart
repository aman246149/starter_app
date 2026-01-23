import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/core/application/app_error_handling_service.dart';
import 'package:starter_app/core/domain/ports/i_error_reporter.dart';

import '../../helpers/mock_helpers.dart';

class MockErrorReporter extends Mock implements IErrorReporter {}

void main() {
  late MockAppLogger mockLogger;
  late MockErrorReporter mockErrorReporter;
  late AppErrorHandlingService service;

  setUp(() {
    mockLogger = MockAppLogger();
    mockErrorReporter = MockErrorReporter();

    // Stub captureException to return a completed Future
    when(
      () => mockErrorReporter.captureException(
        any(),
        stackTrace: any(named: 'stackTrace'),
        context: any(named: 'context'),
        tag: any(named: 'tag'),
      ),
    ).thenAnswer((_) async {});

    service = AppErrorHandlingService(mockLogger, mockErrorReporter);
  });

  group('AppErrorHandlingService', () {
    test('setup registers error handlers', () {
      // Save original handlers to restore later
      final originalFlutterHandler = FlutterError.onError;
      final originalPlatformHandler = PlatformDispatcher.instance.onError;

      // Ensure we start with something different (or default)
      // Just calling setup should change them or set them.
      service.setup();

      expect(FlutterError.onError, isNot(equals(originalFlutterHandler)));
      expect(
        PlatformDispatcher.instance.onError,
        isNot(equals(originalPlatformHandler)),
      );

      // Verify FlutterError handler
      final flutterErrorDetails = FlutterErrorDetails(
        exception: Exception('Flutter Error'),
        stack: StackTrace.empty,
        library: 'test lib',
        context: ErrorDescription('test context'),
      );

      FlutterError.onError!(flutterErrorDetails);

      verify(
        () => mockLogger.error(
          'Flutter framework error',
          error: any(named: 'error'),
          stackTrace: any(named: 'stackTrace'),
          data: {
            'library': 'test lib',
            'context': 'test context',
          },
          tag: 'FlutterError',
        ),
      ).called(1);

      verify(
        () => mockErrorReporter.captureException(
          any(),
          stackTrace: any(named: 'stackTrace'),
          context: {
            'library': 'test lib',
            'context': 'test context',
          },
          tag: 'FlutterError',
        ),
      ).called(1);

      // Verify PlatformDispatcher handler
      final platformError = Exception('Platform Error');
      final handled = PlatformDispatcher.instance.onError!(
        platformError,
        StackTrace.empty,
      );

      expect(handled, isTrue);

      verify(
        () => mockLogger.error(
          'Platform error',
          error: platformError,
          stackTrace: any(named: 'stackTrace'),
          tag: 'PlatformError',
        ),
      ).called(1);

      verify(
        () => mockErrorReporter.captureException(
          platformError,
          stackTrace: any(named: 'stackTrace'),
          tag: 'PlatformError',
        ),
      ).called(1);

      // Restore handlers
      FlutterError.onError = originalFlutterHandler;
      PlatformDispatcher.instance.onError = originalPlatformHandler;
    });

    test('logZoneError logs error with correct tag', () {
      final error = Exception('Zone Error');
      final stack = StackTrace.current;

      service.logZoneError(error, stack);

      verify(
        () => mockLogger.error(
          'Uncaught async error in zone',
          error: error,
          stackTrace: stack,
          tag: 'ZoneError',
        ),
      ).called(1);

      verify(
        () => mockErrorReporter.captureException(
          error,
          stackTrace: stack,
          tag: 'ZoneError',
        ),
      ).called(1);
    });
  });
}
