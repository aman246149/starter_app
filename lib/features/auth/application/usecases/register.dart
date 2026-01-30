import 'package:injectable/injectable.dart';

import 'package:starter_app/core/domain/base/command.dart';
import 'package:starter_app/core/types/types.dart';
import 'package:starter_app/features/auth/domain/entities/auth_credentials.dart';
import 'package:starter_app/features/auth/domain/entities/user.dart';
import 'package:starter_app/features/auth/domain/services/user_registration_service.dart';

/// Command for registering a new user account.
///
/// Orchestrates the registration process using [UserRegistrationService].
/// Credentials must include name for registration
/// (use [AuthCredentials.isValidForRegistration]).
@injectable
class Register extends Command<AuthCredentials, User> {
  const Register(this._registrationService);

  final UserRegistrationService _registrationService;

  /// Registers a new user with provided credentials (including name).
  ///
  /// Returns:
  /// - [Right(User)] on successful registration
  /// - [Left(Failure)] if validation fails or registration fails
  @override
  FutureResult<User> call(AuthCredentials credentials) async {
    // Delegate to Domain Service
    return _registrationService.register(credentials: credentials);
  }
}
