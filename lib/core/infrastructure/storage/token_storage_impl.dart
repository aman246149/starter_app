import 'package:injectable/injectable.dart';

import 'package:starter_app/core/domain/ports/i_secure_storage.dart';
import 'package:starter_app/core/domain/ports/i_token_storage.dart';

/// Implementation of [ITokenStorage] for secure token management.
///
/// This is an **adapter** in hexagonal architecture - it implements the
/// [ITokenStorage] port defined in the domain layer.
///
/// Uses [ISecureStorage] abstraction which wraps platform-specific
/// secure storage:
/// - **iOS**: Keychain
/// - **Android**: EncryptedSharedPreferences (AES encryption)
/// - **Web**: Web Cryptography API
/// - **Desktop**: Encrypted storage
///
/// Provides secure storage for:
/// - Access tokens (JWT for API authentication)
/// - Refresh tokens (for obtaining new access tokens)
@LazySingleton(as: ITokenStorage)
class TokenStorageImpl implements ITokenStorage {
  const TokenStorageImpl(this._secureStorage);

  final ISecureStorage _secureStorage;

  // Storage keys
  static const String _accessTokenKey = 'auth_access_token';
  static const String _refreshTokenKey = 'auth_refresh_token';

  @override
  Future<String?> getAccessToken() async {
    return _secureStorage.read(key: _accessTokenKey);
  }

  @override
  Future<String?> getRefreshToken() async {
    return _secureStorage.read(key: _refreshTokenKey);
  }

  @override
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await _secureStorage.write(key: _accessTokenKey, value: accessToken);
    if (refreshToken != null) {
      await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
    }
  }

  @override
  Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(key: _accessTokenKey, value: token);
  }

  @override
  Future<void> clearTokens() async {
    await Future.wait([
      _secureStorage.delete(key: _accessTokenKey),
      _secureStorage.delete(key: _refreshTokenKey),
    ]);
  }

  @override
  Future<bool> hasTokens() async {
    final accessToken = await getAccessToken();
    return accessToken != null && accessToken.isNotEmpty;
  }
}
