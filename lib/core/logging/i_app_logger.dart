import 'package:starter_app/core/logging/models/log_entry.dart';
import 'package:starter_app/core/logging/models/log_level.dart';

/// Abstract interface for application logging.
///
/// Provides a unified logging interface that can have multiple implementations
/// (console, Sentry, file, etc.) and can be easily mocked for testing.
///
/// Usage:
/// ```dart
/// @injectable
/// class MyService {
///   final AppLogger _logger;
///
///   MyService(this._logger);
///
///   void doSomething() {
///     _logger.info('Doing something');
///     try {
///       // ...
///     } catch (e, stack) {
///       _logger.error('Failed to do something', error: e, stackTrace: stack);
///     }
///   }
/// }
/// ```
abstract class IAppLogger {
  /// Log a debug message.
  ///
  /// Use for detailed diagnostic information that is typically only needed
  /// when diagnosing problems.
  void debug(
    String message, {
    Map<String, dynamic>? data,
    String? tag,
  });

  /// Log an informational message.
  ///
  /// Use for normal application events that are interesting but not concerning.
  void info(
    String message, {
    Map<String, dynamic>? data,
    String? tag,
  });

  /// Log a warning message.
  ///
  /// Use for situations that are not errors but might require attention.
  void warning(
    String message, {
    Map<String, dynamic>? data,
    String? tag,
  });

  /// Log an error message.
  ///
  /// Use for error events that might still allow the app to continue running.
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? data,
    String? tag,
  });

  /// Log a fatal error message.
  ///
  /// Use for severe errors that will presumably lead the app to abort.
  void fatal(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? data,
    String? tag,
  });

  /// Log a generic message with specified level.
  void log(
    LogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? data,
    String? tag,
  });

  /// Log a complete log entry.
  void logEntry(LogEntry entry);
}
