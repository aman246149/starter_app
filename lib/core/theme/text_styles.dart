import 'package:flutter/material.dart';

/// Typography styles following Material Design 3 type scale.
///
/// Provides consistent text styling across the application.
/// All styles are defined using Material Design 3 type scale roles.
abstract final class AppTextStyles {
  // ==================== Display Styles ====================
  // Large, prominent text (96, 60, 48)

  /// Display Large - Largest display text (57sp)
  /// Use: Hero headlines, landing pages
  static const TextStyle displayLarge = TextStyle(
    fontSize: 57,
    height: 64 / 57,
    letterSpacing: -0.25,
    fontWeight: FontWeight.w400,
  );

  /// Display Medium - Medium display text (45sp)
  /// Use: Section headers, feature highlights
  static const TextStyle displayMedium = TextStyle(
    fontSize: 45,
    height: 52 / 45,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
  );

  /// Display Small - Small display text (36sp)
  /// Use: Card titles, dialog headers
  static const TextStyle displaySmall = TextStyle(
    fontSize: 36,
    height: 44 / 36,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
  );

  // ==================== Headline Styles ====================
  // Prominent, shorter text (32, 28, 24)

  /// Headline Large - Largest headline (32sp)
  /// Use: Page titles, main headers
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    height: 40 / 32,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
  );

  /// Headline Medium - Medium headline (28sp)
  /// Use: Section headers, card headers
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 28,
    height: 36 / 28,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
  );

  /// Headline Small - Small headline (24sp)
  /// Use: Subsection headers, list headers
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 24,
    height: 32 / 24,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
  );

  // ==================== Title Styles ====================
  // Medium emphasis text (22, 16, 14)

  /// Title Large - Largest title (22sp)
  /// Use: Prominent list items, toolbar titles
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    height: 28 / 22,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
  );

  /// Title Medium - Medium title (16sp)
  /// Use: Card titles, dialog titles
  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    height: 24 / 16,
    letterSpacing: 0.15,
    fontWeight: FontWeight.w500,
  );

  /// Title Small - Small title (14sp)
  /// Use: List item titles, dense layouts
  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    height: 20 / 14,
    letterSpacing: 0.1,
    fontWeight: FontWeight.w500,
  );

  // ==================== Label Styles ====================
  // UI elements, buttons, tabs (14, 12, 11)

  /// Label Large - Largest label (14sp)
  /// Use: Button text, tab labels
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    height: 20 / 14,
    letterSpacing: 0.1,
    fontWeight: FontWeight.w500,
  );

  /// Label Medium - Medium label (12sp)
  /// Use: Form labels, chip labels
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    letterSpacing: 0.5,
    fontWeight: FontWeight.w500,
  );

  /// Label Small - Small label (11sp)
  /// Use: Captions, overlines
  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    height: 16 / 11,
    letterSpacing: 0.5,
    fontWeight: FontWeight.w500,
  );

  // ==================== Body Styles ====================
  // Regular content text (16, 14)

  /// Body Large - Largest body text (16sp)
  /// Use: Primary content, article text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    height: 24 / 16,
    letterSpacing: 0.5,
    fontWeight: FontWeight.w400,
  );

  /// Body Medium - Medium body text (14sp)
  /// Use: Secondary content, list items
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    height: 20 / 14,
    letterSpacing: 0.25,
    fontWeight: FontWeight.w400,
  );

  /// Body Small - Small body text (12sp)
  /// Use: Tertiary content, captions
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    letterSpacing: 0.4,
    fontWeight: FontWeight.w400,
  );

  // ==================== Utility Methods ====================

  /// Get text theme with all styles defined
  static TextTheme getTextTheme() {
    return const TextTheme(
      // Display styles
      displayLarge: displayLarge,
      displayMedium: displayMedium,
      displaySmall: displaySmall,
      // Headline styles
      headlineLarge: headlineLarge,
      headlineMedium: headlineMedium,
      headlineSmall: headlineSmall,
      // Title styles
      titleLarge: titleLarge,
      titleMedium: titleMedium,
      titleSmall: titleSmall,
      // Label styles
      labelLarge: labelLarge,
      labelMedium: labelMedium,
      labelSmall: labelSmall,
      // Body styles
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
    );
  }
}
