part of '../pages/auth_page.dart';

final class _RegisterForm extends StatelessWidget {
  const _RegisterForm({required this.state, super.key});
  final RegistrationRequired state;

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      maxWidth: ContentWidthConstants.form,
      child: ResponsivePadding(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(context.authL10n.createAccount(state.email.getOrCrash())),
            const ResponsiveVerticalGap(),
            AppTextField(
              label: context.authL10n.nameLabel,
              onChanged: (name) =>
                  context.read<AuthBloc>().add(AuthEvent.nameChanged(name)),
              onEditingComplete: () => context.read<AuthBloc>().add(
                const AuthEvent.nameUnfocused(),
              ),
              errorText: _getNameError(context),
            ),
            const ResponsiveVerticalGap(),
            PasswordTextField(
              password: state.password,
              showError: state.validation.passwordTouched,
              obscureText: !state.passwordVisible,
              onToggleVisibility: () => context.read<AuthBloc>().add(
                const AuthEvent.togglePasswordVisibility(),
              ),
              label: context.authL10n.passwordLabel,
              onChanged: (password) => context.read<AuthBloc>().add(
                AuthEvent.passwordChanged(password),
              ),
              onEditingComplete: () => context.read<AuthBloc>().add(
                const AuthEvent.passwordUnfocused(),
              ),
            ),
            const ResponsiveVerticalGap(),
            ElevatedButton(
              onPressed: () => context.read<AuthBloc>().add(
                const AuthEvent.registerSubmitted(),
              ),
              child: Text(context.authL10n.register),
            ),
            const ResponsiveVerticalGap(),
            TextButton(
              onPressed: () => context.read<AuthBloc>().add(
                const AuthEvent.emailChanged(''),
              ),
              child: Text(context.authL10n.differentEmail),
            ),
          ],
        ),
      ),
    );
  }

  /// Gets the name validation error using localized messages.
  String? _getNameError(BuildContext context) {
    if (!state.validation.nameTouched) return null;
    final failure = state.name.getFailuresOrNull()?.first;
    if (failure == null) return null;
    return context.read<FailureMessageService>().getLocalizedMessage(
      context,
      failure,
    );
  }
}
