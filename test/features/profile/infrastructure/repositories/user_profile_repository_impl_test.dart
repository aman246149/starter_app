import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/core/error/exception_handler.dart';
import 'package:starter_app/features/profile/domain/entities/user_profile.dart';
import 'package:starter_app/features/profile/infrastructure/datasources/user_profile_remote_data_source.dart';
import 'package:starter_app/features/profile/infrastructure/repositories/user_profile_repository_impl.dart';

import '../../../../helpers/test_data.dart';

class MockUserProfileRemoteDataSource extends Mock
    implements IUserProfileRemoteDataSource {}

class FakeExceptionHandler extends ExceptionHandler {
  const FakeExceptionHandler();
}

void main() {
  late UserProfileRepositoryImpl repository;
  late MockUserProfileRemoteDataSource mockDataSource;
  late ExceptionHandler exceptionHandler;

  setUpAll(() {
    registerFallbackValue(TestData.userProfileModel);
  });

  setUp(() {
    mockDataSource = MockUserProfileRemoteDataSource();
    exceptionHandler = const FakeExceptionHandler();
    repository = UserProfileRepositoryImpl(
      mockDataSource,
      exceptionHandler,
    );
  });

  group('UserProfileRepositoryImpl', () {
    group('create', () {
      test('should call remote data source and return domain entity', () async {
        // Arrange
        final profile = TestData.userProfile();
        when(
          () => mockDataSource.create(any()),
        ).thenAnswer((_) async => TestData.userProfileModel);

        // Act
        final result = await repository.create(profile);

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected Right but got Left: $failure'),
          (createdProfile) {
            expect(createdProfile, isA<UserProfile>());
            expect(createdProfile.displayName.getOrCrash(), TestData.name);
          },
        );
        verify(() => mockDataSource.create(any())).called(1);
      });
    });



    group('getCurrentProfile', () {
      test('should call remote data source getMyProfile', () async {
        // Arrange
        when(
          () => mockDataSource.getMyProfile(),
        ).thenAnswer((_) async => TestData.userProfileModel);

        // Act
        final result = await repository.getCurrentProfile();

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected Right but got Left: $failure'),
          (profile) {
            expect(profile, isA<UserProfile>());
            expect(profile.displayName.getOrCrash(), equals(TestData.name));
          },
        );
        verify(() => mockDataSource.getMyProfile()).called(1);
      });
    });
  });
}
