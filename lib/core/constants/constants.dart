/// Barrel file for all constant definitions.
///
/// Import this file to access all constants and pre-computed widgets:
/// ```dart
/// import 'package:starter_app/core/constants/constants.dart';
/// ```
///
/// ## Usage Examples:
///
/// ### Padding (Pre-computed widgets):
/// ```dart
/// Padding(padding: PaddingWidgets.allMedium)
/// Padding(padding: PaddingWidgets.screen) // Common screen padding
/// ```
///
/// ### Border Radius (Pre-computed widgets):
/// ```dart
/// Container(
///   decoration: BoxDecoration(
///     borderRadius: BorderRadiusWidgets.allMedium,
///   ),
/// )
/// ```
///
/// ### Spacing (Pre-computed widgets):
/// ```dart
/// Column(
///   children: [
///     Text('Item 1'),
///     SpacingWidgets.verticalMd, // 16.0 gap
///     Text('Item 2'),
///   ],
/// )
/// ```
///
/// ### Raw Constants (when you need custom widgets):
/// ```dart
/// EdgeInsets.all(PaddingConstants.medium)
/// BorderRadius.circular(BorderRadiusConstants.medium)
/// SizedBox(height: SpacingConstants.md)
/// ```
///
/// ### Icons:
/// ```dart
/// Icon(Icons.Dashboard, size: IconConstants.medium)
/// ```
///
/// ### Buttons:
/// ```dart
/// SizedBox(height: ButtonConstants.heightMedium)
///
/// ```
/// ### HTTP Headers:
/// ```dart
/// headers[HttpHeaderConstants.authorization] = 'Bearer $token';
/// ```
///
/// ### Durations:
/// ```dart
/// timeout: DurationConstants.timeoutMedium
/// ```
///
/// ### Animation Curves:
/// ```dart
/// AnimatedContainer(
///   duration: DurationConstants.animationMedium,
///   curve: AnimationConstants.standard,
/// )
/// ```
library;

// API & Network Constants
export 'api/http_header_constants.dart';
export 'api/network_constants.dart';
export 'api/pagination_constants.dart';
export 'api/query_parameter_constants.dart';

// Duration Constants
export 'duration_constants.dart';

// UI Constants and Widgets
export 'ui/animation_constants.dart';
export 'ui/app_bar_constants.dart';
export 'ui/avatar_constants.dart';
export 'ui/border_radius_constants.dart';
export 'ui/border_radius_widgets.dart';
export 'ui/breakpoint_constants.dart';
export 'ui/button_constants.dart';
export 'ui/card_constants.dart';
export 'ui/content_width_constants.dart';
export 'ui/dialog_constants.dart';
export 'ui/divider_constants.dart';
export 'ui/elevation_constants.dart';
export 'ui/icon_constants.dart';
export 'ui/image_constants.dart';
export 'ui/navigation_constants.dart';
export 'ui/opacity_constants.dart';
export 'ui/padding_constants.dart';
export 'ui/padding_widgets.dart';
export 'ui/spacing_constants.dart';
export 'ui/spacing_widgets.dart';
