import 'package:injectable/injectable.dart';
import 'package:starter_app/core/domain/ports/i_platform_info.dart';
import 'package:starter_app/core/infrastructure/platform/platform_info.dart';

/// Module for platform-related dependencies.
///
/// Provides:
/// - [IPlatformInfo]: Platform-specific information adapter
@module
abstract class PlatformModule {
  /// Provides the platform info implementation.
  ///
  /// Uses conditional imports to provide the correct implementation:
  /// - Native: Uses dart:io Platform
  /// - Web: Uses browser's navigator API
  @lazySingleton
  IPlatformInfo providePlatformInfo() => const PlatformInfoImpl();
}
