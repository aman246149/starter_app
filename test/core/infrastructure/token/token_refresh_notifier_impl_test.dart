import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/core/domain/ports/i_token_refresh_notifier.dart';
import 'package:starter_app/core/infrastructure/token/token_refresh_notifier_impl.dart';

void main() {
  group('TokenRefreshNotifierImpl', () {
    late TokenRefreshNotifierImpl tokenRefreshNotifier;

    setUp(() {
      tokenRefreshNotifier = TokenRefreshNotifierImpl();
    });

    tearDown(() async {
      await tokenRefreshNotifier.dispose();
    });

    test('can be instantiated', () {
      expect(tokenRefreshNotifier, isNotNull);
      expect(tokenRefreshNotifier, isA<TokenRefreshNotifierImpl>());
    });

    test('implements ITokenRefreshNotifier', () {
      expect(tokenRefreshNotifier, isA<ITokenRefreshNotifier>());
    });

    group('onTokenRefreshed', () {
      test('returns a Stream<void>', () {
        final stream = tokenRefreshNotifier.onTokenRefreshed;

        expect(stream, isA<Stream<void>>());
      });

      test('allows multiple listeners (broadcast stream)', () async {
        final stream = tokenRefreshNotifier.onTokenRefreshed;
        final listener1Values = <void>[];
        final listener2Values = <void>[];

        final subscription1 = stream.listen((_) => listener1Values.add(null));
        final subscription2 = stream.listen((_) => listener2Values.add(null));

        tokenRefreshNotifier.notifyTokenRefreshed();

        await Future<void>.delayed(const Duration(milliseconds: 10));

        expect(listener1Values.length, 1);
        expect(listener2Values.length, 1);

        await subscription1.cancel();
        await subscription2.cancel();
      });

      test('does not buffer events when no listeners', () async {
        // Notify without listeners - should not throw
        tokenRefreshNotifier
          ..notifyTokenRefreshed()
          ..notifyTokenRefreshed();

        // Now add listener - should only receive new events
        final receivedValues = <void>[];
        final subscription = tokenRefreshNotifier.onTokenRefreshed.listen(
          (_) => receivedValues.add(null),
        );

        tokenRefreshNotifier.notifyTokenRefreshed();
        await Future<void>.delayed(const Duration(milliseconds: 10));

        // Should only receive the event after listener was added
        expect(receivedValues.length, 1);

        await subscription.cancel();
      });
    });

    group('notifyTokenRefreshed', () {
      test('emits event on stream', () async {
        final receivedValues = <void>[];
        final subscription = tokenRefreshNotifier.onTokenRefreshed.listen(
          (_) => receivedValues.add(null),
        );

        tokenRefreshNotifier.notifyTokenRefreshed();

        await Future<void>.delayed(const Duration(milliseconds: 10));

        expect(receivedValues.length, 1);

        await subscription.cancel();
      });

      test('can emit multiple events', () async {
        final receivedValues = <void>[];
        final subscription = tokenRefreshNotifier.onTokenRefreshed.listen(
          (_) => receivedValues.add(null),
        );

        tokenRefreshNotifier
          ..notifyTokenRefreshed()
          ..notifyTokenRefreshed()
          ..notifyTokenRefreshed();

        await Future<void>.delayed(const Duration(milliseconds: 10));

        expect(receivedValues.length, 3);

        await subscription.cancel();
      });

      test('does not throw when controller is closed', () async {
        await tokenRefreshNotifier.dispose();

        // Should not throw
        expect(
          () => tokenRefreshNotifier.notifyTokenRefreshed(),
          returnsNormally,
        );
      });

      test('does not emit events after dispose', () async {
        final receivedValues = <void>[];
        final subscription = tokenRefreshNotifier.onTokenRefreshed.listen(
          (_) => receivedValues.add(null),
        );

        tokenRefreshNotifier.notifyTokenRefreshed();
        await Future<void>.delayed(const Duration(milliseconds: 10));
        expect(receivedValues.length, 1);

        await tokenRefreshNotifier.dispose();

        tokenRefreshNotifier.notifyTokenRefreshed();
        await Future<void>.delayed(const Duration(milliseconds: 10));

        // Should not receive new events after dispose
        expect(receivedValues.length, 1);

        await subscription.cancel();
      });

      test('emits to all active listeners', () async {
        final listener1Values = <void>[];
        final listener2Values = <void>[];
        final listener3Values = <void>[];

        final subscription1 = tokenRefreshNotifier.onTokenRefreshed.listen(
          (_) => listener1Values.add(null),
        );
        final subscription2 = tokenRefreshNotifier.onTokenRefreshed.listen(
          (_) => listener2Values.add(null),
        );
        final subscription3 = tokenRefreshNotifier.onTokenRefreshed.listen(
          (_) => listener3Values.add(null),
        );

        tokenRefreshNotifier.notifyTokenRefreshed();
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
        final stream = tokenRefreshNotifier.onTokenRefreshed;

        // Add a listener before dispose
        final subscription = stream.listen((_) {});

        await tokenRefreshNotifier.dispose();

        // Stream should be closed - new listeners should not receive events
        final receivedValues = <void>[];
        final newSubscription = stream.listen(
          (_) => receivedValues.add(null),
        );

        tokenRefreshNotifier.notifyTokenRefreshed();
        await Future<void>.delayed(const Duration(milliseconds: 10));

        expect(receivedValues.length, 0);

        await subscription.cancel();
        await newSubscription.cancel();
      });

      test('can be called multiple times safely', () async {
        await tokenRefreshNotifier.dispose();
        await tokenRefreshNotifier.dispose();
        await tokenRefreshNotifier.dispose();

        // Should not throw
        expect(() async => tokenRefreshNotifier.dispose(), returnsNormally);
      });

      test('completes future when called', () async {
        final disposeFuture = tokenRefreshNotifier.dispose();

        expect(disposeFuture, completes);
        await disposeFuture;
      });

      test('prevents new events from being emitted', () async {
        final receivedValues = <void>[];
        final subscription = tokenRefreshNotifier.onTokenRefreshed.listen(
          (_) => receivedValues.add(null),
        );

        tokenRefreshNotifier.notifyTokenRefreshed();
        await Future<void>.delayed(const Duration(milliseconds: 10));
        expect(receivedValues.length, 1);

        await tokenRefreshNotifier.dispose();

        tokenRefreshNotifier.notifyTokenRefreshed();
        await Future<void>.delayed(const Duration(milliseconds: 10));

        expect(receivedValues.length, 1);

        await subscription.cancel();
      });
    });

    group('integration scenarios', () {
      test('complete token refresh flow', () async {
        // Given - token refresh notifier with listener
        final events = <void>[];
        final subscription = tokenRefreshNotifier.onTokenRefreshed.listen(
          (_) => events.add(null),
        );

        // When - token is refreshed
        tokenRefreshNotifier.notifyTokenRefreshed();

        await Future<void>.delayed(const Duration(milliseconds: 10));

        // Then - listener receives event
        expect(events.length, 1);

        await subscription.cancel();
      });

      test('multiple token refresh notifications', () async {
        final events = <void>[];
        final subscription = tokenRefreshNotifier.onTokenRefreshed.listen(
          (_) => events.add(null),
        );

        tokenRefreshNotifier.notifyTokenRefreshed();
        await Future<void>.delayed(const Duration(milliseconds: 10));
        tokenRefreshNotifier.notifyTokenRefreshed();
        await Future<void>.delayed(const Duration(milliseconds: 10));
        tokenRefreshNotifier.notifyTokenRefreshed();
        await Future<void>.delayed(const Duration(milliseconds: 10));

        expect(events.length, 3);

        await subscription.cancel();
      });

      test(
        'listener added after notification does not receive old events',
        () async {
          // Notify before listener is added
          tokenRefreshNotifier.notifyTokenRefreshed();
          await Future<void>.delayed(const Duration(milliseconds: 10));

          // Add listener
          final events = <void>[];
          final subscription = tokenRefreshNotifier.onTokenRefreshed.listen(
            (_) => events.add(null),
          );

          // Should not have received the previous notification
          expect(events.length, 0);

          // But should receive new notifications
          tokenRefreshNotifier.notifyTokenRefreshed();
          await Future<void>.delayed(const Duration(milliseconds: 10));
          expect(events.length, 1);

          await subscription.cancel();
        },
      );

      test('dispose cleans up resources properly', () async {
        final subscription1 = tokenRefreshNotifier.onTokenRefreshed.listen(
          (_) {},
        );
        final subscription2 = tokenRefreshNotifier.onTokenRefreshed.listen(
          (_) {},
        );

        await tokenRefreshNotifier.dispose();

        // Should be able to cancel subscriptions without errors
        await subscription1.cancel();
        await subscription2.cancel();
      });
    });
  });
}
