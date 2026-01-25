/// Profile API endpoint constants.
abstract final class ProfileEndpoints {
  static const String version = String.fromEnvironment(
    'API_VERSION',
    defaultValue: 'v1',
  );

  static const String profileBasePath = '/api/$version/profiles';

  /// Profile endpoints
  static const String profiles = '/';
  static const String me = '/me';
}
