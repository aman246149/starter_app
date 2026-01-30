import 'dart:async';

import 'package:sentry_flutter/sentry_flutter.dart';

/// Global test configuration that runs before all tests.
///
/// This disables Sentry's auto-integrations that cause timer issues
/// in widget tests (TimeToDisplayTracker creates pending timers).
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // Close any existing Sentry instance to prevent timer leaks
  await Sentry.close();

  // Run the actual tests
  await testMain();
}
