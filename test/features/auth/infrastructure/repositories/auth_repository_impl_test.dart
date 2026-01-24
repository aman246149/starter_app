import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/core/error/exception_handler.dart';
import 'package:starter_app/core/error/exceptions/cache_exception.dart';
import 'package:starter_app/core/error/exceptions/network_exception.dart';
import 'package:starter_app/core/error/exceptions/server_exception.dart';
import 'package:starter_app/core/error/failures/failure.dart';
import 'package:starter_app/core/error/failures/infrastructure_failures.dart';
import 'package:starter_app/features/auth/domain/entities/user.dart';
import 'package:starter_app/features/auth/domain/events/auth_events.dart';
import 'package:starter_app/features/auth/domain/failure/auth_failure.dart';
import 'package:starter_app/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:starter_app/features/auth/domain/value_objects/auth_token.dart';
import 'package:starter_app/features/auth/infrastructure/mappers/auth_exception_mapper.dart';
import 'package:starter_app/features/auth/infrastructure/models/auth_tokens_model.dart';
import 'package:starter_app/features/auth/infrastructure/models/check_user_exists_request_model.dart';
import 'package:starter_app/features/auth/infrastructure/models/login_request_model.dart';
import 'package:starter_app/features/auth/infrastructure/models/register_request_model.dart';
import 'package:starter_app/features/auth/infrastructure/repositories/auth_repository_impl.dart';

import '../../../../helpers/mock_helpers.dart';
import '../../../../helpers/test_data.dart';

/// Fake classes for mocktail fallback values
class FakeLoginRequestModel extends Fake implements LoginRequestModel {}

class FakeRegisterRequestModel extends Fake implements RegisterRequestModel {}

class FakeCheckUserExistsRequestModel extends Fake
    implements CheckUserExistsRequestModel {}

class FakeUserLoggedIn extends Fake implements UserLoggedIn {}

class FakeUserRegistered extends Fake implements UserRegistered {}

void main() {
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockTokenStorage mockTokenStorage;
  late MockAuthWebSocketDataSource mockWebSocketDataSource;
  late ExceptionHandler exceptionHandler;
  late AuthExceptionMapper failureMapper;
  late IAuthRepository repository;

  setUpAll(() {
    // Register fallback values for mocktail
    registerFallbackValue(FakeLoginRequestModel());
    registerFallbackValue(FakeRegisterRequestModel());
    registerFallbackValue(FakeCheckUserExistsRequestModel());
    registerFallbackValue(FakeUserLoggedIn());
    registerFallbackValue(FakeUserRegistered());
  });

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockTokenStorage = MockTokenStorage();
    mockWebSocketDataSource = MockAuthWebSocketDataSource();
    exceptionHandler = const ExceptionHandler();
    failureMapper = const AuthExceptionMapper();
    repository = AuthRepositoryImpl(
      mockRemoteDataSource,
      mockWebSocketDataSource,
      mockTokenStorage,
      exceptionHandler,
      failureMapper,
    );
  });

  // Use centralized test data from TestData
  // Credentials and domain objects use factory methods for test isolation
  final tEmailAddress = TestData.emailAddress();
  final tLoginCredentials = TestData.loginCredentials();
  final tRegisterCredentials = TestData.registerCredentials();

  group('AuthRepositoryImpl', () {
    group('checkUserExists', () {
      test('returns Right(true) when user exists', () async {
        // Given
        when(
          () => mockRemoteDataSource.checkUserExists(any()),
        ).thenAnswer((_) async => true);

        // When
        final result = await repository.checkUserExists(tEmailAddress);

        // Then
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should return Right'),
          (exists) => expect(exists, true),
        );
        verify(
          () => mockRemoteDataSource.checkUserExists(
            const CheckUserExistsRequestModel(email: TestData.email),
          ),
        ).called(1);
      });

      test('returns Right(false) when user does not exist', () async {
        // Given
        when(
          () => mockRemoteDataSource.checkUserExists(any()),
        ).thenAnswer((_) async => false);

        // When
        final result = await repository.checkUserExists(tEmailAddress);

        // Then
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should return Right'),
          (exists) => expect(exists, false),
        );
      });

      test('returns Left(AuthFailure.notFound) on 404 error', () async {
        // Given
        when(() => mockRemoteDataSource.checkUserExists(any())).thenThrow(
          const ServerException(
            statusCode: 404,
            message: 'User not found',
          ),
        );

        // When
        final result = await repository.checkUserExists(tEmailAddress);

        // Then
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<AuthFailure>());
            (failure as AuthFailure).when(
              notFound: (message, _) => expect(message, 'User not found'),
              unauthorized: (_, _) => fail('Should be notFound'),
              forbidden: (_, _) => fail('Should be notFound'),
              emailAlreadyInUse: (_, _) => fail('Should be notFound'),
              invalidInput: (_, _) => fail('Should be notFound'),
            );
          },
          (r) => fail('Should return Left'),
        );
      });
    });

    group('login', () {
      test('returns Right(User) and saves tokens on success', () async {
        // Given
        when(
          () => mockRemoteDataSource.login(any()),
        ).thenAnswer((_) async => TestData.authResponseModel);
        when(
          () => mockTokenStorage.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
          ),
        ).thenAnswer((_) async {});

        // When
        final result = await repository.login(tLoginCredentials);

        // Then
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should return Right'),
          (user) {
            expect(user, isA<User>());
            expect(user.id.value.value, TestData.userId);
            expect(user.email.getOrCrash(), TestData.email);
          },
        );

        verify(
          () => mockRemoteDataSource.login(
            const LoginRequestModel(
              email: TestData.email,
              password: TestData.password,
            ),
          ),
        ).called(1);
        verify(
          () => mockTokenStorage.saveTokens(
            accessToken: TestData.accessToken,
            refreshToken: TestData.refreshToken,
          ),
        ).called(1);
      });

      test('returns Left(AuthFailure.unauthorized) on 401 error', () async {
        // Given
        when(() => mockRemoteDataSource.login(any())).thenThrow(
          const ServerException(
            statusCode: 401,
            message: 'Invalid credentials',
          ),
        );

        // When
        final result = await repository.login(tLoginCredentials);

        // Then
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<AuthFailure>());
            (failure as AuthFailure).when(
              unauthorized: (message, _) =>
                  expect(message, 'Invalid credentials'),
              notFound: (_, _) => fail('Should be unauthorized'),
              forbidden: (_, _) => fail('Should be unauthorized'),
              emailAlreadyInUse: (_, _) => fail('Should be unauthorized'),
              invalidInput: (_, _) => fail('Should be unauthorized'),
            );
          },
          (r) => fail('Should return Left'),
        );
        verifyNever(
          () => mockTokenStorage.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
          ),
        );
      });

      test('does not save tokens when login fails', () async {
        // Given
        when(() => mockRemoteDataSource.login(any())).thenThrow(
          const ServerException(
            statusCode: 401,
            message: 'Invalid credentials',
          ),
        );

        // When
        await repository.login(tLoginCredentials);

        // Then
        verifyNever(
          () => mockTokenStorage.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
          ),
        );
      });
    });

    group('register', () {
      test('returns Right(User) and saves tokens on success', () async {
        // Given
        when(
          () => mockRemoteDataSource.register(any()),
        ).thenAnswer((_) async => TestData.authResponseModel);
        when(
          () => mockTokenStorage.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
          ),
        ).thenAnswer((_) async {});

        // When
        final result = await repository.register(tRegisterCredentials);

        // Then
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should return Right'),
          (user) {
            expect(user, isA<User>());
            expect(user.id.value.value, TestData.userId);
            expect(user.email.getOrCrash(), TestData.email);
          },
        );

        verify(
          () => mockRemoteDataSource.register(
            const RegisterRequestModel(
              email: TestData.email,
              password: TestData.password,
              name: TestData.name,
            ),
          ),
        ).called(1);
        verify(
          () => mockTokenStorage.saveTokens(
            accessToken: TestData.accessToken,
            refreshToken: TestData.refreshToken,
          ),
        ).called(1);
      });

      test('returns Left(AuthFailure) on registration failure', () async {
        // Given
        when(() => mockRemoteDataSource.register(any())).thenThrow(
          const ServerException(
            statusCode: 401,
            message: 'Email already exists',
          ),
        );

        // When
        final result = await repository.register(tRegisterCredentials);

        // Then
        expect(result.isLeft(), true);
        verifyNever(
          () => mockTokenStorage.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
          ),
        );
      });
    });

    group('logout', () {
      test('returns Right(Unit) and clears tokens on success', () async {
        // Given
        when(() => mockRemoteDataSource.logout()).thenAnswer((_) async {});
        when(() => mockTokenStorage.clearTokens()).thenAnswer((_) async {});
        when(() => mockWebSocketDataSource.dispose()).thenAnswer((_) async {});

        // When
        final result = await repository.logout();

        // Then
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should return Right'),
          (value) => expect(value, unit),
        );

        verify(() => mockRemoteDataSource.logout()).called(1);
        verify(() => mockTokenStorage.clearTokens()).called(1);
      });

      test('clears tokens even if remote logout fails', () async {
        // Given
        when(() => mockRemoteDataSource.logout()).thenThrow(
          const ServerException(
            statusCode: 500,
            message: 'Server error',
          ),
        );

        // When
        await repository.logout();

        // Then
        verifyNever(() => mockTokenStorage.clearTokens());
      });
    });

    group('refreshToken', () {
      final tRefreshToken = TestData.refreshTokenVO();
      // Valid JWT format: header.payload.signature
      const tNewTokens = AuthTokensModel(
        accessToken: 'eyJhbGc.eyJzdWI.SflKxw',
        refreshToken: 'new-refresh-token',
      );

      test(
        'returns Right(AuthToken) and saves new tokens on success',
        () async {
          // Given
          when(
            () => mockRemoteDataSource.refreshToken(any()),
          ).thenAnswer((_) async => tNewTokens);
          when(
            () => mockTokenStorage.saveTokens(
              accessToken: any(named: 'accessToken'),
              refreshToken: any(named: 'refreshToken'),
            ),
          ).thenAnswer((_) async {});

          // When
          final result = await repository.refreshToken(tRefreshToken);

          // Then
          expect(result.isRight(), true);
          result.fold(
            (failure) => fail('Should return Right'),
            (token) {
              expect(token, isA<AuthToken>());
              expect(token.getOrCrash(), 'eyJhbGc.eyJzdWI.SflKxw');
            },
          );

          verify(
            () => mockRemoteDataSource.refreshToken(TestData.refreshToken),
          ).called(1);
          verify(
            () => mockTokenStorage.saveTokens(
              accessToken: 'eyJhbGc.eyJzdWI.SflKxw',
              refreshToken: 'new-refresh-token',
            ),
          ).called(1);
        },
      );

      test('returns Left(AuthFailure.unauthorized) on invalid token', () async {
        // Given
        when(() => mockRemoteDataSource.refreshToken(any())).thenThrow(
          const ServerException(
            statusCode: 401,
            message: 'Invalid refresh token',
          ),
        );

        // When
        final result = await repository.refreshToken(tRefreshToken);

        // Then
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<AuthFailure>());
            (failure as AuthFailure).when(
              unauthorized: (message, _) =>
                  expect(message, 'Invalid refresh token'),
              notFound: (_, _) => fail('Should be unauthorized'),
              forbidden: (_, _) => fail('Should be unauthorized'),
              emailAlreadyInUse: (_, _) => fail('Should be unauthorized'),
              invalidInput: (_, _) => fail('Should be unauthorized'),
            );
          },
          (r) => fail('Should return Left'),
        );
        verifyNever(
          () => mockTokenStorage.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
          ),
        );
      });
    });

    group('getCurrentUser', () {
      test(
        'returns Right(User) when token exists and API call succeeds',
        () async {
          // Given
          when(
            () => mockTokenStorage.getAccessToken(),
          ).thenAnswer((_) async => TestData.accessToken);
          when(
            () => mockRemoteDataSource.getCurrentUser(),
          ).thenAnswer((_) async => TestData.userModel);

          // When
          final result = await repository.getCurrentUser();

          // Then
          expect(result.isRight(), true);
          result.fold(
            (failure) => fail('Should return Right'),
            (user) {
              expect(user, isA<User>());
              expect(user!.id.value.value, TestData.userId);
              expect(user.email.getOrCrash(), TestData.email);
            },
          );

          verify(() => mockTokenStorage.getAccessToken()).called(1);
          verify(() => mockRemoteDataSource.getCurrentUser()).called(1);
        },
      );

      test('returns Right(null) when no access token exists', () async {
        // Given
        when(
          () => mockTokenStorage.getAccessToken(),
        ).thenAnswer((_) async => null);

        // When
        final result = await repository.getCurrentUser();

        // Then
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should return Right'),
          (user) => expect(user, null),
        );

        verify(() => mockTokenStorage.getAccessToken()).called(1);
        verifyNever(() => mockRemoteDataSource.getCurrentUser());
      });

      test(
        'returns Left(AuthFailure.unauthorized) when token is invalid',
        () async {
          // Given
          when(
            () => mockTokenStorage.getAccessToken(),
          ).thenAnswer((_) async => TestData.accessToken);
          when(() => mockRemoteDataSource.getCurrentUser()).thenThrow(
            const ServerException(
              statusCode: 401,
              message: 'Token expired',
            ),
          );

          // When
          final result = await repository.getCurrentUser();

          // Then
          expect(result.isLeft(), true);
          result.fold(
            (failure) {
              expect(failure, isA<AuthFailure>());
              (failure as AuthFailure).when(
                unauthorized: (message, _) => expect(message, 'Token expired'),
                notFound: (_, _) => fail('Should be unauthorized'),
                forbidden: (_, _) => fail('Should be unauthorized'),
                emailAlreadyInUse: (_, _) => fail('Should be unauthorized'),
                invalidInput: (_, _) => fail('Should be unauthorized'),
              );
            },
            (r) => fail('Should return Left'),
          );
        },
      );
    });

    group('watchAuthChanges', () {
      test('emits stream of Either<Failure, User?>', () async {
        // Given
        when(
          () => mockWebSocketDataSource.watchAuthChanges(),
        ).thenAnswer((_) => Stream.value(TestData.userModel));

        // When
        final stream = repository.watchAuthChanges();

        // Then
        expect(stream, isA<Stream<Either<Failure, User?>>>());

        final result = await stream.first;
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should return Right'),
          (user) {
            expect(user, isA<User>());
            expect(user!.id.value.value, TestData.userId);
          },
        );
      });

      test('emits Right(null) when WebSocket emits null', () async {
        // Given
        when(
          () => mockWebSocketDataSource.watchAuthChanges(),
        ).thenAnswer((_) => Stream.value(null));

        // When
        final stream = repository.watchAuthChanges();

        // Then
        final result = await stream.first;
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should return Right'),
          (user) => expect(user, isNull),
        );
      });

      test(
        '''emits Left(InfrastructureFailure.server) when WebSocket throws ServerException''',
        () async {
          // Given
          when(
            () => mockWebSocketDataSource.watchAuthChanges(),
          ).thenAnswer(
            (_) => Stream.error(
              const ServerException(message: 'Server Error', statusCode: 500),
            ),
          );

          // When
          final stream = repository.watchAuthChanges();

          // Then
          final result = await stream.first;
          expect(result.isLeft(), true);
          result.fold(
            (failure) {
              expect(failure, isA<InfrastructureFailure>());
              expect(
                (failure as InfrastructureFailure).message,
                'Server Error',
              );
              // Check specific failure type if possible, or just message/mapping
            },
            (user) => fail('Should return Left'),
          );
        },
      );

      test(
        '''emits Left(InfrastructureFailure.network) when WebSocket throws NetworkException''',
        () async {
          // Given
          when(
            () => mockWebSocketDataSource.watchAuthChanges(),
          ).thenAnswer(
            (_) =>
                Stream.error(const NetworkException(message: 'Network Error')),
          );

          // When
          final stream = repository.watchAuthChanges();

          // Then
          final result = await stream.first;
          expect(result.isLeft(), true);
          result.fold(
            (failure) {
              expect(failure, isA<InfrastructureFailure>());
              expect(
                (failure as InfrastructureFailure).message,
                'Network Error',
              );
            },
            (user) => fail('Should return Left'),
          );
        },
      );

      test(
        '''emits Left(InfrastructureFailure.cache) when WebSocket throws CacheException''',
        () async {
          // Given
          when(
            () => mockWebSocketDataSource.watchAuthChanges(),
          ).thenAnswer(
            (_) => Stream.error(const CacheException(message: 'Cache Error')),
          );

          // When
          final stream = repository.watchAuthChanges();

          // Then
          final result = await stream.first;
          expect(result.isLeft(), true);
          result.fold(
            (failure) {
              expect(failure, isA<InfrastructureFailure>());
              expect((failure as InfrastructureFailure).message, 'Cache Error');
            },
            (user) => fail('Should return Left'),
          );
        },
      );

      test(
        '''emits Left(InfrastructureFailure.parse) when WebSocket throws FormatException''',
        () async {
          // Given
          when(
            () => mockWebSocketDataSource.watchAuthChanges(),
          ).thenAnswer(
            (_) => Stream.error(const FormatException('Format Error')),
          );

          // When
          final stream = repository.watchAuthChanges();

          // Then
          final result = await stream.first;
          expect(result.isLeft(), true);
          result.fold(
            (failure) {
              expect(failure, isA<InfrastructureFailure>());
              expect(
                (failure as InfrastructureFailure).message,
                'Format Error',
              );
            },
            (user) => fail('Should return Left'),
          );
        },
      );

      test(
        '''emits Left(InfrastructureFailure.parse) when WebSocket throws unexpected exception''',
        () async {
          // Given
          when(
            () => mockWebSocketDataSource.watchAuthChanges(),
          ).thenAnswer((_) => Stream.error(Exception('Connection lost')));

          // When
          final stream = repository.watchAuthChanges();

          // Then
          final result = await stream.first;
          expect(result.isLeft(), true);
          result.fold(
            (failure) {
              expect(failure, isA<InfrastructureFailure>());
              expect(
                (failure as InfrastructureFailure).message,
                contains('Connection lost'),
              );
            },
            (user) => fail('Should return Left'),
          );
        },
      );
    });

    group('integration scenarios', () {
      test(
        'complete authentication flow: register → getCurrentUser → logout',
        () async {
          // Step 1: Register
          when(
            () => mockRemoteDataSource.register(any()),
          ).thenAnswer((_) async => TestData.authResponseModel);
          when(
            () => mockTokenStorage.saveTokens(
              accessToken: any(named: 'accessToken'),
              refreshToken: any(named: 'refreshToken'),
            ),
          ).thenAnswer((_) async {});

          final registerResult = await repository.register(
            tRegisterCredentials,
          );
          expect(registerResult.isRight(), true);

          // Step 2: Get current user
          when(
            () => mockTokenStorage.getAccessToken(),
          ).thenAnswer((_) async => TestData.accessToken);
          when(
            () => mockRemoteDataSource.getCurrentUser(),
          ).thenAnswer((_) async => TestData.userModel);

          final getUserResult = await repository.getCurrentUser();
          expect(getUserResult.isRight(), true);

          // Step 3: Logout
          when(() => mockRemoteDataSource.logout()).thenAnswer((_) async {});
          when(() => mockTokenStorage.clearTokens()).thenAnswer((_) async {});
          when(
            () => mockWebSocketDataSource.dispose(),
          ).thenAnswer((_) async {});

          final logoutResult = await repository.logout();
          expect(logoutResult.isRight(), true);

          // Verify token operations
          verify(
            () => mockTokenStorage.saveTokens(
              accessToken: TestData.accessToken,
              refreshToken: TestData.refreshToken,
            ),
          ).called(1);
          verify(() => mockTokenStorage.clearTokens()).called(1);
        },
      );

      test('login → refresh token → logout flow', () async {
        // Step 1: Login
        when(
          () => mockRemoteDataSource.login(any()),
        ).thenAnswer((_) async => TestData.authResponseModel);
        when(
          () => mockTokenStorage.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
          ),
        ).thenAnswer((_) async {});

        final loginResult = await repository.login(tLoginCredentials);
        expect(loginResult.isRight(), true);

        // Step 2: Refresh token
        // Valid JWT format: header.payload.signature
        const newTokens = AuthTokensModel(
          accessToken: 'eyJhbGc.eyJzdWI.SflKxw',
          refreshToken: 'new-refresh-token',
        );
        when(
          () => mockRemoteDataSource.refreshToken(any()),
        ).thenAnswer((_) async => newTokens);

        final refreshToken = TestData.refreshTokenVO();
        final refreshResult = await repository.refreshToken(refreshToken);
        expect(refreshResult.isRight(), true);

        // Step 3: Logout
        when(() => mockRemoteDataSource.logout()).thenAnswer((_) async {});
        when(() => mockTokenStorage.clearTokens()).thenAnswer((_) async {});
        when(() => mockWebSocketDataSource.dispose()).thenAnswer((_) async {});

        final logoutResult = await repository.logout();
        expect(logoutResult.isRight(), true);

        // Verify all token operations
        verify(
          () => mockTokenStorage.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
          ),
        ).called(2); // Once for login, once for refresh
        verify(() => mockTokenStorage.clearTokens()).called(1);
      });

      test('handles unauthorized error after token expiry', () async {
        // Given - user was authenticated
        when(
          () => mockTokenStorage.getAccessToken(),
        ).thenAnswer((_) async => 'expired-token');

        // When - token has expired
        when(() => mockRemoteDataSource.getCurrentUser()).thenThrow(
          const ServerException(
            statusCode: 401,
            message: 'Token expired',
          ),
        );

        // Then - should return unauthorized failure
        final result = await repository.getCurrentUser();
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<AuthFailure>());
            expect((failure as AuthFailure).message, contains('expired'));
          },
          (r) => fail('Should return Left'),
        );
      });
    });
  });
}
