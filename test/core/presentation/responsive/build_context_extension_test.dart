import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/core/presentation/responsive/build_context_extension.dart';
import 'package:starter_app/core/presentation/responsive/screen_size.dart';

void main() {
  Future<void> pumpWidgetWithSize(
    WidgetTester tester,
    Size size,
    Widget Function(BuildContext) builder,
  ) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(builder: builder),
        ),
      ),
    );
  }

  group('ResponsiveContext extension', () {
    group('screenSizeFromWidth', () {
      testWidgets('should return compact for small screens', (tester) async {
        ScreenSize? detectedSize;

        await pumpWidgetWithSize(
          tester,
          const Size(400, 800),
          (context) {
            detectedSize = context.screenSizeFromWidth;
            return const SizedBox();
          },
        );

        expect(detectedSize, ScreenSize.compact);
      });

      testWidgets('should return medium for medium screens', (tester) async {
        ScreenSize? detectedSize;

        await pumpWidgetWithSize(
          tester,
          const Size(700, 1000),
          (context) {
            detectedSize = context.screenSizeFromWidth;
            return const SizedBox();
          },
        );

        expect(detectedSize, ScreenSize.medium);
      });

      testWidgets('should return expanded for expanded screens', (
        tester,
      ) async {
        ScreenSize? detectedSize;

        await pumpWidgetWithSize(
          tester,
          const Size(1000, 800),
          (context) {
            detectedSize = context.screenSizeFromWidth;
            return const SizedBox();
          },
        );

        expect(detectedSize, ScreenSize.expanded);
      });

      testWidgets('should return large for large screens', (tester) async {
        ScreenSize? detectedSize;

        await pumpWidgetWithSize(
          tester,
          const Size(1400, 900),
          (context) {
            detectedSize = context.screenSizeFromWidth;
            return const SizedBox();
          },
        );

        expect(detectedSize, ScreenSize.large);
      });

      testWidgets('should return extraLarge for extra large screens', (
        tester,
      ) async {
        ScreenSize? detectedSize;

        await pumpWidgetWithSize(
          tester,
          const Size(1800, 1000),
          (context) {
            detectedSize = context.screenSizeFromWidth;
            return const SizedBox();
          },
        );

        expect(detectedSize, ScreenSize.extraLarge);
      });
    });

    group('width and height', () {
      testWidgets('should return correct width', (tester) async {
        double? width;

        await pumpWidgetWithSize(
          tester,
          const Size(500, 800),
          (context) {
            width = context.width;
            return const SizedBox();
          },
        );

        expect(width, 500.0);
      });

      testWidgets('should return correct height', (tester) async {
        double? height;

        await pumpWidgetWithSize(
          tester,
          const Size(500, 800),
          (context) {
            height = context.height;
            return const SizedBox();
          },
        );

        expect(height, 800.0);
      });
    });

    group('isMobile', () {
      testWidgets('should be true for compact screens', (tester) async {
        bool? isMobile;

        await pumpWidgetWithSize(
          tester,
          const Size(400, 800),
          (context) {
            isMobile = context.isMobile;
            return const SizedBox();
          },
        );

        expect(isMobile, isTrue);
      });

      testWidgets('should be false for non-compact screens', (tester) async {
        bool? isMobile;

        await pumpWidgetWithSize(
          tester,
          const Size(700, 1000),
          (context) {
            isMobile = context.isMobile;
            return const SizedBox();
          },
        );

        expect(isMobile, isFalse);
      });
    });

    group('isTablet', () {
      testWidgets('should be true for medium screens', (tester) async {
        bool? isTablet;

        await pumpWidgetWithSize(
          tester,
          const Size(700, 1000),
          (context) {
            isTablet = context.isTablet;
            return const SizedBox();
          },
        );

        expect(isTablet, isTrue);
      });

      testWidgets('should be true for expanded screens', (tester) async {
        bool? isTablet;

        await pumpWidgetWithSize(
          tester,
          const Size(1000, 800),
          (context) {
            isTablet = context.isTablet;
            return const SizedBox();
          },
        );

        expect(isTablet, isTrue);
      });

      testWidgets('should be false for compact screens', (tester) async {
        bool? isTablet;

        await pumpWidgetWithSize(
          tester,
          const Size(400, 800),
          (context) {
            isTablet = context.isTablet;
            return const SizedBox();
          },
        );

        expect(isTablet, isFalse);
      });

      testWidgets('should be false for desktop screens', (tester) async {
        bool? isTablet;

        await pumpWidgetWithSize(
          tester,
          const Size(1400, 900),
          (context) {
            isTablet = context.isTablet;
            return const SizedBox();
          },
        );

        expect(isTablet, isFalse);
      });
    });

    group('isDesktop', () {
      testWidgets('should be true for large screens', (tester) async {
        bool? isDesktop;

        await pumpWidgetWithSize(
          tester,
          const Size(1400, 900),
          (context) {
            isDesktop = context.isDesktop;
            return const SizedBox();
          },
        );

        expect(isDesktop, isTrue);
      });

      testWidgets('should be true for extraLarge screens', (tester) async {
        bool? isDesktop;

        await pumpWidgetWithSize(
          tester,
          const Size(1800, 1000),
          (context) {
            isDesktop = context.isDesktop;
            return const SizedBox();
          },
        );

        expect(isDesktop, isTrue);
      });

      testWidgets('should be false for mobile screens', (tester) async {
        bool? isDesktop;

        await pumpWidgetWithSize(
          tester,
          const Size(400, 800),
          (context) {
            isDesktop = context.isDesktop;
            return const SizedBox();
          },
        );

        expect(isDesktop, isFalse);
      });

      testWidgets('should be false for tablet screens', (tester) async {
        bool? isDesktop;

        await pumpWidgetWithSize(
          tester,
          const Size(700, 1000),
          (context) {
            isDesktop = context.isDesktop;
            return const SizedBox();
          },
        );

        expect(isDesktop, isFalse);
      });
    });

    group('supportsTwoPane', () {
      testWidgets('should be true for expanded screens', (tester) async {
        bool? supportsTwoPane;

        await pumpWidgetWithSize(
          tester,
          const Size(1000, 800),
          (context) {
            supportsTwoPane = context.supportsTwoPane;
            return const SizedBox();
          },
        );

        expect(supportsTwoPane, isTrue);
      });

      testWidgets('should be true for large screens', (tester) async {
        bool? supportsTwoPane;

        await pumpWidgetWithSize(
          tester,
          const Size(1400, 900),
          (context) {
            supportsTwoPane = context.supportsTwoPane;
            return const SizedBox();
          },
        );

        expect(supportsTwoPane, isTrue);
      });

      testWidgets('should be true for extraLarge screens', (tester) async {
        bool? supportsTwoPane;

        await pumpWidgetWithSize(
          tester,
          const Size(1800, 1000),
          (context) {
            supportsTwoPane = context.supportsTwoPane;
            return const SizedBox();
          },
        );

        expect(supportsTwoPane, isTrue);
      });

      testWidgets('should be false for compact screens', (tester) async {
        bool? supportsTwoPane;

        await pumpWidgetWithSize(
          tester,
          const Size(400, 800),
          (context) {
            supportsTwoPane = context.supportsTwoPane;
            return const SizedBox();
          },
        );

        expect(supportsTwoPane, isFalse);
      });

      testWidgets('should be false for medium screens', (tester) async {
        bool? supportsTwoPane;

        await pumpWidgetWithSize(
          tester,
          const Size(700, 1000),
          (context) {
            supportsTwoPane = context.supportsTwoPane;
            return const SizedBox();
          },
        );

        expect(supportsTwoPane, isFalse);
      });
    });

    group('supportsThreePane', () {
      testWidgets('should be true for large screens', (tester) async {
        bool? supportsThreePane;

        await pumpWidgetWithSize(
          tester,
          const Size(1400, 900),
          (context) {
            supportsThreePane = context.supportsThreePane;
            return const SizedBox();
          },
        );

        expect(supportsThreePane, isTrue);
      });

      testWidgets('should be true for extraLarge screens', (tester) async {
        bool? supportsThreePane;

        await pumpWidgetWithSize(
          tester,
          const Size(1800, 1000),
          (context) {
            supportsThreePane = context.supportsThreePane;
            return const SizedBox();
          },
        );

        expect(supportsThreePane, isTrue);
      });

      testWidgets('should be false for compact screens', (tester) async {
        bool? supportsThreePane;

        await pumpWidgetWithSize(
          tester,
          const Size(400, 800),
          (context) {
            supportsThreePane = context.supportsThreePane;
            return const SizedBox();
          },
        );

        expect(supportsThreePane, isFalse);
      });

      testWidgets('should be false for medium screens', (tester) async {
        bool? supportsThreePane;

        await pumpWidgetWithSize(
          tester,
          const Size(700, 1000),
          (context) {
            supportsThreePane = context.supportsThreePane;
            return const SizedBox();
          },
        );

        expect(supportsThreePane, isFalse);
      });

      testWidgets('should be false for expanded screens', (tester) async {
        bool? supportsThreePane;

        await pumpWidgetWithSize(
          tester,
          const Size(1000, 800),
          (context) {
            supportsThreePane = context.supportsThreePane;
            return const SizedBox();
          },
        );

        expect(supportsThreePane, isFalse);
      });
    });

    group('responsivePadding', () {
      testWidgets('should return EdgeInsets.all(16) for compact', (
        tester,
      ) async {
        EdgeInsets? padding;

        await pumpWidgetWithSize(
          tester,
          const Size(400, 800),
          (context) {
            padding = context.responsivePadding;
            return const SizedBox();
          },
        );

        expect(padding, const EdgeInsets.all(16));
      });

      testWidgets('should return EdgeInsets.all(24) for medium', (
        tester,
      ) async {
        EdgeInsets? padding;

        await pumpWidgetWithSize(
          tester,
          const Size(700, 1000),
          (context) {
            padding = context.responsivePadding;
            return const SizedBox();
          },
        );

        expect(padding, const EdgeInsets.all(24));
      });

      testWidgets('should return EdgeInsets.all(24) for expanded', (
        tester,
      ) async {
        EdgeInsets? padding;

        await pumpWidgetWithSize(
          tester,
          const Size(1000, 800),
          (context) {
            padding = context.responsivePadding;
            return const SizedBox();
          },
        );

        expect(padding, const EdgeInsets.all(24));
      });

      testWidgets('should return EdgeInsets.all(32) for large', (
        tester,
      ) async {
        EdgeInsets? padding;

        await pumpWidgetWithSize(
          tester,
          const Size(1400, 900),
          (context) {
            padding = context.responsivePadding;
            return const SizedBox();
          },
        );

        expect(padding, const EdgeInsets.all(32));
      });

      testWidgets('should return EdgeInsets.all(32) for extraLarge', (
        tester,
      ) async {
        EdgeInsets? padding;

        await pumpWidgetWithSize(
          tester,
          const Size(1800, 1000),
          (context) {
            padding = context.responsivePadding;
            return const SizedBox();
          },
        );

        expect(padding, const EdgeInsets.all(32));
      });
    });

    group('responsivePaddingValue', () {
      testWidgets('should return 16.0 for compact', (tester) async {
        double? value;

        await pumpWidgetWithSize(
          tester,
          const Size(400, 800),
          (context) {
            value = context.responsivePaddingValue;
            return const SizedBox();
          },
        );

        expect(value, 16.0);
      });

      testWidgets('should return 24.0 for medium', (tester) async {
        double? value;

        await pumpWidgetWithSize(
          tester,
          const Size(700, 1000),
          (context) {
            value = context.responsivePaddingValue;
            return const SizedBox();
          },
        );

        expect(value, 24.0);
      });

      testWidgets('should return 24.0 for expanded', (tester) async {
        double? value;

        await pumpWidgetWithSize(
          tester,
          const Size(1000, 800),
          (context) {
            value = context.responsivePaddingValue;
            return const SizedBox();
          },
        );

        expect(value, 24.0);
      });

      testWidgets('should return 32.0 for large', (tester) async {
        double? value;

        await pumpWidgetWithSize(
          tester,
          const Size(1400, 900),
          (context) {
            value = context.responsivePaddingValue;
            return const SizedBox();
          },
        );

        expect(value, 32.0);
      });

      testWidgets('should return 32.0 for extraLarge', (tester) async {
        double? value;

        await pumpWidgetWithSize(
          tester,
          const Size(1800, 1000),
          (context) {
            value = context.responsivePaddingValue;
            return const SizedBox();
          },
        );

        expect(value, 32.0);
      });
    });

    group('responsiveSpacing', () {
      testWidgets('should return 8.0 for compact', (tester) async {
        double? spacing;

        await pumpWidgetWithSize(
          tester,
          const Size(400, 800),
          (context) {
            spacing = context.responsiveSpacing;
            return const SizedBox();
          },
        );

        expect(spacing, 8.0);
      });

      testWidgets('should return 12.0 for medium', (tester) async {
        double? spacing;

        await pumpWidgetWithSize(
          tester,
          const Size(700, 1000),
          (context) {
            spacing = context.responsiveSpacing;
            return const SizedBox();
          },
        );

        expect(spacing, 12.0);
      });

      testWidgets('should return 16.0 for expanded', (tester) async {
        double? spacing;

        await pumpWidgetWithSize(
          tester,
          const Size(1000, 800),
          (context) {
            spacing = context.responsiveSpacing;
            return const SizedBox();
          },
        );

        expect(spacing, 16.0);
      });

      testWidgets('should return 20.0 for large', (tester) async {
        double? spacing;

        await pumpWidgetWithSize(
          tester,
          const Size(1400, 900),
          (context) {
            spacing = context.responsiveSpacing;
            return const SizedBox();
          },
        );

        expect(spacing, 20.0);
      });

      testWidgets('should return 24.0 for extraLarge', (tester) async {
        double? spacing;

        await pumpWidgetWithSize(
          tester,
          const Size(1800, 1000),
          (context) {
            spacing = context.responsiveSpacing;
            return const SizedBox();
          },
        );

        expect(spacing, 24.0);
      });
    });

    group('responsiveHorizontalPadding', () {
      testWidgets('should return symmetric horizontal padding', (
        tester,
      ) async {
        EdgeInsets? padding;

        await pumpWidgetWithSize(
          tester,
          const Size(400, 800),
          (context) {
            padding = context.responsiveHorizontalPadding;
            return const SizedBox();
          },
        );

        expect(padding, const EdgeInsets.symmetric(horizontal: 16));
      });
    });

    group('responsiveVerticalPadding', () {
      testWidgets('should return symmetric vertical padding', (tester) async {
        EdgeInsets? padding;

        await pumpWidgetWithSize(
          tester,
          const Size(400, 800),
          (context) {
            padding = context.responsiveVerticalPadding;
            return const SizedBox();
          },
        );

        expect(padding, const EdgeInsets.symmetric(vertical: 16));
      });
    });

    group('responsiveMargin', () {
      testWidgets('should return EdgeInsets.all with responsive spacing', (
        tester,
      ) async {
        EdgeInsets? margin;

        await pumpWidgetWithSize(
          tester,
          const Size(400, 800),
          (context) {
            margin = context.responsiveMargin;
            return const SizedBox();
          },
        );

        expect(margin, const EdgeInsets.all(8));
      });
    });

    group('responsiveContentMaxWidth', () {
      testWidgets('should return null for compact', (tester) async {
        double? maxWidth;

        await pumpWidgetWithSize(
          tester,
          const Size(400, 800),
          (context) {
            maxWidth = context.responsiveContentMaxWidth;
            return const SizedBox();
          },
        );

        expect(maxWidth, isNull);
      });

      testWidgets('should return 840 for medium', (tester) async {
        double? maxWidth;

        await pumpWidgetWithSize(
          tester,
          const Size(700, 1000),
          (context) {
            maxWidth = context.responsiveContentMaxWidth;
            return const SizedBox();
          },
        );

        expect(maxWidth, 840.0);
      });

      testWidgets('should return 1200 for expanded', (tester) async {
        double? maxWidth;

        await pumpWidgetWithSize(
          tester,
          const Size(1000, 800),
          (context) {
            maxWidth = context.responsiveContentMaxWidth;
            return const SizedBox();
          },
        );

        expect(maxWidth, 1200.0);
      });

      testWidgets('should return 1400 for large', (tester) async {
        double? maxWidth;

        await pumpWidgetWithSize(
          tester,
          const Size(1400, 900),
          (context) {
            maxWidth = context.responsiveContentMaxWidth;
            return const SizedBox();
          },
        );

        expect(maxWidth, 1400.0);
      });

      testWidgets('should return 1600 for extraLarge', (tester) async {
        double? maxWidth;

        await pumpWidgetWithSize(
          tester,
          const Size(1800, 1000),
          (context) {
            maxWidth = context.responsiveContentMaxWidth;
            return const SizedBox();
          },
        );

        expect(maxWidth, 1600.0);
      });
    });

    group('responsiveGridColumns', () {
      testWidgets('should return 2 for compact', (tester) async {
        int? columns;

        await pumpWidgetWithSize(
          tester,
          const Size(400, 800),
          (context) {
            columns = context.responsiveGridColumns;
            return const SizedBox();
          },
        );

        expect(columns, 2);
      });

      testWidgets('should return 3 for medium', (tester) async {
        int? columns;

        await pumpWidgetWithSize(
          tester,
          const Size(700, 1000),
          (context) {
            columns = context.responsiveGridColumns;
            return const SizedBox();
          },
        );

        expect(columns, 3);
      });

      testWidgets('should return 4 for expanded', (tester) async {
        int? columns;

        await pumpWidgetWithSize(
          tester,
          const Size(1000, 800),
          (context) {
            columns = context.responsiveGridColumns;
            return const SizedBox();
          },
        );

        expect(columns, 4);
      });

      testWidgets('should return 5 for large', (tester) async {
        int? columns;

        await pumpWidgetWithSize(
          tester,
          const Size(1400, 900),
          (context) {
            columns = context.responsiveGridColumns;
            return const SizedBox();
          },
        );

        expect(columns, 5);
      });

      testWidgets('should return 6 for extraLarge', (tester) async {
        int? columns;

        await pumpWidgetWithSize(
          tester,
          const Size(1800, 1000),
          (context) {
            columns = context.responsiveGridColumns;
            return const SizedBox();
          },
        );

        expect(columns, 6);
      });
    });

    group('responsiveValue', () {
      testWidgets('should return mobile value for compact', (tester) async {
        String? value;

        await pumpWidgetWithSize(
          tester,
          const Size(400, 800),
          (context) {
            value = context.responsiveValue(
              mobile: 'mobile',
              tablet: 'tablet',
              desktop: 'desktop',
            );
            return const SizedBox();
          },
        );

        expect(value, 'mobile');
      });

      testWidgets('should return tablet value for medium', (tester) async {
        String? value;

        await pumpWidgetWithSize(
          tester,
          const Size(700, 1000),
          (context) {
            value = context.responsiveValue(
              mobile: 'mobile',
              tablet: 'tablet',
              desktop: 'desktop',
            );
            return const SizedBox();
          },
        );

        expect(value, 'tablet');
      });

      testWidgets('should return tablet value for expanded', (tester) async {
        String? value;

        await pumpWidgetWithSize(
          tester,
          const Size(1000, 800),
          (context) {
            value = context.responsiveValue(
              mobile: 'mobile',
              tablet: 'tablet',
              desktop: 'desktop',
            );
            return const SizedBox();
          },
        );

        expect(value, 'tablet');
      });

      testWidgets('should return desktop value for large', (tester) async {
        String? value;

        await pumpWidgetWithSize(
          tester,
          const Size(1400, 900),
          (context) {
            value = context.responsiveValue(
              mobile: 'mobile',
              tablet: 'tablet',
              desktop: 'desktop',
            );
            return const SizedBox();
          },
        );

        expect(value, 'desktop');
      });

      testWidgets('should return desktop value for extraLarge', (
        tester,
      ) async {
        String? value;

        await pumpWidgetWithSize(
          tester,
          const Size(1800, 1000),
          (context) {
            value = context.responsiveValue(
              mobile: 'mobile',
              tablet: 'tablet',
              desktop: 'desktop',
            );
            return const SizedBox();
          },
        );

        expect(value, 'desktop');
      });

      testWidgets('should fallback to mobile when tablet not provided', (
        tester,
      ) async {
        String? value;

        await pumpWidgetWithSize(
          tester,
          const Size(700, 1000),
          (context) {
            value = context.responsiveValue(
              mobile: 'mobile',
              desktop: 'desktop',
            );
            return const SizedBox();
          },
        );

        expect(value, 'mobile');
      });

      testWidgets('should fallback to tablet when desktop not provided', (
        tester,
      ) async {
        String? value;

        await pumpWidgetWithSize(
          tester,
          const Size(1400, 900),
          (context) {
            value = context.responsiveValue(
              mobile: 'mobile',
              tablet: 'tablet',
            );
            return const SizedBox();
          },
        );

        expect(value, 'tablet');
      });

      testWidgets('should fallback to mobile when both not provided', (
        tester,
      ) async {
        String? value;

        await pumpWidgetWithSize(
          tester,
          const Size(1400, 900),
          (context) {
            value = context.responsiveValue(mobile: 'mobile');
            return const SizedBox();
          },
        );

        expect(value, 'mobile');
      });
    });

    group('responsiveValueBySize', () {
      testWidgets('should return compact value for compact', (tester) async {
        String? value;

        await pumpWidgetWithSize(
          tester,
          const Size(400, 800),
          (context) {
            value = context.responsiveValueBySize(
              compact: 'compact',
              medium: 'medium',
              expanded: 'expanded',
              large: 'large',
              extraLarge: 'extraLarge',
            );
            return const SizedBox();
          },
        );

        expect(value, 'compact');
      });

      testWidgets('should return medium value for medium', (tester) async {
        String? value;

        await pumpWidgetWithSize(
          tester,
          const Size(700, 1000),
          (context) {
            value = context.responsiveValueBySize(
              compact: 'compact',
              medium: 'medium',
              expanded: 'expanded',
              large: 'large',
              extraLarge: 'extraLarge',
            );
            return const SizedBox();
          },
        );

        expect(value, 'medium');
      });

      testWidgets('should return expanded value for expanded', (tester) async {
        String? value;

        await pumpWidgetWithSize(
          tester,
          const Size(1000, 800),
          (context) {
            value = context.responsiveValueBySize(
              compact: 'compact',
              medium: 'medium',
              expanded: 'expanded',
              large: 'large',
              extraLarge: 'extraLarge',
            );
            return const SizedBox();
          },
        );

        expect(value, 'expanded');
      });

      testWidgets('should return large value for large', (tester) async {
        String? value;

        await pumpWidgetWithSize(
          tester,
          const Size(1400, 900),
          (context) {
            value = context.responsiveValueBySize(
              compact: 'compact',
              medium: 'medium',
              expanded: 'expanded',
              large: 'large',
              extraLarge: 'extraLarge',
            );
            return const SizedBox();
          },
        );

        expect(value, 'large');
      });

      testWidgets('should return extraLarge value for extraLarge', (
        tester,
      ) async {
        String? value;

        await pumpWidgetWithSize(
          tester,
          const Size(1800, 1000),
          (context) {
            value = context.responsiveValueBySize(
              compact: 'compact',
              medium: 'medium',
              expanded: 'expanded',
              large: 'large',
              extraLarge: 'extraLarge',
            );
            return const SizedBox();
          },
        );

        expect(value, 'extraLarge');
      });

      testWidgets('should fallback to compact when medium not provided', (
        tester,
      ) async {
        String? value;

        await pumpWidgetWithSize(
          tester,
          const Size(700, 1000),
          (context) {
            value = context.responsiveValueBySize(compact: 'compact');
            return const SizedBox();
          },
        );

        expect(value, 'compact');
      });

      testWidgets('should fallback through chain when values missing', (
        tester,
      ) async {
        String? value;

        await pumpWidgetWithSize(
          tester,
          const Size(1800, 1000),
          (context) {
            value = context.responsiveValueBySize(
              compact: 'compact',
              medium: 'medium',
            );
            return const SizedBox();
          },
        );

        expect(value, 'medium');
      });
    });
  });
}
