import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/core/logging/i_app_logger.dart';
import 'package:starter_app/core/presentation/widgets/adaptive_navigation_scaffold.dart';

import '../../helpers/mock_helpers.dart';
import '../../helpers/pump_app.dart';

/// A fake implementation of StatefulNavigationShell for testing.
///
/// This extends Fake to provide noSuchMethod for unimplemented members,
/// and properly implements the Widget interface so it can be rendered.
class FakeStatefulNavigationShell extends Fake
    implements StatefulNavigationShell {
  FakeStatefulNavigationShell({
    required this.currentIndex,
    this.onGoBranch,
  });

  @override
  final int currentIndex;

  /// Callback invoked when goBranch is called.
  final void Function(int index, {bool initialLocation})? onGoBranch;

  @override
  void goBranch(int index, {bool initialLocation = false}) {
    onGoBranch?.call(index, initialLocation: initialLocation);
  }

  // Provide a working createElement so this can be rendered as a Widget
  @override
  StatefulElement createElement() => _FakeStatefulElement(this);

  @override
  State<StatefulWidget> createState() => _FakeState();

  @override
  Key? get key => null;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      'FakeStatefulNavigationShell';
}

class _FakeStatefulElement extends StatefulElement {
  _FakeStatefulElement(super.widget);
}

class _FakeState extends State<FakeStatefulNavigationShell> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

void main() {
  group('AdaptiveNavigationScaffold', () {
    late MockAppLogger mockLogger;
    late int capturedBranchIndex;
    late bool goBranchCalled;

    FakeStatefulNavigationShell createFakeShell({int currentIndex = 0}) {
      return FakeStatefulNavigationShell(
        currentIndex: currentIndex,
        onGoBranch: (index, {initialLocation = false}) {
          goBranchCalled = true;
          capturedBranchIndex = index;
        },
      );
    }

    setUp(() async {
      mockLogger = MockAppLogger();
      capturedBranchIndex = -1;
      goBranchCalled = false;

      await GetIt.I.reset();
      GetIt.I.registerSingleton<IAppLogger>(mockLogger);
    });

    tearDown(() async {
      await GetIt.I.reset();
    });

    testWidgets('renders without errors', (tester) async {
      await tester.pumpApp(
        AdaptiveNavigationScaffold(
          navigationShell: createFakeShell(),
          logger: mockLogger,
        ),
      );
      expect(find.byType(AdaptiveNavigationScaffold), findsOneWidget);
    });

    testWidgets('renders compact layout for small screens', (tester) async {
      // Set compact screen size (< 600px)
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpApp(
        AdaptiveNavigationScaffold(
          navigationShell: createFakeShell(),
          logger: mockLogger,
        ),
      );
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(NavigationRail), findsNothing);
      expect(find.byType(NavigationDrawer), findsNothing);
    });

    testWidgets('renders medium layout for medium screens', (tester) async {
      // Set medium screen size (600-840px)
      tester.view.physicalSize = const Size(700, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpApp(
        AdaptiveNavigationScaffold(
          navigationShell: createFakeShell(),
          logger: mockLogger,
        ),
      );
      expect(find.byType(NavigationBar), findsNothing);
      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.byType(NavigationDrawer), findsNothing);
    });

    testWidgets('renders expanded layout for expanded screens', (tester) async {
      // Set expanded screen size (840-1200px)
      tester.view.physicalSize = const Size(1000, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpApp(
        AdaptiveNavigationScaffold(
          navigationShell: createFakeShell(),
          logger: mockLogger,
        ),
      );
      expect(find.byType(NavigationBar), findsNothing);
      expect(find.byType(NavigationRail), findsNothing);
      // Expanded layout uses a drawer in Scaffold (not rendered until opened)
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('renders large layout for large screens', (tester) async {
      // Set large screen size (> 1200px)
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpApp(
        AdaptiveNavigationScaffold(
          navigationShell: createFakeShell(),
          logger: mockLogger,
        ),
      );
      expect(find.byType(NavigationBar), findsNothing);
      expect(find.byType(NavigationRail), findsNothing);
      expect(find.byType(NavigationDrawer), findsOneWidget);
      expect(find.byType(AppBar), findsNothing); // No AppBar in large layout
    });

    testWidgets('calls goBranch when destination selected in compact layout', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpApp(
        AdaptiveNavigationScaffold(
          navigationShell: createFakeShell(),
          logger: mockLogger,
        ),
      );
      // Find and tap the second destination (index 1)
      final navigationBar = tester.widget<NavigationBar>(
        find.byType(NavigationBar),
      );
      navigationBar.onDestinationSelected!(1);
      await tester.pumpAndSettle();

      expect(goBranchCalled, isTrue);
      expect(capturedBranchIndex, equals(1));
    });

    testWidgets('calls goBranch when destination selected in medium layout', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(700, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpApp(
        AdaptiveNavigationScaffold(
          navigationShell: createFakeShell(),
          logger: mockLogger,
        ),
      );
      // Find NavigationRail and select destination
      final navigationRail = tester.widget<NavigationRail>(
        find.byType(NavigationRail),
      );
      navigationRail.onDestinationSelected!(2);
      await tester.pumpAndSettle();

      expect(goBranchCalled, isTrue);
      expect(capturedBranchIndex, equals(2));
    });

    testWidgets(
      'calls goBranch when destination selected in expanded layout drawer',
      (tester) async {
        tester.view.physicalSize = const Size(1000, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpApp(
          AdaptiveNavigationScaffold(
            navigationShell: createFakeShell(),
            logger: mockLogger,
          ),
        );
        // Open the drawer
        tester
            .state<ScaffoldState>(
              find.byType(Scaffold),
            )
            .openDrawer();
        await tester.pumpAndSettle();

        // Now the NavigationDrawer should be visible
        expect(find.byType(NavigationDrawer), findsOneWidget);

        // Find NavigationDrawer and select destination
        final navigationDrawer = tester.widget<NavigationDrawer>(
          find.byType(NavigationDrawer),
        );
        navigationDrawer.onDestinationSelected!(1);
        await tester.pumpAndSettle();

        expect(goBranchCalled, isTrue);
        expect(capturedBranchIndex, equals(1));
      },
    );

    testWidgets('calls goBranch when destination selected in large layout', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpApp(
        AdaptiveNavigationScaffold(
          navigationShell: createFakeShell(),
          logger: mockLogger,
        ),
      );
      // Find NavigationDrawer
      // (permanent in large layout) and select destination
      final navigationDrawer = tester.widget<NavigationDrawer>(
        find.byType(NavigationDrawer),
      );
      navigationDrawer.onDestinationSelected!(2);
      await tester.pumpAndSettle();

      expect(goBranchCalled, isTrue);
      expect(capturedBranchIndex, equals(2));
    });

    testWidgets('does not call goBranch when same destination selected', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpApp(
        AdaptiveNavigationScaffold(
          navigationShell: createFakeShell(),
          logger: mockLogger,
        ),
      );
      // Try to select the same destination (index 0)
      final navigationBar = tester.widget<NavigationBar>(
        find.byType(NavigationBar),
      );
      navigationBar.onDestinationSelected!(0);
      await tester.pumpAndSettle();

      // Should not call goBranch when same index is selected
      expect(goBranchCalled, isFalse);
    });

    testWidgets('logs tab switch when destination changes', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpApp(
        AdaptiveNavigationScaffold(
          navigationShell: createFakeShell(),
          logger: mockLogger,
        ),
      );
      // Select a different destination
      final navigationBar = tester.widget<NavigationBar>(
        find.byType(NavigationBar),
      );
      navigationBar.onDestinationSelected!(1);
      await tester.pumpAndSettle();

      // Verify logger was called
      verify(
        () => mockLogger.debug(
          'Navigation: TAB_SWITCH (RESTORE)',
          data: any(named: 'data'),
          tag: 'Navigation',
        ),
      ).called(1);
    });

    testWidgets('renders expanded layout structure', (tester) async {
      tester.view.physicalSize = const Size(1000, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpApp(
        AdaptiveNavigationScaffold(
          navigationShell: createFakeShell(),
          logger: mockLogger,
        ),
      );
      // Should render scaffold with AppBar (expanded layout has AppBar)
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('medium layout shows navigation destinations', (tester) async {
      tester.view.physicalSize = const Size(700, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpApp(
        AdaptiveNavigationScaffold(
          navigationShell: createFakeShell(),
          logger: mockLogger,
        ),
      );
      // Verify NavigationRail has destinations
      final navigationRail = tester.widget<NavigationRail>(
        find.byType(NavigationRail),
      );
      expect(navigationRail.destinations.length, equals(3));
      expect(navigationRail.labelType, equals(NavigationRailLabelType.all));
    });

    testWidgets('large layout shows app name in drawer', (tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpApp(
        AdaptiveNavigationScaffold(
          navigationShell: createFakeShell(),
          logger: mockLogger,
        ),
      );
      // Large layout should show the app name in the permanent drawer
      expect(find.text('Starter App'), findsOneWidget);
    });

    testWidgets('expanded layout shows app name in app bar and drawer', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1000, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpApp(
        AdaptiveNavigationScaffold(
          navigationShell: createFakeShell(),
          logger: mockLogger,
        ),
      );
      // AppBar should show app name
      expect(find.text('Starter App'), findsOneWidget);

      // Open the drawer to see app name there too
      tester
          .state<ScaffoldState>(
            find.byType(Scaffold),
          )
          .openDrawer();
      await tester.pumpAndSettle();

      // App name appears in both AppBar and drawer header
      expect(find.text('Starter App'), findsNWidgets(2));
    });

    testWidgets('compact layout shows correct selected index', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpApp(
        AdaptiveNavigationScaffold(
          navigationShell: createFakeShell(currentIndex: 1),
          logger: mockLogger,
        ),
      );

      final navigationBar = tester.widget<NavigationBar>(
        find.byType(NavigationBar),
      );
      expect(navigationBar.selectedIndex, equals(1));
    });

    testWidgets('medium layout shows correct selected index', (tester) async {
      tester.view.physicalSize = const Size(700, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpApp(
        AdaptiveNavigationScaffold(
          navigationShell: createFakeShell(currentIndex: 2),
          logger: mockLogger,
        ),
      );

      final navigationRail = tester.widget<NavigationRail>(
        find.byType(NavigationRail),
      );
      expect(navigationRail.selectedIndex, equals(2));
    });

    testWidgets('large layout shows correct selected index', (tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpApp(
        AdaptiveNavigationScaffold(
          navigationShell: createFakeShell(currentIndex: 1),
          logger: mockLogger,
        ),
      );

      final navigationDrawer = tester.widget<NavigationDrawer>(
        find.byType(NavigationDrawer),
      );
      expect(navigationDrawer.selectedIndex, equals(1));
    });
  });
}
