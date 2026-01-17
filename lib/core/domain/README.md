# Domain Layer - Core

This directory contains the foundational building blocks for domain-driven design across all features.

## Overview

The domain layer is the heart of the application, containing:

- **Business entities** with identity
- **Value objects** without identity
- **Business rules** and validation logic
- **Repository interfaces** (ports)

This folder specifically contains **shared/core domain concepts** used across multiple features. Feature-specific domain models belong in their respective feature folders.

## Structure

```text
domain/
├── base/                       # Base abstractions
│   ├── base.dart              # Barrel export
│   ├── aggregate_root.dart    # Aggregate root with domain events
│   ├── command.dart           # Command base classes (CQRS)
│   ├── domain_event.dart      # Domain event base class
│   ├── domain_service.dart    # Domain service base class
│   ├── entity.dart            # Entity interface
│   ├── event_dispatcher.dart  # Event dispatcher interface + impl
│   ├── query.dart             # Query base classes (CQRS)
│   ├── specification.dart     # Specification pattern
│   ├── unique_id.dart         # UniqueId value object
│   ├── usecase.dart           # UseCase base classes (legacy)
│   └── value_object.dart      # ValueObject interface
├── ports/                      # Port interfaces (hexagonal architecture)
│   ├── ports.dart             # Barrel export
│   ├── i_circuit_breaker.dart # Circuit breaker pattern port
│   ├── i_platform_info.dart   # Platform info port
│   ├── i_secure_storage.dart  # Secure storage port
│   ├── i_session_manager.dart # Session management port
│   ├── i_token_refresh_notifier.dart # Token refresh notification port
│   ├── i_token_storage.dart   # Token storage port
│   ├── i_websocket_connection.dart # WebSocket connection port
│   └── i_websocket_manager.dart # WebSocket manager port
├── types/                      # Domain-level types
│   ├── types.dart             # Barrel export
│   ├── i_reconnection_policy.dart # Abstract reconnection policy interface
│   └── websocket_connection_state.dart # WebSocket state enum
└── value_objects/             # Shared value objects
    ├── value_objects.dart     # Barrel export
    ├── email_address.dart     # Email validation
    ├── image_url.dart         # Image URL validation
    ├── name.dart              # Name validation
    └── password.dart          # Password validation
```

## Core Concepts

### Entity vs Value Object

| Aspect | Entity | Value Object |
| -------- | -------- | -------------- |
| **Identity** | Has unique ID | No identity |
| **Equality** | By ID | By value |
| **Mutability** | Immutable (via copyWith) | Immutable |
| **Lifecycle** | Long-lived | Short-lived |
| **Example** | User, Product, Order | Email, Price, Address |

### Entity

An object with a unique identity that persists over time.

**Interface:**

```dart
abstract class Entity {
  UniqueId get id;
}

abstract class AggregateRoot extends Entity {
  List<DomainEvent> get domainEvents;
  void addDomainEvent(DomainEvent event);
  void clearDomainEvents();
}
```

**Example - User (actual implementation):**

```dart
import 'package:starter_app/core/domain/base/aggregate_root.dart';
import 'package:starter_app/core/domain/value_objects/email_address.dart';

/// User entity - Auth Aggregate Root.
class User extends AggregateRoot {
  User({
    required this.id,
    required this.email,
    required this.isEmailVerified,
  });

  @override
  final UserId id;
  final EmailAddress email;
  final bool isEmailVerified;

  /// Business method: verifies email and emits domain event.
  User verifyEmail() {
    if (isEmailVerified) return this;

    final updatedUser = copyWith(isEmailVerified: true);
    updatedUser.addDomainEvent(UserEmailVerified(updatedUser));
    return updatedUser;
  }

  /// Business method: changes email (resets verification).
  User changeEmail(EmailAddress newEmail) {
    if (email == newEmail) return this;

    final oldEmailStr = email.getOrCrash();
    final updatedUser = copyWith(email: newEmail, isEmailVerified: false);
    updatedUser.addDomainEvent(UserEmailChanged(updatedUser, oldEmailStr));
    return updatedUser;
  }

  User copyWith({UserId? id, EmailAddress? email, bool? isEmailVerified}) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }
}
```

**Rules:**

- ✅ Extend `AggregateRoot` (which extends `Entity`) for domain entities
- ✅ Use feature-specific ID types (e.g., `UserId`, `ProfileId`)
- ✅ Use value objects for validated fields (e.g., `EmailAddress`)
- ✅ Add business logic as methods that return new instances
- ✅ Emit domain events for significant state changes
- ✅ Implement manual `copyWith()` for immutability
- ❌ Don't use `@freezed` for entities (use plain classes)
- ❌ Don't add JSON serialization (that's for DTOs/models)
- ❌ Don't depend on infrastructure

### Value Object

An object defined by its attributes, not identity.

**Interface:**

```dart
abstract class ValueObject<T> {
  const ValueObject();

  /// Left = list of validation failures, Right = valid value
  Either<List<ValueFailure<T>>, T> get value;

  /// Returns value or throws UnexpectedValueError
  T getOrCrash();

  /// Returns value or null
  T? getOrNull();

  /// Returns failures or null
  List<ValueFailure<T>>? getFailuresOrNull();

  /// Returns true if valid
  bool get isValid;
}
```

**Example - EmailAddress (actual implementation):**

```dart
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:starter_app/core/domain/base/value_object.dart';
import 'package:starter_app/core/error/failures/value_failure.dart';

@immutable
final class EmailAddress extends ValueObject<String> {
  /// Creates with validation.
  factory EmailAddress(String input) {
    return EmailAddress._(_validateEmailAddress(input));
  }

  /// Creates from trusted source (bypasses validation).
  factory EmailAddress.fromTrustedSource(String input) {
    return EmailAddress._(right(input));
  }

  const EmailAddress._(this.value);

  /// Constant empty instance.
  static const empty = EmailAddress._(
    Left([ValueFailure.empty(fieldName: 'Email')]),
  );

  @override
  final Either<List<ValueFailure<String>>, String> value;

  static Either<List<ValueFailure<String>>, String> _validateEmailAddress(
    String? input,
  ) {
    if (input == null || input.isEmpty) {
      return left([const ValueFailure.empty(fieldName: 'Email')]);
    }
    if (!_emailRegex.hasMatch(input)) {
      return left([
        ValueFailure.invalidFormat(
          expectedFormat: 'Valid email address',
          failedValue: input,
        ),
      ]);
    }
    return right(input.trim().toLowerCase());
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is EmailAddress && value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'EmailAddress(${getOrNull() ?? "invalid"})';
}
```

**Rules:**

- ✅ Use `final class` with `extends ValueObject<T>`
- ✅ Use `@immutable` annotation
- ✅ Encapsulate validation in factory constructor
- ✅ Add `fromTrustedSource` factory for backend data
- ✅ Add `static const empty` for constant instances
- ✅ Return `Either<List<ValueFailure<T>>, T>` for multi-failure support
- ✅ Override `==`, `hashCode`, `toString`
- ❌ Don't use `@freezed` for value objects (plain classes only)
- ❌ Don't allow invalid state
- ❌ Don't make validation optional

### UniqueId

A type-safe wrapper for entity IDs.

**Usage:**

```dart
// Creating from String (from database/API)
final id = UniqueId.fromString('user-123');

// Creating new (for new entities)
final newId = UniqueId.generate();

// Getting String value (for persistence)
final stringValue = id.value; // 'user-123'

// Equality
final id1 = UniqueId.fromString('123');
final id2 = UniqueId.fromString('123');
print(id1 == id2); // true
```

**Implementation:**

```dart
final class UniqueId {
  const UniqueId._(this.value);
  final String value;

  factory UniqueId.generate() {
    return UniqueId._(const Uuid().v4());
  }

  factory UniqueId.fromString(String value) {
    return UniqueId._(value);
  }

  static Either<List<ValueFailure<String>>, UniqueId> fromUntrusted(String? input) {
    if (input == null || input.trim().isEmpty) {
      return left([const ValueFailure.empty()]);
    }
    return right(UniqueId._(input.trim()));
  }
}
```

**Benefits:**

- Type safety (can't confuse different ID types)
- Prevents primitive obsession
- Clear semantics in code
- Easy to add validation/formatting

## Creating New Domain Objects

### 1. Create an Entity

```bash
# Create in feature domain folder
touch lib/features/shop/domain/entities/product.dart
touch lib/features/shop/domain/entities/product_id.dart
```

**First, create the feature-specific ID (using extension type for zero runtime cost):**

```dart
// product_id.dart
import 'package:starter_app/core/domain/base/unique_id.dart';

/// Type-safe wrapper for UniqueId specifically for Products.
/// This is a compile-time extension type (zero runtime cost).
extension type const ProductId(UniqueId value) implements UniqueId {
  /// Generates a new [ProductId].
  factory ProductId.generate() => ProductId(UniqueId.generate());

  /// Creates a [ProductId] from a trusted string.
  factory ProductId.fromString(String value) => ProductId(UniqueId.fromString(value));
}
```

**Then, create the entity:**

```dart
// product.dart
import 'package:starter_app/core/domain/base/aggregate_root.dart';

class Product extends AggregateRoot {
  Product({
    required this.id,
    required this.name,
    required this.price,
  });

  @override
  final ProductId id;
  final String name;
  final double price;

  bool get isExpensive => price > 100;
  bool get isValid => name.isNotEmpty && price > 0;

  Product updatePrice(double newPrice) {
    final updated = copyWith(price: newPrice);
    updated.addDomainEvent(ProductPriceChanged(updated));
    return updated;
  }

  Product copyWith({ProductId? id, String? name, double? price}) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
    );
  }
}
```

### 2. Create a Value Object

```bash
# If shared across features
touch lib/core/domain/value_objects/phone_number.dart

# If feature-specific
touch lib/features/user/domain/value_objects/username.dart
```

Follow the EmailAddress pattern above. Key checklist:

1. `@immutable` + `final class` extending `ValueObject<T>`
2. Factory constructor with validation: `factory PhoneNumber(String input)`
3. `fromTrustedSource` factory to bypass validation
4. Private const constructor: `const PhoneNumber._(this.value)`
5. Static validation method returning `Either<List<ValueFailure<T>>, T>`
6. Override `==`, `hashCode`, `toString`

## Validation Patterns

### Simple Validation (Fail-Fast)

Returns first failure encountered:

```dart
static Either<List<ValueFailure<String>>, String> _validate(String? input) {
  if (input == null || input.isEmpty) {
    return left([const ValueFailure.empty(fieldName: 'Name')]);
  }

  if (input.length < 3) {
    return left([
      ValueFailure.tooShort(minLength: 3, actualLength: input.length),
    ]);
  }

  return right(input);
}
```

### Accumulating Validation (All Failures)

Returns all failures at once for better UX (like Password):

```dart
static Either<List<ValueFailure<String>>, String> _validate(String? input) {
  if (input == null || input.isEmpty) {
    return left([const ValueFailure.empty(fieldName: 'Password')]);
  }

  final failures = <ValueFailure<String>>[];

  if (input.length < 8) {
    failures.add(ValueFailure.tooShort(minLength: 8, actualLength: input.length));
  }

  if (!RegExp('[A-Z]').hasMatch(input)) {
    failures.add(const ValueFailure.invalidFormat(
      expectedFormat: 'At least one uppercase letter',
      failedValue: 'Missing uppercase',
    ));
  }

  if (!RegExp('[0-9]').hasMatch(input)) {
    failures.add(const ValueFailure.invalidFormat(
      expectedFormat: 'At least one digit',
      failedValue: 'Missing digit',
    ));
  }

  return failures.isEmpty ? right(input) : left(failures);
}
```

### Using Value Objects in Entities

Value objects provide safe accessors (see Entity section above for full example):

```dart
// Check if all value objects are valid
bool get isValid => email.isValid && displayName.isValid;

// Safely get value (returns null if invalid)
String? get validEmail => email.getOrNull();

// Get value or throw (use after validation)
String get emailString => email.getOrCrash();

// Get failures for display
List<ValueFailure<String>>? get emailErrors => email.getFailuresOrNull();
```

## Best Practices

### DO ✅

- Use feature-specific ID types (e.g., `UserId`, `ProductId`)
- Validate in value object constructors
- Keep domain layer pure (no I/O, no framework dependencies)
- Use `Either<Failure, T>` for operations that can fail
- Add business logic as methods/getters in entities
- Use plain classes with manual `copyWith()` for entities
- Use `final class` for value objects
- Separate domain entities from DTOs/models
- Keep validation close to data (in value objects)

### DON'T ❌

- Don't use primitive types for IDs (String, int)
- Don't allow invalid state in value objects
- Don't add JSON serialization to domain classes
- Don't depend on infrastructure (database, API)
- Don't mix presentation logic in domain
- Don't use mutable state
- Don't create anemic domain models (data without behavior)
- Don't bypass validation

## Testing Domain Objects

### Testing Entities

```dart
test('Product is expensive when price > 100', () {
  final product = Product(
    id: ProductId.generate(),
    name: 'Test',
    price: 150,
  );

  expect(product.isExpensive, isTrue);
});

test('Product equality by ID', () {
  final id = ProductId.generate();

  final product1 = Product(id: id, name: 'A', price: 10);
  final product2 = Product(id: id, name: 'B', price: 20);

  expect(product1.id, equals(product2.id));
});
```

### Testing Value Objects

```dart
group('EmailAddress', () {
  test('valid email passes', () {
    final email = EmailAddress('test@example.com');

    expect(email.value.isRight(), isTrue);
  });

  test('empty email fails', () {
    final email = EmailAddress('');

    expect(
      email.value.isLeft(),
      isTrue,
    );
  });

  test('invalid format fails', () {
    final email = EmailAddress('notanemail');

    expect(email.isValid, isFalse);
    expect(email.getFailuresOrNull(), isNotNull);
  });
});
```

### Testing with UniqueId

```dart
test('UniqueId generates unique values', () {
  final id1 = UniqueId.generate();
  final id2 = UniqueId.generate();

  expect(id1, isNot(equals(id2)));
});

test('UniqueId equality by value', () {
  final id1 = UniqueId.fromString('123');
  final id2 = UniqueId.fromString('123');

  expect(id1, equals(id2));
});
```

## Common Value Objects

Consider creating these shared value objects:

- `EmailAddress` - Email validation
- `PhoneNumber` - Phone number validation
- `Url` - URL validation
- `PositiveInt` - Positive integer constraint
- `NonNegativeDouble` - Non-negative double
- `DateRange` - Date range validation
- `Percentage` - 0-100 constraint
- `Money` - Currency amount with precision

## References

- Architecture Rules: `docs/architecture-rules/03_domain_layer.md`
- Error Handling: `docs/architecture-rules/08_error_handling.md`
- Data Modeling: `docs/architecture-rules/11_data_modeling.md`
- [Domain-Driven Design Fundamentals](https://martinfowler.com/bliki/DomainDrivenDesign.html)
