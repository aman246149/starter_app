import 'package:freezed_annotation/freezed_annotation.dart';

part 'value_failure.freezed.dart';

/// Represents generic validation failures for value objects.
///
/// These are ONLY truly generic failures that apply across all domains.
/// Domain-specific failures (email, URL, etc.) should be defined alongside
/// their respective value objects.
///
/// Example:
/// ```dart
/// // Generic validation
/// if (input.isEmpty) {
///   return left(const ValueFailure.empty());
/// }
///
/// // Domain-specific validation should be in its own failure type
/// // See: lib/core/domain/value_objects/ for examples
/// ```
@freezed
class ValueFailure<T> with _$ValueFailure<T> {
  /// Value is null or empty.
  const factory ValueFailure.empty({
    String? fieldName,
  }) = Empty<T>;

  /// Value is shorter than the minimum required length.
  const factory ValueFailure.tooShort({
    required int minLength,
    required int actualLength,
  }) = TooShort<T>;

  /// Value exceeds the maximum allowed length.
  const factory ValueFailure.tooLong({
    required int maxLength,
    required int actualLength,
  }) = TooLong<T>;

  /// Value doesn't match the expected format/pattern.
  const factory ValueFailure.invalidFormat({
    required String expectedFormat,
    required String failedValue,
  }) = InvalidFormat<T>;

  /// Value is outside the valid numeric range.
  const factory ValueFailure.outOfRange({
    required num min,
    required num max,
    required num actual,
  }) = OutOfRange<T>;
}
