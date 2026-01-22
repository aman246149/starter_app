import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:starter_app/core/logging/i_app_logger.dart';
import 'package:starter_app/core/logging/models/log_entry.dart';
import 'package:starter_app/core/logging/models/log_level.dart' as app;

/// Console logger implementation using the official Dart logging package.
///
/// Provides color-coded console output with structured formatting.
/// Only active in debug mode OR development environment.
///
/// Uses the official `logging` package (published by dart.dev) which is:
/// - Industry standard (used by Google internally)
/// - Lightweight (~50KB vs 2.5MB for third-party packages)
/// - Better maintained and production-ready
final class ConsoleLogger implements IAppLogger {
  ConsoleLogger() : _logger = Logger('StarterApp') {
    if (kDebugMode) {
      // Configure logging in debug mode
      Logger.root.level = Level.ALL;
      Logger.root.onRecord.listen(_handleLogRecord);
    }
  }

  final Logger _logger;

  /// Handle log records with custom formatting.
  void _handleLogRecord(LogRecord record) {
    if (!kDebugMode) return;

    final emoji = _getEmoji(record.level);
    final color = _getColorCode(record.level);
    const reset = '\x1B[0m';

    // Format timestamp
    final time = _formatTime(record.time);

    // Build message
    final buffer = StringBuffer()
      ..write('$color$emoji ')
      ..write('[$time] ');

    if (record.loggerName.isNotEmpty && record.loggerName != 'StarterApp') {
      buffer.write('[${record.loggerName}] ');
    }

    buffer
      ..write(record.message)
      ..write(reset);

    // Print main message
    developer.log(
      buffer.toString(),
      time: record.time,
      level: record.level.value,
      name: record.loggerName,
      error: record.error,
      stackTrace: record.stackTrace,
    );

    // Print error if present
    if (record.error != null) {
      developer.log(
        '$color  └─ Error: ${record.error}$reset',
        time: record.time,
        level: record.level.value,
        name: record.loggerName,
      );
    }

    // Print stack trace if present
    if (record.stackTrace != null) {
      final stackLines = record.stackTrace
          .toString()
          .split('\n')
          .take(8)
          .map((line) => '$color  │  $line$reset')
          .join('\n');
      developer.log(
        stackLines,
        time: record.time,
        level: record.level.value,
        name: record.loggerName,
      );
    }
  }

  /// Get emoji for log level.
  String _getEmoji(Level level) {
    if (level >= Level.SEVERE) return '💀';
    if (level >= Level.SHOUT) return '❌';
    if (level >= Level.WARNING) return '⚠️';
    if (level >= Level.INFO) return 'ℹ️';
    return '🐛';
  }

  /// Get ANSI color code for log level.
  String _getColorCode(Level level) {
    if (level >= Level.SEVERE) return '\x1B[35m'; // Magenta
    if (level >= Level.SHOUT) return '\x1B[31m'; // Red
    if (level >= Level.WARNING) return '\x1B[33m'; // Yellow
    if (level >= Level.INFO) return '\x1B[36m'; // Cyan
    return '\x1B[90m'; // Gray
  }

  /// Format timestamp.
  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}:'
        '${time.second.toString().padLeft(2, '0')}.'
        '${(time.millisecond ~/ 10).toString().padLeft(2, '0')}';
  }

  /// Convert app log level to logging package level.
  Level _toLoggingLevel(app.LogLevel level) {
    return switch (level) {
      app.LogLevel.debug => Level.FINE,
      app.LogLevel.info => Level.INFO,
      app.LogLevel.warning => Level.WARNING,
      app.LogLevel.error => Level.SHOUT,
      app.LogLevel.fatal => Level.SEVERE,
    };
  }

  @override
  void debug(
    String message, {
    Map<String, dynamic>? data,
    String? tag,
  }) {
    if (!kDebugMode) return;

    final formattedMessage = _formatMessage(message, data, tag);
    _logger.fine(formattedMessage);
  }

  @override
  void info(
    String message, {
    Map<String, dynamic>? data,
    String? tag,
  }) {
    final formattedMessage = _formatMessage(message, data, tag);
    _logger.info(formattedMessage);
  }

  @override
  void warning(
    String message, {
    Map<String, dynamic>? data,
    String? tag,
  }) {
    final formattedMessage = _formatMessage(message, data, tag);
    _logger.warning(formattedMessage);
  }

  @override
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? data,
    String? tag,
  }) {
    final formattedMessage = _formatMessage(message, data, tag);
    _logger.shout(formattedMessage, error, stackTrace);
  }

  @override
  void fatal(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? data,
    String? tag,
  }) {
    final formattedMessage = _formatMessage(message, data, tag);
    _logger.severe(formattedMessage, error, stackTrace);
  }

  @override
  void log(
    app.LogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? data,
    String? tag,
  }) {
    final formattedMessage = _formatMessage(message, data, tag);
    final loggingLevel = _toLoggingLevel(level);

    _logger.log(loggingLevel, formattedMessage, error, stackTrace);
  }

  @override
  void logEntry(LogEntry entry) {
    log(
      entry.level,
      entry.message,
      error: entry.error,
      stackTrace: entry.stackTrace,
      data: entry.data,
      tag: entry.tag,
    );
  }

  /// Format message with optional tag and data.
  String _formatMessage(
    String message,
    Map<String, dynamic>? data,
    String? tag,
  ) {
    final buffer = StringBuffer();

    if (tag != null) {
      buffer.write('[$tag] ');
    }

    buffer.write(message);

    if (data != null && data.isNotEmpty) {
      buffer.write(' | Data: $data');
    }

    return buffer.toString();
  }
}
