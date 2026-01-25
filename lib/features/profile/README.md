# Profile Feature

User profile management for the starter app.

## Structure

```
lib/features/profile/
├── domain/           # Entities, value objects, repository interfaces
├── application/      # Use cases (GetProfile query)
├── infrastructure/   # Repository impl, data sources, models
├── presentation/     # BLoC, pages, widgets
└── l10n/             # Feature-specific localization
```

## Key Components

### Domain Layer
- **UserProfile** - Aggregate root with `displayName` (Name value object)
- **ProfileId** - Type-safe extension type wrapping UniqueId
- **ProfileFailure** - Domain failures extending `TechnicalFailure` (`isRetryable`, `stackTrace`)
- **IUserProfileRepository** - Repository interface returning `FutureResult<UserProfile>`

### Application Layer
- **GetProfile** - CQRS query (no params) delegating to repository

### Infrastructure Layer
- **UserProfileRepositoryImpl** - Uses `BaseRepository` and `ProfileExceptionMapper`
- **ProfileExceptionMapper** - Maps `ServerException` (404, 500) to `ProfileFailure`
- **UserProfileRemoteDataSource** - Uses `response.requireBody` for null safety
- **ProfileApiService** - Chopper-based API client

### Presentation Layer
- **ProfileBloc** - Listens to auth events via `IEventDispatcher`
- **ProfileFailureMapper** - Maps failures to localized user messages
- **ProfilePage** - Displays profile or login button
- **ProfileContent** - Isolated widget for profile details

## Key Patterns

### 1. Railway-Oriented Error Handling
Returns `FutureResult<UserProfile>` (alias for `Future<Either<Failure, UserProfile>>`).
Failures are strongly typed (`ProfileFailure`) and mapped from exceptions in the infrastructure layer.

### 2. Event-Driven Architecture

The `ProfileBloc` subscribes to `AuthDomainEvent` stream:

```dart
switch (event) {
  case UserRegistered():
  case UserLoggedIn():
  case UserSessionRestored():
    add(ProfileEvent.getMyProfile());
  case UserLoggedOut():
    add(ProfileEvent.reset());
}
```

## Tests

```bash
very_good test --no-optimization test/features/profile/
```

73 tests covering all layers.
