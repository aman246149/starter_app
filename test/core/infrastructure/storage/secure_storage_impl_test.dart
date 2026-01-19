import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/core/infrastructure/storage/secure_storage_impl.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockFlutterSecureStorage mockStorage;
  late SecureStorageImpl secureStorage;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    secureStorage = SecureStorageImpl(mockStorage);
  });

  group('SecureStorageImpl', () {
    const key = 'test_key';
    const value = 'test_value';

    test('write should call storage.write', () async {
      // Arrange
      when(
        () => mockStorage.write(key: key, value: value),
      ).thenAnswer((_) async {});

      // Act
      await secureStorage.write(key: key, value: value);

      // Assert
      verify(() => mockStorage.write(key: key, value: value)).called(1);
    });

    test('read should call storage.read and return value', () async {
      // Arrange
      when(() => mockStorage.read(key: key)).thenAnswer((_) async => value);

      // Act
      final result = await secureStorage.read(key: key);

      // Assert
      verify(() => mockStorage.read(key: key)).called(1);
      expect(result, value);
    });

    test('delete should call storage.delete', () async {
      // Arrange
      when(() => mockStorage.delete(key: key)).thenAnswer((_) async {});

      // Act
      await secureStorage.delete(key: key);

      // Assert
      verify(() => mockStorage.delete(key: key)).called(1);
    });

    test('deleteAll should call storage.deleteAll', () async {
      // Arrange
      when(() => mockStorage.deleteAll()).thenAnswer((_) async {});

      // Act
      await secureStorage.deleteAll();

      // Assert
      verify(() => mockStorage.deleteAll()).called(1);
    });
  });
}
