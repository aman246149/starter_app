import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/features/auth/application/usecases/login.dart';
import 'package:starter_app/features/auth/domain/entities/user.dart';
import 'package:starter_app/features/auth/domain/events/auth_events.dart';
import 'package:starter_app/features/auth/domain/failure/auth_failure.dart';

import '../../../../helpers/mock_helpers.dart';
import '../../../../helpers/test_data.dart';

void main() {
  late MockAuthRepository mockRepository;
  late MockEventDispatcher mockDispatcher;
  late Login useCase;

  setUpAll(() {
    registerFallbackValue(TestData.loginCredentials());
    registerFallbackValue(FakeDomainEvent());
  });

  setUp(() {
    mockRepository = MockAuthRepository();
    mockDispatcher = MockEventDispatcher();
    useCase = Login(mockRepository, mockDispatcher);
  });

  group('Login', () {
    final tCredentials = TestData.loginCredentials();
    final tUser = TestData.user();

    test('should call repository.login and dispatch event', () async {
      // Given
      when(
        () => mockRepository.login(any()),
      ).thenAnswer((_) async => Right(tUser));

      // When
      await useCase(tCredentials);

      // Then
      verify(() => mockRepository.login(tCredentials)).called(1);
      verify(
        () => mockDispatcher.dispatch(any(that: isA<UserLoggedIn>())),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Right(User) when login succeeds', () async {
      // Given
      when(
        () => mockRepository.login(any()),
      ).thenAnswer((_) async => Right(tUser));

      // When
      final result = await useCase(tCredentials);

      // Then
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return Right'),
        (user) {
          expect(user, isA<User>());
          expect(user.id.value.value, 'user-123');
        },
      );
    });

    test('should return Left(AuthFailure) when login fails', () async {
      // Given
      const tFailure = AuthFailure.unauthorized(message: 'Invalid credentials');
      when(
        () => mockRepository.login(any()),
      ).thenAnswer((_) async => const Left(tFailure));

      // When
      final result = await useCase(tCredentials);

      // Then
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, tFailure);
          expect((failure as AuthFailure).message, 'Invalid credentials');
        },
        (_) => fail('Should return Left'),
      );
    });

    test('should pass through repository failures unchanged', () async {
      // Given
      const tFailure = AuthFailure.forbidden(message: 'Account suspended');
      when(
        () => mockRepository.login(any()),
      ).thenAnswer((_) async => const Left(tFailure));

      // When
      final result = await useCase(tCredentials);

      // Then
      result.fold(
        (failure) => expect(failure, tFailure),
        (_) => fail('Should return Left'),
      );
    });

    test('should handle repository exceptions gracefully', () async {
      // Given
      when(
        () => mockRepository.login(any()),
      ).thenThrow(Exception('Network error'));

      // When/Then
      expect(
        () => useCase(tCredentials),
        throwsA(isA<Exception>()),
      );
    });

    group('integration scenarios', () {
      test('successful login flow', () async {
        // Given - user has valid credentials
        when(
          () => mockRepository.login(any()),
        ).thenAnswer((_) async => Right(tUser));

        // When - user attempts to login
        final result = await useCase(tCredentials);

        // Then - user is authenticated
        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should succeed'),
          (user) {
            expect(user.email.getOrCrash(), TestData.email);
          },
        );
      });

      test('failed login with invalid credentials', () async {
        // Given - user has invalid credentials
        const failure = AuthFailure.unauthorized(
          message: 'Invalid email or password',
        );
        when(
          () => mockRepository.login(any()),
        ).thenAnswer((_) async => const Left(failure));

        // When - user attempts to login
        final result = await useCase(tCredentials);

        // Then - login fails with appropriate error
        expect(result.isLeft(), true);
        result.fold(
          (f) => expect((f as AuthFailure).message, contains('Invalid')),
          (_) => fail('Should fail'),
        );
      });
    });
  });
}
