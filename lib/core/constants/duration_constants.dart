/// Duration constants for animations, delays, and timeouts.
///
/// Provides standardized timing values to ensure consistent behavior
/// across the application for animations, debouncing, and network operations.
abstract final class DurationConstants {
  // Animation Durations
  /// Extra short animation: 100ms
  static const Duration animationXShort = Duration(milliseconds: 100);

  /// Short animation: 200ms
  static const Duration animationShort = Duration(milliseconds: 200);

  /// Medium animation: 300ms (most common)
  static const Duration animationMedium = Duration(milliseconds: 300);

  /// Long animation: 500ms
  static const Duration animationLong = Duration(milliseconds: 500);

  /// Extra long animation: 800ms
  static const Duration animationXLong = Duration(milliseconds: 800);

  // Page Transitions
  /// Page transition duration: 300ms
  static const Duration pageTransition = animationMedium;

  /// Modal transition duration: 250ms
  static const Duration modalTransition = Duration(milliseconds: 250);

  // User Input Debouncing
  /// Search debounce: 300ms
  static const Duration debounceSearch = animationMedium;

  /// Input debounce: 500ms
  static const Duration debounceInput = animationLong;

  /// Button debounce: 300ms (prevents double-tap)
  static const Duration debounceButton = animationMedium;

  // Throttling
  /// Scroll throttle: 100ms
  static const Duration throttleScroll = Duration(milliseconds: 100);

  /// API request throttle: 1000ms
  static const Duration throttleApi = Duration(milliseconds: 1000);

  // Timeouts
  /// Short timeout: 10 seconds
  static const Duration timeoutShort = Duration(seconds: 10);

  /// Medium timeout: 30 seconds (default for API calls)
  static const Duration timeoutMedium = Duration(seconds: 30);

  /// Long timeout: 60 seconds
  static const Duration timeoutLong = Duration(seconds: 60);

  /// Extra long timeout: 120 seconds (for large uploads)
  static const Duration timeoutXLong = Duration(seconds: 120);

  // Snackbar & Toast
  /// Snackbar short display: 2 seconds
  static const Duration snackbarShort = Duration(seconds: 2);

  /// Snackbar medium display: 4 seconds
  static const Duration snackbarMedium = Duration(seconds: 4);

  /// Snackbar long display: 6 seconds
  static const Duration snackbarLong = Duration(seconds: 6);

  // Loading Indicators
  /// Minimum loading display time: 500ms
  static const Duration loadingMinimum = animationLong;

  /// Loading spinner delay before showing: 200ms
  static const Duration loadingDelay = animationShort;

  // Cache & Storage
  /// Cache expiration short: 5 minutes
  static const Duration cacheExpirationShort = Duration(minutes: 5);

  /// Cache expiration medium: 30 minutes
  static const Duration cacheExpirationMedium = Duration(minutes: 30);

  /// Cache expiration long: 1 hour
  static const Duration cacheExpirationLong = Duration(hours: 1);

  /// Cache expiration extra long: 24 hours
  static const Duration cacheExpirationXLong = Duration(hours: 24);

  // Refresh & Retry
  /// Auto-refresh interval: 5 minutes
  static const Duration autoRefresh = cacheExpirationShort;

  /// Retry delay short: 1 second
  static const Duration retryShort = Duration(seconds: 1);

  /// Retry delay medium: 3 seconds
  static const Duration retryMedium = Duration(seconds: 3);

  /// Retry delay long: 5 seconds
  static const Duration retryLong = Duration(seconds: 5);

  // Splash Screen
  /// Minimum splash screen display: 1 second
  static const Duration splashMinimum = retryShort;

  /// Maximum splash screen display: 3 seconds
  static const Duration splashMaximum = retryMedium;

  // Polling
  /// Polling interval short: 5 seconds
  static const Duration pollingShort = Duration(seconds: 5);

  /// Polling interval medium: 15 seconds
  static const Duration pollingMedium = Duration(seconds: 15);

  /// Polling interval long: 30 seconds
  static const Duration pollingLong = timeoutMedium;

  // Session
  /// Session timeout warning: 5 minutes before expiry
  static const Duration sessionWarning = cacheExpirationShort;

  /// Session timeout: 30 minutes
  static const Duration sessionTimeout = cacheExpirationMedium;
}
