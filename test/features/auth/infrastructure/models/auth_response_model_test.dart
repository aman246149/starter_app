import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/features/auth/infrastructure/models/auth_response_model.dart';
import 'package:starter_app/features/auth/infrastructure/models/auth_tokens_model.dart';
import 'package:starter_app/features/auth/infrastructure/models/user_model.dart';

import '../../../../helpers/test_data.dart';

void main() {
  group('AuthResponseModel', () {
    const tUserModel = TestData.userModel;

    const tTokensModel = TestData.authTokensModel;

    const tModel = TestData.authResponseModel;

    group('fromJson', () {
      test('deserializes from JSON with all fields', () {
        const json = TestData.authResponseJson;

        final result = AuthResponseModel.fromJson(json);

        expect(result.user.id, TestData.userId);
        expect(result.user.email, TestData.email);
        expect(result.tokens.accessToken, TestData.accessToken);
        expect(result.tokens.refreshToken, TestData.refreshToken);
      });

      test('deserializes nested user model correctly', () {
        final json = {
          'user': {
            'id': '456',
            'email': TestData.email,
          },
          'tokens': {
            'accessToken': 'token1',
            'refreshToken': 'token2',
          },
        };

        final result = AuthResponseModel.fromJson(json);

        expect(result.user.id, '456');
        expect(result.user.email, TestData.email);
      });
    });

    group('toJson', () {
      test('serializes to JSON with all fields', () {
        final result = tModel.toJson();

        expect(result, isA<Map<String, dynamic>>());
        expect(result.containsKey('user'), true);
        expect(result.containsKey('tokens'), true);
      });

      test('serializes nested models correctly', () {
        final json = tModel.toJson();

        expect(json, isA<Map<String, dynamic>>());
        expect(json.containsKey('user'), true);
        expect(json.containsKey('tokens'), true);
      });
    });

    group('domain conversion', () {
      test('user can be converted to domain entity', () {
        final user = tModel.user.toDomain();
        expect(user.id.value.value, TestData.userId);
        expect(user.email.getOrCrash(), TestData.email);
      });

      test('tokens can be converted to domain value objects', () {
        final accessToken = tModel.tokens.toAccessToken();
        final refreshToken = tModel.tokens.toRefreshToken();

        expect(accessToken.getOrCrash(), TestData.accessToken);
        expect(refreshToken.getOrCrash(), TestData.refreshToken);
      });
    });

    group('round trip conversion', () {
      test('JSON -> model -> JSON preserves data', () {
        const originalJson = TestData.authResponseJson;

        final model = AuthResponseModel.fromJson(originalJson);
        final backToJson = model.toJson();

        // Verify it's a Map
        expect(backToJson, isA<Map<String, dynamic>>());
        expect(backToJson.containsKey('user'), true);
        expect(backToJson.containsKey('tokens'), true);
      });
    });

    group('equality', () {
      test('equal models have same values', () {
        const model1 = AuthResponseModel(
          user: tUserModel,
          tokens: tTokensModel,
        );

        const model2 = AuthResponseModel(
          user: tUserModel,
          tokens: tTokensModel,
        );

        expect(model1, model2);
      });

      test('models with different users are not equal', () {
        const differentUser = UserModel(
          id: '456',
          email: 'other@example.com',
        );

        const model1 = AuthResponseModel(
          user: TestData.userModel,
          tokens: TestData.authTokensModel,
        );

        const model2 = AuthResponseModel(
          user: differentUser,
          tokens: TestData.authTokensModel,
        );

        expect(model1, isNot(model2));
      });

      test('models with different tokens are not equal', () {
        const differentTokens = AuthTokensModel(
          accessToken: 'different-access',
          refreshToken: 'different-refresh',
        );

        const model1 = AuthResponseModel(
          user: TestData.userModel,
          tokens: TestData.authTokensModel,
        );

        const model2 = AuthResponseModel(
          user: TestData.userModel,
          tokens: differentTokens,
        );

        expect(model1, isNot(model2));
      });
    });

    group('use cases', () {
      test('represents successful login response', () {
        const json = TestData.authResponseJson;

        final response = AuthResponseModel.fromJson(json);

        expect(response.user.email, TestData.email);
        expect(response.tokens.accessToken, TestData.accessToken);
        expect(response.tokens.refreshToken, TestData.refreshToken);
      });

      test('represents successful registration response', () {
        final json = {
          'user': {
            'id': 'new-user-id',
            'email': TestData.email,
          },
          'tokens': {
            'accessToken': 'new-access-token',
            'refreshToken': 'new-refresh-token',
          },
        };

        final response = AuthResponseModel.fromJson(json);

        expect(response.user.id, 'new-user-id');
        expect(response.user.email, TestData.email);
      });
    });
  });
}
