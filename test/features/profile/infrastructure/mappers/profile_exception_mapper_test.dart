import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/core/error/exceptions/server_exception.dart';
import 'package:starter_app/core/error/failures/infrastructure_failures.dart';
import 'package:starter_app/features/profile/domain/failure/profile_failure.dart';
import 'package:starter_app/features/profile/infrastructure/mappers/profile_exception_mapper.dart';

void main() {
  late ProfileExceptionMapper mapper;

  setUp(() {
    mapper = const ProfileExceptionMapper();
  });

  group('ProfileExceptionMapper', () {
    const message = 'Test error message';

    test('should map 404 to ProfileFailure.notFound', () {
      const exception = ServerException(
        message: message,
        statusCode: HttpStatus.notFound,
      );

      final failure = mapper.mapToFailure(exception);

      expect(failure, isA<ProfileFailure>());
      expect(
        failure,
        equals(const ProfileFailure.notFound(message: message)),
      );
    });

    test('should map 500 to ProfileFailure.serverError', () {
      const exception = ServerException(
        message: message,
        statusCode: HttpStatus.internalServerError,
      );

      final failure = mapper.mapToFailure(exception);

      expect(failure, isA<ProfileFailure>());
      expect(
        failure,
        equals(const ProfileFailure.serverError(message: message)),
      );
    });

    test('should map other status codes to InfrastructureFailure.server', () {
      const exception = ServerException(
        message: message,
        statusCode: HttpStatus.badGateway,
      );

      final failure = mapper.mapToFailure(exception);

      expect(failure, isA<InfrastructureFailure>());
      expect(
        failure,
        equals(
          const InfrastructureFailure.server(
            message: message,
            statusCode: HttpStatus.badGateway,
          ),
        ),
      );
    });
  });
}
