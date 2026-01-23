import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:starter_app/core/application/application_environment.dart';
import 'package:starter_app/core/domain/ports/i_error_reporter.dart';
import 'package:starter_app/core/domain/ports/i_platform_info.dart';
import 'package:starter_app/core/logging/i_app_logger.dart';

/// Service responsible for application monitoring and diagnostics.
///
/// Handles:
/// - Sentry SDK initialization
/// - Startup configuration logging
/// - Integration of [IAppLogger] (console) and [IErrorReporter] (Sentry)
///
/// **Architecture:**
/// - [IAppLogger]: Console logging for development debugging
/// - [IErrorReporter]: Error tracking and breadcrumbs for staging/production
///
/// Sentry must be initialized before [IErrorReporter] methods work.
@lazySingleton
class AppMonitoringService {
  AppMonitoringService(
    this._logger,
    this._errorReporter,
    this._platformInfo,
  );

  final IAppLogger _logger;
  final IErrorReporter _errorReporter;
  final IPlatformInfo _platformInfo;

  /// Initializes the monitoring system.
  ///
  /// Must be called early in app bootstrap before using [IErrorReporter].
  Future<void> initialize(
    AppEnvironment environment, {
    String? sentryDsnOverride,
    @visibleForTesting String? configurationWarningOverride,
  }) async {
    // Log startup configuration to console
    _logStartupConfiguration(
      environment,
      warningOverride: configurationWarningOverride,
    );

    // Initialize Sentry SDK (required for IErrorReporter to work)
    final dsn = sentryDsnOverride ?? environment.sentryDsn;
    if (environment.sentryEnabled && dsn != null) {
      await SentryFlutter.init(
        (options) {
          options
            ..dsn = dsn
            ..environment = environment.name
            ..tracesSampleRate = environment.sentrySampleRate;
        },
      );

      // Add startup breadcrumb to Sentry
      _errorReporter.addBreadcrumb(
        'Application initialized',
        category: 'lifecycle',
        data: {
          'environment': environment.name,
          'platform': defaultTargetPlatform.name,
        },
        level: SeverityLevel.info,
      );
    }
  }

  void _logStartupConfiguration(
    AppEnvironment environment, {
    String? warningOverride,
  }) {
    final warning = warningOverride ?? AppEnvironment.configurationWarning;
    if (warning != null) {
      _logger.warning(warning, tag: 'Configuration');
    }

    _logger.info(
      'Application starting',
      data: {
        'environment': environment.name,
        'explicitlyConfigured': AppEnvironment.isExplicitlyConfigured,
        'apiBaseUrl': environment.apiBaseUrl,
        'webSocketUrl': environment.webSocketUrl,
        'sentryEnabled': environment.sentryEnabled,
        'operatingSystem': defaultTargetPlatform.name,
        'operatingSystemVersion': _platformInfo.operatingSystemVersion,
      },
      tag: 'Bootstrap',
    );
  }
}
