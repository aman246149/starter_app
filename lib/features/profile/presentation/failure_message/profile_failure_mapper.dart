import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:starter_app/core/error/failures/failure.dart';
import 'package:starter_app/core/presentation/failure_message/failure_message_mapper.dart';
import 'package:starter_app/features/profile/domain/failure/profile_failure.dart';
import 'package:starter_app/features/profile/l10n/l10n_extensions.dart';

/// Maps profile failures to user-friendly localized messages.
///
/// Registration is automatic via the base class constructor.
@injectable
final class ProfileFailureMapper extends FailureMessageMapper {
  ProfileFailureMapper(super.registry);

  @override
  bool canHandle(Failure failure) => failure is ProfileFailure;

  @override
  String map(BuildContext context, Failure failure) {
    final l10n = context.profileL10n;
    final profileFailure = failure as ProfileFailure;
    return profileFailure.map(
      unexpected: (_) => l10n.unexpectedError,
      serverError: (_) => l10n.serverError,
      notFound: (_) => l10n.notFound,
    );
  }
}
