import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/features/profile/application/usecases/get_profile.dart';
import 'package:starter_app/features/profile/domain/failure/profile_failure.dart';

import '../../../../helpers/mock_helpers.dart';
import '../../../../helpers/test_data.dart';

void main() {
  late GetProfile useCase;
  late MockUserProfileRepository mockRepository;

  setUp(() {
    mockRepository = MockUserProfileRepository();
    useCase = GetProfile(mockRepository);
  });

  group('GetProfile', () {
    test('should get current profile from repository', () async {
      // Arrange
      final profile = TestData.userProfile();
      when(
        () => mockRepository.getCurrentProfile(),
      ).thenAnswer((_) async => Right(profile));

      // Act
      final result = await useCase();

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected Right but got Left: $failure'),
        (retrievedProfile) {
          expect(retrievedProfile.id, equals(profile.id));
          expect(retrievedProfile.userId, equals(profile.userId));
          expect(retrievedProfile.displayName, equals(profile.displayName));
        },
      );
      verify(() => mockRepository.getCurrentProfile()).called(1);
    });

    test('should return failure when repository fails', () async {
      // Arrange
      const failure = ProfileFailure.serverError(message: 'Server error');
      when(() => mockRepository.getCurrentProfile()).thenAnswer(
        (_) async => const Left(failure),
      );

      // Act
      final result = await useCase();

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<ProfileFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });

    test('should extend QueryNoParams', () {
      expect(useCase, isA<GetProfile>());
    });
  });
}
