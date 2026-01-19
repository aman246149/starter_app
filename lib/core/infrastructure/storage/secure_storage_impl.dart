import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:starter_app/core/domain/ports/i_secure_storage.dart';

/// Implementation of [ISecureStorage]
/// using the `flutter_secure_storage` package.
///
/// This is an **adapter** in hexagonal architecture - it implements the
/// [ISecureStorage] port defined in the domain layer.
///
/// Platform-specific storage:
/// - **iOS**: Keychain
/// - **Android**: EncryptedSharedPreferences (AES encryption)
/// - **Web**: Web Cryptography API
/// - **Desktop**: Encrypted storage
///
/// This class is registered as a lazy singleton, so a single instance
/// is used throughout the application.
@LazySingleton(as: ISecureStorage)
class SecureStorageImpl implements ISecureStorage {
  const SecureStorageImpl(this._storage);

  final FlutterSecureStorage _storage;

  @override
  Future<void> write({required String key, required String value}) {
    return _storage.write(key: key, value: value);
  }

  @override
  Future<String?> read({required String key}) {
    return _storage.read(key: key);
  }

  @override
  Future<void> delete({required String key}) {
    return _storage.delete(key: key);
  }

  @override
  Future<void> deleteAll() {
    return _storage.deleteAll();
  }
}
