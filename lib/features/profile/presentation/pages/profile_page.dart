import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starter_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:starter_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:starter_app/features/profile/l10n/l10n_extensions.dart';
import 'package:starter_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:starter_app/features/profile/presentation/bloc/profile_state.dart';
import 'package:starter_app/features/profile/presentation/widgets/login_button.dart';

/// Profile page with language and theme settings.
final class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.profileL10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.appBarTitle)),
      body: Center(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            return authState.maybeMap(
              authenticated: (state) {
                return BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, profileState) {
                    return profileState.map(
                      initial: (_) => const SizedBox.shrink(),
                      loading: (_) => const CircularProgressIndicator(),
                      error: (s) =>
                          Text('Error: ${s.error}'), // Simplified error
                      loaded: (s) => Text(
                        '''${l10n.welcome} ${s.profile.displayName.getOrCrash()}''',
                      ),
                    );
                  },
                );
              },
              orElse: () => const LoginButton(),
            );
          },
        ),
      ),
    );
  }
}
