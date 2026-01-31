# Error Handling Module

> Core error handling infrastructure following Clean Architecture principles.

## Architecture Overview

```
lib/core/error/
├── exceptions/              # Infrastructure layer exceptions
│   ├── cache_exception.dart
│   ├── circuit_breaker_exception.dart
│   ├── network_exception.dart
│   ├── server_exception.dart
│   └── exceptions.dart      # Barrel export
├── failures/                # Domain layer failures
│   ├── failure.dart         # Base abstract class
│   ├── technical_failure.dart
│   ├── value_failure.dart
│   ├── infrastructure_failures.dart
│   └── failures.dart        # Barrel export
├── reporters/               # Error reporting implementations
│   ├── no_op_error_reporter.dart
│   └── sentry_error_reporter.dart
├── exception_handler.dart   # Generic exception-to-failure mapper
├── i_exception_mapper.dart  # Feature-specific mapper interface
├── sensitive_data_filter.dart
└── README.md
```

## Key Concepts

### Exceptions vs Failures

| Concept | Layer | Purpose |
|---------|-------|---------|
| **Exception** | Infrastructure | Thrown when things go wrong (network, cache, server) |
| **Failure** | Domain | Returned to UI layer via `Either<Failure, T>` |

**Rule**: Exceptions **NEVER** escape the infrastructure layer. They are caught in repositories and converted to `Either<Failure, T>`.

### Failure Hierarchy

```
Failure (abstract)
├── TechnicalFailure (abstract)
│   ├── InfrastructureFailure (server, network, cache, parse, circuitBreaker, unexpected)
│   └── AuthFailure (unauthorized, forbidden, sessionExpired, etc.)
└── ValueFailure<T> (abstract)
    ├── EmailFailure
    ├── PasswordFailure
    ├── NameFailure
    └── ...
```

## Usage

### In Repositories

```dart
@LazySingleton(as: IAuthRepository)
class AuthRepositoryImpl implements IAuthRepository {
  AuthRepositoryImpl(this._exceptionHandler, this._dataSource);
  
  final ExceptionHandler _exceptionHandler;
  final IAuthRemoteDataSource _dataSource;

  @override
  FutureResult<User> login(AuthCredentials credentials) {
    return _exceptionHandler.handle(
      operation: () async {
        final response = await _dataSource.login(credentials.toDto());
        return response.user.toDomain();
      },
      // Optional: Custom server exception mapping
      serverExceptionMapper: (e) => switch (e.statusCode) {
        401 => const AuthFailure.invalidCredentials(),
        _ => InfrastructureFailure.server(
              message: e.message,
              statusCode: e.statusCode,
            ),
      },
    );
  }
}
```

### Exception Types

| Exception | When Thrown | Maps To |
|-----------|-------------|---------|
| `ServerException` | API returns error (4xx, 5xx) | `InfrastructureFailure.server` |
| `NetworkException` | No internet, timeout | `InfrastructureFailure.network` |
| `CacheException` | Local storage fails | `InfrastructureFailure.cache` |
| `CircuitBreakerException` | Service overloaded | `InfrastructureFailure.circuitBreaker` |
| `FormatException` | JSON parse error | `InfrastructureFailure.parse` |
| Other `Exception` | Unknown/unhandled | `InfrastructureFailure.unexpected` |

### Error Reporting

```dart
// In main.dart - Sentry is used in prod/staging, NoOp in dev
await SentryFlutter.init(
  (options) {
    options.dsn = Env.sentryDsn;
    options.environment = AppEnvironment.current.name;
  },
  appRunner: () => runApp(const App()),
);
```

**Sensitive Data Filtering**: All context data is automatically filtered before sending to Sentry via `SensitiveDataFilter`:

```dart
// Filtered terms: password, token, api_key, ssn, credit_card, etc.
final context = {'user': 'john', 'password': 'secret'};
final filtered = dataFilter.filter(context);
// Result: {'user': 'john', 'password': '***REDACTED***'}
```

## Feature-Specific Mappers

For domain-specific failure mapping, implement `IExceptionMapper`:

```dart
@injectable
class AuthExceptionMapper implements IExceptionMapper {
  @override
  TechnicalFailure mapToFailure(ServerException exception) {
    return switch (exception.statusCode) {
      401 => const AuthFailure.invalidCredentials(),
      403 => const AuthFailure.forbidden(),
      _ => InfrastructureFailure.server(
            message: exception.message,
            statusCode: exception.statusCode,
          ),
    };
  }
}
```

## Retryable Failures

Some failures can be retried (used for UI retry buttons):

| Failure Type | Retryable | Reason |
|--------------|-----------|--------|
| `server` | ✅ Yes | Temporary server issues |
| `network` | ✅ Yes | Connection can recover |
| `circuitBreaker` | ✅ Yes | Will reset after timeout |
| `cache` | ❌ No | Usually a bug |
| `parse` | ❌ No | Data format issue |
| `unexpected` | ❌ No | Unknown errors |

## Related ADRs

- `docs/adr/ADR-0011-error-strategy.md` - Error handling strategy
- `docs/adr/ADR-0003-functional-error-handling.md` - Either pattern
