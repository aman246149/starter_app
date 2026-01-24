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

/// A widget that applies responsive padding to its child.
///
/// The padding amount adapts based on screen size, with additional
/// options for customizing padding per breakpoint.
///
/// Example:
/// ```dart
/// ResponsivePadding(
///   child: Text('Content'),
/// )
/// ```
///
/// Example with custom padding:
/// ```dart
/// ResponsivePadding(
///   mobilePadding: const EdgeInsets.all(12),
///   tabletPadding: const EdgeInsets.all(20),
///   desktopPadding: const EdgeInsets.all(28),
///   child: Text('Content'),
/// )
/// ```
final class ResponsivePadding extends StatelessWidget {
  /// Creates a [ResponsivePadding] widget.
  const ResponsivePadding({
    required this.child,
    this.mobilePadding,
    this.tabletPadding,
    this.desktopPadding,
    super.key,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// Custom padding for mobile (compact) screens.
  ///
  /// Defaults to EdgeInsets.all(16) if not specified.
  final EdgeInsets? mobilePadding;

  /// Custom padding for tablet (medium/expanded) screens.
  ///
  /// Defaults to EdgeInsets.all(24) if not specified.
  final EdgeInsets? tabletPadding;

  /// Custom padding for desktop (large/extra-large) screens.
  ///
  /// Defaults to EdgeInsets.all(32) if not specified.
  final EdgeInsets? desktopPadding;

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayoutBuilder(
      builder: (context, screenSize) {
        final padding = switch (screenSize) {
          ScreenSize.compact => mobilePadding ?? const EdgeInsets.all(16),
          ScreenSize.medium ||
          ScreenSize.expanded => tabletPadding ?? const EdgeInsets.all(24),
          ScreenSize.large ||
          ScreenSize.extraLarge => desktopPadding ?? const EdgeInsets.all(32),
        };

        return Padding(
          padding: padding,
          child: child,
        );
      },
    );
  }
}

/// A responsive grid container that adapts column count based on screen size.
///
/// Automatically adjusts the number of columns based on available space,
/// following Material Design guidelines.
///
/// Example:
/// ```dart
/// ResponsiveGrid(
///   children: [
///     Card(child: Text('Item 1')),
///     Card(child: Text('Item 2')),
///     Card(child: Text('Item 3')),
///   ],
/// )
/// ```
final class ResponsiveGrid extends StatelessWidget {
  /// Creates a [ResponsiveGrid].
  const ResponsiveGrid({
    required this.children,
    this.crossAxisSpacing = 16,
    this.mainAxisSpacing = 16,
    this.childAspectRatio = 1.0,
    super.key,
  });

  /// The widgets to display in the grid.
  final List<Widget> children;

  /// The spacing between columns.
  final double crossAxisSpacing;

  /// The spacing between rows.
  final double mainAxisSpacing;

  /// The aspect ratio of each grid item.
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayoutBuilder(
      builder: (context, screenSize) {
        final columns = switch (screenSize) {
          ScreenSize.compact => 2,
          ScreenSize.medium => 3,
          ScreenSize.expanded => 4,
          ScreenSize.large => 5,
          ScreenSize.extraLarge => 6,
        };

        return ResponsivePadding(
          child: GridView.count(
            crossAxisCount: columns,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisSpacing: mainAxisSpacing,
            childAspectRatio: childAspectRatio,
            children: children,
          ),
        );
      },
    );
  }
}
