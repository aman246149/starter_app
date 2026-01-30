import 'dart:convert';
import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/core/error/exceptions/server_exception.dart';
import 'package:starter_app/features/auth/infrastructure/datasources/auth_remote_data_source.dart';
import 'package:starter_app/features/auth/infrastructure/models/auth_response_model.dart';
import 'package:starter_app/features/auth/infrastructure/models/auth_tokens_model.dart';
import 'package:starter_app/features/auth/infrastructure/models/check_user_exists_request_model.dart';
import 'package:starter_app/features/auth/infrastructure/models/login_request_model.dart';
import 'package:starter_app/features/auth/infrastructure/models/register_request_model.dart';
import 'package:starter_app/features/auth/infrastructure/models/user_model.dart';

import '../../../../helpers/mock_helpers.dart';
import '../../../../helpers/test_data.dart';

/// Helper function to create test responses
/// For models with toJson(), use jsonEncode/jsonDecode to ensure proper conversion
Response<Map<String, dynamic>> createTestResponse(
  dynamic body, {
  int statusCode = 200,
}) {
  final httpResponse = http.Response('', statusCode);
  // If body has toJson, encode and decode to ensure proper JSON structure
  final jsonBody = body is Map
      ? body as Map<String, dynamic>
      : json.decode(json.encode(body)) as Map<String, dynamic>;
  return Response<Map<String, dynamic>>(httpResponse, jsonBody);
}

void main() {
  late MockAuthApiService mockApiService;
  late IAuthRemoteDataSource dataSource;

  setUp(() {
    mockApiService = MockAuthApiService();
    dataSource = AuthRemoteDataSourceImpl(mockApiService);
  });

  group('AuthRemoteDataSourceImpl', () {
    const tEmail = TestData.email;
    const tPassword = TestData.password;
    const tName = TestData.name;

    // Properly constructed JSON for testing
    const tAuthResponseJson = TestData.authResponseJson;
    const tUserJson = TestData.userJson;

    group('checkUserExists', () {
      test('returns true when user exists', () async {
        // Given
        const request = CheckUserExistsRequestModel(email: tEmail);
        final response = createTestResponse({'exists': true});
        when(
          () => mockApiService.checkUserExists(any()),
        ).thenAnswer((_) async => response);

        // When
        final result = await dataSource.checkUserExists(request);

        // Then
        expect(result, true);
        verify(
          () => mockApiService.checkUserExists(request.toJson()),
        ).called(1);
      });

      test('returns false when user does not exist', () async {
        // Given
        const request = CheckUserExistsRequestModel(email: tEmail);
        final response = createTestResponse({'exists': false});
        when(
          () => mockApiService.checkUserExists(any()),
        ).thenAnswer((_) async => response);

        // When
        final result = await dataSource.checkUserExists(request);

        // Then
        expect(result, false);
      });

      test('throws ServerException on API error', () async {
        // Given
        const request = CheckUserExistsRequestModel(email: tEmail);
        when(() => mockApiService.checkUserExists(any())).thenThrow(
          const ServerException(
            statusCode: 500,
            message: 'Server error',
          ),
        );

        // When/Then
        expect(
          () => dataSource.checkUserExists(request),
          throwsA(isA<ServerException>()),
        );
      });
    });

    group('login', () {
      test('returns AuthResponseModel on success', () async {
        // Given
        const request = LoginRequestModel(
          email: tEmail,
          password: tPassword,
        );
        final response = createTestResponse(tAuthResponseJson);
        when(
          () => mockApiService.login(any()),
        ).thenAnswer((_) async => response);

        // When
        final result = await dataSource.login(request);

        // Then
        expect(result, isA<AuthResponseModel>());
        expect(result.user.email, tEmail);
        expect(result.tokens.accessToken, TestData.accessToken);
        verify(() => mockApiService.login(request.toJson())).called(1);
      });

      test('throws ServerException on API error', () async {
        // Given
        const request = LoginRequestModel(
          email: tEmail,
          password: tPassword,
        );
        when(() => mockApiService.login(any())).thenThrow(
          const ServerException(
            statusCode: 401,
            message: 'Invalid credentials',
          ),
        );

        // When/Then
        expect(
          () => dataSource.login(request),
          throwsA(isA<ServerException>()),
        );
      });
    });

    group('register', () {
      const tRegisterRequest = RegisterRequestModel(
        email: tEmail,
        password: tPassword,
        name: tName,
      );

      test('returns AuthResponseModel on success', () async {
        // Given
        when(
          () => mockApiService.register(any()),
        ).thenAnswer(
          (_) async => Response(
            http.Response(jsonEncode(tAuthResponseJson), 200),
            tAuthResponseJson,
          ),
        );

        // When
        final result = await dataSource.register(
          const RegisterRequestModel(
            email: TestData.email,
            password: TestData.password,
            name: TestData.name,
          ),
        );

        // Then
        expect(result, TestData.authResponseModel);
        verify(
          () => mockApiService.register({
            'email': TestData.email,
            'password': TestData.password,
            'name': TestData.name,
          }),
        ).called(1);
      });

      test('throws ServerException on API error', () async {
        // Given
        when(() => mockApiService.register(any())).thenThrow(
          const ServerException(
            statusCode: HttpStatus.badRequest,
            message: 'Email already exists',
          ),
        );

        // When/Then
        expect(
          () => dataSource.register(tRegisterRequest),
          throwsA(isA<ServerException>()),
        );
      });

      test('throws FormatException on JSON parsing error', () async {
        // Given - response with invalid JSON structure
        final response = createTestResponse({'invalid': 'structure'});
        when(
          () => mockApiService.register(any()),
        ).thenAnswer((_) async => response);

        // When/Then
        expect(
          () => dataSource.register(tRegisterRequest),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('logout', () {
      test('completes successfully', () async {
        // Given
        when(() => mockApiService.logout()).thenAnswer(
          (_) async => Response(
            http.Response('', 204),
            null,
          ),
        );

        // When
        await expectLater(
          dataSource.logout(),
          completes,
        );

        // Then
        verify(() => mockApiService.logout()).called(1);
      });

      test('throws ServerException on API error', () async {
        // Given
        when(() => mockApiService.logout()).thenThrow(
          const ServerException(
            statusCode: 500,
            message: 'Server error',
          ),
        );

        // When/Then
        expect(
          () => dataSource.logout(),
          throwsA(isA<ServerException>()),
        );
      });
    });

    group('refreshToken', () {
      const tRefreshToken = TestData.refreshToken;

      test('returns new AuthTokensModel on success', () async {
        // Given
        final response = createTestResponse({
          'accessToken': TestData.accessToken,
          'refreshToken': TestData.refreshToken,
        });
        when(
          () => mockApiService.refreshToken(any()),
        ).thenAnswer((_) async => response);

        // When
        final result = await dataSource.refreshToken(tRefreshToken);

        // Then
        expect(result, isA<AuthTokensModel>());
        expect(result.accessToken, TestData.accessToken);
        expect(result.refreshToken, TestData.refreshToken);
        verify(
          () => mockApiService.refreshToken({'token': tRefreshToken}),
        ).called(1);
      });

      test('throws ServerException when refresh token is invalid', () async {
        // Given
        when(() => mockApiService.refreshToken(any())).thenThrow(
          const ServerException(
            statusCode: HttpStatus.unauthorized,
            message: 'Invalid refresh token',
          ),
        );

        // When/Then
        expect(
          () => dataSource.refreshToken(tRefreshToken),
          throwsA(isA<ServerException>()),
        );
      });
    });

    group('getCurrentUser', () {
      test('returns UserModel on success', () async {
        // Given
        final response = createTestResponse(tUserJson);
        when(
          () => mockApiService.getCurrentUser(),
        ).thenAnswer((_) async => response);

        // When
        final result = await dataSource.getCurrentUser();

        // Then
        expect(result, isA<UserModel>());
        expect(result.id, TestData.userId);
        expect(result.email, tEmail);
        verify(() => mockApiService.getCurrentUser()).called(1);
      });

      test('throws ServerException when unauthorized', () async {
        // Given
        when(() => mockApiService.getCurrentUser()).thenThrow(
          const ServerException(
            statusCode: HttpStatus.unauthorized,
            message: 'Unauthorized',
          ),
        );

        // When/Then
        expect(
          () => dataSource.getCurrentUser(),
          throwsA(isA<ServerException>()),
        );
      });

      test('throws FormatException on JSON parsing error', () async {
        // Given
        final response = createTestResponse({'bad': 'data'});
        when(
          () => mockApiService.getCurrentUser(),
        ).thenAnswer((_) async => response);

        // When/Then
        expect(
          () => dataSource.getCurrentUser(),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('BaseRemoteDataSource error handling', () {
      test('converts Error to FormatException', () async {
        // Given - setup a call that will throw an Error (not Exception)
        when(() => mockApiService.getCurrentUser()).thenThrow(TypeError());

        // When/Then
        expect(
          () => dataSource.getCurrentUser(),
          throwsA(isA<FormatException>()),
        );
      });

      test('rethrows Exception unchanged', () async {
        // Given
        when(() => mockApiService.getCurrentUser()).thenThrow(
          const ServerException(
            statusCode: HttpStatus.internalServerError,
            message: 'Server error',
          ),
        );

        // When/Then
        expect(
          () => dataSource.getCurrentUser(),
          throwsA(isA<ServerException>()),
        );
      });
    });

    group('integration scenarios', () {
      test('register → login flow', () async {
        // Given - setup register
        final registerResponse = createTestResponse(tAuthResponseJson);
        when(
          () => mockApiService.register(any()),
        ).thenAnswer((_) async => registerResponse);

        // When - register
        final registerResult = await dataSource.register(
          const RegisterRequestModel(
            email: tEmail,
            password: tPassword,
            name: TestData.name,
          ),
        );

        // Then - verify register result
        expect(registerResult.user.email, TestData.email);
        expect(registerResult.tokens.accessToken, TestData.accessToken);

        // Given - setup login
        final loginResponse = createTestResponse(tAuthResponseJson);
        when(
          () => mockApiService.login(any()),
        ).thenAnswer((_) async => loginResponse);

        // When - login
        final loginResult = await dataSource.login(
          const LoginRequestModel(email: tEmail, password: tPassword),
        );

        // Then
        expect(loginResult.user.email, TestData.email);
        expect(loginResult.tokens.accessToken, TestData.accessToken);
      });

      test('login → getCurrentUser flow', () async {
        // Given - setup login
        final loginResponse = createTestResponse(tAuthResponseJson);
        when(
          () => mockApiService.login(any()),
        ).thenAnswer((_) async => loginResponse);

        // When - login
        final loginResult = await dataSource.login(
          const LoginRequestModel(email: tEmail, password: tPassword),
        );
        expect(loginResult.tokens.accessToken, TestData.accessToken);

        // Given - setup getCurrentUser
        final userResponse = createTestResponse(tUserJson);
        when(
          () => mockApiService.getCurrentUser(),
        ).thenAnswer((_) async => userResponse);

        // When
        final user = await dataSource.getCurrentUser();

        // Then
        expect(user.id, TestData.userId);
        expect(user.email, TestData.email);
      });

      test('token refresh flow', () async {
        // Given
        const oldTokens = TestData.authTokensModel;

        final response = createTestResponse({
          'accessToken': 'new-access-token',
          'refreshToken': TestData.refreshToken,
        });
        when(
          () => mockApiService.refreshToken(any()),
        ).thenAnswer((_) async => response);

        // When
        final result = await dataSource.refreshToken(oldTokens.refreshToken);

        // Then
        expect(result.accessToken, 'new-access-token');
        expect(result.refreshToken, TestData.refreshToken);
        expect(result.accessToken, isNot(oldTokens.accessToken));
      });
    });
  });
}
