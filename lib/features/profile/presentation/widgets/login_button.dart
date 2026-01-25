import 'package:flutter/material.dart';
import 'package:starter_app/core/navigation/app_router.dart';
import 'package:starter_app/features/auth/l10n/l10n_extensions.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.authL10n;
    return TextButton(
      onPressed: () async {
        await const AuthRoute().push<void>(context);
      },
      child: Text(l10n.login),
    );
  }
}
