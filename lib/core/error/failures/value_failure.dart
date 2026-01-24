import 'package:starter_app/core/error/failures/failures.dart';

/// Abstract base class for all domain validation failures.
///
/// Value failures represent validation errors for value objects in the domain
/// layer. Unlike [TechnicalFailure] which represents infrastructure/technical
/// errors with retry capability, value failures are business rule violations
/// that typically require user correction.
///
/// Each domain concept has its own specific failure type:
/// - [PasswordFailure] - Password validation errors
/// - [EmailFailure] - Email validation errors
/// - [NameFailure] - Name validation errors
/// - [TokenFailure] - Token validation errors
/// - [UniqueIdFailure] - Unique ID validation errors
///
/// Example:
/// ```dart
/// // In Password value object
/// if (!_uppercaseRegex.hasMatch(input)) {
///   failures.add(const PasswordFailure.missingUppercase());
/// }
///
/// // In UI mapper
/// final message = failure.when(
///   missingUppercase: () => context.l10n.passwordMissingUppercase,
///   // ...
/// );
/// ```
///
/// The type parameter [T] represents the underlying value type being validated
/// (e.g., String for passwords, emails).
abstract class ValueFailure<T> extends Failure {
  /// Creates a [ValueFailure].
  const ValueFailure();
}
