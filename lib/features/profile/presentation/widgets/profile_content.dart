import 'package:flutter/material.dart';
import 'package:starter_app/features/profile/domain/entities/user_profile.dart';
import 'package:starter_app/features/profile/l10n/l10n_extensions.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({
    required this.profile,
    super.key,
  });

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final l10n = context.profileL10n;
    return Center(
      child: Text(
        '${l10n.welcome} ${profile.displayName.getOrCrash()}',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
