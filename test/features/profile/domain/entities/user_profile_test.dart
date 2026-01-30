import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/core/domain/value_objects/name.dart';
import 'package:starter_app/features/auth/domain/entities/user_id.dart';
import 'package:starter_app/features/profile/domain/entities/profile_id.dart';
import 'package:starter_app/features/profile/domain/events/profile_events.dart';

import '../../../../helpers/test_data.dart';

void main() {
  group('UserProfile', () {
    group('creation', () {
      test('creates a valid UserProfile with all required fields', () {
        final profile = TestData.userProfile();

        expect(profile.id, isA<ProfileId>());
        expect(profile.userId, isA<UserId>());
        expect(profile.displayName, isA<Name>());
      });

      test('creates profile with custom values', () {
        const customId = 'custom-profile-123';
        const customUserId = 'custom-user-456';
        const customName = 'Custom Name';
        const customAvatar = 'https://example.com/custom.jpg';

        final profile = TestData.userProfile(
          id: customId,
          userIdStr: customUserId,
          displayName: customName,
          avatar: customAvatar,
        );

        expect(profile.id.value.value, equals(customId));
        expect(profile.userId.value.value, equals(customUserId));
        expect(profile.displayName.getOrCrash(), equals(customName));
      });

      test('extends AggregateRoot', () {
        final profile = TestData.userProfile();

        // AggregateRoot should have domainEvents and clearDomainEvents
        expect(profile.domainEvents, isEmpty);
      });
    });

    group('copyWith', () {
      test('creates a copy with all same values', () {
        final profile = TestData.userProfile();
        final copy = profile.copyWith();

        expect(copy.id, equals(profile.id));
        expect(copy.userId, equals(profile.userId));
        expect(copy.displayName, equals(profile.displayName));
      });

      test('creates a copy with different id', () {
        final profile = TestData.userProfile();
        final newId = ProfileId.fromString('new-id');

        final copy = profile.copyWith(id: newId);

        expect(copy.id, equals(newId));
        expect(copy.userId, equals(profile.userId));
      });

      test('creates a copy with different userId', () {
        final profile = TestData.userProfile();
        final newUserId = UserId.fromString('new-user-id');

        final copy = profile.copyWith(userId: newUserId);

        expect(copy.id, equals(profile.id));
        expect(copy.userId, equals(newUserId));
      });
    });
  });

  group('ProfileId', () {
    test('generates unique ProfileId', () {
      final id1 = ProfileId.generate();
      final id2 = ProfileId.generate();

      expect(id1, isNot(equals(id2)));
    });

    test('creates ProfileId from string', () {
      const idString = 'test-profile-id';
      final profileId = ProfileId.fromString(idString);

      expect(profileId.value.value, equals(idString));
    });

    test('implements UniqueId', () {
      final profileId = ProfileId.generate();

      expect(profileId.value, isNotNull);
    });
  });

  group('ProfileDomainEvent', () {
    test('UserProfileCreated contains profile', () {
      final profile = TestData.userProfile();
      final event = UserProfileCreated(profile);

      expect(event.profile, equals(profile));
    });
  });
}
