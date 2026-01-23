import 'package:injectable/injectable.dart';

import 'package:starter_app/core/domain/base/query.dart';
import 'package:starter_app/core/domain/value_objects/email_address.dart';
import 'package:starter_app/core/types/types.dart';
import 'package:starter_app/features/auth/domain/repositories/i_auth_repository.dart';

/// Query for checking if a user
/// with a given email address is already registered.
///
/// This is a **read operation** (Query) that doesn't mutate application state.
/// Part of the email-first authentication flow.
/// This is called after the user enters their email to determine
/// whether to show the login or registration form.
@injectable
class CheckUserExists extends Query<EmailAddress, bool> {
  const CheckUserExists(this._repository);

  final IAuthRepository _repository;

  /// Checks if the provided email is registered.
  ///
  /// Returns:
  /// - [Right(true)] if user exists (user should login)
  /// - [Right(false)] if user doesn't exist (user should register)
  /// - [Left(Failure)] if validation fails or check fails
  @override
  FutureResult<bool> call(EmailAddress email) async {
    // Delegate to repository
    return _repository.checkUserExists(email);
  }
}
