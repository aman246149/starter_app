import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/core/l10n/arb/app_localizations.dart';
import 'package:starter_app/core/logging/i_app_logger.dart';
import 'package:starter_app/core/navigation/app_router.dart';
import 'package:starter_app/core/navigation/page_builder.dart';
import 'package:starter_app/core/presentation/bloc/bloc.dart';
import 'package:starter_app/features/auth/l10n/auth_localizations.dart';
import 'package:starter_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:starter_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:starter_app/features/dashboard/l10n/dashboard_localizations.dart';
import 'package:starter_app/features/profile/l10n/profile_localizations.dart';
import 'package:starter_app/features/settings/l10n/settings_localizations.dart';

import '../../helpers/mock_helpers.dart';

class FakeBuildContext extends Fake implements BuildContext {}

class FakeGoRouterState extends Fake implements GoRouterState {}

class FakeWidget extends Fake implements Widget {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      'FakeWidget';
}

class MockPageBuilder extends Mock implements PageBuilder {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeBuildContext());
    registerFallbackValue(FakeGoRouterState());
    registerFallbackValue(FakeWidget());
  });

  group('Generated Route Mixins', () {
    late MockAppLogger mockLogger;

    setUp(() async {
      await GetIt.I.reset();
      mockLogger = MockAppLogger();
      GetIt.I.registerSingleton<IAppLogger>(mockLogger);

      try {
        final _ = $appRoutes;
      } on Exception catch (_) {
        // Ignore
      }
    });

    tearDown(() async {
      await GetIt.I.reset();
    });

    Future<void> testRouteNavigation(
      WidgetTester tester,
      String targetPath,
      void Function(BuildContext context) action,
    ) async {
      final router = GoRouter(
        initialLocation: '/start',
        routes: [
          GoRoute(
            path: '/start',
            builder: (_, _) => const Scaffold(body: SizedBox(key: Key('ctx'))),
          ),
          GoRoute(
            path: '/dashboard',
            builder: (_, _) => const Scaffold(body: SizedBox()),
          ),
          GoRoute(
            path: '/profile',
            builder: (_, _) => const Scaffold(body: SizedBox()),
          ),
          GoRoute(
            path: '/settings',
            builder: (_, _) => const Scaffold(body: SizedBox()),
          ),
          GoRoute(
            path: '/auth',
            builder: (_, _) => const Scaffold(body: SizedBox()),
          ),
          GoRoute(
            path: '/orders',
            builder: (_, _) => const Scaffold(body: SizedBox()),
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();

      final context = tester.element(find.byKey(const Key('ctx')));
      action(context);

      await tester.pumpAndSettle();

      expect(
        router.routerDelegate.currentConfiguration.matches.last.matchedLocation,
        targetPath,
      );
    }

    group('Typed Route Matching', () {
      late MockAuthBloc mockAuthBloc;
      late MockThemeCubit mockThemeCubit;
      late MockLocaleCubit mockLocaleCubit;
      late MockPageBuilder mockPageBuilder;

      setUp(() {
        mockAuthBloc = MockAuthBloc();
        mockThemeCubit = MockThemeCubit();
        mockLocaleCubit = MockLocaleCubit();
        mockPageBuilder = MockPageBuilder();

        when(() => mockAuthBloc.state).thenReturn(AuthState.empty());
        when(() => mockThemeCubit.state).thenReturn(AppThemeMode.system);
        when(() => mockLocaleCubit.state).thenReturn(AppLocale.en);

        // Mock PageBuilder for standard routes
        // (Auth, Settings, Profile use standard routes?)
        // Actually Profile/Settings/Dashboard use shell routes which might use different logic
        // But Auth uses standard route.
        when(
          () => mockPageBuilder.build(
            context: any(named: 'context'),
            state: any(named: 'state'),
            child: any(named: 'child'),
          ),
        ).thenAnswer((invocation) {
          // Return the child directly or wrapped in a simple page
          // We must return a Page<void>
          final child = invocation.namedArguments[#child] as Widget;
          return MaterialPage(child: child);
        });
      });

      testWidgets('matches all typed routes', (tester) async {
        final router = GoRouter(
          initialLocation: '/dashboard',
          routes: $appRoutes,
        );

        await tester.pumpWidget(
          MultiRepositoryProvider(
            providers: [
              RepositoryProvider<IAppLogger>.value(value: mockLogger),
              RepositoryProvider<PageBuilder>.value(value: mockPageBuilder),
            ],
            child: MultiBlocProvider(
              providers: [
                BlocProvider<AuthBloc>.value(value: mockAuthBloc),
                BlocProvider<ThemeCubit>.value(value: mockThemeCubit),
                BlocProvider<LocaleCubit>.value(value: mockLocaleCubit),
              ],
              child: MaterialApp.router(
                routerConfig: router,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  AuthLocalizations.delegate,
                  DashboardLocalizations.delegate,
                  ProfileLocalizations.delegate,
                  SettingsLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: AppLocalizations.supportedLocales,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Navigate to Profile
        router.go('/profile');
        await tester.pumpAndSettle();
        expect(router.routerDelegate.currentConfiguration.uri.path, '/profile');

        // Navigate to Settings
        router.go('/settings');
        await tester.pumpAndSettle();
        expect(
          router.routerDelegate.currentConfiguration.uri.path,
          '/settings',
        );

        // Navigate to Auth
        router.go('/auth');
        await tester.pumpAndSettle();
        expect(router.routerDelegate.currentConfiguration.uri.path, '/auth');
      });
    });

    group('DashboardRoute', () {
      test('location returns correct path', () {
        const route = DashboardRoute();
        expect(route.location, '/dashboard');
      });

      testWidgets('go navigates to Dashboard route', (tester) async {
        await testRouteNavigation(
          tester,
          '/dashboard',
          (ctx) => const DashboardRoute().go(ctx),
        );
      });

      testWidgets('push navigates to Dashboard route', (tester) async {
        await testRouteNavigation(
          tester,
          '/dashboard',
          (ctx) => const DashboardRoute().push<void>(ctx),
        );
      });

      testWidgets('pushReplacement navigates to Dashboard route', (
        tester,
      ) async {
        await testRouteNavigation(
          tester,
          '/dashboard',
          (ctx) => const DashboardRoute().pushReplacement(ctx),
        );
      });

      testWidgets('replace navigates to Dashboard route', (tester) async {
        await testRouteNavigation(
          tester,
          '/dashboard',
          (ctx) => const DashboardRoute().replace(ctx),
        );
      });
    });

    group('ProfileRoute', () {
      test('location returns correct path', () {
        const route = ProfileRoute();
        expect(route.location, '/profile');
      });

      testWidgets('go navigates to profile route', (tester) async {
        await testRouteNavigation(
          tester,
          '/profile',
          (ctx) => const ProfileRoute().go(ctx),
        );
      });

      testWidgets('push navigates to profile route', (tester) async {
        await testRouteNavigation(
          tester,
          '/profile',
          (ctx) => const ProfileRoute().push<void>(ctx),
        );
      });

      testWidgets('pushReplacement navigates to profile route', (tester) async {
        await testRouteNavigation(
          tester,
          '/profile',
          (ctx) => const ProfileRoute().pushReplacement(ctx),
        );
      });

      testWidgets('replace navigates to profile route', (tester) async {
        await testRouteNavigation(
          tester,
          '/profile',
          (ctx) => const ProfileRoute().replace(ctx),
        );
      });
    });

    group('SettingsRoute', () {
      test('location returns correct path', () {
        const route = SettingsRoute();
        expect(route.location, '/settings');
      });

      testWidgets('go navigates to settings route', (tester) async {
        await testRouteNavigation(
          tester,
          '/settings',
          (ctx) => const SettingsRoute().go(ctx),
        );
      });

      testWidgets('push navigates to settings route', (tester) async {
        await testRouteNavigation(
          tester,
          '/settings',
          (ctx) => const SettingsRoute().push<void>(ctx),
        );
      });

      testWidgets('pushReplacement navigates to settings route', (
        tester,
      ) async {
        await testRouteNavigation(
          tester,
          '/settings',
          (ctx) => const SettingsRoute().pushReplacement(ctx),
        );
      });

      testWidgets('replace navigates to settings route', (tester) async {
        await testRouteNavigation(
          tester,
          '/settings',
          (ctx) => const SettingsRoute().replace(ctx),
        );
      });
    });

    group('AuthRoute', () {
      test('location returns correct path', () {
        const route = AuthRoute();
        expect(route.location, '/auth');
      });

      testWidgets('go navigates to auth route', (tester) async {
        await testRouteNavigation(
          tester,
          '/auth',
          (ctx) => const AuthRoute().go(ctx),
        );
      });

      testWidgets('push navigates to auth route', (tester) async {
        await testRouteNavigation(
          tester,
          '/auth',
          (ctx) => const AuthRoute().push<void>(ctx),
        );
      });

      testWidgets('pushReplacement navigates to auth route', (tester) async {
        await testRouteNavigation(
          tester,
          '/auth',
          (ctx) => const AuthRoute().pushReplacement(ctx),
        );
      });

      testWidgets('replace navigates to auth route', (tester) async {
        await testRouteNavigation(
          tester,
          '/auth',
          (ctx) => const AuthRoute().replace(ctx),
        );
      });
    });

    group('OrdersRoute', () {
      test('location returns correct path', () {
        const route = OrdersRoute();
        expect(route.location, '/orders');
      });

      testWidgets('go navigates to orders route', (tester) async {
        await testRouteNavigation(
          tester,
          '/orders',
          (ctx) => const OrdersRoute().go(ctx),
        );
      });

      testWidgets('push navigates to orders route', (tester) async {
        await testRouteNavigation(
          tester,
          '/orders',
          (ctx) => const OrdersRoute().push<void>(ctx),
        );
      });

      testWidgets('pushReplacement navigates to orders route', (tester) async {
        await testRouteNavigation(
          tester,
          '/orders',
          (ctx) => const OrdersRoute().pushReplacement(ctx),
        );
      });

      testWidgets('replace navigates to orders route', (tester) async {
        await testRouteNavigation(
          tester,
          '/orders',
          (ctx) => const OrdersRoute().replace(ctx),
        );
      });
    });

    group('AppShellRoute', () {
      test('can be instantiated', () {
        const route = AppShellRoute();
        expect(route, isA<AppShellRoute>());
      });
    });

    group('Generated Route Lists', () {
      test('appRoutes contains shell, auth, and orders routes', () {
        expect($appRoutes, isA<List<RouteBase>>());
        expect($appRoutes.length, 3);
        // Check types instead of instance equality since routes are recreated
        expect($appRoutes.any((r) => r is StatefulShellRoute), isTrue);
        expect($appRoutes.any((r) => r is GoRoute && r.name == 'auth'), isTrue);
        expect(
          $appRoutes.any((r) => r is GoRoute && r.name == 'orders'),
          isTrue,
        );
      });

      test('appShellRoute is a StatefulShellRoute', () {
        expect($appShellRoute, isA<RouteBase>());
        expect($appShellRoute, isA<StatefulShellRoute>());
      });

      test('authRoute is a GoRoute', () {
        expect($authRoute, isA<RouteBase>());
        expect($authRoute, isA<GoRoute>());
      });

      test('ordersRoute is a GoRoute', () {
        expect($ordersRoute, isA<RouteBase>());
        expect($ordersRoute, isA<GoRoute>());
      });
    });
  });
}
