# Dependency Injection

This directory contains the dependency injection configuration using GetIt and Injectable.

## Overview

The DI system provides:

- **Automatic dependency registration** via code generation
- **Environment-specific dependencies** (development, staging, production)
- **Lifecycle management** (singleton, lazy singleton, factory)
- **Module-based organization** for related dependencies

## Structure

```text
di/
├── injection.dart              # Main DI setup with getIt instance
├── injection.config.dart       # Generated configuration (auto-generated)
└── modules/                    # DI modules for organizing dependencies
    ├── bloc_module.dart        # BLoC/Cubit providers
    ├── error_module.dart       # Error reporting (NoOp/Sentry by environment)
    ├── logging_module.dart     # Logger configuration
    ├── navigation_module.dart  # Router and navigation
    ├── network_module.dart     # HTTP client, API services
    ├── platform_module.dart    # Platform-specific info
    └── storage_module.dart     # Local storage, databases
```

## Setup

### 1. Initialize in Bootstrap

```dart
// lib/bootstrap.dart
Future<void> bootstrap(AppEnvironment environment) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure dependency injection
  await configureDependencies(environment);

  runApp(const MyApp());
}
```

### 2. Access Dependencies

#### In Presentation Layer (BLoC/Pages)

```dart
// Direct access via getIt
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MyBloc>(),
      child: // ...
    );
  }
}
```

#### In Other Layers (Constructor Injection)

```dart
@LazySingleton(as: IProductRepository)
class ProductRepositoryImpl implements IProductRepository {
  final IProductRemoteDataSource _remoteDataSource;
  final IProductLocalDataSource _localDataSource;

  ProductRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  );
}
```

## Registration Types

### @injectable (Factory)

Creates a **new instance** every time:

```dart
@injectable
class MyUseCase {
  final IRepository _repository;
  MyUseCase(this._repository);
}

// Each call creates new instance
final useCase1 = getIt<MyUseCase>(); // New instance
final useCase2 = getIt<MyUseCase>(); // Different instance
```

**Use for:** Use cases, BLoCs, short-lived services

### @singleton

Creates instance **immediately** when registered:

```dart
@singleton
class MyService {
  MyService() {
    print('Created immediately');
  }
}
```

**Use for:** Services needed at startup, eager initialization

### @lazySingleton

Creates instance **on first access** only:

```dart
@lazySingleton
class MyDatabase {
  MyDatabase() {
    print('Created on first use');
  }
}

// First access creates instance
final db1 = getIt<MyDatabase>(); // Creates instance
final db2 = getIt<MyDatabase>(); // Returns same instance
```

**Use for:** Expensive resources, repositories, API clients

### @LazySingleton(as: Interface)

Register implementation as interface:

```dart
@LazySingleton(as: IProductRepository)
class ProductRepositoryImpl implements IProductRepository {
  // Implementation
}

// Access via interface
final repo = getIt<IProductRepository>(); // Returns ProductRepositoryImpl
```

**Use for:** Following dependency inversion principle

## Environment-Specific Registration

### Register for Specific Environments

```dart
@Environment('development')
@lazySingleton
class MockApiService implements IApiService {
  // Mock implementation for development
}

@Environment('production')
@lazySingleton
class RealApiService implements IApiService {
  // Real implementation for production
}
```

### Register for Multiple Environments

```dart
@Environment(Environment.dev)
@Environment(Environment.test)
@lazySingleton
class DebugLogger implements ILogger {
  // Used in both dev and test
}
```

## Modules

### What are Modules?

Modules provide dependencies that require custom initialization or third-party setup.

### Creating a Module

```dart
@module
abstract class NetworkModule {
  /// Provides Chopper client
  @singleton
  ChopperClient provideChopperClient(
    IAppLogger logger,
    TokenStorage tokenStorage,
    // ... other dependencies
  ) {
    return ChopperClient(
      baseUrl: Uri.parse(AppEnvironment.current.apiBaseUrl),
      services: [
        AuthApiService.create(),
      ],
      converter: const JsonConverter(),
      interceptors: [
        AuthInterceptor(() => tokenStorage.getAccessToken()),
        LoggingInterceptor(logger),
      ],
    );
  }
}
```

### Async Providers (@preResolve)

For dependencies requiring async initialization:

```dart
@module
abstract class StorageModule {
  @preResolve
  @singleton
  Future<HydratedStorage> provideHydratedStorage() async {
    return HydratedStorage.build(
      storageDirectory: kIsWeb
          ? HydratedStorageDirectory.web
          : HydratedStorageDirectory((await getTemporaryDirectory()).path),
    );
  }
}
```

## Existing Modules

### BlocModule

- Provides all BLoC observers
- ThemeCubit & LocaleCubit

### LoggingModule

- Logger instance (Console/Sentry)
- Environment-specific configuration

### NavigationModule

- AppRouter and GoRouter
- NavigatorObserver
- PageBuilder

### NetworkModule

- Chopper client (HTTP)
- API Services (AuthApiService, etc.)
- Interceptors (Auth, Logging, Error, Refresh)
- Network error handler
- WebSocket configuration

### StorageModule

- SharedPreferences
- FlutterSecureStorage
- HydratedBloc storage

## Adding New Dependencies

### Step 1: Annotate the Class

```dart
@lazySingleton
class MyNewService {
  final Dio _dio;

  MyNewService(this._dio);

  Future<void> doSomething() async {
    // Implementation
  }
}
```

### Step 2: Run Code Generation

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Step 3: Use the Dependency

```dart
final service = getIt<MyNewService>();
await service.doSomething();
```

## Testing with DI

### Setup Test Dependencies

```dart
@InjectableInit(generateForDir: ['test'])
void configureTestDependencies() {
  getIt.init();
}

void main() {
  setUpAll(() {
    configureTestDependencies();
  });

  tearDown(() {
    getIt.reset();
  });
}
```

### Mock Dependencies

```dart
class MockRepository extends Mock implements IProductRepository {}

void main() {
  setUp(() {
    getIt.registerLazySingleton<IProductRepository>(
      () => MockRepository(),
    );
  });

  test('use case with mock repository', () {
    final useCase = getIt<GetProductUseCase>();
    // Test with mocked repository
  });
}
```

## Best Practices

### DO ✅

- Use constructor injection in all layers except presentation
- Register interfaces, not implementations (`as: IInterface`)
- Use `@lazySingleton` for repositories and services
- Use `@injectable` for use cases and BLoCs
- Organize related dependencies in modules
- Use `@preResolve` for async initialization
- Register environment-specific implementations

### DON'T ❌

- Don't use `getIt<T>()` in constructors (breaks testability)
- Don't register concrete classes when you have interfaces
- Don't mix DI with service locator pattern
- Don't forget to run code generation after changes
- Don't register stateful widgets
- Don't access `getIt` in domain layer
- Don't create circular dependencies

## Code Generation

### Generate Once

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Watch Mode (Auto-regenerate)

```bash
dart run build_runner watch --delete-conflicting-outputs
```

### Clean Before Build

```bash
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

## Troubleshooting

### Issue: "No registered factory found"

**Cause:** Class not registered or code generation not run.

**Solution:**

1. Add `@injectable`, `@singleton`, or `@lazySingleton`
2. Run `dart run build_runner build`

### Issue: "Circular dependency detected"

**Cause:** Two classes depend on each other.

**Solution:**

- Introduce an interface/abstraction
- Use `@factoryMethod` or lazy loading

### Issue: "Environment not found"

**Cause:** Wrong environment passed to `configureDependencies()`.

**Solution:**

- Ensure correct environment: `configureDependencies(environment)`
- Check environment name matches `@Environment('...')`

### Issue: "Async dependency not resolved"

**Cause:** Missing `await configureDependencies()`.

**Solution:**

```dart
await configureDependencies(environment); // Don't forget await!
```

## References

- [GetIt Documentation](https://pub.dev/packages/get_it)
- [Injectable Documentation](https://pub.dev/packages/injectable)
- Architecture Rules: `docs/architecture-rules/09_dependency_injection.md`
- Environment Config: `lib/core/application/CONFIGURATION.md`
