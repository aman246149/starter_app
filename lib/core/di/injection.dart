import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:starter_app/core/application/application_environment.dart';

import 'package:starter_app/core/di/injection.config.dart';

/// Global service locator instance.
///
/// Provides access to all registered dependencies throughout the application.
/// Dependencies are registered
/// using the Injectable package with code generation.
///
/// Usage:
/// ```dart
/// // In presentation layer (pages/widgets)
/// final myBloc = getIt<MyBloc>();
///
/// // In other layers, use constructor injection
/// class MyUseCase {
///   final IRepository _repository;
///   MyUseCase(this._repository);
/// }
/// ```
final GetIt getIt = GetIt.instance;

/// Configures all application dependencies using Injectable code generation.
///
/// This function must be called before running the app, typically in
/// `bootstrap.dart` or main entry points.
///
/// The function handles:
/// - Registering all @injectable, @singleton, @lazySingleton classes
/// - Executing @module providers
/// - Resolving @preResolve async dependencies
///
/// Example:
/// ```dart
/// Future<void> main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await configureDependencies();
///   runApp(const MyApp());
/// }
/// ```
@injectableInit
Future<void> configureDependencies(AppEnvironment environment) async =>
    getIt.init(environment: environment.name);
