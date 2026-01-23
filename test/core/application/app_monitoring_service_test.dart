import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/core/application/app_monitoring_service.dart';
import 'package:starter_app/core/application/application_environment.dart';
import 'package:starter_app/core/domain/ports/i_error_reporter.dart';
import 'package:starter_app/core/domain/ports/i_platform_info.dart';


import '../../helpers/mock_helpers.dart';

class MockPlatformInfo extends Mock implements IPlatformInfo {}

class MockErrorReporter extends Mock implements IErrorReporter {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAppLogger mockLogger;
  late MockErrorReporter mockErrorReporter;
  late MockPlatformInfo mockPlatformInfo;
  late AppMonitoringService service;

  setUp(() {
    mockLogger = MockAppLogger();
    mockErrorReporter = MockErrorReporter();
    mockPlatformInfo = MockPlatformInfo();
    when(() => mockPlatformInfo.operatingSystemVersion).thenReturn('1.0.0');
    service = AppMonitoringService(
      mockLogger,
      mockErrorReporter,
      mockPlatformInfo,
    );
  });

  group('AppMonitoringService', () {
    test('initialize logs startup configuration for development', () async {
      await service.initialize(AppEnvironment.development);

      verify(
        () => mockLogger.info(
          'Application starting',
          data: {
            'environment': 'development',
            'explicitlyConfigured': false, // Assuming default mock/env
            'apiBaseUrl': AppEnvironment.development.apiBaseUrl,
            'webSocketUrl': AppEnvironment.development.webSocketUrl,
            'sentryEnabled': false,
            'operatingSystem': defaultTargetPlatform.name,
            'operatingSystemVersion': '1.0.0',
          },
          tag: 'Bootstrap',
        ),
      ).called(1);

      // Should not add breadcrumb for development (Sentry disabled)
      verifyNever(
        () => mockErrorReporter.addBreadcrumb(
          any(),
          category: any(named: 'category'),
          data: any(named: 'data'),
          level: any(named: 'level'),
        ),
      );
    });

    test('logs warning if configuration warning is present', () async {
      // We can pass a warning override to force the log
      await service.initialize(
        AppEnvironment.development,
        configurationWarningOverride: 'Test Warning',
      );

      verify(
        () => mockLogger.warning(
          'Test Warning',
          tag: 'Configuration',
        ),
      ).called(1);
    });

    test('does not log warning if no configuration warning', () async {
      await service.initialize(AppEnvironment.development);

      verifyNever(
        () => mockLogger.warning(
          any(),
          tag: 'Configuration',
        ),
      );
    });

    test('initializes Sentry when enabled', () async {
      final log = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('sentry_flutter'),
            (MethodCall methodCall) async {
              log.add(methodCall);
              return null;
            },
          );

      // Sentry is enabled in Staging.
      // We provide a DSN override so it attempts to initialize.
      await service.initialize(
        AppEnvironment.staging,
        sentryDsnOverride: 'https://example@sentry.io/123',
      );

      // Verify Sentry init was called via MethodChannel
      expect(log, isNotEmpty);

      // Verify logging happened for staging
      verify(
        () => mockLogger.info(
          'Application starting',
          data: {
            'environment': 'staging',
            'explicitlyConfigured': false,
            'apiBaseUrl': AppEnvironment.staging.apiBaseUrl,
            'webSocketUrl': AppEnvironment.staging.webSocketUrl,
            'sentryEnabled': true,
            'operatingSystem': defaultTargetPlatform.name,
            'operatingSystemVersion': '1.0.0',
          },
          tag: 'Bootstrap',
        ),
      ).called(1);

      // Verify startup breadcrumb was added
      verify(
        () => mockErrorReporter.addBreadcrumb(
          'Application initialized',
          category: 'lifecycle',
          data: {
            'environment': 'staging',
            'platform': defaultTargetPlatform.name,
          },
          level: SeverityLevel.info,
        ),
      ).called(1);

      // Clean up
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('sentry_flutter'),
            null,
          );
    });
  });
}
