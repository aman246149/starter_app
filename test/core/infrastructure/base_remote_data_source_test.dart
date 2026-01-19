import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/core/infrastructure/base_remote_data_source.dart';

class TestRemoteDataSource extends BaseRemoteDataSource {
  Future<T> testExecute<T>(Future<T> Function() operation) {
    return execute(operation);
  }
}

void main() {
  late TestRemoteDataSource dataSource;

  setUp(() {
    dataSource = TestRemoteDataSource();
  });

  group('BaseRemoteDataSource', () {
    test('should return value when operation succeeds', () async {
      // Act
      final result = await dataSource.testExecute(() async => 'success');

      // Assert
      expect(result, 'success');
    });

    test('should rethrow Exception as is', () async {
      // Arrange
      final exception = Exception('test exception');

      // Act & Assert
      expect(
        () => dataSource.testExecute(() async => throw exception),
        throwsA(equals(exception)),
      );
    });

    test('should convert Error to FormatException', () async {
      // Arrange
      final error = ArgumentError('test error');

      // Act & Assert
      expect(
        () => dataSource.testExecute(() async => throw error),
        throwsA(isA<FormatException>()),
      );
    });

    test('should convert TypeError to FormatException', () async {
      // Arrange
      final error = TypeError();

      // Act & Assert
      expect(
        () => dataSource.testExecute(() async => throw error),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
