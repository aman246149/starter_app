/// Authentication API endpoint constants.
///
/// Feature-specific endpoint paths for the auth module.
/// These are separate from the general API endpoints to follow
/// the feature-first architecture pattern.
///
/// **Usage in Chopper Services:**
/// ```dart
/// @POST(path: AuthEndpoints.login)
/// Future<Response<Map<String, dynamic>>> login(@Body() Map data);
/// ```
///
/// **Adding New Endpoints:**
/// ```dart
/// static const String newEndpoint = '$authBasePath/new-endpoint';
/// ```
abstract final class AuthEndpoints {
  /// API version from environment configuration.
  /// Defaults to 'v1' if not specified.
  static const String version = String.fromEnvironment(
    'API_VERSION',
    defaultValue: 'v1',
  );

  /// Base auth API path with version.
  /// Example: '/api/v1/auth'
  static const String authBasePath = '/api/$version/auth';

  // ══════════════════════════════════════════════════════════════════════════
  // Authentication Endpoints (Relative paths only)
  // ══════════════════════════════════════════════════════════════════════════

  /// Login endpoint: '/login'
  static const String login = '/login';

  /// Logout endpoint: '/logout'
  static const String logout = '/logout';

  /// Register/Sign up endpoint: '/register'
  static const String register = '/register';

  /// Refresh token endpoint: '/refresh'
  static const String refreshToken = '/refresh';

  /// Get current user profile: '/me'
  static const String currentUser = '/me';

  /// Check if user exists endpoint: '/check-user-exists'
  static const String checkUserExists = '/check-user-exists';
}
