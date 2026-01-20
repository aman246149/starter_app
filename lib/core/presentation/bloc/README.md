# Core Presentation BLoC

This directory contains cross-cutting presentation state management (Cubits/BLoCs) that are used throughout the application.

## Architecture

These cubits are in `core/presentation/` because:

1. **Presentation Layer Concern**: Cubits manage UI state, which is a presentation layer responsibility
2. **Cross-Cutting**: Theme and locale affect all features, not just one
3. **No Domain Logic**: These manage pure UI preferences, not business rules
4. **Clean Architecture**: State management belongs in presentation, not core infrastructure

### Separation of Concerns

```text
lib/core/theme/              → Configuration (data)
├── app_theme.dart           # ThemeData definitions
├── color_palette.dart       # Color constants
└── ...

lib/core/l10n/               → Localization Resources (data)
├── arb/                     # ARB translation files
└── ...

lib/core/presentation/bloc/  → State Management (presentation)
├── theme_cubit.dart         # Which theme is active?
└── locale_cubit.dart        # Which locale is active?
```

## Structure

```text
bloc/
├── theme_cubit.dart    # Theme mode state management
├── locale_cubit.dart   # Locale/language state management
└── bloc.dart           # Barrel file for exports
```

## ThemeCubit

Manages the application's theme mode (light, dark, system) with automatic persistence.

### AppThemeMode

Framework-independent enum for theme modes:

```dart
enum AppThemeMode {
  light,
  dark,
  system;
}
```

### Usage

```dart
import 'package:starter_app/core/presentation/bloc/bloc.dart';
import 'package:starter_app/core/theme/app_theme_extension.dart';

// In BlocBuilder
BlocBuilder<ThemeCubit, AppThemeMode>(
  builder: (context, appThemeMode) {
    return MaterialApp(
      themeMode: appThemeMode.toThemeMode(), // Convert to Flutter's ThemeMode
      // ...
    );
  },
)

// Changing theme
context.read<ThemeCubit>().setLightTheme();
context.read<ThemeCubit>().setDarkTheme();
context.read<ThemeCubit>().setSystemTheme();
context.read<ThemeCubit>().toggleTheme();
```

### Persistence

Uses `HydratedBloc` for automatic persistence:
- State is saved to local storage as JSON
- State is restored on app restart
- No manual SharedPreferences handling needed

## LocaleCubit

Manages the application's locale/language with automatic persistence.

### AppLocale

Framework-independent locale representation:

```dart
class AppLocale {
  const AppLocale(this.languageCode, [this.countryCode]);
  
  final String languageCode;
  final String? countryCode;
  
  static const en = AppLocale('en');
  static const es = AppLocale('es');
}
```

### Usage

```dart
import 'package:starter_app/core/presentation/bloc/bloc.dart';

// In BlocBuilder
BlocBuilder<LocaleCubit, AppLocale>(
  builder: (context, appLocale) {
    return MaterialApp(
      locale: Locale(appLocale.languageCode, appLocale.countryCode),
      // ...
    );
  },
)

// Changing locale
context.read<LocaleCubit>().setEnglish();
context.read<LocaleCubit>().setSpanish();
context.read<LocaleCubit>().setLocale(AppLocale('fr'));
```

## Dependency Injection

Both cubits are registered in `BlocModule`:

```dart
// lib/core/di/modules/bloc_module.dart

@lazySingleton
ThemeCubit provideThemeCubit() {
  return ThemeCubit(AppThemeMode.system);
}

@lazySingleton
LocaleCubit provideLocaleCubit() {
  return LocaleCubit(AppLocale.en);
}
```

**Important:** Both use `@lazySingleton` (not `@singleton`) because `HydratedBloc.storage` must be initialized before any `HydratedCubit` is created.

## Why Not in Features?

Theme and locale could be placed in a `settings` feature, but they're better as core presentation concerns because:

| Aspect | Settings Feature | Core Presentation |
|--------|-----------------|-------------------|
| Has domain logic? | Would need it | ❌ No domain logic |
| Used by | One feature | All features |
| Nature | User preference | App-wide UI state |
| Complexity | 3-layer feature | Simple cubit |

These are **pure UI state** with **no business rules**, making them ideal for `core/presentation/`.

### When to Move to Features

If you introduce **remote data fetching** (e.g., fetching translations or theme config from an API), these cubits should move to dedicated features:

- **Remote translations** → `features/localization/` with domain/data/application layers
- **Remote theme config** → `features/settings/` or `features/theming/`

**The rule:** If it needs a repository interface or use cases, it's a feature, not core.

## Testing

Tests are located at:
```
test/core/presentation/bloc/theme_cubit_test.dart
```

Example:
```dart
blocTest<ThemeCubit, AppThemeMode>(
  'emits [AppThemeMode.dark] when setDarkTheme is called',
  build: () => ThemeCubit(AppThemeMode.system),
  act: (cubit) => cubit.setDarkTheme(),
  expect: () => [AppThemeMode.dark],
);
```

## Best Practices

### Do
- Import from `core/presentation/bloc/bloc.dart`
- Use `AppThemeMode` / `AppLocale` (framework-independent)
- Convert to Flutter types at the UI boundary
- Provide cubits at app level

### Don't
- Create multiple instances of these cubits
- Mix framework-independent and Flutter types
- Put domain logic in these cubits
- Import from individual files (use barrel file)

## See Also

- [Theme Configuration](../../theme/README.md) - Theme data and colors
- [Localization](../../l10n/LOCALIZATION.md) - ARB files and translations
- [DI Modules](../../di/README.md) - Dependency injection setup
