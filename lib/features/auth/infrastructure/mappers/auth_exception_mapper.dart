import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:starter_app/core/error/exceptions/server_exception.dart';
import 'package:starter_app/core/error/failures/failure.dart';
import 'package:starter_app/core/error/failures/infrastructure_failures.dart';
import 'package:starter_app/core/error/i_exception_mapper.dart';
import 'package:starter_app/features/auth/domain/failure/auth_failure.dart';

/// Maps [ServerException] to authentication-specific failures.
///
/// This mapper implements [IExceptionMapper] and provides domain-specific
/// mapping for authentication-related HTTP errors.
///
/// Status code mapping:
/// - 401 Unauthorized → [AuthFailure.unauthorized]
/// - 403 Forbidden → [AuthFailure.forbidden]
/// - 404 Not Found → [AuthFailure.notFound]
/// - Other 4xx/5xx → [InfrastructureFailure.server]
@injectable
class AuthExceptionMapper implements IExceptionMapper {
  const AuthExceptionMapper();

  @override
  Failure mapToFailure(ServerException exception) {
    return switch (exception.statusCode) {
      HttpStatus.badRequest => AuthFailure.invalidInput(
        message: exception.message,
      ),
      HttpStatus.unauthorized => AuthFailure.unauthorized(
        message: exception.message,
      ),
      HttpStatus.forbidden => AuthFailure.forbidden(
        message: exception.message,
      ),
      HttpStatus.notFound => AuthFailure.notFound(
        message: exception.message,
      ),
      HttpStatus.conflict => const AuthFailure.emailAlreadyInUse(),
      _ => InfrastructureFailure.server(
        message: exception.message,
        statusCode: exception.statusCode,
      ),
    };
  }
}
