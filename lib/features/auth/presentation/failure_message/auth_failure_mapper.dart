import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:starter_app/core/error/failures/failure.dart';
import 'package:starter_app/core/presentation/failure_message/failure_message_mapper.dart';
import 'package:starter_app/features/auth/domain/failure/auth_failure.dart';
import 'package:starter_app/features/auth/infrastructure/mappers/auth_exception_mapper.dart';
import 'package:starter_app/features/auth/l10n/l10n_extensions.dart';

/// Maps auth failures to user-friendly localized messages.
///
/// Registration is automatic via the base class constructor.
///
/// Named differently from [AuthExceptionMapper] in infrastructure layer
/// to avoid naming conflicts.
@injectable
class AuthFailureMessageMapper extends FailureMessageMapper {
  /// Creates this mapper. Registration is automatic via super constructor.
  AuthFailureMessageMapper(super.registry);

  @override
  bool canHandle(Failure failure) => failure is AuthFailure;

  @override
  String map(BuildContext context, Failure failure) {
    final authFailure = failure as AuthFailure;
    return authFailure.map(
      unauthorized: (_) => context.authL10n.unauthorized,
      forbidden: (_) => context.authL10n.forbidden,
      notFound: (_) => context.authL10n.notFound,
      emailAlreadyInUse: (_) => context.authL10n.emailAlreadyInUse,
      invalidInput: (_) => context.authL10n.invalidInput,
    );
  }
}
