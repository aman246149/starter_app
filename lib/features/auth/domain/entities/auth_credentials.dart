import 'package:meta/meta.dart';

import 'package:starter_app/core/domain/value_objects/email_address.dart';
import 'package:starter_app/core/domain/value_objects/name.dart';
import 'package:starter_app/core/domain/value_objects/password.dart';

/// Authentication credentials data holder.
///
/// This is NOT an entity (no identity, doesn't persist).
/// It's a simple immutable data class for passing validated credentials
/// between layers.
///
/// Both email and password are validated value objects, ensuring
/// only valid credentials can be created.
///
/// For login, only email and password are required.
/// For registration, name is also required.
///
/// Example:
/// ```dart
/// // Login credentials
/// final loginCredentials = AuthCredentials(
///   email: EmailAddress(event.email),
///   password: Password(event.password),
/// );
///
/// // Registration credentials
/// final registerCredentials = AuthCredentials(
///   email: EmailAddress(event.email),
///   password: Password(event.password),
///   name: Name(event.name),
/// );
/// ```
@immutable
class AuthCredentials {
  /// Creates authentication credentials.
  ///
  /// Both email and password must be valid value objects.
  /// Name is optional (only required for registration).
  const AuthCredentials({
    required this.email,
    required this.password,
    this.name,
  });

  /// User's email address (validated).
  final EmailAddress email;

  /// User's password (validated).
  final Password password;

  /// User's name (validated, optional - only for registration).
  final Name? name;

  /// Whether credentials are valid for login (email + password).
  bool get isValidForLogin => email.isValid && password.isValid;

  /// Whether credentials are valid for registration (email + password + name).
  bool get isValidForRegistration =>
      isValidForLogin && (name?.isValid ?? false);

  /// Gets the raw email string (throws if invalid).
  String get emailValue => email.getOrCrash();

  /// Gets the raw password string (throws if invalid).
  String get passwordValue => password.getOrCrash();

  /// Gets the raw name string (throws if invalid or null).
  String? get nameValue => name?.getOrCrash();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthCredentials &&
          runtimeType == other.runtimeType &&
          email == other.email &&
          password == other.password &&
          name == other.name;

  @override
  int get hashCode => Object.hash(email, password, name);

  @override
  String toString() =>
      'AuthCredentials(email: ${email.getOrNull() ?? "invalid"}, '
      'password: ${password.isValid ? "****" : "invalid"}, '
      'name: ${name?.getOrNull() ?? "not provided"})';
}
