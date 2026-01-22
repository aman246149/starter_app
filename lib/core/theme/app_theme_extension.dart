import 'package:flutter/material.dart';
import 'package:starter_app/core/presentation/bloc/theme_cubit.dart';

extension AppThemeModeExtension on AppThemeMode {
  ThemeMode toThemeMode() {
    return switch (this) {
      AppThemeMode.light => ThemeMode.light,
      AppThemeMode.dark => ThemeMode.dark,
      AppThemeMode.system => ThemeMode.system,
    };
  }
}
