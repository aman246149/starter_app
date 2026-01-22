import 'package:injectable/injectable.dart';
import 'package:starter_app/core/application/application_environment.dart';
import 'package:starter_app/core/logging/i_app_logger.dart';
import 'package:starter_app/core/logging/loggers/console_logger.dart';

/// Module for logging-related dependencies.
///
/// Provides ConsoleLogger for all environments.
/// Console logging is only active in development (disabled in staging/prod
/// via internal AppEnvironment check in ConsoleLogger).
///
/// **Note:** Error tracking is handled separately by `IErrorReporter`.
/// See `ErrorModule` for Sentry integration.
@module
abstract class LoggingModule {
  /// Provides logger for all environments.
  ///
  /// Uses ConsoleLogger which internally checks AppEnvironment
  /// and disables output in staging/production.
  @LazySingleton(
    env: [
      AppEnvironment.devEnv,
      AppEnvironment.stagingEnv,
      AppEnvironment.prodEnv,
    ],
  )
  IAppLogger provideLogger() {
    return ConsoleLogger();
  }
}
