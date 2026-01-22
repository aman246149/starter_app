import 'package:flutter/material.dart';
import 'package:starter_app/core/theme/color_palette.dart';

/// Custom theme extension for semantic colors not covered by Material Design 3.
///
/// Provides access to success, warning, and info colors through the theme.
@immutable
class SemanticColors extends ThemeExtension<SemanticColors> {
  const SemanticColors({
    required this.success,
    required this.warning,
    required this.info,
    required this.successContainer,
    required this.warningContainer,
    required this.infoContainer,
    required this.onSuccess,
    required this.onWarning,
    required this.onInfo,
  });

  /// Light theme semantic colors
  factory SemanticColors.light() {
    return const SemanticColors(
      success: AppColorPalette.success,
      warning: AppColorPalette.warning,
      info: AppColorPalette.info,
      successContainer: AppColorPalette.successLight,
      warningContainer: AppColorPalette.warningLight,
      infoContainer: AppColorPalette.infoLight,
      onSuccess: AppColorPalette.white,
      onWarning: AppColorPalette.black87,
      onInfo: AppColorPalette.white,
    );
  }

  /// Dark theme semantic colors
  factory SemanticColors.dark() {
    return const SemanticColors(
      success: AppColorPalette.successLight,
      warning: AppColorPalette.warningLight,
      info: AppColorPalette.infoLight,
      successContainer: AppColorPalette.successDark,
      warningContainer: AppColorPalette.warningDark,
      infoContainer: AppColorPalette.infoDark,
      onSuccess: AppColorPalette.black87,
      onWarning: AppColorPalette.black87,
      onInfo: AppColorPalette.white,
    );
  }

  /// Success color for positive states
  final Color success;

  /// Warning color for cautionary states
  final Color warning;

  /// Info color for informational messages
  final Color info;

  /// Background color for success states
  final Color successContainer;

  /// Background color for warning states
  final Color warningContainer;

  /// Background color for info states
  final Color infoContainer;

  /// Text color on success backgrounds
  final Color onSuccess;

  /// Text color on warning backgrounds
  final Color onWarning;

  /// Text color on info backgrounds
  final Color onInfo;

  @override
  SemanticColors copyWith({
    Color? success,
    Color? warning,
    Color? info,
    Color? successContainer,
    Color? warningContainer,
    Color? infoContainer,
    Color? onSuccess,
    Color? onWarning,
    Color? onInfo,
  }) {
    return SemanticColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      successContainer: successContainer ?? this.successContainer,
      warningContainer: warningContainer ?? this.warningContainer,
      infoContainer: infoContainer ?? this.infoContainer,
      onSuccess: onSuccess ?? this.onSuccess,
      onWarning: onWarning ?? this.onWarning,
      onInfo: onInfo ?? this.onInfo,
    );
  }

  @override
  SemanticColors lerp(ThemeExtension<SemanticColors>? other, double t) {
    if (other is! SemanticColors) {
      return this;
    }
    return SemanticColors(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      successContainer: Color.lerp(
        successContainer,
        other.successContainer,
        t,
      )!,
      warningContainer: Color.lerp(
        warningContainer,
        other.warningContainer,
        t,
      )!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      onInfo: Color.lerp(onInfo, other.onInfo, t)!,
    );
  }
}

/// Extension to access semantic colors from BuildContext
extension SemanticColorsExtension on BuildContext {
  /// Access semantic colors from the current theme
  SemanticColors get semanticColors {
    return Theme.of(this).extension<SemanticColors>() ?? SemanticColors.light();
  }
}
