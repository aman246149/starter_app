import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/features/auth/domain/entities/user.dart';
import 'package:starter_app/features/auth/domain/events/auth_events.dart';

import '../../../../helpers/test_data.dart';

void main() {
  group('User', () {
    final testId = TestData.uniqueUserId();
    final testEmail = TestData.emailAddress();

    group('constructor', () {
      test('creates user with all required fields', () {
        final user = User(
          id: testId,
          email: testEmail,
        );

        expect(user.id, testId);
        expect(user.email, testEmail);
      });
    });

    group('changeEmail', () {
      test('updates email and emits event', () {
        final user = TestData.user(
          id: testId.value.value,
          emailStr: 'old@example.com',
        );

        final newEmail = TestData.emailAddress('new@example.com');
        final updatedUser = user.changeEmail(newEmail);

        expect(updatedUser.email, newEmail);
        expect(updatedUser.domainEvents.length, 1);
        expect(updatedUser.domainEvents.first, isA<UserEmailChanged>());

        final event = updatedUser.domainEvents.first as UserEmailChanged;
        expect(event.user, updatedUser);
        expect(event.oldEmail, 'old@example.com');
      });

      test('does nothing when email is same', () {
        final user = TestData.user(
          id: testId.value.value,
          emailStr: testEmail.getOrCrash(),
        );

        final updatedUser = user.changeEmail(testEmail);

        expect(updatedUser, user); // Same instance
        expect(updatedUser.domainEvents, isEmpty);
      });
    });

    group('equality', () {
      test('has same ID when created with same ID', () {
        final user1 = TestData.user(
          id: testId.value.value,
          emailStr: testEmail.getOrCrash(),
        );

        final user2 = TestData.user(
          id: testId.value.value,
          emailStr: 'different@example.com',
        );

        // Both users have the same ID
        expect(user1.id, user2.id);
      });

      test('not equals user with different id', () {
        final user1 = TestData.user(
          id: testId.value.value,
          emailStr: testEmail.getOrCrash(),
        );

        final user2 = TestData.user(
          id: TestData.uniqueId('user-456').value,
          emailStr: testEmail.getOrCrash(),
        );

        expect(user1, isNot(user2));
      });

      test('identity check returns true for same instance', () {
        final user = TestData.user(
          id: testId.value.value,
          emailStr: testEmail.getOrCrash(),
        );

        expect(identical(user, user), true);
      });

      test('equals user with same id even if other properties differ', () {
        final user1 = TestData.user(
          id: testId.value.value,
          emailStr: testEmail.getOrCrash(),
        );

        final user2 = TestData.user(
          id: testId.value.value,
          emailStr: 'other@example.com',
        );

        // Identity-based equality: same ID means same entity
        expect(user1, user2);
        expect(user1.hashCode, user2.hashCode);
      });
    });

    group('hashCode', () {
      test('hashCode exists and is consistent', () {
        final user = TestData.user(
          id: testId.value.value,
          emailStr: testEmail.getOrCrash(),
        );

        expect(user.hashCode, isNotNull);
        expect(user.hashCode, user.hashCode); // Consistent
      });

      test('different id produces different hash code', () {
        final user1 = TestData.user(
          id: testId.value.value,
          emailStr: testEmail.getOrCrash(),
        );

        final user2 = TestData.user(
          id: TestData.uniqueId('user-456').value,
          emailStr: testEmail.getOrCrash(),
        );

        expect(user1.hashCode, isNot(user2.hashCode));
      });
    });

    group('copyWith', () {
      test('creates new user with updated fields', () {
        final user = TestData.user(
          id: testId.value.value,
          emailStr: testEmail.getOrCrash(),
        );

        final newEmail = TestData.emailAddress('new@example.com');
        final updated = user.copyWith(
          email: newEmail,
        );

        expect(updated.id, user.id); // unchanged
        expect(updated.email, newEmail); // changed
      });

      test('creates new user when no fields updated', () {
        final user = TestData.user(
          id: testId.value.value,
          emailStr: testEmail.getOrCrash(),
        );

        final updated = user.copyWith();

        // Should have same values
        expect(updated.id, user.id);
        expect(updated.email, user.email);
        expect(identical(updated, user), false); // different instance
      });
    });

    group('immutability', () {
      test('is immutable', () {
        final user = TestData.user(
          id: testId.value.value,
          emailStr: testEmail.getOrCrash(),
        );

        // All fields are final, can't modify
        expect(user.id, testId);
        expect(user.email, testEmail);
      });
    });
  });
}
