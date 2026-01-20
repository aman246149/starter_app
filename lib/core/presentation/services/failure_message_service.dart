import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:starter_app/core/error/failures/failure.dart';
import 'package:starter_app/core/l10n/l10n_extensions.dart';
import 'package:starter_app/core/logging/i_app_logger.dart';
import 'package:starter_app/core/presentation/failure_message/failure_mapper_registry.dart';
import 'package:starter_app/core/presentation/failure_message/failure_message_mapper.dart';

/// Service for translating domain failures to localized messages.
///
/// This service is injected into the UI layer to translate failures
/// to user-friendly localized messages. It uses the [FailureMapperRegistry]
/// which automatically collects all registered mappers.
///
/// Usage:
/// ```dart
/// // In UI (BlocListener)
/// BlocListener<AuthBloc, AuthState>(
///   listener: (context, state) {
///     if (state.error != null) {
///       final service = context.read<FailureMessageService>();
///       final message = state.error!.getMessage(context, service);
///       showSnackBar(message);
///     }
///   },
/// )
/// ```
@lazySingleton
class FailureMessageService {
  /// Creates a failure message service with the mapper registry.
  ///
  /// Mappers self-register with the registry when created by DI,
  /// eliminating the need for manual list maintenance.
  FailureMessageService(this._registry, this._logger);

  final FailureMapperRegistry _registry;
  final IAppLogger _logger;

  /// Cache for O(1) mapper lookup after first resolution.
  ///
  /// Maps failure runtime type to its corresponding mapper.
  /// This avoids repeated O(n) searches for frequently shown failures.
  final Map<Type, FailureMessageMapper> _mapperCache = {};

  /// Translates a domain failure to a localized user-friendly message.
  ///
  /// Uses cached mapper for O(1) lookup if available, otherwise performs
  /// O(n) search and caches the result. Falls back to generic error if
  /// no mapper found.
  ///
  /// This is typically called by ErrorModel.getMessage() in the UI layer.
  String getLocalizedMessage(BuildContext context, Failure failure) {
    final failureType = failure.runtimeType;

    // O(1) cache lookup - fast path for repeated failures
    final cachedMapper = _mapperCache[failureType];
    if (cachedMapper != null) {
      return _mapWithErrorHandling(context, failure, cachedMapper);
    }

    // O(n) search - only happens once per failure type
    // Registry returns mappers in priority order (feature-specific first)
    final mappers = _registry.all;
    for (final mapper in mappers) {
      if (mapper.canHandle(failure)) {
        // Cache for future O(1) lookups
        _mapperCache[failureType] = mapper;
        return _mapWithErrorHandling(context, failure, mapper);
      }
    }

    // No mapper found - log and use fallback
    _logger.warning(
      'No mapper found for failure type: $failureType. '
      'Using generic error message. '
      'Consider creating a mapper for this failure type.',
    );
    return context.appL10n.unexpectedError;
  }

  /// Maps a failure using the given mapper with error handling.
  ///
  /// If the mapper throws an exception, logs the error and returns
  /// a generic error message instead of crashing the app.
  String _mapWithErrorHandling(
    BuildContext context,
    Failure failure,
    FailureMessageMapper mapper,
  ) {
    try {
      return mapper.map(context, failure);
    } on Exception catch (e, stackTrace) {
      // If mapper throws, log and use fallback
      _logger.error(
        'Mapper ${mapper.runtimeType} failed to map $failure',
        error: e,
        stackTrace: stackTrace,
      );
      return context.appL10n.unexpectedError;
    }
  }
}
