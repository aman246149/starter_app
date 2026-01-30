import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/core/presentation/responsive/adaptive_layout_builder.dart';
import 'package:starter_app/core/presentation/responsive/screen_size.dart';

void main() {
  // Helper to pump the widget with a specific size
  Future<void> pumpAdaptiveBuilder(
    WidgetTester tester,
    Size size,
    Widget Function(BuildContext, ScreenSize) builder,
  ) async {
    // Set the physical size and device pixel ratio to 1.0
    // so logical pixels == physical pixels
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AdaptiveLayoutBuilder(builder: builder),
        ),
      ),
    );
    // Advance past Sentry timer
    await tester.pump(const Duration(seconds: 4));
  }

  group('AdaptiveLayoutBuilder', () {
    testWidgets('should provide ScreenSize.compact for small screens', (
      tester,
    ) async {
      ScreenSize? detectedSize;

      await pumpAdaptiveBuilder(
        tester,
        const Size(400, 800), // Width 400 -> Compact
        (context, size) {
          detectedSize = size;
          return const SizedBox();
        },
      );

      expect(detectedSize, ScreenSize.compact);
    });

    testWidgets('should provide ScreenSize.medium for medium screens', (
      tester,
    ) async {
      ScreenSize? detectedSize;

      await pumpAdaptiveBuilder(
        tester,
        const Size(700, 1000), // Width 700 -> Medium
        (context, size) {
          detectedSize = size;
          return const SizedBox();
        },
      );

      expect(detectedSize, ScreenSize.medium);
    });

    testWidgets('should provide ScreenSize.expanded for expanded screens', (
      tester,
    ) async {
      ScreenSize? detectedSize;

      await pumpAdaptiveBuilder(
        tester,
        const Size(1000, 800), // Width 1000 -> Expanded
        (context, size) {
          detectedSize = size;
          return const SizedBox();
        },
      );

      expect(detectedSize, ScreenSize.expanded);
    });

    testWidgets('should provide ScreenSize.large for large screens', (
      tester,
    ) async {
      ScreenSize? detectedSize;

      await pumpAdaptiveBuilder(
        tester,
        const Size(1400, 900), // Width 1400 -> Large
        (context, size) {
          detectedSize = size;
          return const SizedBox();
        },
      );

      expect(detectedSize, ScreenSize.large);
    });

    testWidgets('should rebuild when screen size changes', (tester) async {
      ScreenSize? detectedSize;

      // Start with compact
      await pumpAdaptiveBuilder(
        tester,
        const Size(400, 800),
        (context, size) {
          detectedSize = size;
          return Text(size.toString());
        },
      );

      expect(detectedSize, ScreenSize.compact);
      expect(find.text(ScreenSize.compact.toString()), findsOneWidget);

      // Resize to desktop
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;
      await tester.pumpAndSettle();

      expect(detectedSize, ScreenSize.large);
      expect(find.text(ScreenSize.large.toString()), findsOneWidget);
    });

    testWidgets(
      'should provide ScreenSize.extraLarge for extra large screens',
      (tester) async {
        ScreenSize? detectedSize;

        await pumpAdaptiveBuilder(
          tester,
          const Size(1800, 1000), // Width 1800 -> Extra Large
          (context, size) {
            detectedSize = size;
            return const SizedBox();
          },
        );

        expect(detectedSize, ScreenSize.extraLarge);
      },
    );

    test('debugFillProperties should include builder', () {
      Widget builder(BuildContext context, ScreenSize screenSize) {
        return const SizedBox();
      }

      final widget = AdaptiveLayoutBuilder(builder: builder);
      final properties = DiagnosticPropertiesBuilder();

      widget.debugFillProperties(properties);

      // Verify that properties were added
      expect(properties.properties, isNotEmpty);
    });
  });
}
