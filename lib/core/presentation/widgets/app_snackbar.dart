import 'package:flutter/material.dart';

/// A custom SnackBar widget for consistent app-wide messaging.
///
/// Encapsulates the styling and default behavior of SnackBars
/// used throughout the application.
final class AppSnackBar extends SnackBar {
  AppSnackBar({
    required String message,
    super.key,
    super.action,
    super.duration,
    super.behavior,
    super.persist,
  }) : super(content: Text(message));
}
