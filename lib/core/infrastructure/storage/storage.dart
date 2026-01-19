/// Storage infrastructure implementations.
///
/// This module contains adapters that implement storage ports
/// defined in the domain layer.
///
/// Usage:
/// ```dart
/// // Import interfaces from domain
/// import 'package:starter_app/core/domain/ports/ports.dart';
///
/// // Use via dependency injection
/// final tokenStorage = getIt<ITokenStorage>();
/// await tokenStorage.saveTokens(accessToken: token);
/// ```
library;

export 'secure_storage_impl.dart';
export 'token_storage_impl.dart';
