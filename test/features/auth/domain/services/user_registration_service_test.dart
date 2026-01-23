import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/core/domain/base/domain_event.dart';
import 'package:starter_app/core/error/failures/infrastructure_failures.dart';
import 'package:starter_app/features/auth/domain/entities/auth_credentials.dart';
import 'package:starter_app/features/auth/domain/events/auth_events.dart';
import 'package:starter_app/features/auth/domain/services/user_registration_service.dart';

import '../../../../helpers/mock_helpers.dart';
import '../../../../helpers/test_data.dart';

void main() {
  late UserRegistrationService service;
  late MockAuthRepository mockAuthRepository;
  late MockEventDispatcher mockEventDispatcher;

  setUpAll(registerMockFallbackValues);

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockEventDispatcher = MockEventDispatcher();
    service = UserRegistrationService(
      mockAuthRepository,
      mockEventDispatcher,
    );
  });

  group('UserRegistrationService', () {
    final name = TestData.nameVO();
    final user = TestData.user();

    // Create credentials with name for registration
    AuthCredentials registrationCredentials() => AuthCredentials(
      email: TestData.emailAddress(),
      password: TestData.passwordVO(),
      name: name,
    );

    group('register', () {
      test(
        'successfully registers user when credentials include name',
        () async {
          // Arrange
          final credentials = registrationCredentials();
          when(
            () => mockAuthRepository.register(any()),
          ).thenAnswer((_) async => Right(user));
          when(() => mockEventDispatcher.dispatch(any())).thenReturn(null);

          // Act
          final result = await service.register(credentials: credentials);

          // Assert
          expect(result.isRight(), true);
          result.fold(
            (failure) => fail('Expected Right but got Left: $failure'),
            (registeredUser) => expect(registeredUser, user),
          );

          verify(() => mockAuthRepository.register(any())).called(1);
          verify(
            () =>
                mockEventDispatcher.dispatch(any(that: isA<UserRegistered>())),
          ).called(1);
        },
      );

      test('returns failure when auth registration fails', () async {
        // Arrange
        final credentials = registrationCredentials();
        const failure = InfrastructureFailure.server(
          message: 'Registration failed',
        );
        when(
          () => mockAuthRepository.register(any()),
        ).thenAnswer((_) async => const Left(failure));

        // Act
        final result = await service.register(credentials: credentials);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (f) => expect(f, failure),
          (_) => fail('Expected Left but got Right'),
        );

        verify(() => mockAuthRepository.register(any())).called(1);
        verifyNever(() => mockEventDispatcher.dispatch(any()));
      });

      test('dispatches UserRegistered event on success', () async {
        // Arrange
        final credentials = registrationCredentials();
        DomainEvent? dispatchedEvent;
        when(
          () => mockAuthRepository.register(any()),
        ).thenAnswer((_) async => Right(user));
        when(() => mockEventDispatcher.dispatch(any())).thenAnswer((
          invocation,
        ) {
          dispatchedEvent = invocation.positionalArguments[0] as DomainEvent;
        });

        // Act
        await service.register(credentials: credentials);

        // Assert
        expect(dispatchedEvent, isA<UserRegistered>());
        expect((dispatchedEvent! as UserRegistered).user, user);
      });
    });
  });
}
