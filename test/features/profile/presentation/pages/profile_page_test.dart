import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/core/di/injection.dart';
import 'package:starter_app/core/error/failures/infrastructure_failures.dart';
import 'package:starter_app/core/presentation/models/error_model.dart';
import 'package:starter_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:starter_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:starter_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:starter_app/features/profile/presentation/bloc/profile_state.dart';
import 'package:starter_app/features/profile/presentation/pages/profile_page.dart';
import 'package:starter_app/features/profile/presentation/widgets/login_button.dart';

import '../../../../helpers/mock_helpers.dart';
import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_data.dart';

void main() {
  late MockAuthBloc mockAuthBloc;
  late MockProfileBloc mockProfileBloc;
  setUp(() {
    mockAuthBloc = MockAuthBloc();
    mockProfileBloc = MockProfileBloc();
    getIt.registerFactory<ProfileBloc>(() => mockProfileBloc);
  });

  tearDown(getIt.reset);

  group('ProfilePage', () {
    testWidgets('renders without errors', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthState.empty());

      await tester.pumpAppWithBloc(
        const ProfilePage(),
        providers: [
          BlocProvider<AuthBloc>.value(value: mockAuthBloc),
        ],
      );

      expect(find.byType(ProfilePage), findsOneWidget);
    });

    testWidgets('displays app bar with title', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthState.empty());

      await tester.pumpAppWithBloc(
        const ProfilePage(),
        providers: [BlocProvider<AuthBloc>.value(value: mockAuthBloc)],
      );

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('shows LoginButton when unauthenticated', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthState.empty());

      await tester.pumpAppWithBloc(
        const ProfilePage(),
        providers: [BlocProvider<AuthBloc>.value(value: mockAuthBloc)],
      );

      expect(find.byType(LoginButton), findsOneWidget);
    });

    testWidgets('shows welcome message when authenticated', (tester) async {
      final user = TestData.user();
      when(() => mockAuthBloc.state).thenReturn(AuthState.authenticated(user));
      when(
        () => mockProfileBloc.state,
      ).thenReturn(ProfileState.loaded(TestData.userProfile()));

      await tester.pumpAppWithBloc(
        const ProfilePage(),
        providers: [
          BlocProvider<AuthBloc>.value(value: mockAuthBloc),
          BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
        ],
      );

      expect(find.byType(LoginButton), findsNothing);
      expect(
        find.textContaining(
          TestData.userProfile().displayName.getOrCrash(),
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows SizedBox.shrink when profile state is initial', (
      tester,
    ) async {
      final user = TestData.user();
      when(() => mockAuthBloc.state).thenReturn(AuthState.authenticated(user));
      when(
        () => mockProfileBloc.state,
      ).thenReturn(const ProfileState.initial());

      await tester.pumpAppWithBloc(
        const ProfilePage(),
        providers: [
          BlocProvider<AuthBloc>.value(value: mockAuthBloc),
          BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
        ],
      );

      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('shows CircularProgressIndicator when profile is loading', (
      tester,
    ) async {
      final user = TestData.user();
      when(() => mockAuthBloc.state).thenReturn(AuthState.authenticated(user));
      when(
        () => mockProfileBloc.state,
      ).thenReturn(const ProfileState.loading());

      await tester.pumpAppWithBloc(
        const ProfilePage(),
        providers: [
          BlocProvider<AuthBloc>.value(value: mockAuthBloc),
          BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
        ],
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error message when profile state has error', (
      tester,
    ) async {
      final user = TestData.user();
      final errorModel = ErrorModel.fromFailure(
        const InfrastructureFailure.server(message: 'Test error'),
      );
      when(() => mockAuthBloc.state).thenReturn(AuthState.authenticated(user));
      when(
        () => mockProfileBloc.state,
      ).thenReturn(ProfileState.error(errorModel));

      await tester.pumpAppWithBloc(
        const ProfilePage(),
        providers: [
          BlocProvider<AuthBloc>.value(value: mockAuthBloc),
          BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
        ],
      );

      expect(find.textContaining('Error'), findsOneWidget);
    });
  });
}
