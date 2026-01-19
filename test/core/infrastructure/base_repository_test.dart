import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/core/error/exception_handler.dart';
import 'package:starter_app/core/error/exceptions/server_exception.dart';
import 'package:starter_app/core/error/failures/failure.dart';
import 'package:starter_app/core/error/failures/infrastructure_failures.dart';
import 'package:starter_app/core/error/i_exception_mapper.dart';
import 'package:starter_app/core/infrastructure/base_repository.dart';

class MockFailureMapper extends Mock implements IExceptionMapper {}

class TestRepository extends BaseRepository {
  TestRepository(
    super.exceptionHandler, [
    super.failureMapper,
  ]);

  Future<Either<Failure, T>> testExecute<T>(Future<T> Function() operation) {
    return execute(operation);
  }
}

void main() {
  late ExceptionHandler exceptionHandler;
  late MockFailureMapper failureMapper;
  late TestRepository repository;

  setUp(() {
    exceptionHandler = const ExceptionHandler();
    failureMapper = MockFailureMapper();
    repository = TestRepository(exceptionHandler, failureMapper);
  });

  group('BaseRepository', () {
    test('should return Right(result) when operation succeeds', () async {
      // Act
      final result = await repository.testExecute(() async => 'success');

      // Assert
      expect(result, isA<Right<Failure, String>>());
      result.fold(
        (l) => fail('Should be Right'),
        (r) => expect(r, 'success'),
      );
    });

    test(
      '''
      should return Left(mapped failure) when 
      ServerException occurs and mapper is provided''',
      () async {
        // Arrange
        const exception = ServerException(message: 'error', statusCode: 500);
        const failure = InfrastructureFailure.server(
          message: 'mapped error',
          statusCode: 500,
        );

        when(() => failureMapper.mapToFailure(exception)).thenReturn(failure);

        // Act
        final result = await repository.testExecute(
          () async => throw exception,
        );

        // Assert
        expect(result, isA<Left<Failure, String>>());
        result.fold(
          (l) => expect(l, failure),
          (r) => fail('Should be Left'),
        );
        verify(() => failureMapper.mapToFailure(exception)).called(1);
      },
    );

    test(
      'should return Left(InfrastructureFailure) when mapper is not provided',
      () async {
        // Arrange
        repository = TestRepository(exceptionHandler);
        const exception = ServerException(message: 'error', statusCode: 500);

        // Act
        final result = await repository.testExecute(
          () async => throw exception,
        );

        // Assert
        expect(result, isA<Left<Failure, String>>());
        result.fold(
          (l) => expect(l, isA<InfrastructureFailure>()),
          (r) => fail('Should be Left'),
        );
      },
    );
  });
}
