/// Responsive breakpoint constants based on Material Design 3.
///
/// These values define the window size class breakpoints used throughout
/// the app for adaptive layouts. They align with Material Design 3
/// specifications and are used by the ScreenSize enum for screen
/// size calculations.
///
/// See also:
/// - ScreenSize enum for the enum-based screen size classification
/// - Material Design 3 Layout Guidelines
abstract final class BreakpointConstants {
  /// Compact screen max width: 599.0
  ///
  /// Screens from 0dp to 599dp are considered compact (phones in portrait).
  static const double compact = 599;

  /// Medium screen max width: 839.0
  ///
  /// Screens from 600dp to 839dp are considered medium
  /// (tablets in portrait, large phones in landscape).
  static const double medium = 839;

  /// Expanded screen max width: 1199.0
  ///
  /// Screens from 840dp to 1199dp are considered expanded
  /// (tablets in landscape, small desktops).
  static const double expanded = 1199;

  /// Large screen max width: 1599.0
  ///
  /// Screens from 1200dp to 1599dp are considered large (desktops).
  static const double large = 1599;

  /// Extra large screen min width: 1600.0
  ///
  /// Screens from 1600dp and above are considered extra large
  /// (large/ultra-wide desktops).
  static const double extraLarge = 1600;
}
