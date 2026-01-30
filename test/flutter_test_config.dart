import 'dart:async';

import 'package:sentry_flutter/sentry_flutter.dart';

/// Global test configuration that runs before all tests.
///
/// Disables Sentry's auto-integrations that cause timer issues
/// (TimeToDisplayTracker creates pending timers during widget tests).
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // Initialize Sentry with minimal config to prevent auto-integrations
  // from causing timer leaks. We use noop settings with empty DSN.
  await SentryFlutter.init(
    (options) {
      options
        ..dsn =
            '' // Empty DSN prevents sending and most auto-init
        ..autoInitializeNativeSdk = false;
    },
    appRunner: () async {
      await testMain();
    },
  );
}
