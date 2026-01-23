import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:starter_app/core/error/failures/failure.dart';
import 'package:starter_app/core/error/failures/infrastructure_failures.dart';
import 'package:starter_app/core/l10n/l10n_extensions.dart';
import 'package:starter_app/core/presentation/failure_message/failure_message_mapper.dart';

/// Maps infrastructure failures to user-friendly messages.
///
/// Infrastructure failures are feature-independent and handled centrally.
/// Registered with low priority so feature-specific mappers take precedence.
@singleton
class InfrastructureFailureMapper extends FailureMessageMapper {
  /// Creates this mapper with low priority (feature mappers take precedence).
  InfrastructureFailureMapper(super.registry) : super(highPriority: false);

  @override
  bool canHandle(Failure failure) => failure is InfrastructureFailure;

  @override
  String map(BuildContext context, Failure failure) {
    final infraFailure = failure as InfrastructureFailure;
    return infraFailure.map(
      server: (f) => context.appL10n.serverError,
      network: (_) => context.appL10n.networkError,
      cache: (_) => context.appL10n.cacheError,
      parse: (_) => context.appL10n.parseError,
      circuitBreaker: (_) =>
          context.appL10n.circuitBreakerError
    );
  }
}
