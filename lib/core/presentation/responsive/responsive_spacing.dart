import 'package:flutter/material.dart';
import 'package:starter_app/core/presentation/responsive/build_context_extension.dart';

/// A widget that applies responsive padding around its child.
///
/// The padding amount adapts based on screen size:
/// - 16.0 for compact (mobile)
/// - 24.0 for medium/expanded (tablet)
/// - 32.0 for large/extra-large (desktop)
///
/// Example:
/// ```dart
/// ResponsiveSpacing(
///   child: Text('Content with adaptive padding'),
/// )
/// ```
final class ResponsiveSpacing extends StatelessWidget {
  /// Creates a [ResponsiveSpacing] widget.
  const ResponsiveSpacing({
    required this.child,
    super.key,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.responsivePadding,
      child: child,
    );
  }
}

/// A widget that creates responsive spacing between elements.
///
/// The gap size adapts based on screen size. You can specify different
/// sizes for mobile, tablet, and desktop, or let it use the default
/// responsive spacing values.
///
/// Example:
/// ```dart
/// Column(
///   children: [
///     Text('First item'),
///     const ResponsiveGap(),
///     Text('Second item'),
///   ],
/// )
/// ```
///
/// Example with custom sizes:
/// ```dart
/// const ResponsiveGap(
///   mobileSize: 12.0,
///   tabletSize: 16.0,
///   desktopSize: 24.0,
/// )
/// ```
final class ResponsiveGap extends StatelessWidget {
  /// Creates a [ResponsiveGap] widget.
  ///
  /// If sizes are not specified, uses the default responsive spacing
  /// from the context.
  const ResponsiveGap({
    this.mobileSize,
    this.tabletSize,
    this.desktopSize,
    super.key,
  });

  /// The gap size for mobile (compact) screens.
  ///
  /// Defaults to 8.0 if not specified.
  final double? mobileSize;

  /// The gap size for tablet (medium/expanded) screens.
  ///
  /// Defaults to 12.0-16.0 based on exact screen size if not specified.
  final double? tabletSize;

  /// The gap size for desktop (large/extra-large) screens.
  ///
  /// Defaults to 20.0-24.0 based on exact screen size if not specified.
  final double? desktopSize;

  @override
  Widget build(BuildContext context) {
    final size = context.responsiveValue(
      mobile: mobileSize ?? 8.0,
      tablet: tabletSize ?? context.responsiveSpacing,
      desktop: desktopSize ?? context.responsiveSpacing,
    );

    return SizedBox.square(dimension: size);
  }
}

/// A widget that creates responsive vertical spacing.
///
/// Similar to [ResponsiveGap] but specifically for vertical spacing
/// in column layouts.
///
/// Example:
/// ```dart
/// Column(
///   children: [
///     Text('First item'),
///     const ResponsiveVerticalGap(),
///     Text('Second item'),
///   ],
/// )
/// ```
final class ResponsiveVerticalGap extends StatelessWidget {
  /// Creates a [ResponsiveVerticalGap] widget.
  const ResponsiveVerticalGap({
    this.height,
    super.key,
  });

  /// Custom height for the gap.
  ///
  /// If not specified, uses responsive spacing from context.
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height ?? context.responsiveSpacing);
  }
}

/// A widget that creates responsive horizontal spacing.
///
/// Similar to [ResponsiveGap] but specifically for horizontal spacing
/// in row layouts.
///
/// Example:
/// ```dart
/// Row(
///   children: [
///     Icon(Icons.star),
///     const ResponsiveHorizontalGap(),
///     Text('Rating'),
///   ],
/// )
/// ```
final class ResponsiveHorizontalGap extends StatelessWidget {
  /// Creates a [ResponsiveHorizontalGap] widget.
  const ResponsiveHorizontalGap({
    this.width,
    super.key,
  });

  /// Custom width for the gap.
  ///
  /// If not specified, uses responsive spacing from context.
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width ?? context.responsiveSpacing);
  }
}
