/// Platform information adapter with conditional imports.
///
/// This barrel file exports the appropriate [IPlatformInfo] implementation
/// based on the target platform:
/// - Web: Uses browser's navigator API
/// - Native (iOS, Android, desktop): Uses dart:io Platform
///
/// Usage:
/// ```dart
/// import 'package:starter_app/core/infrastructure/platform/platform_info.dart';
///
/// final platformInfo = PlatformInfoImpl();
/// print(platformInfo.operatingSystemVersion);
/// ```
library;

import 'package:starter_app/core/domain/ports/i_platform_info.dart';

export 'platform_info_io.dart'
    if (dart.library.js_interop) 'platform_info_web.dart';
