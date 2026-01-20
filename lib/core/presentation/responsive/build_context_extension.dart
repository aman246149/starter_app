import 'package:flutter/material.dart';
import 'package:starter_app/core/presentation/responsive/screen_size.dart';

/// Extension methods on [BuildContext] for responsive design.
///
/// Provides convenient access to screen size information and
/// responsive values throughout the widget tree.
///
/// Example:
/// ```dart
/// if (context.isMobile) {
///   // Show mobile layout
/// }
///
/// final padding = context.responsivePadding;
/// final spacing = context.responsiveSpacing;
/// ```
extension ResponsiveContext on BuildContext {
  /// Get the current screen size based on window width.
  ScreenSize get screenSizeFromWidth =>
      ScreenSize.fromWidth(MediaQuery.sizeOf(this).width);

  /// Get the current screen width in logical pixels.
  double get width => MediaQuery.sizeOf(this).width;

  /// Get the current screen height in logical pixels.
  double get height => MediaQuery.sizeOf(this).height;

  // ==================== Screen Size Checks ====================

  /// Check if current screen is mobile size (compact).
  bool get isMobile => screenSizeFromWidth.isMobile;

  /// Check if current screen is tablet size (medium or expanded).
  bool get isTablet => screenSizeFromWidth.isTablet;

  /// Check if current screen is desktop size (large or extraLarge).
  bool get isDesktop => screenSizeFromWidth.isDesktop;

  /// Check if current screen supports two-pane layouts.
  ///
  /// Returns true for expanded, large, and extra-large screens.
  bool get supportsTwoPane => screenSizeFromWidth.supportsTwoPane;

  /// Check if current screen supports three-pane layouts.
  ///
  /// Returns true for large and extra-large screens.
  bool get supportsThreePane => screenSizeFromWidth.supportsThreePane;

  // ==================== Responsive Values ====================

  /// Get responsive padding based on screen size.
  ///
  /// Returns:
  /// - 16.0 for compact (mobile)
  /// - 24.0 for medium and expanded (tablet)
  /// - 32.0 for large and extra-large (desktop)
  EdgeInsets get responsivePadding {
    return EdgeInsets.all(responsivePaddingValue);
  }

  /// Get responsive padding value (as double) based on screen size.
  double get responsivePaddingValue {
    return switch (screenSizeFromWidth) {
      ScreenSize.compact => 16.0,
      ScreenSize.medium || ScreenSize.expanded => 24.0,
      ScreenSize.large || ScreenSize.extraLarge => 32.0,
    };
  }

  /// Get responsive spacing between elements based on screen size.
  ///
  /// Returns:
  /// - 8.0 for compact
  /// - 12.0 for medium
  /// - 16.0 for expanded
  /// - 20.0 for large
  /// - 24.0 for extra-large
  double get responsiveSpacing {
    return switch (screenSizeFromWidth) {
      ScreenSize.compact => 8.0,
      ScreenSize.medium => 12.0,
      ScreenSize.expanded => 16.0,
      ScreenSize.large => 20.0,
      ScreenSize.extraLarge => 24.0,
    };
  }

  /// Get responsive horizontal padding based on screen size.
  ///
  /// Useful for list items and content containers.
  EdgeInsets get responsiveHorizontalPadding {
    return EdgeInsets.symmetric(horizontal: responsivePaddingValue);
  }

  /// Get responsive vertical padding based on screen size.
  EdgeInsets get responsiveVerticalPadding {
    return EdgeInsets.symmetric(vertical: responsivePaddingValue);
  }

  /// Get responsive margin based on screen size.
  EdgeInsets get responsiveMargin {
    return EdgeInsets.all(responsiveSpacing);
  }

  /// Get responsive content width constraint.
  ///
  /// Returns null for mobile (no constraint), and appropriate max widths
  /// for larger screens to maintain readability.
  ///
  /// Returns:
  /// - null for compact (full width)
  /// - 840 for medium
  /// - 1200 for expanded
  /// - 1400 for large
  /// - 1600 for extra-large
  double? get responsiveContentMaxWidth {
    return switch (screenSizeFromWidth) {
      ScreenSize.compact => null,
      ScreenSize.medium => 840,
      ScreenSize.expanded => 1200,
      ScreenSize.large => 1400,
      ScreenSize.extraLarge => 1600,
    };
  }

  /// Get responsive grid column count.
  ///
  /// Useful for GridView layouts.
  ///
  /// Returns:
  /// - 2 for compact
  /// - 3 for medium
  /// - 4 for expanded
  /// - 5 for large
  /// - 6 for extra-large
  int get responsiveGridColumns {
    return switch (screenSizeFromWidth) {
      ScreenSize.compact => 2,
      ScreenSize.medium => 3,
      ScreenSize.expanded => 4,
      ScreenSize.large => 5,
      ScreenSize.extraLarge => 6,
    };
  }

  /// Get a responsive value based on a provided selector function.
  ///
  /// Example:
  /// ```dart
  /// final fontSize = context.responsiveValue(
  ///   mobile: 14.0,
  ///   tablet: 16.0,
  ///   desktop: 18.0,
  /// );
  /// ```
  T responsiveValue<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isMobile) return mobile;
    if (isTablet) return tablet ?? mobile;
    return desktop ?? tablet ?? mobile;
  }

  /// Get a responsive value based on specific screen sizes.
  ///
  /// More granular control than [responsiveValue].
  ///
  /// Example:
  /// ```dart
  /// final columns = context.responsiveValueBySize(
  ///   compact: 1,
  ///   medium: 2,
  ///   expanded: 3,
  ///   large: 4,
  ///   extraLarge: 5,
  /// );
  /// ```
  T responsiveValueBySize<T>({
    required T compact,
    T? medium,
    T? expanded,
    T? large,
    T? extraLarge,
  }) {
    return switch (screenSizeFromWidth) {
      ScreenSize.compact => compact,
      ScreenSize.medium => medium ?? compact,
      ScreenSize.expanded => expanded ?? medium ?? compact,
      ScreenSize.large => large ?? expanded ?? medium ?? compact,
      ScreenSize.extraLarge =>
        extraLarge ?? large ?? expanded ?? medium ?? compact,
    };
  }
}
