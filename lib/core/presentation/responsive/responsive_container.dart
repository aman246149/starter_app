import 'package:flutter/material.dart';
import 'package:starter_app/core/presentation/responsive/adaptive_layout_builder.dart';
import 'package:starter_app/core/presentation/responsive/screen_size.dart';

/// A container that constrains content width on large screens.
///
/// This widget prevents content from stretching too wide on large displays,
/// maintaining readability and proper visual hierarchy. Content is centered
/// on screens larger than the specified maximum width.
///
/// Example:
/// ```dart
/// ResponsiveContainer(
///   child: ListView(
///     children: [...],
///   ),
/// )
/// ```
///
/// Example with custom max width:
/// ```dart
/// ResponsiveContainer(
///   maxWidth: 1000,
///   child: Column(
///     children: [...],
///   ),
/// )
/// ```
final class ResponsiveContainer extends StatelessWidget {
  /// Creates a [ResponsiveContainer].
  ///
  /// The [maxWidth] defaults to 1200 logical pixels.
  /// Set [centerOnLarge] to false to disable centering on large screens.
  const ResponsiveContainer({
    required this.child,
    this.maxWidth = 1200,
    this.centerOnLarge = false,
    super.key,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// The maximum width constraint for content.
  ///
  /// Defaults to 1200 logical pixels. Set to null to disable width
  /// constraints entirely.
  final double? maxWidth;

  /// Whether to center content on large screens.
  ///
  /// When true, content is centered horizontally when the screen is wider
  /// than [maxWidth]. When false, content fills the available width up to
  /// [maxWidth].
  final bool centerOnLarge;

  @override
  Widget build(BuildContext context) {
    if (maxWidth == null) {
      return child;
    }

    return AdaptiveLayoutBuilder(
      builder: (context, screenSize) {
        // On mobile and tablet, don't constrain width
        if (!centerOnLarge || screenSize.index < ScreenSize.large.index) {
          return child;
        }

        // On large screens, center and constrain width
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth!),
            child: child,
          ),
        );
      },
    );
  }
}
