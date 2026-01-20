import 'package:injectable/injectable.dart';
import 'package:starter_app/core/presentation/failure_message/failure_message_mapper.dart';

/// Registry for failure message mappers.
///
/// This singleton collects all [FailureMessageMapper] implementations
/// automatically via self-registration. Each mapper registers itself
/// when created by the DI container, eliminating manual list maintenance.
///
/// ## Benefits
/// - **Impossible to forget**: Mappers register in their constructor
/// - **Priority control**: Feature mappers registered with high priority
/// - **No manual aggregation**: No need to update a central list
///
/// ## Usage
/// ```dart
/// // In a mapper - register itself when created
/// @injectable
/// class PaymentFailureMapper extends FailureMessageMapper {
///   PaymentFailureMapper(FailureMapperRegistry registry) {
///     registry.register(this);
///   }
/// }
/// ```
@singleton
class FailureMapperRegistry {
  final List<FailureMessageMapper> _mappers = [];

  /// Returns all registered mappers.
  ///
  /// Feature-specific mappers (high priority) are first,
  /// infrastructure mappers (low priority) are last.
  List<FailureMessageMapper> get all => List.unmodifiable(_mappers);

  /// Registers a mapper.
  ///
  /// [highPriority] - If true (default), mapper is inserted at the beginning.
  /// Feature-specific mappers should use high priority to override
  /// infrastructure mappers when handling the same failure type.
  void register(FailureMessageMapper mapper, {bool highPriority = true}) {
    if (highPriority) {
      _mappers.insert(0, mapper);
    } else {
      _mappers.add(mapper);
    }
  }
}
