part of '../pages/auth_page.dart';

final class _EmailForm extends StatelessWidget {
  const _EmailForm({required this.state, super.key});
  final Initial state;

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      maxWidth: ContentWidthConstants.form,
      child: ResponsivePadding(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EmailTextField(
              email: state.email,
              showError: state.validation.emailTouched,
              label: context.authL10n.emailLabel,
              hint: context.authL10n.emailHint,
              onChanged: (email) => context.read<AuthBloc>().add(
                AuthEvent.emailChanged(email),
              ),
              onEditingComplete: () => context.read<AuthBloc>().add(
                const AuthEvent.emailUnfocused(),
              ),
              onSubmitted: (email) => context.read<AuthBloc>().add(
                const AuthEvent.emailSubmitted(),
              ),
            ),
            const ResponsiveVerticalGap(),
            ElevatedButton(
              onPressed: () => context.read<AuthBloc>().add(
                const AuthEvent.emailSubmitted(),
              ),
              child: Text(context.authL10n.continueToEmail),
            ),
          ],
        ),
      ),
    );
  }
}
