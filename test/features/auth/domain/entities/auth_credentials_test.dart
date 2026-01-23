import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/core/domain/base/value_object.dart';
import 'package:starter_app/core/domain/value_objects/email_address.dart';
import 'package:starter_app/core/domain/value_objects/name.dart';
import 'package:starter_app/core/domain/value_objects/password.dart';
import 'package:starter_app/features/auth/domain/entities/auth_credentials.dart';

void main() {
  group('AuthCredentials', () {
    final validEmail = EmailAddress('test@example.com');
    final validPassword = Password('Password123!');
    final validName = Name('John Doe');
    final invalidEmail = EmailAddress('invalid-email');
    final invalidPassword = Password('short');
    final invalidName = Name('');

    group('isValidForLogin', () {
      test('should return true when both email and password are valid', () {
        final credentials = AuthCredentials(
          email: validEmail,
          password: validPassword,
        );

        expect(credentials.isValidForLogin, isTrue);
      });

      test('should return false when email is invalid', () {
        final credentials = AuthCredentials(
          email: invalidEmail,
          password: validPassword,
        );

        expect(credentials.isValidForLogin, isFalse);
      });

      test('should return false when password is invalid', () {
        final credentials = AuthCredentials(
          email: validEmail,
          password: invalidPassword,
        );

        expect(credentials.isValidForLogin, isFalse);
      });
    });

    group('isValidForRegistration', () {
      test('should return true when email, password, and name are valid', () {
        final credentials = AuthCredentials(
          email: validEmail,
          password: validPassword,
          name: validName,
        );

        expect(credentials.isValidForRegistration, isTrue);
      });

      test('should return false when name is null', () {
        final credentials = AuthCredentials(
          email: validEmail,
          password: validPassword,
        );

        expect(credentials.isValidForRegistration, isFalse);
      });

      test('should return false when name is invalid', () {
        final credentials = AuthCredentials(
          email: validEmail,
          password: validPassword,
          name: invalidName,
        );

        expect(credentials.isValidForRegistration, isFalse);
      });

      test(
        'should return false when email is invalid even with valid name',
        () {
          final credentials = AuthCredentials(
            email: invalidEmail,
            password: validPassword,
            name: validName,
          );

          expect(credentials.isValidForRegistration, isFalse);
        },
      );
    });

    group('values', () {
      test('should return correct emailValue when valid', () {
        final credentials = AuthCredentials(
          email: validEmail,
          password: validPassword,
        );

        expect(credentials.emailValue, 'test@example.com');
      });

      test('should throw when accessing invalid emailValue', () {
        final credentials = AuthCredentials(
          email: invalidEmail,
          password: validPassword,
        );

        expect(
          () => credentials.emailValue,
          throwsA(isA<UnexpectedValueError>()),
        );
      });

      test('should return correct passwordValue when valid', () {
        final credentials = AuthCredentials(
          email: validEmail,
          password: validPassword,
        );

        expect(credentials.passwordValue, 'Password123!');
      });

      test('should throw when accessing invalid passwordValue', () {
        final credentials = AuthCredentials(
          email: validEmail,
          password: invalidPassword,
        );

        expect(
          () => credentials.passwordValue,
          throwsA(isA<UnexpectedValueError>()),
        );
      });

      test('should return correct nameValue when valid', () {
        final credentials = AuthCredentials(
          email: validEmail,
          password: validPassword,
          name: validName,
        );

        expect(credentials.nameValue, 'John Doe');
      });

      test('should return null nameValue when name is null', () {
        final credentials = AuthCredentials(
          email: validEmail,
          password: validPassword,
        );

        expect(credentials.nameValue, isNull);
      });
    });

    group('equality', () {
      test('should be equal when values are same (without name)', () {
        final creds1 = AuthCredentials(
          email: validEmail,
          password: validPassword,
        );
        final creds2 = AuthCredentials(
          email: validEmail,
          password: validPassword,
        );

        expect(creds1, equals(creds2));
        expect(creds1.hashCode, equals(creds2.hashCode));
      });

      test('should be equal when values are same (with name)', () {
        final creds1 = AuthCredentials(
          email: validEmail,
          password: validPassword,
          name: validName,
        );
        final creds2 = AuthCredentials(
          email: validEmail,
          password: validPassword,
          name: validName,
        );

        expect(creds1, equals(creds2));
        expect(creds1.hashCode, equals(creds2.hashCode));
      });

      test('should not be equal when values differ', () {
        final creds1 = AuthCredentials(
          email: validEmail,
          password: validPassword,
        );
        final creds2 = AuthCredentials(
          email: EmailAddress('other@example.com'),
          password: validPassword,
        );

        expect(creds1, isNot(equals(creds2)));
      });

      test('should not be equal when name differs', () {
        final creds1 = AuthCredentials(
          email: validEmail,
          password: validPassword,
          name: validName,
        );
        final creds2 = AuthCredentials(
          email: validEmail,
          password: validPassword,
          name: Name('Jane Doe'),
        );

        expect(creds1, isNot(equals(creds2)));
      });
    });

    group('toString', () {
      test('should mask password in toString', () {
        final credentials = AuthCredentials(
          email: validEmail,
          password: validPassword,
        );

        final string = credentials.toString();
        expect(string, contains('test@example.com'));
        expect(string, contains('****'));
        expect(string, isNot(contains('Password123!')));
      });

      test('should show invalid for invalid fields', () {
        final credentials = AuthCredentials(
          email: invalidEmail,
          password: invalidPassword,
        );

        final string = credentials.toString();
        expect(string, contains('invalid'));
      });

      test('should show name in toString when provided', () {
        final credentials = AuthCredentials(
          email: validEmail,
          password: validPassword,
          name: validName,
        );

        final string = credentials.toString();
        expect(string, contains('John Doe'));
      });
    });
  });
}
