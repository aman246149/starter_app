/// Port interface for data filtering before external transmission.
///
/// Used to sanitize data before sending to external services
/// (error reporters, analytics, logging aggregators, etc.).
///
/// **Implementations:**
/// - `SensitiveDataFilter` - Filters sensitive fields like passwords, tokens
abstract class IDataFilter {
  /// Filter data, returning a sanitized copy.
  ///
  /// [data] The map to filter.
  /// Returns a new map with sensitive values redacted.
  Map<String, dynamic> filter(Map<String, dynamic> data);

  /// Check if a key indicates data that should be filtered.
  ///
  /// [key] The key to check.
  /// Returns true if the key should be filtered.
  bool shouldFilter(String key);
}
