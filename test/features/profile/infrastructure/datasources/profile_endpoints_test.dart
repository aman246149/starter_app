import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/features/profile/infrastructure/datasources/profile_endpoints.dart';

void main() {
  group('ProfileEndpoints', () {
    test('has correct version', () {
      // Default value from String.fromEnvironment
      expect(ProfileEndpoints.version, isNotEmpty);
    });

    test('has correct profileBasePath', () {
      expect(
        ProfileEndpoints.profileBasePath,
        contains('/api/'),
      );
      expect(
        ProfileEndpoints.profileBasePath,
        contains('/profiles'),
      );
    });

    test('profiles endpoint is correct', () {
      expect(ProfileEndpoints.profiles, equals('/'));
    });

    test('currentProfile endpoint is correct', () {
      expect(ProfileEndpoints.me, equals('/me'));
    });
  });
}
