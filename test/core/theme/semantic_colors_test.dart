import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/core/theme/theme_extensions.dart';

void main() {
  group('SemanticColors', () {
    test('light factory creates correct instance', () {
      final colors = SemanticColors.light();
      expect(colors.success, isA<Color>());
      expect(colors.warning, isA<Color>());
      expect(colors.info, isA<Color>());
    });

    test('dark factory creates correct instance', () {
      final colors = SemanticColors.dark();
      expect(colors.success, isA<Color>());
      expect(colors.warning, isA<Color>());
      expect(colors.info, isA<Color>());
    });

    test('copyWith creates new instance with updated values', () {
      final original = SemanticColors.light();
      final updated = original.copyWith(
        success: Colors.red,
        warning: Colors.blue,
      );

      expect(updated.success, Colors.red);
      expect(updated.warning, Colors.blue);
      expect(updated.info, original.info);
    });

    test('copyWith with all parameters', () {
      final original = SemanticColors.light();
      final updated = original.copyWith(
        success: Colors.red,
        warning: Colors.orange,
        info: Colors.blue,
        successContainer: Colors.green,
        warningContainer: Colors.yellow,
        infoContainer: Colors.cyan,
        onSuccess: Colors.white,
        onWarning: Colors.black,
        onInfo: Colors.white,
      );

      expect(updated.success, Colors.red);
      expect(updated.warning, Colors.orange);
      expect(updated.info, Colors.blue);
      expect(updated.successContainer, Colors.green);
      expect(updated.warningContainer, Colors.yellow);
      expect(updated.infoContainer, Colors.cyan);
      expect(updated.onSuccess, Colors.white);
      expect(updated.onWarning, Colors.black);
      expect(updated.onInfo, Colors.white);
    });

    test('copyWith with null parameters preserves original values', () {
      final original = SemanticColors.light();
      final updated = original.copyWith();

      expect(updated.success, original.success);
      expect(updated.warning, original.warning);
      expect(updated.info, original.info);
      expect(updated.successContainer, original.successContainer);
      expect(updated.warningContainer, original.warningContainer);
      expect(updated.infoContainer, original.infoContainer);
      expect(updated.onSuccess, original.onSuccess);
      expect(updated.onWarning, original.onWarning);
      expect(updated.onInfo, original.onInfo);
    });

    test('lerp interpolates between two instances', () {
      final start = SemanticColors.light().copyWith(
        success: const Color(0xFF000000),
      );
      final end = SemanticColors.light().copyWith(
        success: const Color(0xFFFFFFFF),
      );

      final middle = start.lerp(end, 0.5);

      // 0 to 255 at 0.5 is 127.5, rounded to 128 usually
      expect((middle.success.r * 255.0).round().clamp(0, 255), 128);
    });

    test('lerp returns this if other is null', () {
      final colors = SemanticColors.light();
      expect(colors.lerp(null, 0.5), colors);
    });
  });
}
