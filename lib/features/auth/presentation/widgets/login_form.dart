part of '../pages/auth_page.dart';

final class _LoginForm extends StatelessWidget {
  const _LoginForm({required this.state, super.key});
  final LoginRequired state;

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      maxWidth: ContentWidthConstants.form,
      child: ResponsivePadding(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(context.authL10n.welcomeBack(state.email.getOrCrash())),
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
              onSubmitted: (password) => context.read<AuthBloc>().add(
                const AuthEvent.loginSubmitted(),
              ),
            ),
            const ResponsiveVerticalGap(),
            ElevatedButton(
              onPressed: () => context.read<AuthBloc>().add(
                const AuthEvent.loginSubmitted(),
              ),
              child: Text(context.authL10n.login),
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
}
