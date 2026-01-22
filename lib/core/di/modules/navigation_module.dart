import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:starter_app/core/navigation/app_router.dart';
import 'package:starter_app/core/navigation/app_router_observer.dart';
import 'package:starter_app/core/navigation/auth_change_notifier.dart';
import 'package:starter_app/core/navigation/page_builder.dart';

/// Module for navigation-related dependencies.
///
/// Provides:
/// - **NavigatorObserver**: Navigation event logging and tracking
/// - **PageBuilder**: Custom page transitions
/// - **GoRouter**: Router configuration from AppRouter
///
/// Note: [AppRouter] is registered via `@lazySingleton` annotation on the class
/// itself, not through this module. This is because AppRouter now depends on
/// [AuthChangeNotifier] which is also auto-registered.
///
/// All navigation dependencies are singletons that live for the entire
/// app lifetime. No explicit disposal needed.
@module
abstract class NavigationModule {
  /// Provides NavigatorObserver for navigation event logging.
  ///
  /// The observer:
  /// - Logs all navigation events (push, pop, replace, remove)
  /// - Maintains an internal navigation stack for debugging
  /// - Tracks navigation history
  /// - Provides utilities for querying navigation state
  ///
  /// Lives for the entire app lifetime as a lazySingleton.
  @LazySingleton(as: NavigatorObserver)
  AppRouterObserver provideAppRouterObserver() {
    return AppRouterObserver();
  }

  /// Provides the default PageBuilder with custom transitions.
  ///
  /// This is the main page builder used by most routes.
  /// Provides:
  /// - Slide-forward transition for push navigation
  /// - Fade-back transition for pop navigation
  /// - Configurable transition duration (300ms default)
  ///
  /// PageBuilder is stateless and doesn't require disposal.
  @Singleton(as: PageBuilder)
  CustomTransitionPageBuilder providePageBuilder() {
    return const CustomTransitionPageBuilder();
  }

  /// Provides GoRouter instance from AppRouter.
  ///
  /// This is the actual GoRouter configuration used by MaterialApp.router.
  /// Retrieved from the AppRouter singleton's routerConfig property.
  @singleton
  GoRouter provideGoRouter(AppRouter appRouter) {
    return appRouter.routerConfig;
  }
}
