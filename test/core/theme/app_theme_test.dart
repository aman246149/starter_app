import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/core/theme/app_theme.dart';
import 'package:starter_app/core/theme/theme_extensions.dart';

// ignore_for_file: prefer_const_constructors -
// to be able to test the constructors

void main() {
  group('AppTheme', () {
    final appTheme = AppTheme();

    test('lightTheme has correct brightness and extensions', () {
      final theme = appTheme.lightTheme;
      expect(theme.brightness, Brightness.light);
      expect(theme.extensions.values.first, isA<SemanticColors>());
    });

    test('darkTheme has correct brightness and extensions', () {
      final theme = appTheme.darkTheme;
      expect(theme.brightness, Brightness.dark);
      expect(theme.extensions.values.first, isA<SemanticColors>());
    });
  });
}
