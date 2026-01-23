import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/features/auth/infrastructure/datasources/auth_api_service.dart';

import '../../../../helpers/mock_helpers.dart';

void main() {
  group('AuthApiService', () {
    late MockChopperClient mockChopperClient;

    setUp(() {
      mockChopperClient = MockChopperClient();
      // No need to stub baseUrl as it's set in super constructor,
      // but if we need to override other things we can.
    });

    test('create returns an instance of AuthApiService', () {
      final service = AuthApiService.create(mockChopperClient);

      expect(service, isA<AuthApiService>());
      // Accessing .client might fail if _$AuthApiService does strict checks,
      // but usually it just assigns it.
      expect(service.client, mockChopperClient);
    });
  });
}
