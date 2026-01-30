import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/features/auth/l10n/auth_localizations.dart';
import 'package:starter_app/features/auth/l10n/auth_localizations_en.dart';
import 'package:starter_app/features/auth/l10n/auth_localizations_es.dart';

void main() {
  group('AuthLocalizations', () {
    test('delegate isSupported returns true for supported locales', () {
      expect(
        AuthLocalizations.delegate.isSupported(const Locale('en')),
        isTrue,
      );
      expect(
        AuthLocalizations.delegate.isSupported(const Locale('es')),
        isTrue,
      );
    });

    test('delegate isSupported returns false for unsupported locales', () {
      expect(
        AuthLocalizations.delegate.isSupported(const Locale('fr')),
        isFalse,
      );
    });

    test('delegate load returns correct localizations', () async {
      final enLocalizations = await AuthLocalizations.delegate.load(
        const Locale('en'),
      );
      expect(enLocalizations, isA<AuthLocalizationsEn>());

      final esLocalizations = await AuthLocalizations.delegate.load(
        const Locale('es'),
      );
      expect(esLocalizations, isA<AuthLocalizationsEs>());
    });

    test('delegate shouldReload returns false', () {
      expect(
        AuthLocalizations.delegate.shouldReload(AuthLocalizations.delegate),
        isFalse,
      );
    });

    test(
      'lookupAuthLocalizations throws FlutterError for unsupported locale',
      () {
        expect(
          () => lookupAuthLocalizations(const Locale('fr')),
          throwsA(isA<FlutterError>()),
        );
      },
    );

    testWidgets('of(context) retrieves localizations', (tester) async {
      late AuthLocalizations retrievedLocalizations;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AuthLocalizations.localizationsDelegates,
          supportedLocales: AuthLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              retrievedLocalizations = AuthLocalizations.of(context);
              return Container();
            },
          ),
        ),
      );
      // Advance past Sentry timer
      await tester.pump(const Duration(seconds: 4));

      expect(
        retrievedLocalizations,
        isA<AuthLocalizationsEn>(),
      ); // Default is usually en
    });
  });

  group('AuthLocalizationsEn', () {
    final l10n = AuthLocalizationsEn();

    test('verifies English strings', () {
      expect(l10n.unauthorized, 'Invalid credentials or session expired');
      expect(l10n.forbidden, 'Access denied - insufficient permissions');
      expect(l10n.notFound, 'Authentication resource not found');
      expect(l10n.emailLabel, 'Email');
      expect(l10n.emailHint, 'Enter your email address');
      expect(l10n.continueToEmail, 'Continue');
      expect(
        l10n.welcomeBack('test@example.com'),
        'Welcome back, test@example.com!',
      );
      expect(l10n.passwordLabel, 'Password');
      expect(l10n.login, 'Login');
      expect(
        l10n.createAccount('test@example.com'),
        'Create an account for test@example.com.',
      );
      expect(l10n.nameLabel, 'Your Name');
      expect(l10n.nameEmpty, 'Name cannot be empty');
      expect(l10n.register, 'Register');
      expect(l10n.retry, 'Retry');
      expect(l10n.differentEmail, 'Use a different email');
      expect(l10n.returnHome, 'Return to home');
      expect(
        l10n.emailAlreadyInUse,
        'This email is already registered. Please login instead.',
      );
      expect(l10n.invalidInput, 'Please check your input and try again.');
    });
  });

  group('AuthLocalizationsEs', () {
    final l10n = AuthLocalizationsEs();

    test('verifies Spanish strings', () {
      expect(l10n.unauthorized, 'Credenciales inválidas o sesión expirada');
      expect(l10n.forbidden, 'Acceso denegado - permisos insuficientes');
      expect(l10n.notFound, 'Recurso de autenticación no encontrado');
      expect(l10n.emailLabel, 'Correo electrónico');
      expect(l10n.emailHint, 'Ingresa tu dirección de correo electrónico');
      expect(l10n.continueToEmail, 'Continuar');
      expect(
        l10n.welcomeBack('test@example.com'),
        '¡Bienvenido de nuevo, test@example.com!',
      );
      expect(l10n.passwordLabel, 'Contraseña');
      expect(l10n.login, 'Iniciar sesión');
      expect(
        l10n.createAccount('test@example.com'),
        'Crea una cuenta para test@example.com.',
      );
      expect(l10n.nameLabel, 'Tu nombre');
      expect(l10n.nameEmpty, 'El nombre no puede estar vacío');
      expect(l10n.register, 'Registrarse');
      expect(l10n.retry, 'Reintentar');
      expect(l10n.differentEmail, 'Usar un correo diferente');
      expect(l10n.returnHome, 'Volver al inicio');
      expect(
        l10n.emailAlreadyInUse,
        'Este correo ya está registrado. Por favor inicia sesión.',
      );
      expect(
        l10n.invalidInput,
        'Por favor verifica tus datos e intenta de nuevo.',
      );
    });
  });
}
