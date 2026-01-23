import 'package:flutter/material.dart';
import 'package:starter_app/core/constants/ui/padding_constants.dart';

/// Pre-computed EdgeInsets widgets for padding and margins.
///
/// These widgets reduce boilerplate by providing ready-to-use EdgeInsets
/// instances based on [PaddingConstants] values.
abstract final class PaddingWidgets {
  // Pre-computed EdgeInsets (all sides)
  /// All sides padding: 4.0
  static const EdgeInsets allXSmall = EdgeInsets.all(PaddingConstants.xSmall);

  /// All sides padding: 8.0
  static const EdgeInsets allSmall = EdgeInsets.all(PaddingConstants.small);

  /// All sides padding: 16.0
  static const EdgeInsets allMedium = EdgeInsets.all(PaddingConstants.medium);

  /// All sides padding: 24.0
  static const EdgeInsets allLarge = EdgeInsets.all(PaddingConstants.large);

  /// All sides padding: 32.0
  static const EdgeInsets allXLarge = EdgeInsets.all(PaddingConstants.xLarge);

  /// All sides padding: 48.0
  static const EdgeInsets allXXLarge = EdgeInsets.all(PaddingConstants.xxLarge);

  // Pre-computed EdgeInsets (horizontal)
  /// Horizontal padding: 8.0
  static const EdgeInsets horizontalSmall = EdgeInsets.symmetric(
    horizontal: PaddingConstants.small,
  );

  /// Horizontal padding: 16.0
  static const EdgeInsets horizontalMedium = EdgeInsets.symmetric(
    horizontal: PaddingConstants.medium,
  );

  /// Horizontal padding: 24.0
  static const EdgeInsets horizontalLarge = EdgeInsets.symmetric(
    horizontal: PaddingConstants.large,
  );

  /// Horizontal padding: 32.0
  static const EdgeInsets horizontalXLarge = EdgeInsets.symmetric(
    horizontal: PaddingConstants.xLarge,
  );

  // Pre-computed EdgeInsets (vertical)
  /// Vertical padding: 8.0
  static const EdgeInsets verticalSmall = EdgeInsets.symmetric(
    vertical: PaddingConstants.small,
  );

  /// Vertical padding: 16.0
  static const EdgeInsets verticalMedium = EdgeInsets.symmetric(
    vertical: PaddingConstants.medium,
  );

  /// Vertical padding: 24.0
  static const EdgeInsets verticalLarge = EdgeInsets.symmetric(
    vertical: PaddingConstants.large,
  );

  /// Vertical padding: 32.0
  static const EdgeInsets verticalXLarge = EdgeInsets.symmetric(
    vertical: PaddingConstants.xLarge,
  );

  // Common screen/page padding patterns
  /// Standard screen padding (horizontal: 16.0, vertical: 24.0)
  static const EdgeInsets screen = EdgeInsets.symmetric(
    horizontal: PaddingConstants.medium,
    vertical: PaddingConstants.large,
  );

  /// Compact screen padding (horizontal: 16.0, vertical: 16.0)
  static const EdgeInsets screenCompact = EdgeInsets.all(
    PaddingConstants.medium,
  );

  /// Dialog padding (horizontal: 24.0, vertical: 24.0)
  static const EdgeInsets dialog = EdgeInsets.all(PaddingConstants.large);
}
