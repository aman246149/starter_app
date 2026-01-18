import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:starter_app/core/error/i_error_reporter.dart';
import 'package:starter_app/core/logging/i_app_logger.dart';

/// Service responsible for global error handling setup.
///
/// Handles:
/// - Flutter framework errors (FlutterError.onError)
/// - Platform-level errors (PlatformDispatcher.onError)
/// - Zone errors (uncaught async errors)
///
/// **Architecture:**
/// - [IAppLogger]: Console logging for development debugging
/// - [IErrorReporter]: Error tracking for staging/production (Sentry)
///
/// Both are called for all errors to ensure:
/// - Developers see errors in console during development
/// - Errors are tracked in Sentry for staging/production
@lazySingleton
class AppErrorHandlingService {
  AppErrorHandlingService(this._logger, this._errorReporter);

  final IAppLogger _logger;
  final IErrorReporter _errorReporter;

  /// Sets up global error handlers.
  ///
  /// Must be called during app bootstrap, before runApp.
  void setup() {
    // Set up global error handling for Flutter framework errors
    FlutterError.onError = (details) {
      _logger.error(
        'Flutter framework error',
        error: details.exception,
        stackTrace: details.stack,
        data: {
          'library': details.library ?? 'unknown',
          'context': details.context?.toString(),
        },
        tag: 'FlutterError',
      );

      // Report to Sentry with context
      unawaited(
        _errorReporter.captureException(
          details.exception,
          stackTrace: details.stack,
          context: {
            'library': details.library ?? 'unknown',
            'context': details.context?.toString(),
          },
          tag: 'FlutterError',
        ),
      );
    };

    // Set up platform-level error handling
    PlatformDispatcher.instance.onError = (error, stack) {
      _logger.error(
        'Platform error',
        error: error,
        stackTrace: stack,
        tag: 'PlatformError',
      );

      // Report to Sentry
      unawaited(
        _errorReporter.captureException(
          error,
          stackTrace: stack,
          tag: 'PlatformError',
        ),
      );

      return true; // Mark as handled to prevent crash
    };
  }

  /// Logs and reports an uncaught zone error.
  ///
  /// Called from runZonedGuarded error handler.
  void logZoneError(Object error, StackTrace stack) {
    _logger.error(
      'Uncaught async error in zone',
      error: error,
      stackTrace: stack,
      tag: 'ZoneError',
    );

    // Report to Sentry
    unawaited(
      _errorReporter.captureException(
        error,
        stackTrace: stack,
        tag: 'ZoneError',
      ),
    );
  }
}
