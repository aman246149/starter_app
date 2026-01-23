import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/features/auth/application/usecases/get_current_user.dart';
import 'package:starter_app/features/auth/domain/failure/auth_failure.dart';

import '../../../../helpers/mock_helpers.dart';
import '../../../../helpers/test_data.dart';

void main() {
  late MockAuthRepository mockRepository;
  late MockEventDispatcher mockEventDispatcher;
  late GetCurrentUser useCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    mockEventDispatcher = MockEventDispatcher();
    useCase = GetCurrentUser(mockRepository, mockEventDispatcher);
  });

  group('GetCurrentUser', () {
    final tUser = TestData.user();

    test('should call repository.getCurrentUser', () async {
      // Given
      when(
        () => mockRepository.getCurrentUser(),
      ).thenAnswer((_) async => Right(tUser));

      // When
      await useCase();

      // Then
      verify(() => mockRepository.getCurrentUser()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Right(User) when user is authenticated', () async {
      // Given
      when(
        () => mockRepository.getCurrentUser(),
      ).thenAnswer((_) async => Right(tUser));

      // When
      final result = await useCase();

      // Then
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return Right'),
        (user) {
          expect(user, tUser);
          expect(user!.id.value.value, 'user-123');
          expect(user.email.getOrCrash(), TestData.email);
        },
      );
    });

    test('should return Right(null) when no user is authenticated', () async {
      // Given
      when(
        () => mockRepository.getCurrentUser(),
      ).thenAnswer((_) async => const Right(null));

      // When
      final result = await useCase();

      // Then
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return Right'),
        (user) => expect(user, null),
      );
    });

    test('should return Left(Failure) when fetching user fails', () async {
      // Given
      const tFailure = AuthFailure.unauthorized(message: 'Token expired');
      when(
        () => mockRepository.getCurrentUser(),
      ).thenAnswer((_) async => const Left(tFailure));

      // When
      final result = await useCase();

      // Then
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, tFailure);
          expect(failure.message, 'Token expired');
        },
        (_) => fail('Should return Left'),
      );
    });

    test('should pass through repository failures unchanged', () async {
      // Given
      const tFailure = AuthFailure.forbidden(message: 'Access denied');
      when(
        () => mockRepository.getCurrentUser(),
      ).thenAnswer((_) async => const Left(tFailure));

      // When
      final result = await useCase();

      // Then
      result.fold(
        (failure) => expect(failure, tFailure),
        (_) => fail('Should return Left'),
      );
    });

    test('should handle repository exceptions gracefully', () async {
      // Given
      when(
        () => mockRepository.getCurrentUser(),
      ).thenThrow(Exception('Network error'));

      // When/Then
      expect(
        () => useCase(),
        throwsA(isA<Exception>()),
      );
    });

    group('integration scenarios', () {
      test('app startup with authenticated user', () async {
        // Given - user has valid token
        when(
          () => mockRepository.getCurrentUser(),
        ).thenAnswer((_) async => Right(tUser));

        // When - app starts and checks auth state
        final result = await useCase();

        // Then - user is authenticated
        result.fold(
          (_) => fail('Should succeed'),
          (user) {
            expect(user, isNotNull);
            expect(user!.email.getOrCrash(), TestData.email);
          },
        );
      });

      test('app startup without authenticated user', () async {
        // Given - no stored token
        when(
          () => mockRepository.getCurrentUser(),
        ).thenAnswer((_) async => const Right(null));

        // When - app starts and checks auth state
        final result = await useCase();

        // Then - no user is authenticated
        result.fold(
          (_) => fail('Should succeed'),
          (user) => expect(user, null),
        );
      });

      test('app startup with expired token', () async {
        // Given - token has expired
        const failure = AuthFailure.unauthorized(
          message: 'Session expired, please login again',
        );
        when(
          () => mockRepository.getCurrentUser(),
        ).thenAnswer((_) async => const Left(failure));

        // When - app starts and checks auth state
        final result = await useCase();

        // Then - should redirect to login
        expect(result.isLeft(), true);
        result.fold(
          (f) => expect(f.message, contains('expired')),
          (_) => fail('Should fail'),
        );
      });

      test('refresh user data', () async {
        // Given - user wants to refresh their profile data
        final updatedUser = TestData.user(
          emailStr: 'updated@example.com',
        );
        when(
          () => mockRepository.getCurrentUser(),
        ).thenAnswer((_) async => Right(updatedUser));

        // When - user pulls to refresh
        final result = await useCase();

        // Then - updated data is fetched
        result.fold(
          (_) => fail('Should succeed'),
          (user) {
            expect(user!.email.getOrCrash(), 'updated@example.com');
          },
        );
      });

      test('requires no parameters', () async {
        // Given
        when(
          () => mockRepository.getCurrentUser(),
        ).thenAnswer((_) async => Right(tUser));

        // When - called without parameters
        final result = await useCase();

        // Then - succeeds
        expect(result.isRight(), true);
      });
    });
  });
}
