import 'package:flutter/material.dart';
import 'package:starter_app/core/error/failures/failure.dart';
import 'package:starter_app/core/presentation/failure_message/failure_mapper_registry.dart';

/// Maps failures to user-friendly messages.
///
/// This is a presentation layer concern - failures in the domain layer
/// remain framework-agnostic and don't know about BuildContext.
///
/// Each feature provides its own mapper implementation to handle
/// feature-specific failures. The mapper **automatically registers itself**
/// with the [FailureMapperRegistry] when created
/// no manual registration needed.
///
/// ## Creating a New Mapper
///
/// 1. Extend this class
/// 2. Add `@injectable` annotation
/// 3. Call `super(registry)` in constructor
/// 4. Implement [canHandle] and [map]
///
/// That's it! Registration is automatic and impossible to forget.
///
/// ## Example
///
/// ```dart
/// @injectable
/// class PaymentFailureMapper extends FailureMessageMapper {
///   // Just pass registry to super - registration is automatic!
///   PaymentFailureMapper(super.registry);
///
///   @override
///   bool canHandle(Failure failure) => failure is PaymentFailure;
///
///   @override
///   String map(BuildContext context, Failure failure) {
///     final f = failure as PaymentFailure;
///     return f.map(
///       insufficientFunds: (_) => context.l10n.insufficientFunds,
///       cardDeclined: (_) => context.l10n.cardDeclined,
///     );
///   }
/// }
/// ```
///
/// ## Priority
///
/// By default, mappers are registered with high priority (feature-specific).
/// For infrastructure/fallback mappers, use `highPriority: false`:
///
/// ```dart
/// InfrastructureFailureMapper(super.registry, highPriority: false);
/// ```
abstract class FailureMessageMapper {
  /// Creates and automatically registers this mapper with the registry.
  ///
  /// [registry] - The failure mapper registry (injected by DI)
  /// [highPriority] - If true (default), this mapper takes precedence.
  ///   Use false for infrastructure/fallback mappers.
  FailureMessageMapper(
    FailureMapperRegistry registry, {
    bool highPriority = true,
  }) {
    registry.register(this, highPriority: highPriority);
  }

  /// Returns true if this mapper can handle the given failure type.
  bool canHandle(Failure failure);

  /// Maps a failure to a user-friendly message.
  ///
  /// Only called if [canHandle] returns true for this failure.
  String map(BuildContext context, Failure failure);
}
