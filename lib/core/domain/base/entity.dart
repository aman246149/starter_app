import 'package:meta/meta.dart';
import 'package:starter_app/core/domain/base/unique_id.dart';

/// Base interface for all domain entities.
///
/// An entity is a domain object with a distinct identity that persists
/// over time, identified by its [id].
///
/// Entities use [UniqueId] (or feature-specific ID types like `UserId`)
/// instead of primitive strings to avoid primitive obsession.
///
/// ## Implementation Pattern
///
/// Entities in this project use plain classes with manual `copyWith`:
///
/// ```dart
/// class User extends AggregateRoot {
///   User({required this.id,
///   required this.email,
///   required this.isEmailVerified});
///
///   @override
///   final UserId id;
///   final EmailAddress email;
///   final bool isEmailVerified;
///
///   /// Business method that returns new instance + emits event.
///   User verifyEmail() {
///     if (isEmailVerified) return this;
///     final updated = copyWith(isEmailVerified: true);
///     updated.addDomainEvent(UserEmailVerified(updated));
///     return updated;
///   }
///
///   User copyWith({UserId? id, EmailAddress? email, bool? isEmailVerified}) {
///     return User(
///       id: id ?? this.id,
///       email: email ?? this.email,
///       isEmailVerified: isEmailVerified ?? this.isEmailVerified,
///     );
///   }
/// }
/// ```
///
/// ## Equality
///
/// Entity equality is based on [id] and [runtimeType].
@immutable
abstract class Entity {
  /// The unique identifier for this entity.
  ///
  /// This ID must be unique within the entity's domain.
  UniqueId get id;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Entity && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => Object.hash(runtimeType, id);
}
