import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/features/profile/l10n/profile_localizations.dart';
import 'package:starter_app/features/profile/l10n/profile_localizations_en.dart';
import 'package:starter_app/features/profile/l10n/profile_localizations_es.dart';

void main() {
  group('ProfileLocalizations', () {
    group('lookupProfileLocalizations', () {
      test('returns English localizations for en locale', () {
        final localizations = lookupProfileLocalizations(const Locale('en'));

        expect(localizations, isA<ProfileLocalizationsEn>());
        expect(localizations.appBarTitle, equals('Profile'));
        expect(localizations.welcome, equals('Welcome'));
      });

      test('returns Spanish localizations for es locale', () {
        final localizations = lookupProfileLocalizations(const Locale('es'));

        expect(localizations, isA<ProfileLocalizationsEs>());
        expect(localizations.appBarTitle, equals('Perfil'));
        expect(localizations.welcome, equals('Bienvenido'));
      });

      test('throws FlutterError for unsupported locale', () {
        expect(
          () => lookupProfileLocalizations(const Locale('fr')),
          throwsA(isA<FlutterError>()),
        );
      });
    });

    group('ProfileLocalizationsDelegate', () {
      test('isSupported returns true for en', () {
        const delegate = ProfileLocalizations.delegate;

        expect(delegate.isSupported(const Locale('en')), isTrue);
      });

      test('isSupported returns true for es', () {
        const delegate = ProfileLocalizations.delegate;

        expect(delegate.isSupported(const Locale('es')), isTrue);
      });

      test('isSupported returns false for unsupported locale', () {
        const delegate = ProfileLocalizations.delegate;

        expect(delegate.isSupported(const Locale('fr')), isFalse);
      });

      test('load returns correct localizations for en', () async {
        const delegate = ProfileLocalizations.delegate;
        final localizations = await delegate.load(const Locale('en'));

        expect(localizations, isA<ProfileLocalizationsEn>());
      });

      test('load returns correct localizations for es', () async {
        const delegate = ProfileLocalizations.delegate;
        final localizations = await delegate.load(const Locale('es'));

        expect(localizations, isA<ProfileLocalizationsEs>());
      });

      test('shouldReload returns false', () {
        const delegate = ProfileLocalizations.delegate;

        expect(delegate.shouldReload(delegate), isFalse);
      });
    });

    group('supportedLocales', () {
      test('contains en and es', () {
        expect(
          ProfileLocalizations.supportedLocales,
          containsAll([const Locale('en'), const Locale('es')]),
        );
      });
    });

    group('localizationsDelegates', () {
      test('contains the profile delegate', () {
        expect(
          ProfileLocalizations.localizationsDelegates,
          contains(ProfileLocalizations.delegate),
        );
      });
    });
  });

  group('ProfileLocalizationsEn', () {
    test('has correct localeName', () {
      final localizations = ProfileLocalizationsEn();

      expect(localizations.localeName, equals('en'));
    });

    test('appBarTitle returns Profile', () {
      final localizations = ProfileLocalizationsEn();

      expect(localizations.appBarTitle, equals('Profile'));
    });

    test('welcome returns Welcome', () {
      final localizations = ProfileLocalizationsEn();

      expect(localizations.welcome, equals('Welcome'));
    });
  });

  group('ProfileLocalizationsEs', () {
    test('has correct localeName', () {
      final localizations = ProfileLocalizationsEs();

      expect(localizations.localeName, equals('es'));
    });

    test('appBarTitle returns Perfil', () {
      final localizations = ProfileLocalizationsEs();

      expect(localizations.appBarTitle, equals('Perfil'));
    });

    test('welcome returns Bienvenido', () {
      final localizations = ProfileLocalizationsEs();

      expect(localizations.welcome, equals('Bienvenido'));
    });
  });
}
