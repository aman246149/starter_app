import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/core/presentation/responsive/responsive.dart';

// ignore_for_file: prefer_const_constructors -
//to be able to test the constructors

void main() {
  Future<void> pumpWidgetWithSize(
    WidgetTester tester,
    Size size,
    Widget child,
  ) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: child),
      ),
    );
    // Advance past Sentry timer
    await tester.pump(const Duration(seconds: 4));
  }

  group('ResponsivePadding', () {
    testWidgets('should apply mobile padding on compact screens', (
      tester,
    ) async {
      await pumpWidgetWithSize(
        tester,
        const Size(400, 800),
        const ResponsivePadding(child: SizedBox()),
      );

      final padding = tester.widget<Padding>(find.byType(Padding));
      expect(padding.padding, equals(const EdgeInsets.all(16)));
    });

    testWidgets('should apply tablet padding on medium screens', (
      tester,
    ) async {
      await pumpWidgetWithSize(
        tester,
        const Size(700, 1000),
        const ResponsivePadding(child: SizedBox()),
      );

      final padding = tester.widget<Padding>(find.byType(Padding));
      expect(padding.padding, equals(const EdgeInsets.all(24)));
    });

    testWidgets('should apply tablet padding on expanded screens', (
      tester,
    ) async {
      await pumpWidgetWithSize(
        tester,
        const Size(1000, 800),
        const ResponsivePadding(child: SizedBox()),
      );

      final padding = tester.widget<Padding>(find.byType(Padding));
      expect(padding.padding, equals(const EdgeInsets.all(24)));
    });

    testWidgets('should apply desktop padding on large screens', (
      tester,
    ) async {
      await pumpWidgetWithSize(
        tester,
        const Size(1400, 900),
        const ResponsivePadding(child: SizedBox()),
      );

      final padding = tester.widget<Padding>(find.byType(Padding));
      expect(padding.padding, equals(const EdgeInsets.all(32)));
    });

    testWidgets('should apply desktop padding on extraLarge screens', (
      tester,
    ) async {
      await pumpWidgetWithSize(
        tester,
        const Size(1800, 1000),
        const ResponsivePadding(child: SizedBox()),
      );

      final padding = tester.widget<Padding>(find.byType(Padding));
      expect(padding.padding, equals(const EdgeInsets.all(32)));
    });

    testWidgets('should use custom mobile padding when provided', (
      tester,
    ) async {
      await pumpWidgetWithSize(
        tester,
        const Size(400, 800),
        const ResponsivePadding(
          mobilePadding: EdgeInsets.all(20),
          child: SizedBox(),
        ),
      );

      final padding = tester.widget<Padding>(find.byType(Padding));
      expect(padding.padding, equals(const EdgeInsets.all(20)));
    });

    testWidgets('should use custom tablet padding when provided', (
      tester,
    ) async {
      await pumpWidgetWithSize(
        tester,
        const Size(700, 1000),
        const ResponsivePadding(
          tabletPadding: EdgeInsets.all(30),
          child: SizedBox(),
        ),
      );

      final padding = tester.widget<Padding>(find.byType(Padding));
      expect(padding.padding, equals(const EdgeInsets.all(30)));
    });

    testWidgets('should use custom desktop padding when provided', (
      tester,
    ) async {
      await pumpWidgetWithSize(
        tester,
        const Size(1400, 900),
        const ResponsivePadding(
          desktopPadding: EdgeInsets.all(40),
          child: SizedBox(),
        ),
      );

      final padding = tester.widget<Padding>(find.byType(Padding));
      expect(padding.padding, equals(const EdgeInsets.all(40)));
    });
  });

  group('ResponsiveGrid', () {
    testWidgets('should show 2 columns on compact screens', (tester) async {
      await pumpWidgetWithSize(
        tester,
        const Size(400, 800),
        ResponsiveGrid.builder(
          itemCount: 4,
          itemBuilder: (context, index) => const SizedBox(),
        ),
      );

      final grid = tester.widget<GridView>(find.byType(GridView));
      final delegate =
          grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, 2);
    });

    testWidgets('should show 3 columns on medium screens', (tester) async {
      await pumpWidgetWithSize(
        tester,
        const Size(700, 1000),
        ResponsiveGrid.builder(
          itemCount: 4,
          itemBuilder: (context, index) => const SizedBox(),
        ),
      );

      final grid = tester.widget<GridView>(find.byType(GridView));
      final delegate =
          grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, 3);
    });

    testWidgets('should show 4 columns on expanded screens', (tester) async {
      await pumpWidgetWithSize(
        tester,
        const Size(1000, 800),
        ResponsiveGrid.builder(
          itemCount: 8,
          itemBuilder: (context, index) => const SizedBox(),
        ),
      );

      final grid = tester.widget<GridView>(find.byType(GridView));
      final delegate =
          grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, 4);
    });

    testWidgets('should show 5 columns on large screens', (tester) async {
      await pumpWidgetWithSize(
        tester,
        const Size(1400, 900),
        ResponsiveGrid.builder(
          itemCount: 6,
          itemBuilder: (context, index) => const SizedBox(),
        ),
      );

      final grid = tester.widget<GridView>(find.byType(GridView));
      final delegate =
          grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, 5);
    });

    testWidgets('should show 6 columns on extraLarge screens', (tester) async {
      await pumpWidgetWithSize(
        tester,
        const Size(1800, 1000),
        ResponsiveGrid.builder(
          itemCount: 12,
          itemBuilder: (context, index) => const SizedBox(),
        ),
      );

      final grid = tester.widget<GridView>(find.byType(GridView));
      final delegate =
          grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, 6);
    });
  });

  group('ResponsiveSpacing', () {
    test('should create ResponsiveSpacing with required child', () {
      final widget = ResponsiveSpacing(child: SizedBox());
      expect(widget.child, isA<SizedBox>());
    });

    test('should create ResponsiveSpacing without const', () {
      const widget = ResponsiveSpacing(child: SizedBox());
      expect(widget.child, isA<SizedBox>());
    });

    testWidgets('should apply responsive padding on compact screens', (
      tester,
    ) async {
      await pumpWidgetWithSize(
        tester,
        const Size(400, 800),
        const ResponsiveSpacing(child: SizedBox()),
      );

      final padding = tester.widget<Padding>(find.byType(Padding));
      expect(padding.padding, equals(const EdgeInsets.all(16)));
    });

    testWidgets('should apply responsive padding on medium screens', (
      tester,
    ) async {
      await pumpWidgetWithSize(
        tester,
        const Size(700, 1000),
        const ResponsiveSpacing(child: SizedBox()),
      );

      final padding = tester.widget<Padding>(find.byType(Padding));
      expect(padding.padding, equals(const EdgeInsets.all(24)));
    });

    testWidgets('should apply responsive padding on large screens', (
      tester,
    ) async {
      await pumpWidgetWithSize(
        tester,
        const Size(1400, 900),
        const ResponsiveSpacing(child: SizedBox()),
      );

      final padding = tester.widget<Padding>(find.byType(Padding));
      expect(padding.padding, equals(const EdgeInsets.all(32)));
    });
  });

  group('ResponsiveGap', () {
    test('should create ResponsiveGap with all optional parameters', () {
      const widget = ResponsiveGap(
        mobileSize: 10,
        tabletSize: 15,
        desktopSize: 20,
      );
      expect(widget.mobileSize, 10.0);
      expect(widget.tabletSize, 15.0);
      expect(widget.desktopSize, 20.0);
    });

    test('should create ResponsiveGap with no parameters', () {
      const widget = ResponsiveGap();
      expect(widget.mobileSize, isNull);
      expect(widget.tabletSize, isNull);
      expect(widget.desktopSize, isNull);
    });

    testWidgets('should use default mobile size', (tester) async {
      await pumpWidgetWithSize(
        tester,
        const Size(400, 800),
        const Column(children: [ResponsiveGap()]),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, 8.0);
      expect(sizedBox.height, 8.0);
    });

    testWidgets('should use custom mobile size', (tester) async {
      await pumpWidgetWithSize(
        tester,
        const Size(400, 800),
        const Column(children: [ResponsiveGap(mobileSize: 20)]),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, 20.0);
      expect(sizedBox.height, 20.0);
    });

    testWidgets('should use responsive spacing for tablet when not specified', (
      tester,
    ) async {
      await pumpWidgetWithSize(
        tester,
        const Size(700, 1000),
        const Column(children: [ResponsiveGap()]),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      // Should use responsiveSpacing (12.0 for medium)
      expect(sizedBox.width, 12.0);
      expect(sizedBox.height, 12.0);
    });

    testWidgets('should use custom tablet size', (tester) async {
      await pumpWidgetWithSize(
        tester,
        const Size(700, 1000),
        const Column(children: [ResponsiveGap(tabletSize: 18)]),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, 18.0);
      expect(sizedBox.height, 18.0);
    });

    testWidgets(
      'should use responsive spacing for desktop when not specified',
      (tester) async {
        await pumpWidgetWithSize(
          tester,
          const Size(1400, 900),
          const Column(children: [ResponsiveGap()]),
        );

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
        // Should use responsiveSpacing (20.0 for large)
        expect(sizedBox.width, 20.0);
        expect(sizedBox.height, 20.0);
      },
    );

    testWidgets('should use custom desktop size', (tester) async {
      await pumpWidgetWithSize(
        tester,
        const Size(1400, 900),
        const Column(children: [ResponsiveGap(desktopSize: 30)]),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, 30.0);
      expect(sizedBox.height, 30.0);
    });
  });

  group('ResponsiveVerticalGap', () {
    test('should create ResponsiveVerticalGap with height', () {
      const widget = ResponsiveVerticalGap(height: 25);
      expect(widget.height, 25.0);
    });

    test('should create ResponsiveVerticalGap without height', () {
      const widget = ResponsiveVerticalGap();
      expect(widget.height, isNull);
    });

    testWidgets('should use responsive spacing when height not specified', (
      tester,
    ) async {
      await pumpWidgetWithSize(
        tester,
        const Size(400, 800),
        const Column(children: [ResponsiveVerticalGap()]),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, isNull);
      expect(sizedBox.height, 8.0); // responsiveSpacing for compact
    });

    testWidgets('should use custom height when specified', (tester) async {
      await pumpWidgetWithSize(
        tester,
        const Size(400, 800),
        const Column(children: [ResponsiveVerticalGap(height: 25)]),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, isNull);
      expect(sizedBox.height, 25.0);
    });

    testWidgets('should use responsive spacing for tablet', (tester) async {
      await pumpWidgetWithSize(
        tester,
        const Size(700, 1000),
        const Column(children: [ResponsiveVerticalGap()]),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.height, 12.0); // responsiveSpacing for medium
    });

    testWidgets('should use responsive spacing for desktop', (tester) async {
      await pumpWidgetWithSize(
        tester,
        const Size(1400, 900),
        const Column(children: [ResponsiveVerticalGap()]),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.height, 20.0); // responsiveSpacing for large
    });
  });

  group('ResponsiveHorizontalGap', () {
    test('should create ResponsiveHorizontalGap with width', () {
      final widget = ResponsiveHorizontalGap(width: 25);
      expect(widget.width, 25.0);
    });

    test('should create ResponsiveHorizontalGap without width', () {
      const widget = ResponsiveHorizontalGap();
      expect(widget.width, isNull);
    });

    test('should create ResponsiveHorizontalGap without const', () {
      const widget = ResponsiveHorizontalGap(width: 25);
      expect(widget.width, 25.0);
    });

    testWidgets('should use responsive spacing when width not specified', (
      tester,
    ) async {
      await pumpWidgetWithSize(
        tester,
        const Size(400, 800),
        const Row(children: [ResponsiveHorizontalGap()]),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, 8.0); // responsiveSpacing for compact
      expect(sizedBox.height, isNull);
    });

    testWidgets('should use custom width when specified', (tester) async {
      await pumpWidgetWithSize(
        tester,
        const Size(400, 800),
        const Row(children: [ResponsiveHorizontalGap(width: 25)]),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, 25.0);
      expect(sizedBox.height, isNull);
    });

    testWidgets('should use responsive spacing for tablet', (tester) async {
      await pumpWidgetWithSize(
        tester,
        const Size(700, 1000),
        const Row(children: [ResponsiveHorizontalGap()]),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, 12.0); // responsiveSpacing for medium
    });

    testWidgets('should use responsive spacing for desktop', (tester) async {
      await pumpWidgetWithSize(
        tester,
        const Size(1400, 900),
        const Row(children: [ResponsiveHorizontalGap()]),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, 20.0); // responsiveSpacing for large
    });
  });
}
