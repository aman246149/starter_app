import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/core/domain/ports/i_session_manager.dart';
import 'package:starter_app/core/infrastructure/session/session_manager_impl.dart';

void main() {
  group('SessionManagerImpl', () {
    late SessionManagerImpl sessionManager;

    setUp(() {
      sessionManager = SessionManagerImpl();
    });

    tearDown(() async {
      await sessionManager.dispose();
    });

    test('can be instantiated', () {
      expect(sessionManager, isNotNull);
      expect(sessionManager, isA<SessionManagerImpl>());
    });

    test('implements ISessionManager', () {
      expect(sessionManager, isA<ISessionManager>());
    });

    group('onSessionExpired', () {
      test('returns a Stream<void>', () {
        final stream = sessionManager.onSessionExpired;

        expect(stream, isA<Stream<void>>());
      });

      test('allows multiple listeners (broadcast stream)', () async {
        final stream = sessionManager.onSessionExpired;
        final listener1Values = <void>[];
        final listener2Values = <void>[];

        final subscription1 = stream.listen((_) => listener1Values.add(null));
        final subscription2 = stream.listen((_) => listener2Values.add(null));

        sessionManager.notifySessionExpired();

        await Future<void>.delayed(const Duration(milliseconds: 10));

        expect(listener1Values.length, 1);
        expect(listener2Values.length, 1);

        await subscription1.cancel();
        await subscription2.cancel();
      });

      test('does not buffer events when no listeners', () async {
        // Notify without listeners - should not throw
        sessionManager
          ..notifySessionExpired()
          ..notifySessionExpired();

        // Now add listener - should only receive new events
        final receivedValues = <void>[];
        final subscription = sessionManager.onSessionExpired.listen(
          (_) => receivedValues.add(null),
        );

        sessionManager.notifySessionExpired();
        await Future<void>.delayed(const Duration(milliseconds: 10));

        // Should only receive the event after listener was added
        expect(receivedValues.length, 1);

        await subscription.cancel();
      });
    });

    group('notifySessionExpired', () {
      test('emits event on stream', () async {
        final receivedValues = <void>[];
        final subscription = sessionManager.onSessionExpired.listen(
          (_) => receivedValues.add(null),
        );

        sessionManager.notifySessionExpired();

        await Future<void>.delayed(const Duration(milliseconds: 10));

        expect(receivedValues.length, 1);

        await subscription.cancel();
      });

      test('can emit multiple events', () async {
        final receivedValues = <void>[];
        final subscription = sessionManager.onSessionExpired.listen(
          (_) => receivedValues.add(null),
        );

        sessionManager
          ..notifySessionExpired()
          ..notifySessionExpired()
          ..notifySessionExpired();

        await Future<void>.delayed(const Duration(milliseconds: 10));

        expect(receivedValues.length, 3);

        await subscription.cancel();
      });

      test('does not throw when controller is closed', () async {
        await sessionManager.dispose();

        // Should not throw
        expect(() => sessionManager.notifySessionExpired(), returnsNormally);
      });

      test('does not emit events after dispose', () async {
        final receivedValues = <void>[];
        final subscription = sessionManager.onSessionExpired.listen(
          (_) => receivedValues.add(null),
        );

        sessionManager.notifySessionExpired();
        await Future<void>.delayed(const Duration(milliseconds: 10));
        expect(receivedValues.length, 1);

        await sessionManager.dispose();

        sessionManager.notifySessionExpired();
        await Future<void>.delayed(const Duration(milliseconds: 10));

        // Should not receive new events after dispose
        expect(receivedValues.length, 1);

        await subscription.cancel();
      });

      test('emits to all active listeners', () async {
        final listener1Values = <void>[];
        final listener2Values = <void>[];
        final listener3Values = <void>[];

        final subscription1 = sessionManager.onSessionExpired.listen(
          (_) => listener1Values.add(null),
        );
        final subscription2 = sessionManager.onSessionExpired.listen(
          (_) => listener2Values.add(null),
        );
        final subscription3 = sessionManager.onSessionExpired.listen(
          (_) => listener3Values.add(null),
        );

        sessionManager.notifySessionExpired();
        await Future<void>.delayed(const Duration(milliseconds: 10));

        expect(listener1Values.length, 1);
        expect(listener2Values.length, 1);
        expect(listener3Values.length, 1);

        await subscription1.cancel();
        await subscription2.cancel();
        await subscription3.cancel();
      });
    });

    group('dispose', () {
      test('closes the stream controller', () async {
        final stream = sessionManager.onSessionExpired;

        // Add a listener before dispose
        final subscription = stream.listen((_) {});

        await sessionManager.dispose();

        // Stream should be closed - new listeners should not receive events
        final receivedValues = <void>[];
        final newSubscription = stream.listen(
          (_) => receivedValues.add(null),
        );

        sessionManager.notifySessionExpired();
        await Future<void>.delayed(const Duration(milliseconds: 10));

        expect(receivedValues.length, 0);

        await subscription.cancel();
        await newSubscription.cancel();
      });

      test('can be called multiple times safely', () async {
        await sessionManager.dispose();
        await sessionManager.dispose();
        await sessionManager.dispose();

        // Should not throw
        expect(() async => sessionManager.dispose(), returnsNormally);
      });

      test('completes future when called', () async {
        final disposeFuture = sessionManager.dispose();

        expect(disposeFuture, completes);
        await disposeFuture;
      });

      test('prevents new events from being emitted', () async {
        final receivedValues = <void>[];
        final subscription = sessionManager.onSessionExpired.listen(
          (_) => receivedValues.add(null),
        );

        sessionManager.notifySessionExpired();
        await Future<void>.delayed(const Duration(milliseconds: 10));
        expect(receivedValues.length, 1);

        await sessionManager.dispose();

        sessionManager.notifySessionExpired();
        await Future<void>.delayed(const Duration(milliseconds: 10));

        expect(receivedValues.length, 1);

        await subscription.cancel();
      });
    });

    group('integration scenarios', () {
      test('complete session expiration flow', () async {
        // Given - session manager with listener
        final events = <void>[];
        final subscription = sessionManager.onSessionExpired.listen(
          (_) => events.add(null),
        );

        // When - session expires
        sessionManager.notifySessionExpired();

        await Future<void>.delayed(const Duration(milliseconds: 10));

        // Then - listener receives event
        expect(events.length, 1);

        await subscription.cancel();
      });

      test('multiple session expiration notifications', () async {
        final events = <void>[];
        final subscription = sessionManager.onSessionExpired.listen(
          (_) => events.add(null),
        );

        sessionManager.notifySessionExpired();
        await Future<void>.delayed(const Duration(milliseconds: 10));
        sessionManager.notifySessionExpired();
        await Future<void>.delayed(const Duration(milliseconds: 10));
        sessionManager.notifySessionExpired();
        await Future<void>.delayed(const Duration(milliseconds: 10));

        expect(events.length, 3);

        await subscription.cancel();
      });

      test(
        'listener added after notification does not receive old events',
        () async {
          // Notify before listener is added
          sessionManager.notifySessionExpired();
          await Future<void>.delayed(const Duration(milliseconds: 10));

          // Add listener
          final events = <void>[];
          final subscription = sessionManager.onSessionExpired.listen(
            (_) => events.add(null),
          );

          // Should not have received the previous notification
          expect(events.length, 0);

          // But should receive new notifications
          sessionManager.notifySessionExpired();
          await Future<void>.delayed(const Duration(milliseconds: 10));
          expect(events.length, 1);

          await subscription.cancel();
        },
      );

      test('dispose cleans up resources properly', () async {
        final subscription1 = sessionManager.onSessionExpired.listen((_) {});
        final subscription2 = sessionManager.onSessionExpired.listen((_) {});

        await sessionManager.dispose();

        // Should be able to cancel subscriptions without errors
        await subscription1.cancel();
        await subscription2.cancel();
      });
    });
  });
}
