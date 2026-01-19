import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/core/domain/ports/i_secure_storage.dart';
import 'package:starter_app/core/infrastructure/storage/token_storage_impl.dart';

class MockSecureStorage extends Mock implements ISecureStorage {}

void main() {
  late MockSecureStorage mockSecureStorage;
  late TokenStorageImpl tokenStorage;

  const accessTokenKey = 'auth_access_token';
  const refreshTokenKey = 'auth_refresh_token';
  const testAccessToken = 'test_access_token';
  const testRefreshToken = 'test_refresh_token';

  setUp(() {
    mockSecureStorage = MockSecureStorage();
    tokenStorage = TokenStorageImpl(mockSecureStorage);
  });

  group('TokenStorageImpl', () {
    test('getAccessToken should return token from secure storage', () async {
      // Arrange
      when(
        () => mockSecureStorage.read(key: accessTokenKey),
      ).thenAnswer((_) async => testAccessToken);

      // Act
      final result = await tokenStorage.getAccessToken();

      // Assert
      expect(result, testAccessToken);
      verify(() => mockSecureStorage.read(key: accessTokenKey)).called(1);
    });

    test('getRefreshToken should return token from secure storage', () async {
      // Arrange
      when(
        () => mockSecureStorage.read(key: refreshTokenKey),
      ).thenAnswer((_) async => testRefreshToken);

      // Act
      final result = await tokenStorage.getRefreshToken();

      // Assert
      expect(result, testRefreshToken);
      verify(() => mockSecureStorage.read(key: refreshTokenKey)).called(1);
    });

    test('saveTokens should save both tokens', () async {
      // Arrange
      when(
        () => mockSecureStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});

      // Act
      await tokenStorage.saveTokens(
        accessToken: testAccessToken,
        refreshToken: testRefreshToken,
      );

      // Assert
      verify(
        () => mockSecureStorage.write(
          key: accessTokenKey,
          value: testAccessToken,
        ),
      ).called(1);
      verify(
        () => mockSecureStorage.write(
          key: refreshTokenKey,
          value: testRefreshToken,
        ),
      ).called(1);
    });

    test('saveAccessToken should save only access token', () async {
      // Arrange
      when(
        () => mockSecureStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});

      // Act
      await tokenStorage.saveAccessToken(testAccessToken);

      // Assert
      verify(
        () => mockSecureStorage.write(
          key: accessTokenKey,
          value: testAccessToken,
        ),
      ).called(1);
      verifyNever(
        () => mockSecureStorage.write(
          key: refreshTokenKey,
          value: any(named: 'value'),
        ),
      );
    });

    test('clearTokens should delete both tokens', () async {
      // Arrange
      when(
        () => mockSecureStorage.delete(key: any(named: 'key')),
      ).thenAnswer((_) async {});

      // Act
      await tokenStorage.clearTokens();

      // Assert
      verify(() => mockSecureStorage.delete(key: accessTokenKey)).called(1);
      verify(() => mockSecureStorage.delete(key: refreshTokenKey)).called(1);
    });

    test('hasTokens should return true when access token exists', () async {
      // Arrange
      when(
        () => mockSecureStorage.read(key: accessTokenKey),
      ).thenAnswer((_) async => testAccessToken);

      // Act
      final result = await tokenStorage.hasTokens();

      // Assert
      expect(result, true);
    });

    test('hasTokens should return false when access token is null', () async {
      // Arrange
      when(
        () => mockSecureStorage.read(key: accessTokenKey),
      ).thenAnswer((_) async => null);

      // Act
      final result = await tokenStorage.hasTokens();

      // Assert
      expect(result, false);
    });
  });
}
