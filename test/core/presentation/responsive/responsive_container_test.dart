import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/core/presentation/responsive/adaptive_layout_builder.dart';
import 'package:starter_app/core/presentation/responsive/responsive_container.dart';

void main() {
  Future<void> pumpResponsiveContainer(
    WidgetTester tester,
    Size size, {
    double? maxWidth,
    bool centerOnLarge = true,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ResponsiveContainer(
            maxWidth: maxWidth,
            centerOnLarge: centerOnLarge,
            child: const SizedBox(width: double.infinity, height: 100),
          ),
        ),
      ),
    );
  }

  group('ResponsiveContainer', () {
    testWidgets('should not constrain width on mobile screens', (tester) async {
      await pumpResponsiveContainer(
        tester,
        const Size(400, 800), // Mobile
        maxWidth: 1200,
      );

      final box = tester.renderObject<RenderBox>(find.byType(SizedBox));
      expect(box.size.width, equals(400.0)); // Full width
      expect(find.byType(Center), findsNothing); // Not centered
    });

    testWidgets('should constrain width and center on large screens', (
      tester,
    ) async {
      const maxWidth = 800.0;
      const screenWidth = 1400.0;

      await pumpResponsiveContainer(
        tester,
        const Size(screenWidth, 900), // Large
        maxWidth: maxWidth,
      );

      // Should find a ConstrainedBox with correct constraint
      final constrainedBox = tester.widget<ConstrainedBox>(
        find.descendant(
          of: find.byType(Center),
          matching: find.byType(ConstrainedBox),
        ),
      );
      expect(constrainedBox.constraints.maxWidth, equals(maxWidth));

      // Should be centered
      expect(find.byType(Center), findsOneWidget);
    });

    testWidgets('should not constrain if centerOnLarge is false', (
      tester,
    ) async {
      await pumpResponsiveContainer(
        tester,
        const Size(1400, 900), // Large
        maxWidth: 800,
        centerOnLarge: false,
      );

      final box = tester.renderObject<RenderBox>(find.byType(SizedBox));
      expect(box.size.width, equals(1400.0)); // Full width
      expect(find.byType(Center), findsNothing);
    });

    testWidgets('should return child directly if maxWidth is null', (
      tester,
    ) async {
      await pumpResponsiveContainer(
        tester,
        const Size(1400, 900),
      );

      expect(find.byType(AdaptiveLayoutBuilder), findsNothing);
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('should not constrain on tablet when centerOnLarge is false', (
      tester,
    ) async {
      await pumpResponsiveContainer(
        tester,
        const Size(1000, 800), // Expanded
        maxWidth: 800,
        centerOnLarge: false,
      );

      final box = tester.renderObject<RenderBox>(find.byType(SizedBox));
      expect(box.size.width, equals(1000.0)); // Full width
      expect(find.byType(Center), findsNothing);
    });

    testWidgets(
      'should not constrain on expanded when centerOnLarge is false',
      (tester) async {
        await pumpResponsiveContainer(
          tester,
          const Size(1000, 800), // Expanded
          maxWidth: 800,
          centerOnLarge: false,
        );

        final box = tester.renderObject<RenderBox>(find.byType(SizedBox));
        expect(box.size.width, equals(1000.0)); // Full width
        expect(find.byType(Center), findsNothing);
      },
    );
  });

  group('ResponsivePadding', () {
    Future<void> pumpResponsivePadding(
      WidgetTester tester,
      Size size, {
      EdgeInsets? mobilePadding,
      EdgeInsets? tabletPadding,
      EdgeInsets? desktopPadding,
    }) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsivePadding(
              mobilePadding: mobilePadding,
              tabletPadding: tabletPadding,
              desktopPadding: desktopPadding,
              child: const SizedBox(width: 100, height: 100),
            ),
          ),
        ),
      );
    }

    testWidgets('should apply default mobile padding on compact screens', (
      tester,
    ) async {
      await pumpResponsivePadding(tester, const Size(400, 800));

      final padding = tester.widget<Padding>(find.byType(Padding));
      expect(padding.padding, equals(const EdgeInsets.all(16)));
    });

    testWidgets('should apply default tablet padding on medium screens', (
      tester,
    ) async {
      await pumpResponsivePadding(tester, const Size(700, 1000));

      final padding = tester.widget<Padding>(find.byType(Padding));
      expect(padding.padding, equals(const EdgeInsets.all(24)));
    });

    testWidgets('should apply default tablet padding on expanded screens', (
      tester,
    ) async {
      await pumpResponsivePadding(tester, const Size(1000, 800));

      final padding = tester.widget<Padding>(find.byType(Padding));
      expect(padding.padding, equals(const EdgeInsets.all(24)));
    });

    testWidgets('should apply default desktop padding on large screens', (
      tester,
    ) async {
      await pumpResponsivePadding(tester, const Size(1400, 900));

      final padding = tester.widget<Padding>(find.byType(Padding));
      expect(padding.padding, equals(const EdgeInsets.all(32)));
    });

    testWidgets('should apply default desktop padding on extraLarge screens', (
      tester,
    ) async {
      await pumpResponsivePadding(tester, const Size(1800, 1000));

      final padding = tester.widget<Padding>(find.byType(Padding));
      expect(padding.padding, equals(const EdgeInsets.all(32)));
    });

    testWidgets('should use custom mobile padding when provided', (
      tester,
    ) async {
      await pumpResponsivePadding(
        tester,
        const Size(400, 800),
        mobilePadding: const EdgeInsets.all(20),
      );

      final padding = tester.widget<Padding>(find.byType(Padding));
      expect(padding.padding, equals(const EdgeInsets.all(20)));
    });

    testWidgets('should use custom tablet padding when provided', (
      tester,
    ) async {
      await pumpResponsivePadding(
        tester,
        const Size(700, 1000),
        tabletPadding: const EdgeInsets.all(30),
      );

      final padding = tester.widget<Padding>(find.byType(Padding));
      expect(padding.padding, equals(const EdgeInsets.all(30)));
    });

    testWidgets('should use custom desktop padding when provided', (
      tester,
    ) async {
      await pumpResponsivePadding(
        tester,
        const Size(1400, 900),
        desktopPadding: const EdgeInsets.all(40),
      );

      final padding = tester.widget<Padding>(find.byType(Padding));
      expect(padding.padding, equals(const EdgeInsets.all(40)));
    });
  });
}
