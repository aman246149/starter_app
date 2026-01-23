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
              errorText: state.validation.nameTouched
                  ? state.name.value.fold(
                      (f) => f.first.mapOrNull(
                        empty: (f) => context.authL10n.nameEmpty,
                      ),
                      (_) => null,
                    )
                  : null,
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
}
