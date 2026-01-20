import 'package:flutter/material.dart';
import 'package:starter_app/core/presentation/widgets/app_snackbar.dart'; // Import the new AppSnackBar

extension ContextExtensions on BuildContext {
  /// Shows a SnackBar with the given message.
  ///
  /// [persist] determines whether the SnackBar should stay visible indefinitely
  /// (until manually dismissed or replaced) or auto-hide after a duration.
  void showSnackBar({
    required String message,
    Duration? duration,
    SnackBarAction? action,
    bool persist = false,
  }) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        AppSnackBar(
          // Use AppSnackBar here
          message: message,
          action: action,
          persist: persist,
        ),
      );
  }
}
