import 'package:flutter/material.dart';
import 'package:starter_app/core/constants/ui/spacing_constants.dart';

/// Pre-computed SizedBox widgets for gaps between elements.
///
/// These widgets reduce boilerplate by providing ready-to-use SizedBox
/// instances based on [SpacingConstants] values.
/// Use these for Column/Row spacing and other layout spacing needs.
abstract final class SpacingWidgets {
  // Pre-computed SizedBox widgets (vertical gaps)
  /// Vertical gap: 1.0
  static const SizedBox verticalHairline = SizedBox(
    height: SpacingConstants.hairline,
  );

  /// Vertical gap: 4.0
  static const SizedBox verticalXs = SizedBox(height: SpacingConstants.xs);

  /// Vertical gap: 8.0
  static const SizedBox verticalSm = SizedBox(height: SpacingConstants.sm);

  /// Vertical gap: 16.0
  static const SizedBox verticalMd = SizedBox(height: SpacingConstants.md);

  /// Vertical gap: 24.0
  static const SizedBox verticalLg = SizedBox(height: SpacingConstants.lg);

  /// Vertical gap: 32.0
  static const SizedBox verticalXl = SizedBox(height: SpacingConstants.xl);

  /// Vertical gap: 48.0
  static const SizedBox verticalXxl = SizedBox(height: SpacingConstants.xxl);

  // Pre-computed SizedBox widgets (horizontal gaps)
  /// Horizontal gap: 1.0
  static const SizedBox horizontalHairline = SizedBox(
    width: SpacingConstants.hairline,
  );

  /// Horizontal gap: 4.0
  static const SizedBox horizontalXs = SizedBox(width: SpacingConstants.xs);

  /// Horizontal gap: 8.0
  static const SizedBox horizontalSm = SizedBox(width: SpacingConstants.sm);

  /// Horizontal gap: 16.0
  static const SizedBox horizontalMd = SizedBox(width: SpacingConstants.md);

  /// Horizontal gap: 24.0
  static const SizedBox horizontalLg = SizedBox(width: SpacingConstants.lg);

  /// Horizontal gap: 32.0
  static const SizedBox horizontalXl = SizedBox(width: SpacingConstants.xl);

  /// Horizontal gap: 48.0
  static const SizedBox horizontalXxl = SizedBox(width: SpacingConstants.xxl);
}
