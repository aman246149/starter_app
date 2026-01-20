import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/core/error/failures/failure.dart';
import 'package:starter_app/core/presentation/failure_message/failure_mapper_registry.dart';
import 'package:starter_app/core/presentation/failure_message/failure_message_mapper.dart';

class MockFailureMapperRegistry extends Mock implements FailureMapperRegistry {}

class TestFailureMapper extends FailureMessageMapper {
  TestFailureMapper(super.registry, {super.highPriority});

  @override
  bool canHandle(Failure failure) => true;

  @override
  String map(BuildContext context, Failure failure) => 'mapped';
}

class FakeFailureMessageMapper extends Fake implements FailureMessageMapper {}

void main() {
  late MockFailureMapperRegistry registry;

  setUpAll(() {
    registerFallbackValue(FakeFailureMessageMapper());
  });

  setUp(() {
    registry = MockFailureMapperRegistry();
  });

  group('FailureMessageMapper', () {
    test('should register with high priority by default', () {
      // Act
      TestFailureMapper(registry);

      // Assert
      verify(
        () => registry.register(any()),
      ).called(1);
    });

    test('should register with low priority when specified', () {
      // Act
      TestFailureMapper(registry, highPriority: false);

      // Assert
      verify(() => registry.register(any(), highPriority: false)).called(1);
    });
  });
}
