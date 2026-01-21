import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/core/error/failures/value_failure.dart';

void main() {
  group('ValueFailure', () {
    group('Empty', () {
      test('creates empty failure without field name', () {
        const failure = ValueFailure<String>.empty();

        expect(failure, isA<Empty<String>>());
        failure.when(
          empty: (fieldName) => expect(fieldName, null),
          tooShort: (min, actual) => fail('Wrong type'),
          tooLong: (max, actual) => fail('Wrong type'),
          invalidFormat: (format, value) => fail('Wrong type'),
          outOfRange: (min, max, actual) => fail('Wrong type'),
        );
      });

      test('creates empty failure with field name', () {
        const failure = ValueFailure<String>.empty(fieldName: 'Email');

        expect(failure, isA<Empty<String>>());
        failure.when(
          empty: (fieldName) => expect(fieldName, 'Email'),
          tooShort: (min, actual) => fail('Wrong type'),
          tooLong: (max, actual) => fail('Wrong type'),
          invalidFormat: (format, value) => fail('Wrong type'),
          outOfRange: (min, max, actual) => fail('Wrong type'),
        );
      });

      test('equals another empty failure with same field name', () {
        const failure1 = ValueFailure<String>.empty(fieldName: 'Email');
        const failure2 = ValueFailure<String>.empty(fieldName: 'Email');

        expect(failure1, failure2);
      });

      test('not equals empty failure with different field name', () {
        const failure1 = ValueFailure<String>.empty(fieldName: 'Email');
        const failure2 = ValueFailure<String>.empty(fieldName: 'Password');

        expect(failure1, isNot(failure2));
      });
    });

    group('TooShort', () {
      test('creates too short failure', () {
        const failure = ValueFailure<String>.tooShort(
          minLength: 8,
          actualLength: 5,
        );

        expect(failure, isA<TooShort<String>>());
        failure.when(
          empty: (field) => fail('Wrong type'),
          tooShort: (minLength, actualLength) {
            expect(minLength, 8);
            expect(actualLength, 5);
          },
          tooLong: (max, actual) => fail('Wrong type'),
          invalidFormat: (format, value) => fail('Wrong type'),
          outOfRange: (min, max, actual) => fail('Wrong type'),
        );
      });

      test('equals another too short failure with same values', () {
        const failure1 = ValueFailure<String>.tooShort(
          minLength: 8,
          actualLength: 5,
        );
        const failure2 = ValueFailure<String>.tooShort(
          minLength: 8,
          actualLength: 5,
        );

        expect(failure1, failure2);
      });

      test('not equals too short failure with different values', () {
        const failure1 = ValueFailure<String>.tooShort(
          minLength: 8,
          actualLength: 5,
        );
        const failure2 = ValueFailure<String>.tooShort(
          minLength: 10,
          actualLength: 5,
        );

        expect(failure1, isNot(failure2));
      });
    });

    group('TooLong', () {
      test('creates too long failure', () {
        const failure = ValueFailure<String>.tooLong(
          maxLength: 100,
          actualLength: 150,
        );

        expect(failure, isA<TooLong<String>>());
        failure.when(
          empty: (field) => fail('Wrong type'),
          tooShort: (min, actual) => fail('Wrong type'),
          tooLong: (maxLength, actualLength) {
            expect(maxLength, 100);
            expect(actualLength, 150);
          },
          invalidFormat: (format, value) => fail('Wrong type'),
          outOfRange: (min, max, actual) => fail('Wrong type'),
        );
      });

      test('equals another too long failure with same values', () {
        const failure1 = ValueFailure<String>.tooLong(
          maxLength: 100,
          actualLength: 150,
        );
        const failure2 = ValueFailure<String>.tooLong(
          maxLength: 100,
          actualLength: 150,
        );

        expect(failure1, failure2);
      });
    });

    group('InvalidFormat', () {
      test('creates invalid format failure', () {
        const failure = ValueFailure<String>.invalidFormat(
          expectedFormat: 'Valid email address',
          failedValue: 'not-an-email',
        );

        expect(failure, isA<InvalidFormat<String>>());
        failure.when(
          empty: (field) => fail('Wrong type'),
          tooShort: (min, actual) => fail('Wrong type'),
          tooLong: (max, actual) => fail('Wrong type'),
          invalidFormat: (expectedFormat, failedValue) {
            expect(expectedFormat, 'Valid email address');
            expect(failedValue, 'not-an-email');
          },
          outOfRange: (min, max, actual) => fail('Wrong type'),
        );
      });

      test('equals another invalid format failure with same values', () {
        const failure1 = ValueFailure<String>.invalidFormat(
          expectedFormat: 'Valid email',
          failedValue: 'invalid',
        );
        const failure2 = ValueFailure<String>.invalidFormat(
          expectedFormat: 'Valid email',
          failedValue: 'invalid',
        );

        expect(failure1, failure2);
      });
    });

    group('OutOfRange', () {
      test('creates out of range failure', () {
        const failure = ValueFailure<int>.outOfRange(
          min: 0,
          max: 100,
          actual: 150,
        );

        expect(failure, isA<OutOfRange<int>>());
        failure.when(
          empty: (field) => fail('Wrong type'),
          tooShort: (min, actual) => fail('Wrong type'),
          tooLong: (max, actual) => fail('Wrong type'),
          invalidFormat: (format, value) => fail('Wrong type'),
          outOfRange: (min, max, actual) {
            expect(min, 0);
            expect(max, 100);
            expect(actual, 150);
          },
        );
      });

      test('equals another out of range failure with same values', () {
        const failure1 = ValueFailure<int>.outOfRange(
          min: 0,
          max: 100,
          actual: 150,
        );
        const failure2 = ValueFailure<int>.outOfRange(
          min: 0,
          max: 100,
          actual: 150,
        );

        expect(failure1, failure2);
      });

      test('works with decimal values', () {
        const failure = ValueFailure<double>.outOfRange(
          min: 0.0,
          max: 1.0,
          actual: 1.5,
        );

        expect(failure, isA<OutOfRange<double>>());
        failure.when(
          empty: (field) => fail('Wrong type'),
          tooShort: (min, actual) => fail('Wrong type'),
          tooLong: (max, actual) => fail('Wrong type'),
          invalidFormat: (format, value) => fail('Wrong type'),
          outOfRange: (min, max, actual) {
            expect(min, 0.0);
            expect(max, 1.0);
            expect(actual, 1.5);
          },
        );
      });
    });

    group('type safety', () {
      test('supports different generic types', () {
        const stringFailure = ValueFailure<String>.empty();
        const intFailure = ValueFailure<int>.outOfRange(
          min: 0,
          max: 10,
          actual: 15,
        );
        const doubleFailure = ValueFailure<double>.outOfRange(
          min: 0.0,
          max: 1.0,
          actual: 2.0,
        );

        expect(stringFailure, isA<ValueFailure<String>>());
        expect(intFailure, isA<ValueFailure<int>>());
        expect(doubleFailure, isA<ValueFailure<double>>());
      });
    });
  });
}
