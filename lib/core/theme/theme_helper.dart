import 'package:flutter/material.dart';
import 'package:starter_app/core/theme/theme_extensions.dart';

/// Helper utilities for working with themes.
///
/// Provides convenient methods to access theme properties and
/// semantic colors throughout the application.
abstract final class ThemeHelper {
  // ==================== Color Helpers ====================

  /// Get primary color from context
  static Color primaryColor(BuildContext context) {
    return Theme.of(context).colorScheme.primary;
  }

  /// Get secondary color from context
  static Color secondaryColor(BuildContext context) {
    return Theme.of(context).colorScheme.secondary;
  }

  /// Get error color from context
  static Color errorColor(BuildContext context) {
    return Theme.of(context).colorScheme.error;
  }

  /// Get success color from context
  static Color successColor(BuildContext context) {
    return context.semanticColors.success;
  }

  /// Get warning color from context
  static Color warningColor(BuildContext context) {
    return context.semanticColors.warning;
  }

  /// Get info color from context
  static Color infoColor(BuildContext context) {
    return context.semanticColors.info;
  }

  // ==================== Text Style Helpers ====================

  /// Get headline large text style
  static TextStyle headlineLarge(BuildContext context) {
    return Theme.of(context).textTheme.headlineLarge!;
  }

  /// Get headline medium text style
  static TextStyle headlineMedium(BuildContext context) {
    return Theme.of(context).textTheme.headlineMedium!;
  }

  /// Get body large text style
  static TextStyle bodyLarge(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge!;
  }

  /// Get body medium text style
  static TextStyle bodyMedium(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!;
  }

  /// Get label large text style (for buttons)
  static TextStyle labelLarge(BuildContext context) {
    return Theme.of(context).textTheme.labelLarge!;
  }

  // ==================== Theme Query Helpers ====================

  /// Check if current theme is dark mode
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  /// Check if current theme is light mode
  static bool isLightMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light;
  }

  /// Get current brightness
  static Brightness brightness(BuildContext context) {
    return Theme.of(context).brightness;
  }

  // ==================== Elevation Helpers ====================

  /// Get surface elevation tint color
  static Color surfaceTint(BuildContext context) {
    return Theme.of(context).colorScheme.surfaceTint;
  }

  /// Get elevated surface color at specific level
  static Color elevatedSurface(BuildContext context, {int level = 1}) {
    final surfaceTintColor = surfaceTint(context);
    final surface = Theme.of(context).colorScheme.surface;

    // Material 3 elevation tint opacity
    // Level 0: 0%
    // Level 1: 5%
    // Level 2: 8%
    // Level 3: 11%
    // Level 4: 12%
    // Level 5: 14%
    const opacityLevels = [0.0, 0.05, 0.08, 0.11, 0.12, 0.14];

    final opacity = (level >= 0 && level < opacityLevels.length)
        ? opacityLevels[level]
        : opacityLevels.last;

    return Color.alphaBlend(
      surfaceTintColor.withValues(alpha: opacity),
      surface,
    );
  }
}

/// Extension methods for easier theme access from BuildContext
extension ThemeContextExtension on BuildContext {
  /// Access the current theme data
  ThemeData get theme => Theme.of(this);

  /// Access the current color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Access the current text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Check if current theme is dark
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Check if current theme is light
  bool get isLightMode => Theme.of(this).brightness == Brightness.light;

  // ==================== Quick Color Access ====================

  /// Primary color
  Color get primaryColor => colorScheme.primary;

  /// Secondary color
  Color get secondaryColor => colorScheme.secondary;

  /// Background color
  Color get backgroundColor => colorScheme.surface;

  /// Surface color
  Color get surfaceColor => colorScheme.surface;

  /// Error color
  Color get errorColor => colorScheme.error;

  /// On primary color
  Color get onPrimary => colorScheme.onPrimary;

  /// On secondary color
  Color get onSecondary => colorScheme.onSecondary;

  /// On surface color
  Color get onSurface => colorScheme.onSurface;

  /// On error color
  Color get onError => colorScheme.onError;
}
