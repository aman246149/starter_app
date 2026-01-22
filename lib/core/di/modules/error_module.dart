import 'package:injectable/injectable.dart';
import 'package:starter_app/core/application/application_environment.dart';
import 'package:starter_app/core/domain/ports/i_data_filter.dart';
import 'package:starter_app/core/domain/ports/i_error_reporter.dart';
import 'package:starter_app/core/error/reporters/no_op_error_reporter.dart';
import 'package:starter_app/core/error/reporters/sentry_error_reporter.dart';

/// Module for error reporting dependencies.
///
/// Provides environment-specific error reporter implementations:
/// - **Development**: NoOpErrorReporter (errors go to console via logger)
/// - **Staging**: SentryErrorReporter (test error tracking)
/// - **Production**: SentryErrorReporter (production error tracking)
@module
abstract class ErrorModule {
  /// Provides error reporter for development environment.
  ///
  /// Development uses a no-op reporter since errors are logged to console.
  @LazySingleton(env: [AppEnvironment.devEnv])
  IErrorReporter provideDevelopmentReporter() {
    return const NoOpErrorReporter();
  }

  /// Provides error reporter for staging and production environment.
  /// 
  /// Staging uses Sentry for testing error tracking workflows.
  /// Production uses Sentry for production error tracking.
  @LazySingleton(env: [AppEnvironment.stagingEnv, AppEnvironment.prodEnv])
  IErrorReporter provideStagingReporter(IDataFilter dataFilter) {
    return SentryErrorReporter(dataFilter);
  }
}
