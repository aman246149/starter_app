import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/features/profile/domain/entities/user_profile.dart';
import 'package:starter_app/features/profile/infrastructure/models/user_profile_model.dart';

import '../../../../helpers/test_data.dart';

void main() {
  group('UserProfileModel', () {
    group('fromJson', () {
      test('should parse valid JSON correctly', () {
        final model = UserProfileModel.fromJson(TestData.userProfileJson);

        expect(model.id, equals(TestData.userId));
        expect(model.userId, equals(TestData.userId));
        expect(model.displayName, equals(TestData.name));
        expect(model.avatarUrl, equals(TestData.profileImageUrl));
      });

      test('should handle null avatarUrl', () {
        final json = <String, dynamic>{
          'id': TestData.userId,
          'userId': TestData.userId,
          'displayName': TestData.name,
          'avatarUrl': null,
        };

        final model = UserProfileModel.fromJson(json);

        expect(model.avatarUrl, isNull);
      });

      test('should handle missing avatarUrl', () {
        final json = <String, dynamic>{
          'id': TestData.userId,
          'userId': TestData.userId,
          'displayName': TestData.name,
        };

        final model = UserProfileModel.fromJson(json);

        expect(model.avatarUrl, isNull);
      });
    });

    group('toJson', () {
      test('should serialize to JSON correctly', () {
        const model = UserProfileModel(
          id: TestData.userId,
          userId: TestData.userId,
          displayName: TestData.name,
          avatarUrl: TestData.profileImageUrl,
        );

        final json = model.toJson();

        expect(json['id'], equals(TestData.userId));
        expect(json['userId'], equals(TestData.userId));
        expect(json['displayName'], equals(TestData.name));
        expect(json['avatarUrl'], equals(TestData.profileImageUrl));
      });

      test('should serialize null avatarUrl correctly', () {
        const model = UserProfileModel(
          id: TestData.userId,
          userId: TestData.userId,
          displayName: TestData.name,
        );

        final json = model.toJson();

        expect(json['avatarUrl'], isNull);
      });
    });

    group('fromDomain', () {
      test('should convert domain entity to model', () {
        final profile = TestData.userProfile();

        final model = UserProfileModel.fromDomain(profile);

        expect(model.id, equals(TestData.userId));
        expect(model.userId, equals(TestData.userId));
        expect(model.displayName, equals(TestData.name));
        // Note: Domain entity UserProfile doesn't have avatarUrl field
        // so model.avatarUrl will be null after conversion
        expect(model.avatarUrl, isNull);
      });
    });

    group('toDomain', () {
      test('should convert model to domain entity', () {
        const model = TestData.userProfileModel;

        final profile = model.toDomain();

        expect(profile, isA<UserProfile>());
        expect(profile.id.value.value, equals(TestData.userId));
        expect(profile.userId.value.value, equals(TestData.userId));
        expect(profile.displayName.getOrCrash(), equals(TestData.name));
      });
    });

    group('equality', () {
      test('should be equal when all fields match', () {
        const model1 = UserProfileModel(
          id: TestData.userId,
          userId: TestData.userId,
          displayName: TestData.name,
          avatarUrl: TestData.profileImageUrl,
        );
        const model2 = UserProfileModel(
          id: TestData.userId,
          userId: TestData.userId,
          displayName: TestData.name,
          avatarUrl: TestData.profileImageUrl,
        );

        expect(model1, equals(model2));
      });

      test('should not be equal when fields differ', () {
        const model1 = UserProfileModel(
          id: 'id1',
          userId: TestData.userId,
          displayName: TestData.name,
        );
        const model2 = UserProfileModel(
          id: 'id2',
          userId: TestData.userId,
          displayName: TestData.name,
        );

        expect(model1, isNot(equals(model2)));
      });
    });
  });
}
