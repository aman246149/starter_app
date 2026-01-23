import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/core/domain/value_objects/email_address.dart';
import 'package:starter_app/core/domain/value_objects/password.dart';
import 'package:starter_app/features/auth/domain/entities/auth_credentials.dart';
import 'package:starter_app/features/auth/infrastructure/models/login_request_model.dart';

import '../../../../helpers/test_data.dart';

void main() {
  group('LoginRequestModel', () {
    const tEmail = TestData.email;
    const tPassword = TestData.password;

    const tModel = LoginRequestModel(email: tEmail, password: tPassword);

    group('constructor', () {
      test('creates model with email and password', () {
        expect(tModel.email, tEmail);
        expect(tModel.password, tPassword);
      });
    });

    group('fromJson', () {
      test('deserializes from JSON', () {
        final json = {
          'email': tEmail,
          'password': tPassword,
        };

        final result = LoginRequestModel.fromJson(json);

        expect(result.email, tEmail);
        expect(result.password, tPassword);
      });
    });

    group('toJson', () {
      test('serializes to JSON', () {
        final result = tModel.toJson();

        expect(result['email'], tEmail);
        expect(result['password'], tPassword);
      });

      test('produces valid JSON for API requests', () {
        final json = tModel.toJson();

        expect(json, isA<Map<String, dynamic>>());
        expect(json.keys, containsAll(['email', 'password']));
      });
    });

    group('fromDomain', () {
      test('creates model from domain credentials', () {
        final credentials = AuthCredentials(
          email: EmailAddress(tEmail),
          password: Password(tPassword),
        );

        final result = LoginRequestModel.fromDomain(credentials);

        expect(result.email, tEmail);
        expect(result.password, tPassword);
      });

      test('extracts raw values from value objects', () {
        const rawEmail = TestData.email;
        const rawPassword = TestData.password;

        final credentials = AuthCredentials(
          email: EmailAddress(rawEmail),
          password: Password(rawPassword),
        );

        final result = LoginRequestModel.fromDomain(credentials);

        expect(result.email, rawEmail);
        expect(result.password, rawPassword);
      });
    });

    group('round trip conversion', () {
      test('JSON -> model -> JSON preserves data', () {
        final originalJson = {
          'email': tEmail,
          'password': tPassword,
        };

        final model = LoginRequestModel.fromJson(originalJson);
        final backToJson = model.toJson();

        expect(backToJson, originalJson);
      });

      test('domain -> model -> JSON produces valid request', () {
        final credentials = AuthCredentials(
          email: EmailAddress(tEmail),
          password: Password(tPassword),
        );

        final model = LoginRequestModel.fromDomain(credentials);
        final json = model.toJson();

        expect(json['email'], tEmail);
        expect(json['password'], tPassword);
      });
    });

    group('equality', () {
      test('equal models have same values', () {
        const model1 = LoginRequestModel(
          email: tEmail,
          password: tPassword,
        );

        const model2 = LoginRequestModel(
          email: tEmail,
          password: tPassword,
        );

        expect(model1, model2);
      });

      test('models with different emails are not equal', () {
        const model1 = LoginRequestModel(
          email: TestData.email,
          password: TestData.password,
        );

        const model2 = LoginRequestModel(
          email: TestData.invalidEmail,
          password: TestData.password,
        );

        expect(model1, isNot(model2));
      });

      test('models with different passwords are not equal', () {
        const model1 = LoginRequestModel(
          email: TestData.email,
          password: 'Password1!',
        );

        const model2 = LoginRequestModel(
          email: TestData.email,
          password: 'Password2!',
        );

        expect(model1, isNot(model2));
      });
    });

    group('edge cases', () {
      test('handles empty strings', () {
        const model = LoginRequestModel(
          email: '',
          password: '',
        );

        expect(model.email, '');
        expect(model.password, '');
      });

      test('handles special characters in password', () {
        const specialPassword = r'P@ss!#$%^&*()_+-={}[]|:;<>?,./~`';
        const model = LoginRequestModel(
          email: TestData.email,
          password: specialPassword,
        );

        expect(model.password, specialPassword);
      });

      test('preserves password case sensitivity', () {
        const model = LoginRequestModel(
          email: TestData.email,
          password: 'MixedCase123!',
        );

        expect(model.password, 'MixedCase123!');
      });
    });

    group('use cases', () {
      test('creates valid request for API endpoint', () {
        final credentials = TestData.loginCredentials();

        final model = LoginRequestModel.fromDomain(credentials);
        final json = model.toJson();

        // Should produce JSON ready for POST /auth/login
        expect(json, {
          'email': TestData.email,
          'password': TestData.password,
        });
      });
    });
  });
}
