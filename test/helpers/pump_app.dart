import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/core/l10n/arb/app_localizations.dart';
import 'package:starter_app/core/theme/app_theme.dart';
import 'package:starter_app/features/auth/l10n/auth_localizations.dart';
import 'package:starter_app/features/dashboard/l10n/dashboard_localizations.dart';
import 'package:starter_app/features/orders/l10n/orders_localizations.dart';
import 'package:starter_app/features/profile/l10n/profile_localizations.dart';
import 'package:starter_app/features/settings/l10n/settings_localizations.dart';

extension PumpApp on WidgetTester {
  /// Pump a widget with basic MaterialApp wrapper
  ///
  /// Note: Includes a 4-second pump to advance
  /// past Sentry's TimeToDisplayTracker
  /// timer that would otherwise cause "Timer still pending"
  /// errors in CI.
  Future<void> pumpApp(
    Widget widget, {
    ThemeMode themeMode = ThemeMode.light,
    Locale locale = const Locale('en'),
  }) async {
    const appTheme = AppTheme();
    await pumpWidget(
      MaterialApp(
        theme: appTheme.lightTheme,
        darkTheme: appTheme.darkTheme,
        themeMode: themeMode,
        locale: locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          AuthLocalizations.delegate,
          DashboardLocalizations.delegate,
          OrdersLocalizations.delegate,
          ProfileLocalizations.delegate,
          SettingsLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: widget,
      ),
    );
    // Advance past Sentry's 3-second TimeToDisplayTracker timer
    await pump(const Duration(seconds: 4));
  }

  /// Pump a widget with BLoC providers
  ///
  /// Note: Includes a 4-second pump to
  /// advance past Sentry's TimeToDisplayTracker
  /// timer that would otherwise cause "Timer still pending"
  /// errors in CI.
  Future<void> pumpAppWithBloc(
    Widget widget, {
    List<BlocProvider> providers = const [],
    ThemeMode themeMode = ThemeMode.light,
    Locale locale = const Locale('en'),
  }) async {
    const appTheme = AppTheme();
    await pumpWidget(
      MultiBlocProvider(
        providers: providers,
        child: MaterialApp(
          theme: appTheme.lightTheme,
          darkTheme: appTheme.darkTheme,
          themeMode: themeMode,
          locale: locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            AuthLocalizations.delegate,
            DashboardLocalizations.delegate,
            OrdersLocalizations.delegate,
            ProfileLocalizations.delegate,
            SettingsLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: widget,
        ),
      ),
    );
    // Advance past Sentry's 3-second TimeToDisplayTracker timer
    await pump(const Duration(seconds: 4));
  }
}
