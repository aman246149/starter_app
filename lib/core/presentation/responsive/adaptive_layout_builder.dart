import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:starter_app/core/presentation/responsive/screen_size.dart';

/// A widget that rebuilds its child based on the current screen size.
///
/// This is the primary widget for implementing adaptive layouts. It uses
/// [MediaQuery] to determine the current screen width and provides the
/// appropriate [ScreenSize] to the builder function.
///
/// Use this for top-level, global layout decisions that need to adapt
/// based on screen size. For local, widget-specific sizing, use
/// [LayoutBuilder] instead.
///
/// Example:
/// ```dart
/// AdaptiveLayoutBuilder(
///   builder: (context, screenSize) {
///     if (screenSize == ScreenSize.compact) {
///       return const MobileLayout();
///     }
///     return const DesktopLayout();
///   },
/// )
/// ```
///
/// Example with multiple breakpoints:
/// ```dart
/// AdaptiveLayoutBuilder(
///   builder: (context, screenSize) {
///     return switch (screenSize) {
///       ScreenSize.compact => const SingleColumnLayout(),
///       ScreenSize.medium => const TwoColumnLayout(),
///       _ => const ThreeColumnLayout(),
///     };
///   },
/// )
/// ```
final class AdaptiveLayoutBuilder extends StatelessWidget {
  /// Creates an [AdaptiveLayoutBuilder].
  ///
  /// The [builder] function is called with the current [ScreenSize]
  /// and should return the appropriate widget for that screen size.
  const AdaptiveLayoutBuilder({
    required this.builder,
    super.key,
  });

  /// The builder function called with the current [ScreenSize].
  ///
  /// This function is called whenever the screen size changes (e.g., on
  /// window resize or device rotation).
  final Widget Function(BuildContext context, ScreenSize screenSize) builder;

  @override
  Widget build(BuildContext context) {
    // Using MediaQuery for top-level, global layout decisions
    final width = MediaQuery.sizeOf(context).width;
    final screenSize = ScreenSize.fromWidth(width);
    return builder(context, screenSize);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      ObjectFlagProperty<
        Widget Function(BuildContext context, ScreenSize screenSize)
      >.has(
        'builder',
        builder,
      ),
    );
  }
}
