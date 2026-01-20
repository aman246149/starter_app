/// Responsive design utilities and adaptive layout widgets.
///
/// This package provides a comprehensive set of tools for building adaptive
/// UIs that respond to different screen sizes following Material Design 3
/// guidelines.
///
/// ## Core Components
///
/// - ScreenSize: Five-class breakpoint system (compact, medium, expanded,
///   large, extra-large)
/// - AdaptiveLayoutBuilder: Main widget for adaptive layouts
/// - ResponsiveContext: Extension methods for responsive queries
/// - NavigationDestinationInfo: Data class for adaptive navigation
///
/// ## Responsive Widgets
///
/// - ResponsiveContainer: Constrains content width on large screens
/// - ResponsivePadding: Applies responsive padding
/// - ResponsiveGrid: Grid with adaptive column count
/// - ResponsiveSpacing: Adaptive spacing widget
/// - ResponsiveGap: Gap between elements
/// - ResponsiveVerticalGap: Vertical spacing
/// - ResponsiveHorizontalGap: Horizontal spacing
///
/// ## Usage Example
///
/// ```dart
/// import 'package:starter_app/core/presentation/responsive/responsive.dart';
///
/// // Check screen size
/// if (context.isMobile) {
///   // Mobile layout
/// }
///
/// // Adaptive layout
/// AdaptiveLayoutBuilder(
///   builder: (context, screenSize) {
///     return switch (screenSize) {
///       ScreenSize.compact => const MobileLayout(),
///       ScreenSize.medium => const TabletLayout(),
///       _ => const DesktopLayout(),
///     };
///   },
/// )
///
/// // Responsive spacing
/// Column(
///   children: [
///     Text('Item 1'),
///     const ResponsiveGap(),
///     Text('Item 2'),
///   ],
/// )
/// ```
///
/// ## Breakpoint System
///
/// Based on Material Design 3 window size classes:
///
/// - **Compact** (0-599dp): Phones in portrait
/// - **Medium** (600-839dp): Tablets in portrait, large phones in landscape
/// - **Expanded** (840-1199dp): Tablets in landscape, small desktops
/// - **Large** (1200-1599dp): Desktops
/// - **Extra Large** (1600dp+): Large/ultra-wide desktops
///
/// See also:
/// - [Material Design 3 Layout Guidelines](https://m3.material.io/foundations/layout/applying-layout)
library;

export 'adaptive_layout_builder.dart';
export 'build_context_extension.dart';
export 'responsive_container.dart';
export 'responsive_spacing.dart';
export 'screen_size.dart';
