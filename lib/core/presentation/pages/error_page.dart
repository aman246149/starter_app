import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_app/core/navigation/app_router.dart';

/// Error page for 404 and routing errors.
///
/// This is a shared page used throughout the application to display
/// routing errors and 404 pages. It provides a consistent error
/// experience with navigation back to Dashboard.
///
/// Usage:
/// ```dart
/// errorPageBuilder: (context, state) => pageBuilder.build(
///   context: context,
///   state: state,
///   child: ErrorPage(state: state),
/// ),
/// ```
final class ErrorPage extends StatelessWidget {
  const ErrorPage({required this.state, super.key});

  final GoRouterState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              state.uri.path,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => const DashboardRoute().go(context),
              child: const Text('Go Dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}
