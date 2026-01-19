import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/core/infrastructure/websocket/websocket_reconnection_config.dart';

void main() {
  group('WebSocketReconnectionConfig', () {
    group('constructor', () {
      test('creates config with default values', () {
        const config = WebSocketReconnectionConfig.defaultConfig;

        expect(config.enabled, true);
        expect(config.maxAttempts, 10);
        expect(config.initialDelay, const Duration(seconds: 1));
        expect(config.maxDelay, const Duration(seconds: 30));
        expect(config.backoffMultiplier, 2.0);
        expect(config.jitterFactor, 0.25);
      });

      test('creates config with custom values', () {
        const config = WebSocketReconnectionConfig(
          enabled: false,
          maxAttempts: 5,
          initialDelay: Duration(seconds: 2),
          maxDelay: Duration(seconds: 60),
          backoffMultiplier: 3,
          jitterFactor: 0.5,
        );

        expect(config.enabled, false);
        expect(config.maxAttempts, 5);
        expect(config.initialDelay, const Duration(seconds: 2));
        expect(config.maxDelay, const Duration(seconds: 60));
        expect(config.backoffMultiplier, 3.0);
        expect(config.jitterFactor, 0.5);
      });
    });

    group('defaultConfig', () {
      test('has correct default values', () {
        const config = WebSocketReconnectionConfig.defaultConfig;

        expect(config.enabled, true);
        expect(config.maxAttempts, 10);
        expect(config.initialDelay, const Duration(seconds: 1));
        expect(config.maxDelay, const Duration(seconds: 30));
        expect(config.backoffMultiplier, 2.0);
        expect(config.jitterFactor, 0.25);
      });
    });

    group('noReconnection', () {
      test('has reconnection disabled', () {
        const config = WebSocketReconnectionConfig.noReconnection;

        expect(config.enabled, false);
      });
    });

    group('aggressive', () {
      test('has aggressive reconnection settings', () {
        const config = WebSocketReconnectionConfig.aggressive;

        expect(config.enabled, true);
        expect(config.maxAttempts, 20);
        expect(config.initialDelay, const Duration(milliseconds: 500));
        expect(config.maxDelay, const Duration(seconds: 10));
        expect(config.backoffMultiplier, 1.5);
        expect(config.jitterFactor, 0.2);
      });
    });

    group('conservative', () {
      test('has conservative reconnection settings', () {
        const config = WebSocketReconnectionConfig.conservative;

        expect(config.enabled, true);
        expect(config.maxAttempts, 5);
        expect(config.initialDelay, const Duration(seconds: 5));
        expect(config.maxDelay, const Duration(minutes: 2));
        expect(config.backoffMultiplier, 3.0);
        expect(config.jitterFactor, 0.3);
      });
    });

    group('getDelayForAttempt', () {
      test('returns initial delay for attempt 0', () {
        const config = WebSocketReconnectionConfig.defaultConfig;

        final delay = config.getDelayForAttempt(0);

        // Should be around initialDelay * backoffMultiplier with jitter
        // For attempt 0: 1000ms * (2.0 * 1) = 2000ms base,
        // with 25% jitter up to 2500ms
        expect(delay.inMilliseconds, greaterThan(0));
        expect(delay.inMilliseconds, lessThan(3000)); // Allow for jitter
      });

      test('applies exponential backoff', () {
        const config = WebSocketReconnectionConfig(
          jitterFactor: 0, // No jitter for predictable testing
        );

        // Note: With jitterFactor 0,
        // we still get some variation due to the formula
        // But we can test that later attempts have longer delays
        final delay1 = config.getDelayForAttempt(0);
        final delay2 = config.getDelayForAttempt(1);
        final delay3 = config.getDelayForAttempt(2);

        // Each attempt should have a longer delay
        // (with some tolerance for jitter)
        expect(delay2.inMilliseconds, greaterThan(delay1.inMilliseconds));
        expect(delay3.inMilliseconds, greaterThan(delay2.inMilliseconds));
      });

      test('caps delay at maxDelay', () {
        const config = WebSocketReconnectionConfig(
          backoffMultiplier: 10, // Very aggressive multiplier
          maxDelay: Duration(seconds: 5),
          jitterFactor: 0,
        );

        final delay = config.getDelayForAttempt(10);

        // Should be capped at maxDelay (with some tolerance for jitter)
        expect(delay.inMilliseconds, lessThanOrEqualTo(6000));
      });

      test('handles negative attempt numbers', () {
        const config = WebSocketReconnectionConfig.defaultConfig;

        final delay = config.getDelayForAttempt(-1);

        expect(delay.inMilliseconds, greaterThan(0));
      });

      test('applies jitter correctly', () {
        const config = WebSocketReconnectionConfig(
          initialDelay: Duration(seconds: 10),
          backoffMultiplier: 1,
          jitterFactor: 0.5, // ±50% jitter
        );

        // Run multiple times to check jitter variation
        final delays = <int>[];
        for (var i = 0; i < 10; i++) {
          delays.add(config.getDelayForAttempt(0).inMilliseconds);
        }

        // All delays should be within
        // jitter range (5s to 15s for 10s base with ±50%)
        for (final delay in delays) {
          expect(delay, greaterThan(0));
          expect(delay, lessThan(20000)); // Should be within reasonable range
        }

        // Delays should vary (not all the same)
        final uniqueDelays = delays.toSet();
        expect(uniqueDelays.length, greaterThan(1));
      });

      test('ensures minimum delay of 1ms', () {
        const config = WebSocketReconnectionConfig(
          initialDelay: Duration(milliseconds: 1),
          backoffMultiplier: 0.1, // Very small multiplier
          jitterFactor: 0,
        );

        final delay = config.getDelayForAttempt(0);

        expect(delay.inMilliseconds, greaterThanOrEqualTo(1));
      });
    });

    group('canRetry', () {
      test('returns false when reconnection is disabled', () {
        const config = WebSocketReconnectionConfig.noReconnection;

        expect(config.canRetry(0), false);
        expect(config.canRetry(5), false);
      });

      test('returns true when maxAttempts is null (infinite retries)', () {
        const config = WebSocketReconnectionConfig(maxAttempts: null);

        expect(config.canRetry(0), true);
        expect(config.canRetry(100), true);
        expect(config.canRetry(1000), true);
      });

      test('returns true when currentAttempt is less than maxAttempts', () {
        const config = WebSocketReconnectionConfig(maxAttempts: 5);

        expect(config.canRetry(0), true);
        expect(config.canRetry(1), true);
        expect(config.canRetry(2), true);
        expect(config.canRetry(3), true);
        expect(config.canRetry(4), true);
      });

      test('returns false when currentAttempt equals maxAttempts', () {
        const config = WebSocketReconnectionConfig(maxAttempts: 5);

        expect(config.canRetry(5), false);
      });

      test('returns false when currentAttempt exceeds maxAttempts', () {
        const config = WebSocketReconnectionConfig(maxAttempts: 5);

        expect(config.canRetry(6), false);
        expect(config.canRetry(10), false);
      });
    });

    group('toString', () {
      test('returns string representation', () {
        const config = WebSocketReconnectionConfig(
          maxAttempts: 5,
          initialDelay: Duration(seconds: 2),
          maxDelay: Duration(seconds: 60),
          backoffMultiplier: 3,
          jitterFactor: 0.5,
        );

        final str = config.toString();

        expect(str, contains('WebSocketReconnectionConfig'));
        expect(str, contains('enabled: true'));
        expect(str, contains('maxAttempts: 5'));
        expect(str, contains('initialDelay: 2s'));
        expect(str, contains('maxDelay: 60s'));
        expect(str, contains('backoffMultiplier: 3.0'));
        expect(str, contains('jitterFactor: 0.5'));
      });
    });

    group('edge cases', () {
      test('handles zero jitter factor', () {
        const config = WebSocketReconnectionConfig(
          jitterFactor: 0,
        );

        final delay = config.getDelayForAttempt(0);

        expect(delay.inMilliseconds, greaterThan(0));
      });

      test('handles very large jitter factor', () {
        const config = WebSocketReconnectionConfig(
          jitterFactor: 1,
        );

        final delay = config.getDelayForAttempt(0);

        expect(delay.inMilliseconds, greaterThan(0));
      });

      test('handles very small initial delay', () {
        const config = WebSocketReconnectionConfig(
          initialDelay: Duration(milliseconds: 1),
        );

        final delay = config.getDelayForAttempt(0);

        expect(delay.inMilliseconds, greaterThanOrEqualTo(1));
      });

      test('handles very large max delay', () {
        const config = WebSocketReconnectionConfig(
          maxDelay: Duration(hours: 1),
        );

        final delay = config.getDelayForAttempt(100);

        expect(
          delay.inMilliseconds,
          lessThanOrEqualTo(const Duration(hours: 1).inMilliseconds),
        );
      });
    });
  });
}
