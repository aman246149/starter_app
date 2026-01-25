import 'package:chopper/chopper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/features/profile/infrastructure/datasources/profile_api_service.dart';
import 'package:starter_app/features/profile/infrastructure/datasources/user_profile_remote_data_source.dart';
import 'package:starter_app/features/profile/infrastructure/models/user_profile_model.dart';

import '../../../../helpers/test_data.dart';

class MockProfileApiService extends Mock implements ProfileApiService {}

void main() {
  late UserProfileRemoteDataSourceImpl dataSource;
  late MockProfileApiService mockApiService;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    mockApiService = MockProfileApiService();
    dataSource = UserProfileRemoteDataSourceImpl(mockApiService);
  });

  Response<Map<String, dynamic>> createResponse(Map<String, dynamic>? body) {
    return Response(
      http.Response('', 200),
      body,
    );
  }

  group('UserProfileRemoteDataSourceImpl', () {
    group('getMyProfile', () {
      test('should call API service and return my profile', () async {
        // Arrange
        when(
          () => mockApiService.getMyProfile(),
        ).thenAnswer((_) async => createResponse(TestData.userProfileJson));

        // Act
        final result = await dataSource.getMyProfile();

        // Assert
        expect(result, isA<UserProfileModel>());
        expect(result.displayName, equals(TestData.name));
        verify(() => mockApiService.getMyProfile()).called(1);
      });
    });
  });
}
