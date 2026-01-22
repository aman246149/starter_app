import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ignore_for_file: one_member_abstracts - PageBuilder is an abstract class
//by design for DI and interface segregation

/// Abstract base class for building pages with custom transitions.
///
/// This allows different page builders to be injected based on
/// requirements (e.g., custom transitions, no transitions, etc.).
///
/// Implementations can provide different transition strategies
/// (e.g., slide, fade, scale, or no transition).
abstract class PageBuilder {
  const PageBuilder();

  /// Builds a page with the specified child widget.
  ///
  /// Returns a [Page] that wraps the child with appropriate transitions.
  Page<void> build({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  });
}

/// Custom transition page builder with slide-in and fade-out animations.
///
/// Provides different animations for forward and backward navigation:
/// - **Forward navigation**: Slide from right to left
/// - **Back navigation**: Fade out
///
/// This creates a natural navigation flow following Material Design patterns.
///
/// Registration is handled by NavigationModule.
final class CustomTransitionPageBuilder implements PageBuilder {
  const CustomTransitionPageBuilder();

  @override
  Page<void> build({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      name: state.name,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Determine if we're navigating forward or backward
        final isPopping = animation.status == AnimationStatus.reverse;

        if (isPopping) {
          // Back navigation: Fade out
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        } else {
          // Forward navigation: Slide from right
          return SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(1, 0), // Start from right
                  end: Offset.zero, // End at center
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOut,
                  ),
                ),
            child: child,
          );
        }
      },
    );
  }
}

/// No transition page builder for instant navigation.
///
/// Use this when you want instant page changes without animations,
/// such as for bottom navigation tabs.
///
/// Registration is handled by NavigationModule (commented out for now).
final class NoTransitionPageBuilder implements PageBuilder {
  const NoTransitionPageBuilder();

  @override
  Page<void> build({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) {
    return NoTransitionPage<void>(
      key: state.pageKey,
      name: state.name,
      child: child,
    );
  }
}
