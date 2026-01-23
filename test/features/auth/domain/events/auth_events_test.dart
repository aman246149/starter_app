import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/core/domain/base/domain_event.dart';
import 'package:starter_app/features/auth/domain/events/auth_events.dart';

import '../../../../helpers/test_data.dart';

void main() {
  group('AuthDomainEvent', () {
    test('UserLoggedIn extends AuthDomainEvent and DomainEvent', () {
      final user = TestData.user();
      final event = UserLoggedIn(user);

      expect(event, isA<AuthDomainEvent>());
      expect(event, isA<DomainEvent>());
    });
  });

  group('UserLoggedIn', () {
    test('stores user correctly', () {
      final user = TestData.user();
      final event = UserLoggedIn(user);

      expect(event.user, user);
    });

    test('can be const constructed', () {
      final user = TestData.user();
      final event1 = UserLoggedIn(user);
      final event2 = UserLoggedIn(user);

      expect(event1.user, event2.user);
    });
  });

  group('UserRegistered', () {
    test('stores user correctly', () {
      final user = TestData.user();
      final event = UserRegistered(user);

      expect(event.user, user);
    });

    test('extends AuthDomainEvent', () {
      final user = TestData.user();
      final event = UserRegistered(user);

      expect(event, isA<AuthDomainEvent>());
    });
  });

  group('UserLoggedOut', () {
    test('stores userId correctly', () {
      final userId = TestData.uniqueUserId();
      final event = UserLoggedOut(userId);

      expect(event.userId, userId);
    });

    test('extends AuthDomainEvent', () {
      final userId = TestData.uniqueUserId();
      final event = UserLoggedOut(userId);

      expect(event, isA<AuthDomainEvent>());
    });
  });

  group('UserEmailVerified', () {
    test('stores user correctly', () {
      final user = TestData.user();
      final event = UserEmailVerified(user);

      expect(event.user, user);
    });

    test('extends AuthDomainEvent', () {
      final user = TestData.user();
      final event = UserEmailVerified(user);

      expect(event, isA<AuthDomainEvent>());
    });
  });

  group('UserEmailChanged', () {
    test('stores user and oldEmail correctly', () {
      final user = TestData.user();
      const oldEmail = 'old@example.com';
      final event = UserEmailChanged(user, oldEmail);

      expect(event.user, user);
      expect(event.oldEmail, oldEmail);
    });

    test('extends AuthDomainEvent', () {
      final user = TestData.user();
      final event = UserEmailChanged(user, 'old@example.com');

      expect(event, isA<AuthDomainEvent>());
    });
  });
}
