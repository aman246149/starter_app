import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/core/navigation/base_route.dart';
import 'package:starter_app/core/navigation/page_builder.dart';

import '../../helpers/mock_helpers.dart';

class TestRoute extends BaseRoute {
  const TestRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const Scaffold(
      body: Text('Test Page'),
    );
  }
}

void main() {
  setUpAll(() {
    registerFallbackValue(MockBuildContext());
    registerFallbackValue(MockGoRouterState());
    registerFallbackValue(const SizedBox());
  });

  group('BaseRoute', () {
    late MockGoRouterState mockState;

    setUp(() {
      mockState = MockGoRouterState();
    });

    testWidgets('buildPage uses PageBuilder from context', (tester) async {
      final mockPageBuilder = MockPageBuilder();
      final testPage = MaterialPage<void>(
        key: mockState.pageKey,
        name: mockState.name,
        child: const SizedBox(),
      );

      when(
        () => mockPageBuilder.build(
          context: any(named: 'context'),
          state: any(named: 'state'),
          child: any(named: 'child'),
        ),
      ).thenReturn(testPage);

      late Page<void> resultPage;
      const route = TestRoute();

      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider<PageBuilder>.value(
            value: mockPageBuilder,
            child: Builder(
              builder: (context) {
                resultPage = route.buildPage(context, mockState);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
      // Advance past Sentry timer
      await tester.pump(const Duration(seconds: 4));

      expect(resultPage, testPage);
      verify(
        () => mockPageBuilder.build(
          context: any(named: 'context'),
          state: mockState,
          child: any(named: 'child'),
        ),
      ).called(1);
    });

    testWidgets(
      'buildPage throws ProviderNotFoundException when not provided',
      (
        tester,
      ) async {
        const route = TestRoute();

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                route.buildPage(context, mockState);
                return const SizedBox();
              },
            ),
          ),
        );
        // Advance past Sentry timer
        await tester.pump(const Duration(seconds: 4));

        expect(tester.takeException(), isA<ProviderNotFoundException>());
      },
    );

    testWidgets('build returns the widget from subclass', (tester) async {
      const route = TestRoute();
      // We can test build() directly without PageBuilder since build()
      // doesn't use it.
      // But we need a context.

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return route.build(context, mockState);
            },
          ),
        ),
      );
      // Advance past Sentry timer
      await tester.pump(const Duration(seconds: 4));

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.text('Test Page'), findsOneWidget);
    });
  });
}

class MockPageBuilder extends Mock implements PageBuilder {}
