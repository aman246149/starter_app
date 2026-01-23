import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/features/auth/infrastructure/models/register_request_model.dart';

import '../../../../helpers/test_data.dart';

void main() {
  group('RegisterRequestModel', () {
    group('constructor', () {
      test('creates model with email, password, and name', () {
        const model = RegisterRequestModel(
          email: TestData.email,
          password: TestData.password,
          name: TestData.name,
        );

        expect(model.email, TestData.email);
        expect(model.password, TestData.password);
        expect(model.name, TestData.name);
      });
    });

    group('fromDomain', () {
      test('creates model from AuthCredentials and Name', () {
        final credentials = TestData.registerCredentials();
        final name = TestData.nameVO();
        final model = RegisterRequestModel.fromDomain(credentials, name);

        expect(model.email, credentials.emailValue);
        expect(model.password, credentials.passwordValue);
        expect(model.name, name.getOrCrash());
      });

      test('creates model with custom credentials', () {
        final credentials = TestData.registerCredentials(
          emailStr: 'custom@example.com',
          passwordStr: 'Custom123!@#',
        );
        final name = TestData.nameVO('Custom Name');

        final model = RegisterRequestModel.fromDomain(credentials, name);

        expect(model.email, 'custom@example.com');
        expect(model.password, 'Custom123!@#');
        expect(model.name, 'Custom Name');
      });
    });

    group('toJson', () {
      test('converts model to JSON', () {
        const model = RegisterRequestModel(
          email: TestData.email,
          password: TestData.password,
          name: TestData.name,
        );

        final json = model.toJson();

        expect(json['email'], TestData.email);
        expect(json['password'], TestData.password);
        expect(json['name'], TestData.name);
      });
    });

    group('fromJson', () {
      test('creates model from JSON', () {
        const json = {
          'email': TestData.email,
          'password': TestData.password,
          'name': TestData.name,
        };

        final model = RegisterRequestModel.fromJson(json);

        expect(model.email, TestData.email);
        expect(model.password, TestData.password);
        expect(model.name, TestData.name);
      });
    });

    group('equality', () {
      test('two models with same values are equal', () {
        const model1 = RegisterRequestModel(
          email: TestData.email,
          password: TestData.password,
          name: TestData.name,
        );
        const model2 = RegisterRequestModel(
          email: TestData.email,
          password: TestData.password,
          name: TestData.name,
        );

        expect(model1, model2);
      });
    });
  });
}
