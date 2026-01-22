// ignore_for_file: prefer_const_constructors -
//to be able to test the constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_app/core/navigation/page_builder.dart';

import '../../helpers/mock_helpers.dart';

class TestPageBuilder extends PageBuilder {
  const TestPageBuilder();

  @override
  Page<void> build({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) {
    return MaterialPage(child: child);
  }
}

void main() {
  group('PageBuilder', () {
    test('abstract constructor can be called via subclass', () {
      final builder = TestPageBuilder();
      expect(builder, isA<PageBuilder>());
    });
  });

  group('CustomTransitionPageBuilder', () {
    test('can be instantiated', () {
      final builder = CustomTransitionPageBuilder();
      expect(builder, isA<CustomTransitionPageBuilder>());
    });

    test('build returns CustomTransitionPage', () {
      const builder = CustomTransitionPageBuilder();
      final context = MockBuildContext();
      final state = MockGoRouterState();
      final child = Container();

      final page = builder.build(context: context, state: state, child: child);

      expect(page, isA<CustomTransitionPage<void>>());
      expect(page.key, state.pageKey);
      expect(page.name, state.name);
    });

    test('creates page with transitions builder', () {
      const builder = CustomTransitionPageBuilder();
      final context = MockBuildContext();
      final state = MockGoRouterState();
      const child = Scaffold(body: Text('Test'));

      final page = builder.build(
        context: context,
        state: state,
        child: child,
      );

      // The page should be created with transitions
      expect(page, isA<CustomTransitionPage<void>>());
      expect(page.key, state.pageKey);
      expect(page.name, state.name);
    });

    testWidgets(
      'transitions builder creates slide transition for forward navigation',
      (tester) async {
        const builder = CustomTransitionPageBuilder();
        final state = MockGoRouterState();
        const child = Scaffold(body: Text('Test'));

        final page = builder.build(
          context: MockBuildContext(),
          state: state,
          child: child,
        );

        expect(page, isA<CustomTransitionPage<void>>());
        final customPage = page as CustomTransitionPage<void>;

        // Create a test animation controller
        final controller = AnimationController(
          vsync: tester,
          duration: const Duration(milliseconds: 300),
        );

        // Test forward animation (not reversing)
        unawaited(controller.forward());
        await tester.pump();

        final animation = CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOut,
        );

        final secondaryAnimation = AnimationController(
          vsync: tester,
          duration: const Duration(milliseconds: 300),
        );

        // Create a dummy BuildContext for the transition
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                // Build the transition
                final transition = customPage.transitionsBuilder.call(
                  context,
                  animation,
                  secondaryAnimation,
                  child,
                );

                expect(transition, isA<SlideTransition>());
                return const SizedBox();
              },
            ),
          ),
        );

        controller.dispose();
        secondaryAnimation.dispose();
      },
    );

    testWidgets(
      'transitions builder creates fade transition for backward navigation',
      (tester) async {
        const builder = CustomTransitionPageBuilder();
        final state = MockGoRouterState();
        const child = Scaffold(body: Text('Test'));

        final page = builder.build(
          context: MockBuildContext(),
          state: state,
          child: child,
        );

        expect(page, isA<CustomTransitionPage<void>>());
        final customPage = page as CustomTransitionPage<void>;

        // Create a test animation controller in reverse state
        final controller = AnimationController(
          vsync: tester,
          duration: const Duration(milliseconds: 300),
          value: 1,
        );
        unawaited(controller.reverse());
        await tester.pump();

        final animation = CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOut,
        );

        final secondaryAnimation = AnimationController(
          vsync: tester,
          duration: const Duration(milliseconds: 300),
        );

        // Create a dummy BuildContext for the transition
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                // Build the transition
                final transition = customPage.transitionsBuilder.call(
                  context,
                  animation,
                  secondaryAnimation,
                  child,
                );

                expect(transition, isA<FadeTransition>());
                return const SizedBox();
              },
            ),
          ),
        );

        controller.dispose();
        secondaryAnimation.dispose();
      },
    );
  });

  group('NoTransitionPageBuilder', () {
    test('can be instantiated', () {
      final builder = NoTransitionPageBuilder();
      expect(builder, isA<NoTransitionPageBuilder>());
    });

    test('build returns NoTransitionPage', () {
      const builder = NoTransitionPageBuilder();
      final context = MockBuildContext();
      final state = MockGoRouterState();
      final child = Container();

      final page = builder.build(context: context, state: state, child: child);

      expect(page, isA<NoTransitionPage<void>>());
      expect(page.key, state.pageKey);
      expect(page.name, state.name);
    });

    test('creates page without transitions', () {
      const builder = NoTransitionPageBuilder();
      final context = MockBuildContext();
      final state = MockGoRouterState();
      const child = Scaffold(body: Text('Test'));

      final page = builder.build(
        context: context,
        state: state,
        child: child,
      );

      expect(page, isA<NoTransitionPage<void>>());
      expect(page.key, state.pageKey);
      expect(page.name, state.name);
    });

    test('NoTransitionPage is created correctly', () {
      const builder = NoTransitionPageBuilder();
      final state = MockGoRouterState();
      const child = Scaffold(body: Text('Test'));

      final page = builder.build(
        context: MockBuildContext(),
        state: state,
        child: child,
      );

      expect(page, isA<NoTransitionPage<void>>());
      // NoTransitionPage from go_router handles transitions internally
      // We just verify it's the correct type
      expect(page.key, state.pageKey);
      expect(page.name, state.name);
    });
  });
}
