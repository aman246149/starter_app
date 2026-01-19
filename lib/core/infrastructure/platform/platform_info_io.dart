import 'dart:io';

import 'package:starter_app/core/domain/ports/i_platform_info.dart';

/// Native platform (iOS, Android, desktop) implementation of [IPlatformInfo].
///
/// Uses `dart:io` Platform to access native platform information.
class PlatformInfoImpl implements IPlatformInfo {
  const PlatformInfoImpl();

  @override
  String get operatingSystemVersion => Platform.operatingSystemVersion;
}
