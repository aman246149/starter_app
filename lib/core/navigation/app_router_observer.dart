import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starter_app/core/logging/i_app_logger.dart';
import 'package:starter_app/core/navigation/navigation.dart' show AppShellRoute;

/// Custom navigator observer for debugging and tracking navigation events.
///
/// This observer:
/// - Logs all navigation events in debug mode (using AppLogger)
/// - Maintains an internal navigation stack
/// - Provides utilities for querying navigation state
/// - Helps debug navigation issues
///
/// ## Named Observers
///
/// The [name] parameter distinguishes multiple observer instances in logs:
/// - `root` - Main GoRouter navigator (default)
/// - `Dashboard` - Dashboard branch navigator
/// - `profile` - Profile branch navigator
/// - `settings` - Settings branch navigator
///
/// When using StatefulShellRoute, each branch has its own navigator with
/// its own observer. This results in multiple log entries for the same
/// route (one from root, one from branch) - this is expected behavior.
/// See [AppShellRoute] documentation for the full architecture diagram.
///
/// Registration is handled by NavigationModule (root) and branch route
/// files (per-branch observers).
final class AppRouterObserver extends NavigatorObserver {
  AppRouterObserver({this.name = 'root'});

  /// Observer name for distinguishing multiple observers in logs
  final String name;

  /// Internal navigation stack
  final List<Route<dynamic>> _navigationStack = [];

  /// Get the logger from the navigator's context
  IAppLogger? get _logger {
    // Navigator might be null during initialization or detachment
    if (navigator == null || !navigator!.mounted) return null;

    try {
      return navigator!.context.read<IAppLogger>();
    } on Exception catch (_) {
      // If AppLogger is not found in context
      // (e.g. during some tests), return null
      return null;
    }
  }

  /// Get a copy of the current navigation stack
  List<Route<dynamic>> get navigationStack =>
      List.unmodifiable(_navigationStack);

  /// Get the current route
  Route<dynamic>? get currentRoute =>
      _navigationStack.isEmpty ? null : _navigationStack.last;

  /// Check if we can pop
  bool get canPop => _navigationStack.length > 1;

  /// Get navigation history as route names
  List<String?> get navigationHistory =>
      _navigationStack.map((r) => r.settings.name).toList();

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _navigationStack.add(route);
    _logNavigation('PUSH', route, previousRoute);
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (_navigationStack.isNotEmpty) {
      _navigationStack.removeLast();
    }
    _logNavigation('POP', route, previousRoute);
    super.didPop(route, previousRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _navigationStack.remove(route);
    _logNavigation('REMOVE', route, previousRoute);
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (oldRoute != null) {
      final index = _navigationStack.indexOf(oldRoute);
      if (index >= 0 && newRoute != null) {
        _navigationStack[index] = newRoute;
      }
    }
    _logNavigation('REPLACE', newRoute, oldRoute);
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didStartUserGesture(
    Route<dynamic> route,
    Route<dynamic>? previousRoute,
  ) {
    _logNavigation('START_GESTURE', route, previousRoute);
    super.didStartUserGesture(route, previousRoute);
  }

  @override
  void didStopUserGesture() {
    _logger?.debug('Navigation gesture stopped', tag: 'Navigation');
    super.didStopUserGesture();
  }

  /// Log navigation events using AppLogger
  void _logNavigation(
    String action,
    Route<dynamic>? route,
    Route<dynamic>? previousRoute,
  ) {
    final routeName = route?.settings.name ?? 'unnamed';
    final previousName = previousRoute?.settings.name ?? 'none';
    final stackDepth = _navigationStack.length;

    _logger?.debug(
      '[$name] $action',
      data: {
        'route': routeName,
        'previous': previousName,
        'stackDepth': stackDepth,
      },
      tag: 'Navigation',
    );
  }

  /// Clear the navigation stack (useful for testing)
  @visibleForTesting
  void clearStack() {
    _navigationStack.clear();
  }
}
