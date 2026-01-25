import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/features/profile/infrastructure/datasources/profile_api_service.dart';

import '../../../../helpers/mock_helpers.dart';

void main() {
  group('ProfileApiService', () {
    late MockChopperClient mockChopperClient;

    setUp(() {
      mockChopperClient = MockChopperClient();
    });

    test('create returns an instance of ProfileApiService', () {
      final service = ProfileApiService.create(mockChopperClient);

      expect(service, isA<ProfileApiService>());
      expect(service.client, mockChopperClient);
    });
  });
}
