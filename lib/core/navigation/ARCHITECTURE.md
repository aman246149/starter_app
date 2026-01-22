# Navigation Architecture

## Feature-First Route Organization

This navigation system follows **feature-first architecture** where each feature owns its route declarations.

## Directory Structure

```text
lib/
├── core/navigation/
│   ├── app_router.dart              # Main router hub (imports all routes)
│   ├── app_router.g.dart            # Generated code
│   ├── route_definitions.dart        # Centralized paths/names
│   ├── base_route.dart              # Base route class
│   ├── page_builder.dart            # Transition builders
│   ├── app_router_observer.dart     # Navigation debugging
│ 
│
└── features/
    ├── settings/presentation/
    │   ├── pages/
    │   │   └── settings_page.dart
    │   └── routes/
    │       └── settings_routes.dart # part of app_router.dart
    │
    └── profile/presentation/
        ├── pages/
        │   └── profile_page.dart
        └── routes/
            └── profile_routes.dart  # part of app_router.dart
```

## Part File Pattern

Each feature declares its routes using the `part of` directive:

```dart
// lib/features/settings/presentation/routes/settings_routes.dart
part of '../../../../core/navigation/app_router.dart';

@TypedGoRoute<SettingsRoute>(...)
class SettingsRoute extends BaseRoute with $SettingsRoute {
  // Route implementation
}
```

Then registered in the main router:

```dart
// lib/core/navigation/app_router.dart
part '../../features/settings/presentation/routes/settings_routes.dart';
```

## Benefits

1. **Feature Encapsulation**: Each feature owns its routes
2. **Single Compilation Unit**: All routes compiled together for type-safety
3. **Clear Boundaries**: Core navigation doesn't depend on features
4. **Easy Discovery**: Routes live with their feature
5. **Scalable**: Add new features without modifying core

## Adding a New Feature Route

### 1. Create Feature Structure

```text
lib/features/my_feature/
├── presentation/
│   ├── pages/
│   │   └── my_feature_page.dart
│   └── routes/
│       └── my_feature_routes.dart
└── my_feature.dart
```

### 2. Define Route

```dart
// lib/features/my_feature/presentation/routes/my_feature_routes.dart
part of '../../../../core/navigation/app_router.dart';

@TypedGoRoute<MyFeatureRoute>(
  path: RouteDefinitions.myFeaturePath,
  name: RouteDefinitions.myFeatureName,
)
class MyFeatureRoute extends BaseRoute with $MyFeatureRoute {
  const MyFeatureRoute();
  
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MyFeaturePage();
  }
}
```

### 3. Add Route Definition

```dart
// lib/core/navigation/route_definitions.dart
static const String myFeaturePath = '/my-feature';
static const String myFeatureName = 'my-feature';
```

### 4. Register in AppRouter

```dart
// lib/core/navigation/app_router.dart
part '../../features/my_feature/presentation/routes/my_feature_routes.dart';
```

### 5. Update Shell Route (if needed)

```dart
@TypedShellRoute<AppShellRoute>(
  routes: [
    TypedGoRoute<HomeRoute>(path: RouteDefinitions.homePath),
    TypedGoRoute<MyFeatureRoute>(path: RouteDefinitions.myFeaturePath),
    // ...
  ],
)
```

### 6. Generate Code

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Route Types

### Standard Routes (with transitions)

```dart
class MyRoute extends BaseRoute with $MyRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MyPage();
  }
  // Automatically gets slide/fade transitions from BaseRoute
}
```

### Shell Routes (no transitions)

```dart
class MyRoute extends BaseRoute with $MyRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MyPage();
  }
  
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage(
      key: state.pageKey,
      child: build(context, state),
    );
  }
}
```

## Navigation Patterns

### From UI

```dart
const MyFeatureRoute().go(context);
const MyFeatureRoute().push(context);
```

### With Parameters

```dart
@TypedGoRoute<UserRoute>(path: '/user/:id')
class UserRoute extends BaseRoute with $UserRoute {
  const UserRoute(this.id);
  final String id;
}

// Navigate
UserRoute('123').go(context);
```

## Architecture Compliance

✅ **Feature-First**: Each feature owns its routes  
✅ **Bounded Context**: Routes are part of the feature domain  
✅ **Type-Safe**: Compile-time route validation  
✅ **Centralized Config**: Single router hub  
✅ **Clean Dependencies**: Core doesn't know about features  

## References

- Reference project structure (see COMPARISON.md)
- `docs/architecture-rules/01_project_structure.md` - Feature-first rules
- `docs/architecture-rules/13_navigation.md` - Navigation rules
