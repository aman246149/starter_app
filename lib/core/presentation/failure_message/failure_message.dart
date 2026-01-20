/// Failure message mapping system.
///
/// This module provides mappers for translating domain failures
/// to user-friendly messages in the presentation layer.
///
/// Mappers are automatically injected via dependency injection.
/// Each feature creates a mapper class and marks it with @injectable.
///
/// Example feature mapper:
/// ```dart
/// @injectable
/// class ProfileFailureMapper extends FailureMessageMapper {
///   @override
///   bool canHandle(Failure failure) => failure is ProfileFailure;
///
///   @override
///   String map(BuildContext context, Failure failure) {
///     final profileFailure = failure as ProfileFailure;
///     return profileFailure.map(
///       notFound: (_) => context.l10n.profileNotFound,
///       // ... other cases
///     );
///   }
/// }
/// ```
///
/// Mappers are injected into BLoCs to create ErrorViewModels:
/// ```dart
/// @injectable
/// class ProfileBloc {
///   ProfileBloc(this._mappers);
///   final List<FailureMessageMapper> _mappers;
///
///   void _handleFailure(Failure failure) {
///     final error = ErrorViewModel.fromFailure(failure, _mappers);
///     emit(state.copyWith(error: error));
///   }
/// }
/// ```
library;

export 'failure_message_mapper.dart';
export 'infrastructure_failure_mapper.dart';
