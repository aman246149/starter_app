import 'package:flutter/material.dart';

/// Application color palette following Material Design 3 guidelines.
///
/// Provides semantic color definitions that work across light and dark themes.
/// Uses FlexColorScheme for consistent color generation and theming.
abstract final class AppColorPalette {
  // ==================== Common Colors ====================

  /// Pure white
  static const Color white = Color(0xFFFFFFFF);

  /// Black 87% opacity
  static const Color black87 = Color(0xDD000000);

  // ==================== Primary Colors ====================

  /// Primary brand color - Main color for key components
  static const Color primaryLight = Color(0xFF6750A4);
  static const Color primaryDark = Color(0xFFD0BCFF);

  /// Secondary brand color - For less prominent components
  static const Color secondaryLight = Color(0xFF625B71);
  static const Color secondaryDark = Color(0xFFCCC2DC);

  /// Tertiary brand color - For contrasting accents
  static const Color tertiaryLight = Color(0xFF7D5260);
  static const Color tertiaryDark = Color(0xFFEFB8C8);

  /// Primary Container colors
  static const Color primaryContainerLight = Color(0xFFEADDFF);
  static const Color primaryContainerDark = Color(0xFF4F378B);

  /// Secondary Container colors
  static const Color secondaryContainerLight = Color(0xFFE8DEF8);
  static const Color secondaryContainerDark = Color(0xFF4A4458);

  /// Tertiary Container colors
  static const Color tertiaryContainerLight = Color(0xFFFFD8E4);
  static const Color tertiaryContainerDark = Color(0xFF633B48);

  /// Input field background colors
  static const Color inputBackgroundLight = Color(0xFFF3EDF7);
  static const Color inputBackgroundDark = Color(0xFF1D192B);

  // ==================== Semantic Colors ====================

  /// Success color - For positive actions and states
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFF81C784);
  static const Color successDark = Color(0xFF388E3C);

  /// Warning color - For cautionary actions and states
  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFB74D);
  static const Color warningDark = Color(0xFFF57C00);

  /// Error color - For destructive actions and error states
  static const Color error = Color(0xFFB3261E);
  static const Color errorLight = Color(0xFFF2B8B5);
  static const Color errorDark = Color(0xFF8C1D18);

  /// Info color - For informational messages
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFF64B5F6);
  static const Color infoDark = Color(0xFF1976D2);

  // ==================== Surface Colors ====================

  /// Surface colors for elevated components
  static const Color surfaceLight = Color(0xFFFFFBFE);
  static const Color surfaceDark = Color(0xFF1C1B1F);

  /// Background color for the app
  static const Color backgroundLight = Color(0xFFFFFBFE);
  static const Color backgroundDark = Color(0xFF1C1B1F);

  // ==================== Text Colors ====================

  /// Primary text color
  static const Color onSurfaceLight = Color(0xFF1C1B1F);
  static const Color onSurfaceDark = Color(0xFFE6E1E5);

  /// Secondary text color (lower emphasis)
  static const Color onSurfaceVariantLight = Color(0xFF49454F);
  static const Color onSurfaceVariantDark = Color(0xFFCAC4D0);

  // ==================== Neutral Colors ====================

  /// Outline colors for borders and dividers
  static const Color outlineLight = Color(0xFF79747E);
  static const Color outlineDark = Color(0xFF938F99);

  /// Shadow and overlay colors
  static const Color shadowLight = Color(0xFF000000);
  static const Color shadowDark = Color(0xFF000000);

  // ==================== Utility Methods ====================

  /// Get success color based on brightness
  static Color successColor(Brightness brightness) {
    return brightness == Brightness.light ? success : successLight;
  }

  /// Get warning color based on brightness
  static Color warningColor(Brightness brightness) {
    return brightness == Brightness.light ? warning : warningLight;
  }

  /// Get error color based on brightness
  static Color errorColor(Brightness brightness) {
    return brightness == Brightness.light ? error : errorLight;
  }

  /// Get info color based on brightness
  static Color infoColor(Brightness brightness) {
    return brightness == Brightness.light ? info : infoLight;
  }
}
