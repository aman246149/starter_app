import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/core/l10n/arb/app_localizations.dart';
import 'package:starter_app/core/l10n/arb/app_localizations_en.dart';
import 'package:starter_app/core/l10n/arb/app_localizations_es.dart';

void main() {
  group('AppLocalizationsEn', () {
    late AppLocalizationsEn localizations;

    setUp(() {
      localizations = AppLocalizationsEn();
    });

    test('appName returns correct English translation', () {
      expect(localizations.appName, 'Starter App');
    });

    test('unexpectedError returns correct English translation', () {
      expect(localizations.unexpectedError, 'An unexpected error occurred');
    });

    test('serverError returns correct English translation with statusCode', () {
      expect(
        localizations.serverError,
        'Something went wrong. Please try again.',
      );
    });

    test('networkError returns correct English translation', () {
      expect(
        localizations.networkError,
        "Couldn't connect to the server. Please check your connection",
      );
    });

    test('cacheError returns correct English translation', () {
      expect(localizations.cacheError, 'Local storage error');
    });

    test('parseError returns correct English translation', () {
      expect(
        localizations.parseError,
        'Invalid data format received. Please contact support.',
      );
    });

    test('circuitBreakerError returns correct English translation', () {
      expect(
        localizations.circuitBreakerError,
        'Circuit breaker tripped. Please try again later.',
      );
    });

    test('localeName is set correctly', () {
      expect(localizations.localeName, 'en');
    });

    test('constructor with custom locale sets localeName', () {
      final custom = AppLocalizationsEn('en_US');
      expect(custom.localeName, isNotEmpty);
    });
  });

  group('AppLocalizationsEs', () {
    late AppLocalizationsEs localizations;

    setUp(() {
      localizations = AppLocalizationsEs();
    });

    test('appName returns correct Spanish translation', () {
      expect(localizations.appName, 'Aplicación Inicial');
    });

    test('unexpectedError returns correct Spanish translation', () {
      expect(localizations.unexpectedError, 'Ocurrió un error inesperado');
    });

    test('serverError returns correct Spanish translation', () {
      expect(localizations.serverError, 'Ocurrió un error en el servidor');
    });

    test('networkError returns correct Spanish translation', () {
      expect(localizations.networkError, 'Sin conexión a internet');
    });

    test('cacheError returns correct Spanish translation', () {
      expect(localizations.cacheError, 'Error de almacenamiento local');
    });

    test('parseError returns correct Spanish translation', () {
      expect(localizations.parseError, 'Formato de datos inválido recibido');
    });

    test('circuitBreakerError returns correct Spanish translation', () {
      expect(
        localizations.circuitBreakerError,
        'El disyuntor se ha disparado. Inténtelo de nuevo más tarde.',
      );
    });

    test('passwordEmpty returns correct Spanish translation', () {
      expect(localizations.passwordEmpty, 'La contraseña es requerida');
    });

    test('passwordTooShort returns correct Spanish translation', () {
      expect(
        localizations.passwordTooShort(8),
        'La contraseña debe tener al menos 8 caracteres',
      );
    });

    test('passwordTooLong returns correct Spanish translation', () {
      expect(
        localizations.passwordTooLong(128),
        'La contraseña no debe exceder 128 caracteres',
      );
    });

    test('passwordMissingUppercase returns correct Spanish translation', () {
      expect(
        localizations.passwordMissingUppercase,
        'La contraseña debe contener al menos una letra mayúscula',
      );
    });

    test('passwordMissingLowercase returns correct Spanish translation', () {
      expect(
        localizations.passwordMissingLowercase,
        'La contraseña debe contener al menos una letra minúscula',
      );
    });

    test('passwordMissingDigit returns correct Spanish translation', () {
      expect(
        localizations.passwordMissingDigit,
        'La contraseña debe contener al menos un dígito',
      );
    });

    test(
      'passwordMissingSpecialCharacter returns correct Spanish translation',
      () {
        expect(
          localizations.passwordMissingSpecialCharacter,
          'La contraseña debe contener al menos un carácter especial',
        );
      },
    );

    test('emailEmpty returns correct Spanish translation', () {
      expect(localizations.emailEmpty, 'El correo electrónico es requerido');
    });

    test('emailTooLong returns correct Spanish translation', () {
      expect(
        localizations.emailTooLong(254),
        'El correo no debe exceder 254 caracteres',
      );
    });

    test('emailInvalidFormat returns correct Spanish translation', () {
      expect(
        localizations.emailInvalidFormat,
        'Por favor ingresa un correo electrónico válido',
      );
    });

    test('nameEmpty returns correct Spanish translation', () {
      expect(localizations.nameEmpty, 'El nombre es requerido');
    });

    test('localeName is set correctly', () {
      expect(localizations.localeName, 'es');
    });

    test('constructor with custom locale sets localeName', () {
      final custom = AppLocalizationsEs('es_MX');
      expect(custom.localeName, isNotEmpty);
    });
  });

  group('AppLocalizations', () {
    test('supportedLocales contains en and es', () {
      expect(AppLocalizations.supportedLocales.length, 2);
      expect(AppLocalizations.supportedLocales, contains(const Locale('en')));
      expect(AppLocalizations.supportedLocales, contains(const Locale('es')));
    });

    test('localizationsDelegates contains delegate', () {
      expect(
        AppLocalizations.localizationsDelegates,
        contains(AppLocalizations.delegate),
      );
    });

    test('delegate is not null', () {
      expect(AppLocalizations.delegate, isNotNull);
    });

    testWidgets('of returns AppLocalizations from context', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              final localizations = AppLocalizations.of(context);
              expect(localizations, isA<AppLocalizations>());
              expect(localizations.appName, 'Starter App');
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('of returns Spanish localizations for es locale', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              final localizations = AppLocalizations.of(context);
              expect(localizations, isA<AppLocalizations>());
              expect(localizations.appName, 'Aplicación Inicial');
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });

  group('_AppLocalizationsDelegate', () {
    const delegate = AppLocalizations.delegate;

    test('isSupported returns true for en locale', () {
      expect(delegate.isSupported(const Locale('en')), isTrue);
    });

    test('isSupported returns true for es locale', () {
      expect(delegate.isSupported(const Locale('es')), isTrue);
    });

    test('isSupported returns false for unsupported locale', () {
      expect(delegate.isSupported(const Locale('fr')), isFalse);
      expect(delegate.isSupported(const Locale('de')), isFalse);
      expect(delegate.isSupported(const Locale('ja')), isFalse);
    });

    test('isSupported returns true for locale with country code', () {
      expect(delegate.isSupported(const Locale('en', 'US')), isTrue);
      expect(delegate.isSupported(const Locale('es', 'MX')), isTrue);
    });

    test('load returns AppLocalizationsEn for en locale', () async {
      final result = await delegate.load(const Locale('en'));
      expect(result, isA<AppLocalizationsEn>());
      expect(result.appName, 'Starter App');
    });

    test('load returns AppLocalizationsEs for es locale', () async {
      final result = await delegate.load(const Locale('es'));
      expect(result, isA<AppLocalizationsEs>());
      expect(result.appName, 'Aplicación Inicial');
    });

    test('load returns AppLocalizationsEn for en_US locale', () async {
      final result = await delegate.load(const Locale('en', 'US'));
      expect(result, isA<AppLocalizationsEn>());
      expect(result.appName, 'Starter App');
    });

    test('load returns AppLocalizationsEs for es_MX locale', () async {
      final result = await delegate.load(const Locale('es', 'MX'));
      expect(result, isA<AppLocalizationsEs>());
      expect(result.appName, 'Aplicación Inicial');
    });

    test('shouldReload returns false', () {
      const oldDelegate = AppLocalizations.delegate;
      expect(delegate.shouldReload(oldDelegate), isFalse);
    });
  });

  group('lookupAppLocalizations', () {
    test('returns AppLocalizationsEn for en locale', () {
      final result = lookupAppLocalizations(const Locale('en'));
      expect(result, isA<AppLocalizationsEn>());
      expect(result.appName, 'Starter App');
    });

    test('returns AppLocalizationsEs for es locale', () {
      final result = lookupAppLocalizations(const Locale('es'));
      expect(result, isA<AppLocalizationsEs>());
      expect(result.appName, 'Aplicación Inicial');
    });

    test('returns AppLocalizationsEn for en_US locale', () {
      final result = lookupAppLocalizations(const Locale('en', 'US'));
      expect(result, isA<AppLocalizationsEn>());
      expect(result.appName, 'Starter App');
    });

    test('returns AppLocalizationsEs for es_MX locale', () {
      final result = lookupAppLocalizations(const Locale('es', 'MX'));
      expect(result, isA<AppLocalizationsEs>());
      expect(result.appName, 'Aplicación Inicial');
    });

    test('throws FlutterError for unsupported locale', () {
      expect(
        () => lookupAppLocalizations(const Locale('fr')),
        throwsA(isA<FlutterError>()),
      );
    });

    test('throws FlutterError for unsupported locale with country code', () {
      expect(
        () => lookupAppLocalizations(const Locale('de', 'DE')),
        throwsA(isA<FlutterError>()),
      );
    });

    test('error message contains locale information', () {
      expect(
        () => lookupAppLocalizations(const Locale('fr')),
        throwsA(
          isA<FlutterError>().having(
            (e) => e.message,
            'message',
            allOf(
              contains('fr'),
              contains('unsupported locale'),
            ),
          ),
        ),
      );
    });
  });
}
