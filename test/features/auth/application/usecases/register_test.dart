import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/features/auth/application/usecases/register.dart';
import 'package:starter_app/features/auth/domain/entities/auth_credentials.dart';
import 'package:starter_app/features/auth/domain/entities/user.dart';
import 'package:starter_app/features/auth/domain/failure/auth_failure.dart';
import 'package:starter_app/features/auth/domain/services/user_registration_service.dart';

import '../../../../helpers/mock_helpers.dart';
import '../../../../helpers/test_data.dart';

class MockUserRegistrationService extends Mock
    implements UserRegistrationService {}

void main() {
  late MockUserRegistrationService mockService;
  late Register useCase;

  setUpAll(() {
    registerMockFallbackValues();
    registerFallbackValue(TestData.registerCredentials());
  });

  setUp(() {
    mockService = MockUserRegistrationService();
    useCase = Register(mockService);
  });

  group('Register', () {
    final tCredentials = TestData.registerCredentials();
    final tUser = TestData.user();

    test(
      'should call service.register with credentials',
      () async {
        // Given
        when(
          () => mockService.register(
            credentials: any(named: 'credentials'),
          ),
        ).thenAnswer((_) async => Right(tUser));

        // When
        await useCase(tCredentials);

        // Then
        verify(
          () => mockService.register(credentials: tCredentials),
        ).called(1);
        verifyNoMoreInteractions(mockService);
      },
    );

    test('should return Right(User) when registration succeeds', () async {
      // Given
      when(
        () => mockService.register(
          credentials: any(named: 'credentials'),
        ),
      ).thenAnswer((_) async => Right(tUser));

      // When
      final result = await useCase(tCredentials);

      // Then
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return Right'),
        (user) {
          expect(user, isA<User>());
          expect(user.id.value.value, TestData.userId);
        },
      );
    });

    test('should return Left(AuthFailure) when service fails', () async {
      // Given
      const tFailure = AuthFailure.unauthorized(
        message: 'Email already registered',
      );
      when(
        () => mockService.register(
          credentials: any(named: 'credentials'),
        ),
      ).thenAnswer((_) async => const Left(tFailure));

      // When
      final result = await useCase(tCredentials);

      // Then
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, tFailure);
          expect(failure.message, 'Email already registered');
        },
        (_) => fail('Should return Left'),
      );
    });

    test('should pass credentials with name to service', () async {
      // Given
      AuthCredentials? capturedCredentials;
      when(
        () => mockService.register(
          credentials: any(named: 'credentials'),
        ),
      ).thenAnswer((invocation) async {
        capturedCredentials =
            invocation.namedArguments[const Symbol('credentials')]
                as AuthCredentials;
        return Right(tUser);
      });

      // When
      await useCase(tCredentials);

      // Then
      expect(capturedCredentials, isNotNull);
      expect(capturedCredentials!.name, isNotNull);
      expect(capturedCredentials!.name!.isValid, isTrue);
    });
  });
}
