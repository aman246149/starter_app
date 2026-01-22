import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_app/core/navigation/page_builder.dart';

/// Abstract base class for standard routes with custom transitions.
///
/// All standard routes should extend this class to automatically apply
/// custom page transitions. Shell routes should NOT extend this.
///
/// This class:
/// - Automatically injects the PageBuilder via DI (context)
/// - Applies custom transitions to all routes
/// - Provides a clean separation between route definition and page building
///
/// Usage:
/// ```dart
/// @TypedGoRoute<MyRoute>(path: '/my-route')
/// final class MyRoute extends BaseRoute with $MyRoute {
///   const MyRoute();
///
///   @override
///   Widget build(BuildContext context, GoRouterState state) {
///     return const MyPage();
///   }
/// }
/// ```
abstract class BaseRoute extends GoRouteData {
  const BaseRoute();

  /// Build the page widget for this route.
  ///
  /// Subclasses must implement this to return their page widget.
  @override
  Widget build(BuildContext context, GoRouterState state);

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    // Get PageBuilder from context (provided via RepositoryProvider in App)
    final pageBuilder = context.read<PageBuilder>();

    return pageBuilder.build(
      context: context,
      state: state,
      child: build(context, state),
    );
  }
}
