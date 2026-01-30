import 'package:hydrated_bloc/hydrated_bloc.dart';

/// Framework-independent theme mode enum.
///
/// This enum represents theme modes without depending on Flutter.
/// Map to Flutter's ThemeMode in the presentation layer using
/// the extension in `app_theme_extension.dart`.
enum AppThemeMode {
  /// Light theme mode
  light,

  /// Dark theme mode
  dark,

  /// System theme mode (follows device settings)
  system
  ;

  /// Convert from string representation
  static AppThemeMode fromString(String value) {
    return switch (value.toLowerCase()) {
      'light' => AppThemeMode.light,
      'dark' => AppThemeMode.dark,
      'system' => AppThemeMode.system,
      _ => AppThemeMode.system,
    };
  }

  /// Convert to string representation
  String toStringValue() {
    return switch (this) {
      AppThemeMode.light => 'light',
      AppThemeMode.dark => 'dark',
      AppThemeMode.system => 'system',
    };
  }
}

/// Cubit for managing theme mode state with persistence.
///
/// Uses HydratedBloc for automatic state persistence.
/// Provides methods to switch between light, dark, and system themes.
///
/// Located in `core/presentation/bloc/` because:
/// - Cubits are presentation layer concerns (UI state management)
/// - Theme state is cross-cutting (used by all features)
/// - Theme configuration (colors, styles) stays in `core/theme/`
///
/// Registered via BlocModule with default [AppThemeMode.system] value.
/// Must be lazy (not eager) because HydratedBloc.storage must be set first.
class ThemeCubit extends HydratedCubit<AppThemeMode> {
  ThemeCubit(super.state);

  /// Set theme mode
  void setThemeMode(AppThemeMode mode) => emit(mode);

  /// Switch to light theme
  void setLightTheme() => emit(AppThemeMode.light);

  /// Switch to dark theme
  void setDarkTheme() => emit(AppThemeMode.dark);

  /// Switch to system theme
  void setSystemTheme() => emit(AppThemeMode.system);

  /// Toggle between light and dark theme
  void toggleTheme() {
    if (state == AppThemeMode.light) {
      emit(AppThemeMode.dark);
    } else if (state == AppThemeMode.dark) {
      emit(AppThemeMode.light);
    } else {
      // If system, switch to light
      emit(AppThemeMode.light);
    }
  }

  @override
  AppThemeMode? fromJson(Map<String, dynamic> json) {
    try {
      final modeValue = json['mode'];
      if (modeValue == null) return null;
      if (modeValue is! String) return null;

      return AppThemeMode.fromString(modeValue);
      // ignore: avoid_catches_without_on_clauses, Catches TypeError (Error) and Exception
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(AppThemeMode state) {
    return {
      'mode': state.toStringValue(),
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}
