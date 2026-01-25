import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starter_app/core/constants/constants.dart';
import 'package:starter_app/core/navigation/app_router.dart';
import 'package:starter_app/core/presentation/extensions/context_extensions.dart';
import 'package:starter_app/core/presentation/models/error_model.dart';
import 'package:starter_app/core/presentation/responsive/responsive.dart';
import 'package:starter_app/core/presentation/services/failure_message_service.dart';
import 'package:starter_app/core/presentation/widgets/widgets.dart';
import 'package:starter_app/features/auth/l10n/l10n_extensions.dart';
import 'package:starter_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:starter_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:starter_app/features/auth/presentation/bloc/auth_state.dart';

import 'package:starter_app/features/auth/presentation/widgets/email_form.dart';

part '../widgets/login_form.dart';
part '../widgets/register_form.dart';

final class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        final error = state.mapOrNull(
          initial: (s) => s.error,
          loginRequired: (s) => s.error,
          registrationRequired: (s) => s.error,
        );

        if (error != null) {
          final messageService = context.read<FailureMessageService>();
          final message = error.getMessage(context, messageService);

          context.showSnackBar(
            message: message,
            action: error.isRetryable
                ? SnackBarAction(
                    label: context.authL10n.retry,
                    onPressed: () => _retryLastAction(context),
                  )
                : null,
          );
          return;
        }

        state.maybeWhen(
          authenticated: (user) => const DashboardRoute().go(context),
          orElse: () => null,
        );
      },
      builder: (context, state) {
        final isSubmitting =
            state.mapOrNull(
              initial: (s) => s.isSubmitting,
              loginRequired: (s) => s.isSubmitting,
              registrationRequired: (s) => s.isSubmitting,
            ) ??
            false;

        const emailValueKey = ValueKey('email');
        const loginValueKey = ValueKey('login');
        const registerValueKey = ValueKey('register');
        const loadingValueKey = ValueKey('loading');

        return LoadingOverlay(
          isLoading: isSubmitting,
          child: Scaffold(
            floatingActionButton: Padding(
              padding: PaddingWidgets.allMedium,
              child: TextButton(
                onPressed: () => const DashboardRoute().go(context),
                child: Text(context.authL10n.returnHome),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            body: AnimatedSwitcher(
              duration: DurationConstants.animationMedium,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: const Offset(0, 0.1),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          ),
                        ),
                    child: child,
                  ),
                );
              },
              child: state.maybeMap(
                initial: (s) => EmailForm(
                  key: emailValueKey,
                  email: s.email,
                  showError: s.validation.emailTouched,
                  onEmailChanged: (email) => context.read<AuthBloc>().add(
                    AuthEvent.emailChanged(email),
                  ),
                  onEmailUnfocused: () => context.read<AuthBloc>().add(
                    const AuthEvent.emailUnfocused(),
                  ),
                  onSubmitted: () => context.read<AuthBloc>().add(
                    const AuthEvent.emailSubmitted(),
                  ),
                ),
                loginRequired: (s) => _LoginForm(
                  key: loginValueKey,
                  state: s,
                ),
                registrationRequired: (s) => _RegisterForm(
                  key: registerValueKey,
                  state: s,
                ),
                orElse: () => const Center(
                  key: loadingValueKey,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Retries the last action based on current auth state.
  void _retryLastAction(BuildContext context) {
    context.read<AuthBloc>().state.mapOrNull(
      initial: (_) =>
          context.read<AuthBloc>().add(const AuthEvent.emailSubmitted()),
      loginRequired: (_) =>
          context.read<AuthBloc>().add(const AuthEvent.loginSubmitted()),
      registrationRequired: (_) =>
          context.read<AuthBloc>().add(const AuthEvent.registerSubmitted()),
    );
  }
}
