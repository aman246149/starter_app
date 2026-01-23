/// Elevation constants following Material Design 3 specifications.
///
/// These values define the elevation levels used throughout the app
/// for shadows and depth. They align with Material Design 3 elevation
/// system and are used by Material widgets like Card, AppBar, etc.
abstract final class ElevationConstants {
  /// Level 0: 0dp (flat, no elevation)
  static const double level0 = 0;

  /// Level 1: 1dp (cards, buttons, chips)
  static const double level1 = 1;

  /// Level 2: 3dp (app bars, menus, floating action buttons)
  static const double level2 = 3;

  /// Level 3: 6dp (navigation drawers, bottom sheets)
  static const double level3 = 6;

  /// Level 4: 8dp (dialogs, modals)
  static const double level4 = 8;

  /// Level 5: 12dp (full-screen modals)
  static const double level5 = 12;
}
