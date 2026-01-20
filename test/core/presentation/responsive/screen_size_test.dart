import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/core/presentation/responsive/screen_size.dart';

void main() {
  group('ScreenSize', () {
    group('fromWidth', () {
      test('should return compact for width <= 599', () {
        expect(ScreenSize.fromWidth(0), ScreenSize.compact);
        expect(ScreenSize.fromWidth(300), ScreenSize.compact);
        expect(ScreenSize.fromWidth(599), ScreenSize.compact);
      });

      test('should return medium for 600 <= width <= 839', () {
        expect(ScreenSize.fromWidth(600), ScreenSize.medium);
        expect(ScreenSize.fromWidth(700), ScreenSize.medium);
        expect(ScreenSize.fromWidth(839), ScreenSize.medium);
      });

      test('should return expanded for 840 <= width <= 1199', () {
        expect(ScreenSize.fromWidth(840), ScreenSize.expanded);
        expect(ScreenSize.fromWidth(1000), ScreenSize.expanded);
        expect(ScreenSize.fromWidth(1199), ScreenSize.expanded);
      });

      test('should return large for 1200 <= width <= 1599', () {
        expect(ScreenSize.fromWidth(1200), ScreenSize.large);
        expect(ScreenSize.fromWidth(1400), ScreenSize.large);
        expect(ScreenSize.fromWidth(1599), ScreenSize.large);
      });

      test('should return extraLarge for width >= 1600', () {
        expect(ScreenSize.fromWidth(1600), ScreenSize.extraLarge);
        expect(ScreenSize.fromWidth(2000), ScreenSize.extraLarge);
      });
    });

    group('helper getters', () {
      test('isMobile should only be true for compact', () {
        expect(ScreenSize.compact.isMobile, isTrue);
        expect(ScreenSize.medium.isMobile, isFalse);
        expect(ScreenSize.expanded.isMobile, isFalse);
        expect(ScreenSize.large.isMobile, isFalse);
        expect(ScreenSize.extraLarge.isMobile, isFalse);
      });

      test('isTablet should be true for medium and expanded', () {
        expect(ScreenSize.compact.isTablet, isFalse);
        expect(ScreenSize.medium.isTablet, isTrue);
        expect(ScreenSize.expanded.isTablet, isTrue);
        expect(ScreenSize.large.isTablet, isFalse);
        expect(ScreenSize.extraLarge.isTablet, isFalse);
      });

      test('isDesktop should be true for large and extraLarge', () {
        expect(ScreenSize.compact.isDesktop, isFalse);
        expect(ScreenSize.medium.isDesktop, isFalse);
        expect(ScreenSize.expanded.isDesktop, isFalse);
        expect(ScreenSize.large.isDesktop, isTrue);
        expect(ScreenSize.extraLarge.isDesktop, isTrue);
      });

      test('supportsTwoPane should be true for expanded and up', () {
        expect(ScreenSize.compact.supportsTwoPane, isFalse);
        expect(ScreenSize.medium.supportsTwoPane, isFalse);
        expect(ScreenSize.expanded.supportsTwoPane, isTrue);
        expect(ScreenSize.large.supportsTwoPane, isTrue);
        expect(ScreenSize.extraLarge.supportsTwoPane, isTrue);
      });

      test('supportsThreePane should be true for large and up', () {
        expect(ScreenSize.compact.supportsThreePane, isFalse);
        expect(ScreenSize.medium.supportsThreePane, isFalse);
        expect(ScreenSize.expanded.supportsThreePane, isFalse);
        expect(ScreenSize.large.supportsThreePane, isTrue);
        expect(ScreenSize.extraLarge.supportsThreePane, isTrue);
      });
    });

    group('maxWidth', () {
      test('should return correct maxWidth for each screen size', () {
        expect(ScreenSize.compact.maxWidth, 599.0);
        expect(ScreenSize.medium.maxWidth, 839.0);
        expect(ScreenSize.expanded.maxWidth, 1199.0);
        expect(ScreenSize.large.maxWidth, 1599.0);
        expect(ScreenSize.extraLarge.maxWidth, isNull);
      });
    });

    group('minWidth', () {
      test('should return correct minWidth for each screen size', () {
        expect(ScreenSize.compact.minWidth, 0);
        expect(ScreenSize.medium.minWidth, 600.0);
        expect(ScreenSize.expanded.minWidth, 840.0);
        expect(ScreenSize.large.minWidth, 1200.0);
        expect(ScreenSize.extraLarge.minWidth, 1600.0);
      });
    });

    group('displayName', () {
      test('should return correct displayName for each screen size', () {
        expect(ScreenSize.compact.displayName, 'Compact (Phone)');
        expect(ScreenSize.medium.displayName, 'Medium (Tablet Portrait)');
        expect(ScreenSize.expanded.displayName, 'Expanded (Tablet Landscape)');
        expect(ScreenSize.large.displayName, 'Large (Desktop)');
        expect(ScreenSize.extraLarge.displayName, 'Extra Large (Wide Desktop)');
      });
    });
  });
}
