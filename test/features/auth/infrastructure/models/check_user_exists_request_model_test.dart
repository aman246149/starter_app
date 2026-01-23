import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/core/domain/value_objects/email_address.dart';
import 'package:starter_app/features/auth/infrastructure/models/check_user_exists_request_model.dart';

import '../../../../helpers/test_data.dart';

void main() {
  group('CheckUserExistsRequestModel', () {
    const tEmail = TestData.email;

    const tModel = CheckUserExistsRequestModel(email: tEmail);

    group('constructor', () {
      test('creates model with email', () {
        expect(tModel.email, tEmail);
      });
    });

    group('fromJson', () {
      test('deserializes from JSON', () {
        final json = {'email': tEmail};

        final result = CheckUserExistsRequestModel.fromJson(json);

        expect(result.email, tEmail);
      });
    });

    group('toJson', () {
      test('serializes to JSON', () {
        final result = tModel.toJson();

        expect(result['email'], tEmail);
      });

      test('produces valid JSON for API requests', () {
        final json = tModel.toJson();

        expect(json, isA<Map<String, dynamic>>());
        expect(json.keys, contains('email'));
      });
    });

    group('fromDomain', () {
      test('creates model from domain email', () {
        final emailAddress = EmailAddress(tEmail);

        final result = CheckUserExistsRequestModel.fromDomain(emailAddress);

        expect(result.email, tEmail);
      });

      test('extracts raw value from EmailAddress value object', () {
        const rawEmail = TestData.email;
        final emailAddress = EmailAddress(rawEmail);

        final result = CheckUserExistsRequestModel.fromDomain(emailAddress);

        expect(result.email, rawEmail);
      });

      test('normalizes email to lowercase', () {
        final emailAddress = EmailAddress('John@Example.COM');

        final result = CheckUserExistsRequestModel.fromDomain(emailAddress);

        // EmailAddress normalizes to lowercase
        expect(result.email, 'john@example.com');
      });
    });

    group('round trip conversion', () {
      test('JSON -> model -> JSON preserves data', () {
        final originalJson = {'email': tEmail};

        final model = CheckUserExistsRequestModel.fromJson(originalJson);
        final backToJson = model.toJson();

        expect(backToJson, originalJson);
      });

      test('domain -> model -> JSON produces valid request', () {
        final emailAddress = EmailAddress(tEmail);

        final model = CheckUserExistsRequestModel.fromDomain(emailAddress);
        final json = model.toJson();

        expect(json['email'], tEmail);
      });
    });

    group('equality', () {
      test('equal models have same values', () {
        const model1 = CheckUserExistsRequestModel(email: tEmail);
        const model2 = CheckUserExistsRequestModel(email: tEmail);

        expect(model1, model2);
      });

      test('models with different emails are not equal', () {
        const model1 = CheckUserExistsRequestModel(
          email: TestData.email,
        );
        const model2 = CheckUserExistsRequestModel(
          email: TestData.invalidEmail,
        );

        expect(model1, isNot(model2));
      });
    });

    group('edge cases', () {
      test('handles email with subdomains', () {
        const model = CheckUserExistsRequestModel(
          email: 'user@mail.example.com',
        );

        expect(model.email, 'user@mail.example.com');
      });

      test('handles email with plus addressing', () {
        const model = CheckUserExistsRequestModel(
          email: 'user+tag@example.com',
        );

        expect(model.email, 'user+tag@example.com');
      });

      test('handles email with dots in local part', () {
        const model = CheckUserExistsRequestModel(
          email: 'first.last@example.com',
        );

        expect(model.email, 'first.last@example.com');
      });
    });

    group('use cases', () {
      test('creates valid request for API endpoint', () {
        final emailAddress = TestData.emailAddress('check@example.com');

        final model = CheckUserExistsRequestModel.fromDomain(emailAddress);
        final json = model.toJson();

        // Should produce JSON ready for POST /auth/check-user-exists
        expect(json, {'email': 'check@example.com'});
      });

      test('works in auth flow to check if email is taken', () {
        final emailAddress = TestData.emailAddress('newuser@example.com');

        final model = CheckUserExistsRequestModel.fromDomain(emailAddress);

        expect(model.email, 'newuser@example.com');
        expect(model.toJson(), {'email': 'newuser@example.com'});
      });
    });
  });
}
