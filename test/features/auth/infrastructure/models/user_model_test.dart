import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/features/auth/infrastructure/models/user_model.dart';

import '../../../../helpers/test_data.dart';

void main() {
  group('UserModel', () {
    const tId = TestData.userId;
    const tEmail = TestData.email;

    const tUserModel = TestData.userModel;

    final tUser = TestData.user();

    group('fromJson', () {
      test('deserializes from JSON with all fields', () {
        const json = TestData.userJson;

        final result = UserModel.fromJson(json);

        expect(result.id, tId);
        expect(result.email, tEmail);
      });
    });

    group('toJson', () {
      test('serializes to JSON with all fields', () {
        final result = tUserModel.toJson();

        expect(result['id'], tId);
        expect(result['email'], tEmail);
      });
    });

    group('fromDomain', () {
      test('creates model from domain entity', () {
        final result = UserModel.fromDomain(tUser);

        expect(result.id, tId);
        expect(result.email, tEmail);
      });
    });

    group('toDomain', () {
      test('converts model to domain entity', () {
        final result = tUserModel.toDomain();

        expect(result.id.value.value, tId);
        expect(result.email.getOrCrash(), tEmail);
      });

      test('uses fromTrustedSource for value objects', () {
        // This test verifies that even invalid email formats
        // are accepted since data comes from backend
        const invalidEmail = 'not-an-email';
        const model = UserModel(
          id: TestData.userId,
          email: invalidEmail,
        );

        final result = model.toDomain();

        // Should not throw, should use fromTrustedSource
        expect(result.email.getOrCrash(), invalidEmail);
      });
    });

    group('round trip conversion', () {
      test('domain -> model -> domain preserves data', () {
        final model = UserModel.fromDomain(tUser);
        final backToDomain = model.toDomain();

        expect(backToDomain.id.value.value, tUser.id.value.value);
        expect(backToDomain.email.getOrCrash(), tUser.email.getOrCrash());
      });

      test('JSON -> model -> JSON preserves data', () {
        const originalJson = TestData.userJson;

        final model = UserModel.fromJson(originalJson);
        final backToJson = model.toJson();

        expect(backToJson, originalJson);
      });
    });

    group('equality', () {
      test('equal models have same values', () {
        const model1 = TestData.userModel;

        const model2 = TestData.userModel;

        expect(model1, model2);
      });

      test('models with different IDs are not equal', () {
        const model1 = UserModel(
          id: TestData.userId,
          email: TestData.email,
        );

        const model2 = UserModel(
          id: '456',
          email: TestData.email,
        );

        expect(model1, isNot(model2));
      });
    });
  });
}
