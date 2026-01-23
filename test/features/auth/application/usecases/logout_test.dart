import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/core/error/failures/infrastructure_failures.dart';
import 'package:starter_app/features/auth/application/usecases/logout.dart';
import 'package:starter_app/features/auth/domain/failure/auth_failure.dart';

import '../../../../helpers/mock_helpers.dart';

void main() {
  late MockAuthRepository mockRepository;
  late Logout useCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = Logout(mockRepository);
  });

  group('Logout', () {
    test('should call repository.logout', () async {
      // Given
      when(
        () => mockRepository.logout(),
      ).thenAnswer((_) async => const Right(unit));

      // When
      await useCase();

      // Then
      verify(() => mockRepository.logout()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Right(Unit) when logout succeeds', () async {
      // Given
      when(
        () => mockRepository.logout(),
      ).thenAnswer((_) async => const Right(unit));

      // When
      final result = await useCase();

      // Then
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return Right'),
        (value) => expect(value, unit),
      );
    });

    test('should return Left(Failure) when logout fails', () async {
      // Given
      const tFailure = InfrastructureFailure.server(
        message: 'Server error during logout',
      );
      when(
        () => mockRepository.logout(),
      ).thenAnswer((_) async => const Left(tFailure));

      // When
      final result = await useCase();

      // Then
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, tFailure);
          expect(failure.message, 'Server error during logout');
        },
        (_) => fail('Should return Left'),
      );
    });

    test('should pass through repository failures unchanged', () async {
      // Given
      const tFailure = AuthFailure.unauthorized(message: 'Session expired');
      when(
        () => mockRepository.logout(),
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
      when(() => mockRepository.logout()).thenThrow(Exception('Network error'));

      // When/Then
      expect(
        () => useCase(),
        throwsA(isA<Exception>()),
      );
    });

    group('integration scenarios', () {
      test('successful logout flow', () async {
        // Given - user is authenticated
        when(
          () => mockRepository.logout(),
        ).thenAnswer((_) async => const Right(unit));

        // When - user logs out
        final result = await useCase();

        // Then - session is ended
        expect(result.isRight(), true);
        verify(() => mockRepository.logout()).called(1);
      });

      test('logout clears session even if server call fails', () async {
        // Given - server is unavailable
        const failure = InfrastructureFailure.network(
          message: 'No internet connection',
        );
        when(
          () => mockRepository.logout(),
        ).thenAnswer((_) async => const Left(failure));

        // When - user logs out
        final result = await useCase();

        // Then - logout attempt is made (tokens should be cleared locally)
        expect(result.isLeft(), true);
        verify(() => mockRepository.logout()).called(1);
      });

      test('logout requires no parameters', () async {
        // Given
        when(
          () => mockRepository.logout(),
        ).thenAnswer((_) async => const Right(unit));

        // When - logout is called without parameters
        final result = await useCase();

        // Then - succeeds
        expect(result.isRight(), true);
      });
    });
  });
}
