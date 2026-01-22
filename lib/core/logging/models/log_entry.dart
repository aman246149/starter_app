import 'package:starter_app/core/logging/models/log_level.dart';

/// Represents a single log entry with all relevant context.
final class LogEntry {
  const LogEntry({
    required this.level,
    required this.message,
    required this.timestamp,
    this.error,
    this.stackTrace,
    this.data,
    this.tag,
  });

  /// Create a log entry with current timestamp.
  factory LogEntry.now({
    required LogLevel level,
    required String message,
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? data,
    String? tag,
  }) {
    return LogEntry(
      level: level,
      message: message,
      timestamp: DateTime.now(),
      error: error,
      stackTrace: stackTrace,
      data: data,
      tag: tag,
    );
  }

  /// The severity level of this log entry.
  final LogLevel level;

  /// The main log message.
  final String message;

  /// When this log entry was created.
  final DateTime timestamp;

  /// Optional error object associated with this log.
  final Object? error;

  /// Optional stack trace for error logging.
  final StackTrace? stackTrace;

  /// Additional structured data attached to this log.
  final Map<String, dynamic>? data;

  /// Optional tag for categorizing logs (e.g., 'HTTP', 'BLoC', 'Navigation').
  final String? tag;

  /// Convert to JSON for serialization.
  Map<String, dynamic> toJson() {
    return {
      'level': level.name,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      if (error != null) 'error': error.toString(),
      if (stackTrace != null) 'stackTrace': stackTrace.toString(),
      if (data != null) 'data': data,
      if (tag != null) 'tag': tag,
    };
  }

  @override
  String toString() {
    final buffer = StringBuffer()..write('[${level.label}]');
    if (tag != null) buffer.write(' [$tag]');
    buffer.write(' $message');
    if (data != null && data!.isNotEmpty) {
      buffer.write(' | Data: $data');
    }
    if (error != null) {
      buffer.write(' | Error: $error');
    }
    return buffer.toString();
  }
}
