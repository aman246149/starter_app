/// Log severity levels.
///
/// Ordered from least to most severe for filtering and comparison.
enum LogLevel {
  /// Verbose debug information for development.
  ///
  /// Use for detailed diagnostic information that is typically
  /// only needed when diagnosing problems.
  debug(0),

  /// General informational messages.
  ///
  /// Use for normal application events, like service started,
  /// configuration assumed, etc.
  info(1),

  /// Warning messages for potentially harmful situations.
  ///
  /// Use for situations that are not errors but might require attention.
  warning(2),

  /// Error messages for error events.
  ///
  /// Use for error events that might still allow the app to continue running.
  error(3),

  /// Fatal error messages for very severe error events.
  ///
  /// Use for severe errors that will presumably lead the app to abort.
  fatal(4)
  ;

  const LogLevel(this.value);

  /// Numeric value for comparison.
  final int value;

  /// Check if this level is enabled given a minimum level.
  bool isEnabled(LogLevel minimumLevel) => value >= minimumLevel.value;

  /// Get emoji representation for console output.
  String get emoji => switch (this) {
    LogLevel.debug => '🐛',
    LogLevel.info => 'ℹ️',
    LogLevel.warning => '⚠️',
    LogLevel.error => '❌',
    LogLevel.fatal => '💀',
  };

  /// Get color-coded label for console output.
  String get label => switch (this) {
    LogLevel.debug => 'DEBUG',
    LogLevel.info => 'INFO',
    LogLevel.warning => 'WARN',
    LogLevel.error => 'ERROR',
    LogLevel.fatal => 'FATAL',
  };
}
