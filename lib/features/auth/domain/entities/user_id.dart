import 'package:starter_app/core/domain/base/unique_id.dart';

/// Type-safe wrapper for [UniqueId] specifically for Users.
///
/// This is a compile-time extension type (zero runtime cost).
/// It prevents accidental usage of other IDs
/// (like OrderId) where a UserId is expected.
extension type const UserId(UniqueId value) implements UniqueId {
  /// Generates a new [UserId].
  factory UserId.generate() => UserId(UniqueId.generate());

  /// Creates a [UserId] from a trusted string.
  factory UserId.fromString(String value) => UserId(UniqueId.fromString(value));

  // No need for operator== or hashCode as extension types
  // delegate to the underlying type at runtime, and UniqueId handles it.
}
