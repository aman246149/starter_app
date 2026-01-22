import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/core/theme/color_palette.dart';

void main() {
  group('AppColorPalette', () {
    test('successColor returns correct color for brightness', () {
      expect(
        AppColorPalette.successColor(Brightness.light),
        AppColorPalette.success,
      );
      expect(
        AppColorPalette.successColor(Brightness.dark),
        AppColorPalette.successLight,
      );
    });

    test('warningColor returns correct color for brightness', () {
      expect(
        AppColorPalette.warningColor(Brightness.light),
        AppColorPalette.warning,
      );
      expect(
        AppColorPalette.warningColor(Brightness.dark),
        AppColorPalette.warningLight,
      );
    });

    test('errorColor returns correct color for brightness', () {
      expect(
        AppColorPalette.errorColor(Brightness.light),
        AppColorPalette.error,
      );
      expect(
        AppColorPalette.errorColor(Brightness.dark),
        AppColorPalette.errorLight,
      );
    });

    test('infoColor returns correct color for brightness', () {
      expect(
        AppColorPalette.infoColor(Brightness.light),
        AppColorPalette.info,
      );
      expect(
        AppColorPalette.infoColor(Brightness.dark),
        AppColorPalette.infoLight,
      );
    });
  });
}
