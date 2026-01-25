import 'package:flutter/material.dart';
import 'package:starter_app/core/constants/constants.dart';
import 'package:starter_app/core/domain/value_objects/email_address.dart';
import 'package:starter_app/core/presentation/responsive/responsive.dart';
import 'package:starter_app/core/presentation/widgets/email_text_field.dart';
import 'package:starter_app/features/auth/l10n/l10n_extensions.dart';

final class EmailForm extends StatelessWidget {
  const EmailForm({
    required this.email,
    required this.showError,
    required this.onEmailChanged,
    required this.onEmailUnfocused,
    required this.onSubmitted,
    super.key,
  });

  final EmailAddress email;
  final bool showError;
  final ValueChanged<String> onEmailChanged;
  final VoidCallback onEmailUnfocused;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      maxWidth: ContentWidthConstants.form,
      child: ResponsivePadding(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EmailTextField(
              email: email,
              showError: showError,
              label: context.authL10n.emailLabel,
              hint: context.authL10n.emailHint,
              onChanged: onEmailChanged,
              onEditingComplete: onEmailUnfocused,
              onSubmitted: (_) => onSubmitted(),
            ),
            const ResponsiveVerticalGap(),
            ElevatedButton(
              onPressed: onSubmitted,
              child: Text(context.authL10n.continueToEmail),
            ),
          ],
        ),
      ),
    );
  }
}
