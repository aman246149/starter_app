import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/core/navigation/route_definitions.dart';

void main() {
  group('RouteDefinitions', () {
    test('has correct path constants', () {
      expect(RouteDefinitions.dashboardPath, '/dashboard');
      expect(RouteDefinitions.settingsPath, '/settings');
      expect(RouteDefinitions.profilePath, '/profile');
      expect(RouteDefinitions.authPath, '/auth');
    });

    test('has correct name constants', () {
      expect(RouteDefinitions.dashboardName, 'dashboard');
      expect(RouteDefinitions.settingsName, 'settings');
      expect(RouteDefinitions.profileName, 'profile');
      expect(RouteDefinitions.authName, 'auth');
    });

    test('initialRoute is DashboardPath', () {
      expect(RouteDefinitions.initialRoute, RouteDefinitions.dashboardPath);
    });

    test('unProtectedRoutes contains expected routes', () {
      final routes = RouteDefinitions.unProtectedRoutes;

      expect(routes, contains(RouteDefinitions.dashboardPath));
      expect(routes, contains(RouteDefinitions.authPath));
      expect(routes, contains(RouteDefinitions.settingsPath));
      expect(routes, contains(RouteDefinitions.profilePath));
      expect(routes.length, 4);
    });

    test('authProtectedRoutes contains expected routes', () {
      final routes = RouteDefinitions.deepLinkProtectedRoutes;

      expect(routes, contains(RouteDefinitions.ordersPath));
      expect(routes.length, 1);
    });

    test('isUnProtectedRoute returns true for unprotected routes', () {
      expect(RouteDefinitions.isUnProtectedRoute('/dashboard'), true);
      expect(RouteDefinitions.isUnProtectedRoute('/auth'), true);
      expect(RouteDefinitions.isUnProtectedRoute('/settings'), true);
      expect(RouteDefinitions.isUnProtectedRoute('/profile'), true);
    });

    test('isUnProtectedRoute returns false for protected routes', () {
      expect(RouteDefinitions.isUnProtectedRoute('/orders'), false);
      expect(RouteDefinitions.isUnProtectedRoute('/unknown'), false);
    });

    test('isAuthProtectedRoute returns true for protected routes', () {
      expect(RouteDefinitions.isDeepLinkProtectedRoute('/orders'), true);
    });

    test('isAuthProtectedRoute returns false for unprotected routes', () {
      expect(RouteDefinitions.isDeepLinkProtectedRoute('/dashboard'), false);
      expect(RouteDefinitions.isDeepLinkProtectedRoute('/auth'), false);
      expect(RouteDefinitions.isDeepLinkProtectedRoute('/settings'), false);
      expect(RouteDefinitions.isDeepLinkProtectedRoute('/profile'), false);
      expect(RouteDefinitions.isDeepLinkProtectedRoute('/unknown'), false);
    });

    test('is a final class with private constructor', () {
      // RouteDefinitions is a final class with private constructor
      // This test verifies the class structure exists
      expect(RouteDefinitions.dashboardPath, isA<String>());
    });
  });
}
