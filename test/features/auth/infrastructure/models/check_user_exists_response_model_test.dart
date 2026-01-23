import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/features/auth/infrastructure/models/check_user_exists_response_model.dart';

void main() {
  group('CheckUserExistsResponseModel', () {
    test('fromJson creates model correctly', () {
      final json = {'exists': true};
      final model = CheckUserExistsResponseModel.fromJson(json);

      expect(model.exists, true);
    });

    test('equality works correctly', () {
      const model1 = CheckUserExistsResponseModel(exists: true);
      const model2 = CheckUserExistsResponseModel(exists: true);

      expect(model1, model2);
    });

    test('toJson converts model correctly', () {
      const model = CheckUserExistsResponseModel(exists: true);

      final json = model.toJson();

      expect(json['exists'], true);
    });

    test('fromJson handles false value', () {
      final json = {'exists': false};
      final model = CheckUserExistsResponseModel.fromJson(json);

      expect(model.exists, false);
    });
  });
}
