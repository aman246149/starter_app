import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/features/auth/infrastructure/models/auth_tokens_model.dart';

import '../../../../helpers/test_data.dart';

void main() {
  group('AuthTokensModel', () {
    const tAccessToken = TestData.accessToken;
    const tRefreshToken = TestData.refreshToken;

    const tModel = AuthTokensModel(
      accessToken: tAccessToken,
      refreshToken: tRefreshToken,
    );

    group('fromJson', () {
      test('deserializes from JSON', () {
        final json = {
          'accessToken': tAccessToken,
          'refreshToken': tRefreshToken,
        };

        final result = AuthTokensModel.fromJson(json);

        expect(result.accessToken, tAccessToken);
        expect(result.refreshToken, tRefreshToken);
      });

      test('handles camelCase field names', () {
        final json = {
          'accessToken': tAccessToken,
          'refreshToken': tRefreshToken,
        };

        final result = AuthTokensModel.fromJson(json);

        expect(result, tModel);
      });
    });

    group('toJson', () {
      test('serializes to JSON', () {
        final result = tModel.toJson();

        expect(result['accessToken'], tAccessToken);
        expect(result['refreshToken'], tRefreshToken);
      });

      test('produces valid JSON for API requests', () {
        final json = tModel.toJson();

        expect(json, isA<Map<String, dynamic>>());
        expect(json.keys, containsAll(['accessToken', 'refreshToken']));
      });
    });

    group('toAccessToken', () {
      test('converts to AuthToken value object', () {
        final result = tModel.toAccessToken();

        expect(result.isValid, true);
        expect(result.getOrCrash(), tAccessToken);
      });

      test('uses fromTrustedSource', () {
        // Invalid format should still work with fromTrustedSource
        const modelWithInvalidToken = AuthTokensModel(
          accessToken: 'invalid-format', // Keep invalid format for this test
          refreshToken: TestData.refreshToken,
        );

        final result = modelWithInvalidToken.toAccessToken();

        // Should not throw, uses fromTrustedSource
        expect(result.getOrCrash(), 'invalid-format');
      });
    });

    group('toRefreshToken', () {
      test('converts to RefreshToken value object', () {
        final result = tModel.toRefreshToken();

        expect(result.isValid, true);
        expect(result.getOrCrash(), tRefreshToken);
      });

      test('uses fromTrustedSource', () {
        // Short token should still work with fromTrustedSource
        const modelWithShortToken = AuthTokensModel(
          accessToken: TestData.accessToken,
          refreshToken: 'short',
        );

        final result = modelWithShortToken.toRefreshToken();

        // Should not throw, uses fromTrustedSource
        expect(result.getOrCrash(), 'short');
      });
    });

    group('round trip conversion', () {
      test('JSON -> model -> JSON preserves data', () {
        final originalJson = {
          'accessToken': tAccessToken,
          'refreshToken': tRefreshToken,
        };

        final model = AuthTokensModel.fromJson(originalJson);
        final backToJson = model.toJson();

        expect(backToJson, originalJson);
      });
    });

    group('equality', () {
      test('equal models have same values', () {
        const model1 = AuthTokensModel(
          accessToken: tAccessToken,
          refreshToken: tRefreshToken,
        );

        const model2 = AuthTokensModel(
          accessToken: tAccessToken,
          refreshToken: tRefreshToken,
        );

        expect(model1, model2);
      });

      test('models with different access tokens are not equal', () {
        const model1 = AuthTokensModel(
          accessToken: 'token1',
          refreshToken: TestData.refreshToken,
        );

        const model2 = AuthTokensModel(
          accessToken: 'token2',
          refreshToken: TestData.refreshToken,
        );

        expect(model1, isNot(model2));
      });

      test('models with different refresh tokens are not equal', () {
        const model1 = AuthTokensModel(
          accessToken: TestData.accessToken,
          refreshToken: 'refresh1',
        );

        const model2 = AuthTokensModel(
          accessToken: TestData.accessToken,
          refreshToken: 'refresh2',
        );

        expect(model1, isNot(model2));
      });
    });

    group('edge cases', () {
      test('handles empty strings', () {
        const model = AuthTokensModel(
          accessToken: '',
          refreshToken: '',
        );

        expect(model.accessToken, '');
        expect(model.refreshToken, '');
      });

      test('handles very long tokens', () {
        final longToken = 'a' * 1000;
        final model = AuthTokensModel(
          accessToken: longToken,
          refreshToken: longToken,
        );

        expect(model.accessToken.length, 1000);
        expect(model.refreshToken.length, 1000);
      });
    });
  });
}
