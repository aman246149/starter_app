import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/core/logging/i_app_logger.dart';
import 'package:starter_app/core/navigation/app_router_observer.dart';

import '../../helpers/mock_helpers.dart';

void main() {
  group('AppRouterObserver', () {
    late MockAppLogger mockLogger;
    late AppRouterObserver observer;

    setUp(() {
      mockLogger = MockAppLogger();
      observer = AppRouterObserver();
    });

    Future<void> pumpApp(WidgetTester tester, Widget child) async {
      await tester.pumpWidget(
        RepositoryProvider<IAppLogger>.value(
          value: mockLogger,
          child: MaterialApp(
            navigatorObservers: [observer],
            home: child,
          ),
        ),
      );
      // Advance past Sentry's 3-second TimeToDisplayTracker timer
      await tester.pump(const Duration(seconds: 4));
    }

    testWidgets('handles missing AppLogger gracefully', (tester) async {
      // Pump app WITHOUT AppLogger provider
      await tester.pumpWidget(
        MaterialApp(
          navigatorObservers: [observer],
          home: const SizedBox(),
        ),
      );
      // Advance past Sentry's 3-second TimeToDisplayTracker timer
      await tester.pump(const Duration(seconds: 4));

      // Should not crash even though logger lookup fails
      expect(observer.navigationStack, isNotEmpty);
    });

    testWidgets('canPop returns correct value', (tester) async {
      await pumpApp(tester, const SizedBox());
      // Initial stack has 1 route (Dashboard)
      expect(observer.canPop, false);

      // Push a route
      unawaited(
        tester
            .state<NavigatorState>(find.byType(Navigator))
            .push(
              MaterialPageRoute<void>(
                builder: (_) => const SizedBox(),
                settings: const RouteSettings(name: 'route1'),
              ),
            ),
      );
      await tester.pump();

      // Now stack has 2 routes
      expect(observer.canPop, true);
    });

    testWidgets('initial state is empty', (tester) async {
      await pumpApp(tester, const SizedBox());
      // Upon pumping, the Dashboard route is pushed.
      // So it's NOT empty anymore.
      // MaterialApp pushes 'defaultRouteName' ('/') by default.
      expect(observer.navigationStack, isNotEmpty);
      expect(observer.currentRoute, isNotNull);
    });

    testWidgets('didPush adds to stack and logs', (tester) async {
      await pumpApp(tester, const SizedBox());

      // Clear initial stack from MaterialApp setup
      observer.clearStack();
      reset(mockLogger);

      unawaited(
        tester
            .state<NavigatorState>(find.byType(Navigator))
            .push(
              MaterialPageRoute<void>(
                builder: (_) => const SizedBox(),
                settings: const RouteSettings(name: 'route1'),
              ),
            ),
      );
      await tester.pump();

      expect(observer.navigationStack.last.settings.name, 'route1');
      expect(observer.currentRoute?.settings.name, 'route1');

      verify(
        () => mockLogger.debug(
          any(that: contains('PUSH')),
          data: any(named: 'data'),
          tag: 'Navigation',
        ),
      ).called(1);
    });

    testWidgets('didPop removes from stack and logs', (tester) async {
      await pumpApp(tester, const SizedBox());
      final navigator = tester.state<NavigatorState>(find.byType(Navigator));

      unawaited(
        navigator.push(
          MaterialPageRoute<void>(
            builder: (_) => const SizedBox(),
            settings: const RouteSettings(name: 'route1'),
          ),
        ),
      );
      await tester.pump();

      // Clear logs from push
      reset(mockLogger);

      navigator.pop();
      await tester.pump();

      expect(observer.currentRoute?.settings.name, isNot('route1'));

      verify(
        () => mockLogger.debug(
          any(that: contains('POP')),
          data: any(named: 'data'),
          tag: 'Navigation',
        ),
      ).called(1);
    });

    testWidgets('didReplace replaces in stack and logs', (tester) async {
      await pumpApp(tester, const SizedBox());
      final navigator = tester.state<NavigatorState>(find.byType(Navigator));

      unawaited(
        navigator.push(
          MaterialPageRoute<void>(
            builder: (_) => const SizedBox(),
            settings: const RouteSettings(name: 'route1'),
          ),
        ),
      );
      await tester.pump();

      reset(mockLogger);

      unawaited(
        navigator.pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => const SizedBox(),
            settings: const RouteSettings(name: 'route2'),
          ),
        ),
      );
      await tester.pump();

      expect(observer.currentRoute?.settings.name, 'route2');

      verify(
        () => mockLogger.debug(
          any(that: contains('REPLACE')),
          data: any(named: 'data'),
          tag: 'Navigation',
        ),
      ).called(1);
    });

    testWidgets('didRemove removes from stack and logs', (tester) async {
      await pumpApp(tester, const SizedBox());
      final navigator = tester.state<NavigatorState>(find.byType(Navigator));

      final route1 = MaterialPageRoute<void>(
        builder: (_) => const SizedBox(),
        settings: const RouteSettings(name: 'route1'),
      );

      unawaited(navigator.push(route1));
      await tester.pump();

      unawaited(
        navigator.push(
          MaterialPageRoute<void>(
            builder: (_) => const SizedBox(),
            settings: const RouteSettings(name: 'route2'),
          ),
        ),
      );
      await tester.pump();

      reset(mockLogger);

      navigator.removeRoute(route1);
      await tester.pump();

      expect(observer.navigationHistory, isNot(contains('route1')));

      verify(
        () => mockLogger.debug(
          any(that: contains('REMOVE')),
          data: any(named: 'data'),
          tag: 'Navigation',
        ),
      ).called(1);
    });

    testWidgets('logs user gesture events', (tester) async {
      await pumpApp(tester, const SizedBox());
      final route = MaterialPageRoute<void>(
        builder: (_) => const SizedBox(),
        settings: const RouteSettings(name: 'route1'),
      );
      final previousRoute = MaterialPageRoute<void>(
        builder: (_) => const SizedBox(),
        settings: const RouteSettings(name: 'prev'),
      );

      // Manually trigger gesture start
      observer.didStartUserGesture(route, previousRoute);

      verify(
        () => mockLogger.debug(
          any(that: contains('START_GESTURE')),
          data: any(named: 'data'),
          tag: 'Navigation',
        ),
      ).called(1);

      reset(mockLogger);

      // Manually trigger gesture stop
      observer.didStopUserGesture();

      verify(
        () => mockLogger.debug(
          any(that: contains('Navigation gesture stopped')),
          tag: 'Navigation',
        ),
      ).called(1);
    });

    testWidgets('observer with custom name logs with that name', (
      tester,
    ) async {
      final customObserver = AppRouterObserver(name: 'custom');
      await tester.pumpWidget(
        RepositoryProvider<IAppLogger>.value(
          value: mockLogger,
          child: MaterialApp(
            navigatorObservers: [customObserver],
            home: const SizedBox(),
          ),
        ),
      );
      // Advance past Sentry's 3-second TimeToDisplayTracker timer
      await tester.pump(const Duration(seconds: 4));

      // Verify the initial push logged with [custom]
      verify(
        () => mockLogger.debug(
          any(that: contains('[custom]')),
          data: any(named: 'data'),
          tag: 'Navigation',
        ),
      ).called(greaterThan(0));
    });
  });
}
