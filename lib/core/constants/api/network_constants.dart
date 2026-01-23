/// Network and retry configuration constants.
abstract final class NetworkConstants {
  // Retry Configuration
  /// Maximum number of retry attempts: 3
  static const int maxRetryAttempts = 3;

  /// Initial retry delay: 1 second
  static const Duration initialRetryDelay = Duration(seconds: 1);

  /// Maximum retry delay: 10 seconds
  static const Duration maxRetryDelay = Duration(seconds: 10);

  /// Retry delay multiplier for exponential backoff: 2
  static const int retryDelayMultiplier = 2;

  // Connection Settings
  /// Connection timeout: 30 seconds
  static const Duration connectionTimeout = Duration(seconds: 30);

  /// Receive timeout: 30 seconds
  static const Duration receiveTimeout = Duration(seconds: 30);

  /// Send timeout: 30 seconds
  static const Duration sendTimeout = Duration(seconds: 30);

  // Cache Settings
  /// Enable caching for GET requests
  static const bool enableCaching = true;

  /// Cache max age: 5 minutes
  static const Duration cacheMaxAge = Duration(minutes: 5);
}
