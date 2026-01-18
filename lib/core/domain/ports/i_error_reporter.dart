import 'package:starter_app/features/auth/domain/entities/user.dart';

///
/// Maps to severity levels in error tracking services like Sentry.
enum SeverityLevel {
  /// Informational message, not an error.
  info,

  /// Warning that should be monitored but is not critical.
  warning,

  /// Error that affected user experience.
  error,

  /// Fatal error that caused a crash or critical failure.
  fatal,
}

/// Port interface for error tracking and crash reporting.
///
/// This is NOT a logger. It captures exceptions and provides
/// context (breadcrumbs) for debugging production issues.
///
/// **Key Differences from IAppLogger:**
/// - `IAppLogger`: Development-time logging (console output)
/// - `IErrorReporter`: Production error tracking (Sentry, Crashlytics)
///
/// **When to use:**
/// - Use for unhandled exceptions
/// - Use for important caught exceptions that need monitoring
/// - Use breadcrumbs to provide context for error investigation
///
/// **Example:**
/// ```dart
/// @injectable
/// class AuthService {
///   final IErrorReporter _errorReporter;
///
///   AuthService(this._errorReporter);
///
///   Future<void> login(String email, String password) async {
///     _errorReporter.addBreadcrumb('Login attempt', category: 'auth');
///     try {
///       await _authRepository.login(email, password);
///       _errorReporter.addBreadcrumb('Login successful', category: 'auth');
///     } catch (e, stack) {
///       await _errorReporter.captureException(
///         e,
///         stackTrace: stack,
///         context: {'email': email}, // Never log password!
///         tag: 'auth',
///       );
///       rethrow;
///     }
///   }
/// }
/// ```
///
/// **Implementations:**
/// - `SentryErrorReporter` - Production error tracking via Sentry
abstract class IErrorReporter {
  /// Capture an exception with optional context.
  ///
  /// [exception] The exception or error object to capture.
  /// [stackTrace] Optional stack trace for better debugging.
  /// [context] Additional context data (will be filtered for sensitive info).
  /// [tag] Optional tag for grouping/filtering errors.
  Future<void> captureException(
    Object exception, {
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
    String? tag,
  });

  /// Capture a message for non-exception events.
  ///
  /// Use sparingly - prefer [captureException] for actual errors.
  /// Messages appear as issues in error tracking dashboards.
  ///
  /// [message] The message to capture.
  /// [level] Severity level (defaults to info).
  /// [context] Additional context data.
  /// [tag] Optional tag for grouping/filtering.
  Future<void> captureMessage(
    String message, {
    SeverityLevel level = SeverityLevel.info,
    Map<String, dynamic>? context,
    String? tag,
  });

  /// Add a breadcrumb for context trail.
  ///
  /// Breadcrumbs are only visible when an error is captured.
  /// They provide a trail of events leading up to the error.
  ///
  /// [message] Description of the event.
  /// [category] Category for grouping (e.g., 'navigation', 'http', 'auth').
  /// [data] Additional structured data.
  /// [level] Optional severity level for the breadcrumb.
  void addBreadcrumb(
    String message, {
    String? category,
    Map<String, dynamic>? data,
    SeverityLevel? level,
  });

  /// Set user identity for error grouping.
  ///
  /// Allows grouping errors by user in the dashboard.
  /// Call this after user login.
  ///
  /// [user] The authenticated user entity.
  void setUser(User user);

  /// Clear user identity.
  ///
  /// Call this after user logout.
  void clearUser();
}
