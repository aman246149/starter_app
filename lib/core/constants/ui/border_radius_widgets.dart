import 'package:flutter/material.dart';
import 'package:starter_app/core/constants/constants.dart'
    show BorderRadiusConstants;

/// Pre-computed BorderRadius widgets for consistent corner rounding.
///
/// These widgets reduce boilerplate by providing ready-to-use BorderRadius
/// instances based on [BorderRadiusConstants] values.
abstract final class BorderRadiusWidgets {
  // Pre-computed BorderRadius (all corners)
  /// All corners: 8.0
  static const BorderRadius allSmall = BorderRadius.all(
    Radius.circular(BorderRadiusConstants.small),
  );

  /// All corners: 12.0
  static const BorderRadius allMedium = BorderRadius.all(
    Radius.circular(BorderRadiusConstants.medium),
  );

  /// All corners: 16.0
  static const BorderRadius allLarge = BorderRadius.all(
    Radius.circular(BorderRadiusConstants.large),
  );

  /// All corners: 24.0
  static const BorderRadius allXLarge = BorderRadius.all(
    Radius.circular(BorderRadiusConstants.xLarge),
  );

  /// All corners: circular (999.0)
  static const BorderRadius allCircular = BorderRadius.all(
    Radius.circular(BorderRadiusConstants.circular),
  );

  // Pre-computed BorderRadius (top-only, for bottom sheets, cards)
  /// Top corners only: 12.0
  static const BorderRadius topMedium = BorderRadius.vertical(
    top: Radius.circular(BorderRadiusConstants.medium),
  );

  /// Top corners only: 16.0
  static const BorderRadius topLarge = BorderRadius.vertical(
    top: Radius.circular(BorderRadiusConstants.large),
  );

  /// Top corners only: 24.0
  static const BorderRadius topXLarge = BorderRadius.vertical(
    top: Radius.circular(BorderRadiusConstants.xLarge),
  );

  // Pre-computed BorderRadius (bottom-only)
  /// Bottom corners only: 12.0
  static const BorderRadius bottomMedium = BorderRadius.vertical(
    bottom: Radius.circular(BorderRadiusConstants.medium),
  );

  /// Bottom corners only: 16.0
  static const BorderRadius bottomLarge = BorderRadius.vertical(
    bottom: Radius.circular(BorderRadiusConstants.large),
  );

  /// Bottom corners only: 24.0
  static const BorderRadius bottomXLarge = BorderRadius.vertical(
    bottom: Radius.circular(BorderRadiusConstants.xLarge),
  );
}
