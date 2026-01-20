import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/core/error/failures/infrastructure_failures.dart';
import 'package:starter_app/core/presentation/models/error_model.dart';
import 'package:starter_app/core/presentation/services/failure_message_service.dart';
import 'package:starter_app/features/auth/domain/failure/auth_failure.dart';

class MockBuildContext extends Mock implements BuildContext {}

class MockFailureMessageService extends Mock implements FailureMessageService {}

void main() {
  group('ErrorModel', () {
    group('direct constructor', () {
      test('creates error model with required parameters', () {
        const failure = InfrastructureFailure.server(
          message: 'Server error',
          statusCode: 500,
        );

        const model = ErrorModel(
          failure: failure,
          isRetryable: true,
        );

        expect(model.failure, failure);
        expect(model.isRetryable, true);
      });

      test('creates error model with isRetryable false', () {
        const failure = InfrastructureFailure.cache();

        const model = ErrorModel(
          failure: failure,
          isRetryable: false,
        );

        expect(model.failure, failure);
        expect(model.isRetryable, false);
      });
    });

    group('fromFailure factory', () {
      test('creates error model from server failure (retryable)', () {
        const failure = InfrastructureFailure.server(
          message: 'Server error',
          statusCode: 500,
        );

        final model = ErrorModel.fromFailure(failure);

        expect(model.failure, failure);
        expect(model.isRetryable, true);
      });

      test('creates error model from network failure (retryable)', () {
        const failure = InfrastructureFailure.network();

        final model = ErrorModel.fromFailure(failure);

        expect(model.failure, failure);
        expect(model.isRetryable, true);
      });

      test('creates error model from cache failure (not retryable)', () {
        const failure = InfrastructureFailure.cache();

        final model = ErrorModel.fromFailure(failure);

        expect(model.failure, failure);
        expect(model.isRetryable, false);
      });

      test('creates error model from parse failure (not retryable)', () {
        const failure = InfrastructureFailure.parse();

        final model = ErrorModel.fromFailure(failure);

        expect(model.failure, failure);
        expect(model.isRetryable, false);
      });

      test('creates error model from auth failure (not retryable)', () {
        const failure = AuthFailure.unauthorized(
          message: 'Unauthorized',
        );

        final model = ErrorModel.fromFailure(failure);

        expect(model.failure, failure);
        expect(model.isRetryable, false);
      });

      test(
        'creates error model from auth notFound failure (not retryable)',
        () {
          const failure = AuthFailure.notFound(
            message: 'Not found',
          );

          final model = ErrorModel.fromFailure(failure);

          expect(model.failure, failure);
          expect(model.isRetryable, false);
        },
      );

      test(
        'creates error model from auth forbidden failure (not retryable)',
        () {
          const failure = AuthFailure.forbidden(
            message: 'Forbidden',
          );

          final model = ErrorModel.fromFailure(failure);

          expect(model.failure, failure);
          expect(model.isRetryable, false);
        },
      );

      test(
        '''
        creates error model from auth 
        emailAlreadyInUse failure (not retryable)''',
        () {
          const failure = AuthFailure.emailAlreadyInUse();

          final model = ErrorModel.fromFailure(failure);

          expect(model.failure, failure);
          expect(model.isRetryable, false);
        },
      );

      test(
        'creates error model from auth invalidInput failure (not retryable)',
        () {
          const failure = AuthFailure.invalidInput(
            message: 'Invalid input',
          );

          final model = ErrorModel.fromFailure(failure);

          expect(model.failure, failure);
          expect(model.isRetryable, false);
        },
      );
    });

    group('equality', () {
      test('two models with same failure are equal', () {
        const failure = InfrastructureFailure.server(
          message: 'Server error',
          statusCode: 500,
        );

        final model1 = ErrorModel.fromFailure(failure);
        final model2 = ErrorModel.fromFailure(failure);

        expect(model1, model2);
        expect(model1.hashCode, model2.hashCode);
      });

      test('two models with different failures are not equal', () {
        const failure1 = InfrastructureFailure.server(
          message: 'Server error',
          statusCode: 500,
        );
        const failure2 = InfrastructureFailure.network();

        final model1 = ErrorModel.fromFailure(failure1);
        final model2 = ErrorModel.fromFailure(failure2);

        expect(model1, isNot(model2));
      });

      test(
        'two models with same failure but different isRetryable are not equal',
        () {
          const failure = InfrastructureFailure.server(
            message: 'Server error',
            statusCode: 500,
          );

          const model1 = ErrorModel(
            failure: failure,
            isRetryable: true,
          );
          const model2 = ErrorModel(
            failure: failure,
            isRetryable: false,
          );

          expect(model1, isNot(model2));
        },
      );
    });

    group('copyWith', () {
      test('creates copy with updated failure', () {
        const originalFailure = InfrastructureFailure.server(
          message: 'Server error',
          statusCode: 500,
        );
        const newFailure = InfrastructureFailure.network();

        final original = ErrorModel.fromFailure(originalFailure);
        final updated = original.copyWith(failure: newFailure);

        expect(updated.failure, newFailure);
        expect(updated.isRetryable, original.isRetryable);
        expect(updated, isNot(original));
      });

      test('creates copy with updated isRetryable', () {
        const failure = InfrastructureFailure.server(
          message: 'Server error',
          statusCode: 500,
        );

        final original = ErrorModel.fromFailure(failure);
        final updated = original.copyWith(isRetryable: false);

        expect(updated.failure, original.failure);
        expect(updated.isRetryable, false);
        expect(updated, isNot(original));
      });

      test('creates copy without changes returns same instance', () {
        const failure = InfrastructureFailure.server(
          message: 'Server error',
          statusCode: 500,
        );

        final original = ErrorModel.fromFailure(failure);
        final copy = original.copyWith();

        expect(copy, original);
      });
    });

    group('getMessage extension', () {
      late MockBuildContext mockContext;
      late MockFailureMessageService mockService;

      setUp(() {
        mockContext = MockBuildContext();
        mockService = MockFailureMessageService();
      });

      test('delegates to FailureMessageService.getLocalizedMessage', () {
        const failure = InfrastructureFailure.server(
          message: 'Server error',
          statusCode: 500,
        );
        const expectedMessage = 'Localized error message';

        when(
          () => mockService.getLocalizedMessage(mockContext, failure),
        ).thenReturn(expectedMessage);

        final model = ErrorModel.fromFailure(failure);
        final result = model.getMessage(mockContext, mockService);

        expect(result, expectedMessage);
        verify(
          () => mockService.getLocalizedMessage(mockContext, failure),
        ).called(1);
      });

      test('getMessage works with different failure types', () {
        const networkFailure = InfrastructureFailure.network();
        const authFailure = AuthFailure.unauthorized(
          message: 'Unauthorized',
        );

        when(
          () => mockService.getLocalizedMessage(
            mockContext,
            networkFailure,
          ),
        ).thenReturn('Network error message');
        when(
          () => mockService.getLocalizedMessage(
            mockContext,
            authFailure,
          ),
        ).thenReturn('Unauthorized message');

        final networkModel = ErrorModel.fromFailure(networkFailure);
        final authModel = ErrorModel.fromFailure(authFailure);

        expect(
          networkModel.getMessage(mockContext, mockService),
          'Network error message',
        );
        expect(
          authModel.getMessage(mockContext, mockService),
          'Unauthorized message',
        );

        verify(
          () => mockService.getLocalizedMessage(
            mockContext,
            networkFailure,
          ),
        ).called(1);
        verify(
          () => mockService.getLocalizedMessage(
            mockContext,
            authFailure,
          ),
        ).called(1);
      });
    });

    group('toString', () {
      test('returns string representation', () {
        const failure = InfrastructureFailure.server(
          message: 'Server error',
          statusCode: 500,
        );

        final model = ErrorModel.fromFailure(failure);
        final stringRepresentation = model.toString();

        expect(stringRepresentation, contains('ErrorModel'));
        expect(stringRepresentation, contains('Server error'));
        expect(stringRepresentation, contains('true')); // isRetryable
      });
    });
  });
}
