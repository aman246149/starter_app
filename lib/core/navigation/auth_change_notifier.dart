import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:starter_app/core/navigation/app_router.dart';
import 'package:starter_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:starter_app/features/auth/presentation/bloc/auth_state.dart';

/// A [ChangeNotifier] that listens to [AuthBloc] state changes.
///
/// This class bridges the gap between BLoC and GoRouter's refreshListenable,
/// allowing the router to re-evaluate its redirect logic whenever the
/// authentication state changes.
///
/// ## Usage
///
/// Inject this into [AppRouter] and pass it to GoRouter.refreshListenable:
///
/// ```dart
/// GoRouter(
///   refreshListenable: authChangeNotifier,
///   redirect: (context, state) {
///     // This now runs on every auth state change
///   },
/// )
/// ```
///
/// ## Why This Is Needed
///
/// GoRouter's redirect callback only runs on navigation by default.
/// With refreshListenable, it also runs whenever the notifier calls
/// [notifyListeners], enabling reactive redirects on:
/// - User logout
/// - Session expiration
/// - Successful login
@lazySingleton
class AuthChangeNotifier extends ChangeNotifier {
  /// Creates an [AuthChangeNotifier] that listens to [AuthBloc].
  AuthChangeNotifier(this._authBloc) {
    _subscription = _authBloc.stream.listen((_) => notifyListeners());
  }

  final AuthBloc _authBloc;
  late final StreamSubscription<AuthState> _subscription;

  /// Current authentication state.
  AuthState get state => _authBloc.state;

  /// Whether the user is currently authenticated.
  bool get isAuthenticated =>
      state.mapOrNull(authenticated: (_) => true) ?? false;

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}
