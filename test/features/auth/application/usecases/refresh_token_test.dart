import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/features/auth/application/usecases/refresh_token.dart';
import 'package:starter_app/features/auth/domain/failure/auth_failure.dart';

import '../../../../helpers/mock_helpers.dart';
import '../../../../helpers/test_data.dart';

void main() {
  late MockAuthRepository mockRepository;
  late RefreshTokenUseCase useCase;

  setUpAll(() {
    registerFallbackValue(TestData.refreshTokenVO());
  });

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = RefreshTokenUseCase(mockRepository);
  });

  group('RefreshTokenUseCase', () {
    final tRefreshToken = TestData.refreshTokenVO();
    final tNewAccessToken = TestData.authToken('new-access-token');

    test('should call repository.refreshToken with correct token', () async {
      // Given
      when(
        () => mockRepository.refreshToken(any()),
      ).thenAnswer((_) async => Right(tNewAccessToken));

      // When
      await useCase(tRefreshToken);

      // Then
      verify(() => mockRepository.refreshToken(tRefreshToken)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Right(AuthToken) when refresh succeeds', () async {
      // Given
      when(
        () => mockRepository.refreshToken(any()),
      ).thenAnswer((_) async => Right(tNewAccessToken));

      // When
      final result = await useCase(tRefreshToken);

      // Then
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return Right'),
        (token) {
          expect(token, tNewAccessToken);
          expect(token.getOrCrash(), 'new-access-token');
        },
      );
    });

    test('should return Left(Failure) when refresh fails', () async {
      // Given
      const tFailure = AuthFailure.unauthorized(
        message: 'Invalid refresh token',
      );
      when(
        () => mockRepository.refreshToken(any()),
      ).thenAnswer((_) async => const Left(tFailure));

      // When
      final result = await useCase(tRefreshToken);

      // Then
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, tFailure);
          expect(failure.message, 'Invalid refresh token');
        },
        (_) => fail('Should return Left'),
      );
    });

    test('should pass through repository failures unchanged', () async {
      // Given
      const tFailure = AuthFailure.forbidden(message: 'Token revoked');
      when(
        () => mockRepository.refreshToken(any()),
      ).thenAnswer((_) async => const Left(tFailure));

      // When
      final result = await useCase(tRefreshToken);

      // Then
      result.fold(
        (failure) => expect(failure, tFailure),
        (_) => fail('Should return Left'),
      );
    });

    test('should handle repository exceptions gracefully', () async {
      // Given
      when(
        () => mockRepository.refreshToken(any()),
      ).thenThrow(Exception('Network error'));

      // When/Then
      expect(
        () => useCase(tRefreshToken),
        throwsA(isA<Exception>()),
      );
    });

    group('integration scenarios', () {
      test('automatic token refresh on 401 response', () async {
        // Given - access token has expired
        when(
          () => mockRepository.refreshToken(any()),
        ).thenAnswer((_) async => Right(tNewAccessToken));

        // When - interceptor calls refresh
        final result = await useCase(tRefreshToken);

        // Then - new token is obtained
        result.fold(
          (_) => fail('Should succeed'),
          (token) => expect(token.getOrCrash(), 'new-access-token'),
        );
      });

      test('refresh token expired requires re-login', () async {
        // Given - refresh token has expired
        const failure = AuthFailure.unauthorized(
          message: 'Refresh token expired, please login again',
        );
        when(
          () => mockRepository.refreshToken(any()),
        ).thenAnswer((_) async => const Left(failure));

        // When - attempt to refresh
        final result = await useCase(tRefreshToken);

        // Then - should redirect to login
        expect(result.isLeft(), true);
        result.fold(
          (f) => expect(f.message, contains('login again')),
          (_) => fail('Should fail'),
        );
      });

      test('refresh token revoked by user', () async {
        // Given - user has revoked all sessions
        const failure = AuthFailure.forbidden(
          message: 'Token has been revoked',
        );
        when(
          () => mockRepository.refreshToken(any()),
        ).thenAnswer((_) async => const Left(failure));

        // When - attempt to refresh
        final result = await useCase(tRefreshToken);

        // Then - should require re-login
        expect(result.isLeft(), true);
        result.fold(
          (f) => expect(f.message, contains('revoked')),
          (_) => fail('Should fail'),
        );
      });

      test('multiple refresh attempts with same token', () async {
        // Given - valid refresh token
        when(
          () => mockRepository.refreshToken(any()),
        ).thenAnswer((_) async => Right(tNewAccessToken));

        // When - multiple refresh calls
        final result1 = await useCase(tRefreshToken);
        final result2 = await useCase(tRefreshToken);

        // Then - both succeed (repository handles token rotation)
        expect(result1.isRight(), true);
        expect(result2.isRight(), true);
        verify(() => mockRepository.refreshToken(tRefreshToken)).called(2);
      });

      test('network error during refresh', () async {
        // Given - network is unavailable
        when(
          () => mockRepository.refreshToken(any()),
        ).thenThrow(Exception('No internet connection'));

        // When/Then - exception is propagated
        expect(
          () => useCase(tRefreshToken),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
