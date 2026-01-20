# Responsive Utilities

Comprehensive adaptive UI system based on Material Design 3 window size classes.

## Overview

This package provides a complete set of tools for building adaptive UIs that respond to different screen sizes. Unlike simple responsive design that only adjusts element placement, our adaptive approach fundamentally alters layouts and components for optimal usability across devices.

## Core Components

### ScreenSize Enum

Five window size classes based on Material Design 3:

| Class | Width Range | Typical Devices | Navigation Pattern |
|-------|-------------|-----------------|-------------------|
| `compact` | 0-599dp | Phones (Portrait) | Bottom NavigationBar |
| `medium` | 600-839dp | Tablets (Portrait) | NavigationRail |
| `expanded` | 840-1199dp | Tablets (Landscape) | Dismissible NavigationDrawer |
| `large` | 1200-1599dp | Desktops | Permanent NavigationDrawer |
| `extraLarge` | 1600dp+ | Large Desktops | Permanent NavigationDrawer |

### AdaptiveLayoutBuilder

Main widget for creating adaptive layouts:

```dart
AdaptiveLayoutBuilder(
  builder: (context, screenSize) {
    return switch (screenSize) {
      ScreenSize.compact => const MobileLayout(),
      ScreenSize.medium => const TabletLayout(),
      _ => const DesktopLayout(),
    };
  },
)
```

### BuildContext Extensions

Convenient responsive queries:

```dart
// Screen size checks
if (context.isMobile) { /* ... */ }
if (context.isTablet) { /* ... */ }
if (context.isDesktop) { /* ... */ }

// Layout capabilities
if (context.supportsTwoPane) { /* ... */ }
if (context.supportsThreePane) { /* ... */ }

// Responsive values
final padding = context.responsivePadding;
final spacing = context.responsiveSpacing;
final columns = context.responsiveGridColumns;

// Custom responsive values
final fontSize = context.responsiveValue(
  mobile: 14.0,
  tablet: 16.0,
  desktop: 18.0,
);
```

## Responsive Widgets

### ResponsiveContainer

Constrains content width on large screens:

```dart
ResponsiveContainer(
  maxWidth: 1200,
  child: ListView(children: [...]),
)
```

### ResponsivePadding

Applies adaptive padding:

```dart
ResponsivePadding(
  child: Column(children: [...]),
)

// With custom padding per breakpoint
ResponsivePadding(
  mobilePadding: const EdgeInsets.all(12),
  tabletPadding: const EdgeInsets.all(20),
  desktopPadding: const EdgeInsets.all(28),
  child: Column(children: [...]),
)
```

### ResponsiveSpacing & Gaps

Various spacing widgets:

```dart
Column(
  children: [
    Text('Item 1'),
    const ResponsiveGap(), // Adaptive spacing
    Text('Item 2'),
    const ResponsiveVerticalGap(height: 16), // Custom vertical spacing
    Text('Item 3'),
  ],
)

Row(
  children: [
    Icon(Icons.star),
    const ResponsiveHorizontalGap(), // Adaptive horizontal spacing
    Text('Rating'),
  ],
)
```

### ResponsiveGrid

Grid with adaptive column count:

```dart
ResponsiveGrid(
  crossAxisSpacing: 16,
  mainAxisSpacing: 16,
  childAspectRatio: 1.2,
  children: [
    Card(child: Text('Item 1')),
    Card(child: Text('Item 2')),
    Card(child: Text('Item 3')),
  ],
)
```

Column count automatically adjusts:

- Compact: 2 columns
- Medium: 3 columns
- Expanded: 4 columns
- Large: 5 columns
- Extra Large: 6 columns

## Usage Patterns

### List-Detail Layout

```dart
AdaptiveLayoutBuilder(
  builder: (context, screenSize) {
    if (screenSize == ScreenSize.compact) {
      // Single pane - use navigation
      return const ProductListPage();
    }
    
    // Two-pane layout
    return Row(
      children: [
        SizedBox(
          width: 320,
          child: const ProductListView(),
        ),
        const VerticalDivider(width: 1),
        const Expanded(child: ProductDetailView()),
      ],
    );
  },
)
```

### Responsive Card Grid

```dart
class ProductGrid extends StatelessWidget {
  final List<Product> products;
  
  @override
  Widget build(BuildContext context) {
    final columns = context.responsiveGridColumns;
    
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: context.responsiveSpacing,
        mainAxisSpacing: context.responsiveSpacing,
        childAspectRatio: 0.8,
      ),
      padding: context.responsivePadding,
      itemCount: products.length,
      itemBuilder: (context, index) => ProductCard(
        product: products[index],
      ),
    );
  }
}
```

### Conditional Widget Display

```dart
AdaptiveLayoutBuilder(
  builder: (context, screenSize) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My App'),
        // Show additional actions on larger screens
        actions: [
          if (screenSize.index >= ScreenSize.medium.index)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
          if (screenSize.index >= ScreenSize.expanded.index)
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {},
            ),
        ],
      ),
      body: content,
    );
  },
)
```

### Responsive Typography

```dart
Text(
  'Hello World',
  style: TextStyle(
    fontSize: context.responsiveValue(
      mobile: 16,
      tablet: 18,
      desktop: 20,
    ),
  ),
)
```

## Best Practices

### DO ✅

- Use `AdaptiveLayoutBuilder` for screen-size-dependent layouts
- Test layouts at all five breakpoint thresholds
- Use context extensions for quick responsive checks
- Constrain content width on extra-large screens
- Change interaction patterns, not just sizes
- Show more content on larger screens, not bigger content

### DON'T ❌

- Don't use `LayoutBuilder` for global layout decisions (use it for local sizing only)
- Don't create device-specific code paths
- Don't scale everything proportionally
- Don't assume mobile-first is enough
- Don't leave excessive whitespace on large screens
- Don't force mobile UX patterns on desktop

## Testing

### Widget Tests

```dart
testWidgets('Layout adapts to compact screen', (tester) async {
  await tester.binding.setSurfaceSize(const Size(400, 800));
  await tester.pumpWidget(const MyApp());
  
  expect(context.screenSize, ScreenSize.compact);
  expect(context.isMobile, isTrue);
});

testWidgets('Layout adapts to large screen', (tester) async {
  await tester.binding.setSurfaceSize(const Size(1400, 900));
  await tester.pumpWidget(const MyApp());
  
  expect(context.screenSize, ScreenSize.large);
  expect(context.supportsTwoPane, isTrue);
});
```

## Migration Guide

### From Existing Responsive Code

1. Replace `LayoutBuilder` usage for screen-size decisions with `AdaptiveLayoutBuilder`
2. Update custom breakpoints to use `ScreenSize` enum
3. Replace hardcoded padding/spacing with responsive alternatives
4. Test at all five breakpoints

### Example Migration

**Before:**

```dart
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth < 600) {
      return MobileLayout();
    } else if (constraints.maxWidth < 1200) {
      return TabletLayout();
    }
    return DesktopLayout();
  },
)
```

**After:**

```dart
AdaptiveLayoutBuilder(
  builder: (context, screenSize) {
    return switch (screenSize) {
      ScreenSize.compact => const MobileLayout(),
      ScreenSize.medium || ScreenSize.expanded => const TabletLayout(),
      _ => const DesktopLayout(),
    };
  },
)
```

## Performance Considerations

- Use `const` constructors wherever possible
- Avoid rebuilding entire layouts when only content changes
- Cache computed layout values
- Use `LayoutBuilder` for local, widget-specific sizing
- Use `MediaQuery` (via `AdaptiveLayoutBuilder`) for global decisions

## References

- [Material Design 3 Layout Guidelines](https://m3.material.io/foundations/layout/applying-layout)
- [Material Design 3 Window Size Classes](https://m3.material.io/foundations/layout/canonical-layouts)
- Architecture Rules: `docs/architecture-rules/14_adaptive_ui_strategy.md`
