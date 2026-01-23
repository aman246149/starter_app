import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/core/domain/value_objects/email_address.dart';
import 'package:starter_app/features/auth/application/usecases/check_user_exists.dart';
import 'package:starter_app/features/auth/domain/failure/auth_failure.dart';

import '../../../../helpers/mock_helpers.dart';
import '../../../../helpers/test_data.dart';

void main() {
  late MockAuthRepository mockRepository;
  late CheckUserExists useCase;

  setUpAll(() {
    // Use real value object as fallback - no need to mock value objects
    registerFallbackValue(TestData.emailAddress());
  });

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = CheckUserExists(mockRepository);
  });

  group('CheckUserExists', () {
    final tEmailAddress = TestData.emailAddress();

    test('should call repository.checkUserExists with correct email', () async {
      // Given
      when(
        () => mockRepository.checkUserExists(any()),
      ).thenAnswer((_) async => const Right(true));

      // When
      await useCase(tEmailAddress);

      // Then
      verify(() => mockRepository.checkUserExists(tEmailAddress)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Right(true) when user exists', () async {
      // Given
      when(
        () => mockRepository.checkUserExists(any()),
      ).thenAnswer((_) async => const Right(true));

      // When
      final result = await useCase(tEmailAddress);

      // Then
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return Right'),
        (exists) => expect(exists, true),
      );
    });

    test('should return Right(false) when user does not exist', () async {
      // Given
      when(
        () => mockRepository.checkUserExists(any()),
      ).thenAnswer((_) async => const Right(false));

      // When
      final result = await useCase(tEmailAddress);

      // Then
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return Right'),
        (exists) => expect(exists, false),
      );
    });

    test('should return Left(Failure) when check fails', () async {
      // Given
      const tFailure = AuthFailure.notFound(message: 'Service unavailable');
      when(
        () => mockRepository.checkUserExists(any()),
      ).thenAnswer((_) async => const Left(tFailure));

      // When
      final result = await useCase(tEmailAddress);

      // Then
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, tFailure);
          expect(failure.message, 'Service unavailable');
        },
        (_) => fail('Should return Left'),
      );
    });

    test('should pass through repository failures unchanged', () async {
      // Given
      const tFailure = AuthFailure.unauthorized(message: 'Unauthorized');
      when(
        () => mockRepository.checkUserExists(any()),
      ).thenAnswer((_) async => const Left(tFailure));

      // When
      final result = await useCase(tEmailAddress);

      // Then
      result.fold(
        (failure) => expect(failure, tFailure),
        (_) => fail('Should return Left'),
      );
    });

    test('should handle repository exceptions gracefully', () async {
      // Given
      when(
        () => mockRepository.checkUserExists(any()),
      ).thenThrow(Exception('Network error'));

      // When/Then
      expect(
        () => useCase(tEmailAddress),
        throwsA(isA<Exception>()),
      );
    });

    group('integration scenarios', () {
      test('email-first flow: existing user (should login)', () async {
        // Given - user enters registered email
        when(
          () => mockRepository.checkUserExists(any()),
        ).thenAnswer((_) async => const Right(true));

        // When - check if email exists
        final result = await useCase(tEmailAddress);

        // Then - should redirect to login
        result.fold(
          (_) => fail('Should succeed'),
          (exists) => expect(exists, true),
        );
      });

      test('email-first flow: new user (should register)', () async {
        // Given - user enters unregistered email
        when(
          () => mockRepository.checkUserExists(any()),
        ).thenAnswer((_) async => const Right(false));

        // When - check if email exists
        final result = await useCase(tEmailAddress);

        // Then - should redirect to registration
        result.fold(
          (_) => fail('Should succeed'),
          (exists) => expect(exists, false),
        );
      });

      test('handles different email formats', () async {
        // Given - various email formats
        final emails = [
          EmailAddress('user@example.com'),
          EmailAddress('user.name@example.com'),
          EmailAddress('user+tag@example.com'),
        ];

        when(
          () => mockRepository.checkUserExists(any()),
        ).thenAnswer((_) async => const Right(true));

        // When/Then - all formats are checked correctly
        for (final email in emails) {
          final result = await useCase(email);
          expect(result.isRight(), true);
          verify(() => mockRepository.checkUserExists(email)).called(1);
        }
      });

      test('service error during check', () async {
        // Given - service is temporarily unavailable
        const failure = AuthFailure.notFound(
          message: 'Service temporarily unavailable',
        );
        when(
          () => mockRepository.checkUserExists(any()),
        ).thenAnswer((_) async => const Left(failure));

        // When - user tries to check email
        final result = await useCase(tEmailAddress);

        // Then - error is returned
        expect(result.isLeft(), true);
        result.fold(
          (f) => expect(f.message, contains('unavailable')),
          (_) => fail('Should fail'),
        );
      });
    });
  });
}
