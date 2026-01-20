import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/core/presentation/failure_message/failure_mapper_registry.dart';
import 'package:starter_app/core/presentation/failure_message/failure_message_mapper.dart';

class MockFailureMessageMapper extends Mock implements FailureMessageMapper {}

void main() {
  late FailureMapperRegistry registry;

  setUp(() {
    registry = FailureMapperRegistry();
  });

  group('FailureMapperRegistry', () {
    test('should return empty list initially', () {
      expect(registry.all, isEmpty);
    });

    test('should add high priority mappers to the beginning', () {
      // Arrange
      final mapper1 = MockFailureMessageMapper();
      final mapper2 = MockFailureMessageMapper();

      // Act
      registry
        ..register(mapper1)
        ..register(mapper2);

      // Assert
      expect(registry.all, equals([mapper2, mapper1]));
    });

    test('should add low priority mappers to the end', () {
      // Arrange
      final mapper1 = MockFailureMessageMapper();
      final mapper2 = MockFailureMessageMapper();

      // Act
      registry
        ..register(mapper1, highPriority: false)
        ..register(mapper2, highPriority: false);

      // Assert
      expect(registry.all, equals([mapper1, mapper2]));
    });

    test('should maintain order: high priority then low priority', () {
      // Arrange
      final highMapper = MockFailureMessageMapper();
      final lowMapper = MockFailureMessageMapper();

      // Act
      registry
        ..register(lowMapper, highPriority: false)
        ..register(highMapper);

      // Assert
      expect(registry.all, equals([highMapper, lowMapper]));
    });
  });
}
