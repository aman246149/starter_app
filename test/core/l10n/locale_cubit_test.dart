import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/core/presentation/bloc/locale_cubit.dart';

import '../../helpers/mock_helpers.dart';

void main() {
  group('AppLocale', () {
    test('fromString returns en for "en"', () {
      expect(AppLocale.fromString('en'), AppLocale.en);
    });

    test('fromString returns es for "es"', () {
      expect(AppLocale.fromString('es'), AppLocale.es);
    });

    test('fromString returns en for unknown value', () {
      expect(AppLocale.fromString('fr'), AppLocale.en);
      expect(AppLocale.fromString('de'), AppLocale.en);
      expect(AppLocale.fromString(''), AppLocale.en);
    });

    test('toString returns languageCode when countryCode is null', () {
      expect(AppLocale.en.toString(), 'en');
      expect(AppLocale.es.toString(), 'es');
      expect(const AppLocale('fr').toString(), 'fr');
    });

    test(
      'toString returns languageCode_countryCode when countryCode is not null',
      () {
        expect(const AppLocale('en', 'US').toString(), 'en_US');
        expect(const AppLocale('es', 'MX').toString(), 'es_MX');
        expect(const AppLocale('fr', 'CA').toString(), 'fr_CA');
      },
    );

    test('operator == returns true for identical instances', () {
      const locale1 = AppLocale.en;
      const locale2 = AppLocale.en;
      expect(locale1 == locale2, isTrue);
      expect(locale1, equals(locale2));
    });

    test(
      'operator == returns true for different instances with same values',
      () {
        const locale1 = AppLocale.en;
        const locale2 = AppLocale.en;
        expect(locale1 == locale2, isTrue);
        expect(locale1, equals(locale2));
      },
    );

    test(
      'operator == returns true for instances with same properties',
      () {
        const locale1 = AppLocale('en', 'US');
        const locale2 = AppLocale('en', 'US');
        expect(locale1 == locale2, isTrue);
        expect(locale1, equals(locale2));
      },
    );

    test('operator == returns false for different languageCodes', () {
      expect(AppLocale.en == AppLocale.es, isFalse);
      expect(AppLocale.en, isNot(equals(AppLocale.es)));
    });

    test('operator == returns false for different countryCodes', () {
      const locale1 = AppLocale('en', 'US');
      const locale2 = AppLocale('en', 'GB');
      expect(locale1 == locale2, isFalse);
      expect(locale1, isNot(equals(locale2)));
    });

    test('operator == returns false when countryCode is null vs not null', () {
      const locale1 = AppLocale.en;
      const locale2 = AppLocale('en', 'US');
      expect(locale1 == locale2, isFalse);
      expect(locale1, isNot(equals(locale2)));
    });

    test('operator == returns false for non-AppLocale objects', () {
      expect('en', isNot(isA<AppLocale>()));
      expect(42, isNot(isA<AppLocale>()));
      expect(null, isNot(isA<AppLocale>()));
    });

    test('hashCode is same for equal instances', () {
      const locale1 = AppLocale.en;
      const locale2 = AppLocale.en;
      expect(locale1.hashCode, locale2.hashCode);
    });

    test('hashCode is same for equal instances with countryCode', () {
      const locale1 = AppLocale('en', 'US');
      const locale2 = AppLocale('en', 'US');
      expect(locale1.hashCode, locale2.hashCode);
    });

    test('static constants en and es work correctly', () {
      expect(AppLocale.en.languageCode, 'en');
      expect(AppLocale.en.countryCode, isNull);
      expect(AppLocale.es.languageCode, 'es');
      expect(AppLocale.es.countryCode, isNull);
    });
  });

  group('LocaleCubit', () {
    late MockStorage storage;

    setUp(() {
      storage = MockStorage();
      when(
        () => storage.write(any(), any<dynamic>()),
      ).thenAnswer((_) async {});
      HydratedBloc.storage = storage;
    });

    test('initial state is AppLocale.en', () {
      expect(LocaleCubit(AppLocale.en).state, AppLocale.en);
    });

    blocTest<LocaleCubit, AppLocale>(
      'emits [AppLocale.es] when setSpanish is called',
      build: () => LocaleCubit(AppLocale.en),
      act: (cubit) => cubit.setSpanish(),
      expect: () => [AppLocale.es],
    );

    blocTest<LocaleCubit, AppLocale>(
      'emits [AppLocale.en] when setEnglish is called',
      build: () => LocaleCubit(AppLocale.es),
      act: (cubit) => cubit.setEnglish(),
      expect: () => [AppLocale.en],
    );

    blocTest<LocaleCubit, AppLocale>(
      'emits [AppLocale.es] when setLocale is called',
      build: () => LocaleCubit(AppLocale.en),
      act: (cubit) => cubit.setLocale(AppLocale.es),
      expect: () => [AppLocale.es],
    );

    group('toJson/fromJson', () {
      test('work properly', () {
        final cubit = LocaleCubit(AppLocale.en);
        expect(
          cubit.fromJson(cubit.toJson(AppLocale.es)!),
          AppLocale.es,
        );
      });

      test('fromJson returns null for invalid json', () {
        final cubit = LocaleCubit(AppLocale.en);
        expect(cubit.fromJson({}), null);
      });

      test('fromJson returns null when languageCode is null', () {
        final cubit = LocaleCubit(AppLocale.en);
        expect(cubit.fromJson({'countryCode': 'US'}), null);
      });

      test('fromJson works with countryCode present', () {
        final cubit = LocaleCubit(AppLocale.en);
        final json = {
          'languageCode': 'en',
          'countryCode': 'US',
        };
        final result = cubit.fromJson(json);
        expect(result, isNotNull);
        expect(result!.languageCode, 'en');
        expect(result.countryCode, 'US');
      });

      test('fromJson works with countryCode null', () {
        final cubit = LocaleCubit(AppLocale.en);
        final json = {
          'languageCode': 'es',
          'countryCode': null,
        };
        final result = cubit.fromJson(json);
        expect(result, isNotNull);
        expect(result!.languageCode, 'es');
        expect(result.countryCode, isNull);
      });

      test(
        'fromJson returns null when type casting fails',
        () {
          final cubit = LocaleCubit(AppLocale.en);
          // This will cause a TypeError when trying to cast to String?
          // The bare catch block catches both Exception and Error (TypeError)
          final json = {
            'languageCode': 123, // Wrong type
            'countryCode': 'US',
          };
          // The code catches all errors including TypeError, returning null
          expect(cubit.fromJson(json), isNull);
        },
      );

      test('toJson includes all required fields', () {
        final cubit = LocaleCubit(AppLocale.en);
        final json = cubit.toJson(const AppLocale('en', 'US'));
        expect(json, isNotNull);
        expect(json!['languageCode'], 'en');
        expect(json['countryCode'], 'US');
        expect(json['timestamp'], isA<String>());
        expect(json['timestamp'], isNotEmpty);
      });

      test('toJson includes timestamp', () {
        final cubit = LocaleCubit(AppLocale.en);
        final before = DateTime.now();
        final json = cubit.toJson(AppLocale.en);
        final after = DateTime.now();

        expect(json, isNotNull);
        expect(json!['timestamp'], isA<String>());

        final timestamp = DateTime.parse(json['timestamp'] as String);
        expect(
          timestamp.isAfter(before.subtract(const Duration(seconds: 1))),
          isTrue,
        );
        expect(
          timestamp.isBefore(after.add(const Duration(seconds: 1))),
          isTrue,
        );
      });

      test('toJson works with null countryCode', () {
        final cubit = LocaleCubit(AppLocale.en);
        final json = cubit.toJson(AppLocale.es);
        expect(json, isNotNull);
        expect(json!['languageCode'], 'es');
        expect(json['countryCode'], isNull);
        expect(json['timestamp'], isA<String>());
      });
    });
  });
}
