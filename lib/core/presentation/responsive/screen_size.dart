import 'package:starter_app/core/constants/constants.dart'
    show BreakpointConstants;

/// Defines the five window size classes based on Material Design 3 guidelines.
///
/// This enum represents the adaptive breakpoint system used throughout the app
/// to determine appropriate layouts and navigation patterns for different
/// screen sizes.
///
/// Breakpoints follow Material Design 3 specifications:
/// - Compact: 0-599dp (phones in portrait)
/// - Medium: 600-839dp (tablets in portrait, large phones in landscape)
/// - Expanded: 840-1199dp (tablets in landscape, small desktops)
/// - Large: 1200-1599dp (desktops)
/// - Extra Large: 1600dp+ (large/ultra-wide desktops)
///
/// See also:
/// - [BreakpointConstants] for the actual breakpoint values
enum ScreenSize {
  /// Compact screens (0-599dp) - Phones in portrait
  ///
  /// Navigation: Bottom NavigationBar
  /// Layout: Single-pane, full-screen details
  compact,

  /// Medium screens (600-839dp) - Tablets in portrait, large phones landscape
  ///
  /// Navigation: NavigationRail
  /// Layout: Primarily single-pane, dialogs for details
  medium,

  /// Expanded screens (840-1199dp) - Tablets landscape, small desktops
  ///
  /// Navigation: Dismissible NavigationDrawer
  /// Layout: Two-pane layouts are standard
  expanded,

  /// Large screens (1200-1599dp) - Desktops
  ///
  /// Navigation: Permanent NavigationDrawer
  /// Layout: Two or three-pane layouts, multi-column
  large,

  /// Extra large screens (1600dp+) - Large/ultra-wide desktops
  ///
  /// Navigation: Permanent NavigationDrawer
  /// Layout: Three-pane layouts, expansive views
  extraLarge
  ;

  /// Determines the [ScreenSize] from the window width in logical pixels.
  ///
  /// This follows Material Design 3 breakpoint specifications defined
  /// in [BreakpointConstants].
  ///
  /// Example:
  /// ```dart
  /// final width = MediaQuery.sizeOf(context).width;
  /// final screenSize = ScreenSize.fromWidth(width);
  /// ```
  static ScreenSize fromWidth(double width) {
    if (width <= BreakpointConstants.compact) return ScreenSize.compact;
    if (width <= BreakpointConstants.medium) return ScreenSize.medium;
    if (width <= BreakpointConstants.expanded) return ScreenSize.expanded;
    if (width <= BreakpointConstants.large) return ScreenSize.large;
    return ScreenSize.extraLarge;
  }

  /// Check if screen is mobile size (compact).
  ///
  /// Useful for quick mobile-specific checks.
  bool get isMobile => this == ScreenSize.compact;

  /// Check if screen is tablet size (medium or expanded).
  bool get isTablet => this == ScreenSize.medium || this == ScreenSize.expanded;

  /// Check if screen is desktop size (large or extraLarge).
  bool get isDesktop =>
      this == ScreenSize.large || this == ScreenSize.extraLarge;

  /// Check if screen supports two-pane layouts (expanded or larger).
  ///
  /// Two-pane layouts are standard for expanded, large, and
  /// extra-large screens.
  bool get supportsTwoPane => index >= ScreenSize.expanded.index;

  /// Check if screen supports three-pane layouts (large or larger).
  ///
  /// Three-pane layouts are appropriate for large and
  /// extra-large screens.
  bool get supportsThreePane => index >= ScreenSize.large.index;

  /// Get the maximum width breakpoint for this screen size.
  ///
  /// Returns null for extra large (no upper limit).
  /// Values are sourced from [BreakpointConstants].
  double? get maxWidth {
    return switch (this) {
      ScreenSize.compact => BreakpointConstants.compact,
      ScreenSize.medium => BreakpointConstants.medium,
      ScreenSize.expanded => BreakpointConstants.expanded,
      ScreenSize.large => BreakpointConstants.large,
      ScreenSize.extraLarge => null,
    };
  }

  /// Get the minimum width breakpoint for this screen size.
  ///
  /// Values are sourced from [BreakpointConstants].
  double get minWidth {
    return switch (this) {
      ScreenSize.compact => 0,
      ScreenSize.medium => BreakpointConstants.compact + 1,
      ScreenSize.expanded => BreakpointConstants.medium + 1,
      ScreenSize.large => BreakpointConstants.expanded + 1,
      ScreenSize.extraLarge => BreakpointConstants.extraLarge,
    };
  }

  /// Get a human-readable name for debugging.
  String get displayName {
    return switch (this) {
      ScreenSize.compact => 'Compact (Phone)',
      ScreenSize.medium => 'Medium (Tablet Portrait)',
      ScreenSize.expanded => 'Expanded (Tablet Landscape)',
      ScreenSize.large => 'Large (Desktop)',
      ScreenSize.extraLarge => 'Extra Large (Wide Desktop)',
    };
  }
}
