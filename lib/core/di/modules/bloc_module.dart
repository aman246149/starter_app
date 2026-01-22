import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:starter_app/core/logging/i_app_logger.dart';
import 'package:starter_app/core/presentation/bloc/bloc.dart';

/// Module for BLoC-related dependencies.
///
/// Provides:
/// - **BlocObserver**: Global observer for logging all BLoC/Cubit events
///
/// The observer integrates with the app's logging infrastructure to provide
/// comprehensive state management debugging and monitoring.
@module
abstract class BlocModule {
  /// Provides BlocObserver for logging all BLoC and Cubit events.
  ///
  /// The observer automatically logs:
  /// - **State changes** (onChange): Every state transition
  /// - **Errors** (onError): Any errors thrown in Cubits/Blocs
  /// - **Event emissions** (onEvent): Events dispatched to Blocs
  /// - **Transitions** (onTransition): Full event → state transitions
  ///
  /// All logs are routed through AppLogger, which means:
  /// - **Development**: Logs to console with pretty formatting
  /// - **Staging/Production**: Logs to Sentry for centralized monitoring
  ///
  /// This provides excellent debugging in development and production
  /// monitoring without any additional code in your Cubits/Blocs.
  ///
  /// Registered as singleton and set globally in bootstrap.dart.
  @singleton
  BlocObserver provideBlocObserver(IAppLogger logger) {
    return AppBlocObserver(logger);
  }

  /// Provides ThemeCubit for dynamic theme switching with persistence.
  ///
  /// Uses [AppThemeMode.system] as default, which follows device settings.
  /// State is automatically persisted via HydratedBloc.
  ///
  /// Must be @lazySingleton (not @singleton) because HydratedBloc.storage
  /// must be set before any HydratedCubit is created.
  @lazySingleton
  ThemeCubit provideThemeCubit() {
    return ThemeCubit(AppThemeMode.system);
  }

  /// Provides LocaleCubit for locale/language management with persistence.
  ///
  /// Uses [AppLocale.en] (English) as default.
  /// State is automatically persisted via HydratedBloc.
  ///
  /// Must be @lazySingleton (not @singleton) because HydratedBloc.storage
  /// must be set before any HydratedCubit is created.
  @lazySingleton
  LocaleCubit provideLocaleCubit() {
    return LocaleCubit(AppLocale.en);
  }
}

/// BlocObserver that logs all BLoC events and state changes.
///
/// Uses AppLogger to route logs to console and/or Sentry based on
/// the current environment and build mode.
final class AppBlocObserver extends BlocObserver {
  const AppBlocObserver(this._logger);

  final IAppLogger _logger;

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    _logger.debug(
      'BLoC state changed',
      data: {
        'bloc': bloc.runtimeType.toString(),
        'currentState': change.currentState.toString(),
        'nextState': change.nextState.toString(),
      },
      tag: 'BLoC',
    );
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    _logger.error(
      'BLoC error',
      error: error,
      stackTrace: stackTrace,
      data: {'bloc': bloc.runtimeType.toString()},
      tag: 'BLoC',
    );
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    _logger.debug(
      'BLoC event added',
      data: {
        'bloc': bloc.runtimeType.toString(),
        'event': event.toString(),
      },
      tag: 'BLoC',
    );
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    _logger.debug(
      'BLoC transition',
      data: {
        'bloc': bloc.runtimeType.toString(),
        'event': transition.event.toString(),
        'currentState': transition.currentState.toString(),
        'nextState': transition.nextState.toString(),
      },
      tag: 'BLoC',
    );
  }
}
