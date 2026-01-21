/// Failure types for error handling throughout the application.
///
/// **Architecture:**
/// - `Failure` - Base interface for all failures
/// - `InfrastructureFailure` - Server, network, cache errors
/// - `DomainFailure` - Validation, business rules (domain layer)
/// - `ValueFailure` - Generic validation failures for value objects
///
/// **Separation of Concerns:**
/// - Infrastructure failures = External system errors (API, database, network)
/// - Domain failures = Business logic and validation errors
/// - Features can define their own specific failure types extending `Failure`
///
/// **Usage:**
/// ```dart
/// // Infrastructure layer
/// return Left(InfrastructureFailure.server(message: 'API error'));
///
/// // Domain layer
/// return Left(DomainFailure.validation(errors: [...]));
///
/// // Feature-specific
/// return Left(OrderFailure.insufficientStock(...));
/// ```
library;

export 'failure.dart';
export 'infrastructure_failures.dart';
export 'value_failure.dart';
