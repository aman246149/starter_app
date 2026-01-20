import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/core/presentation/bloc/bloc.dart';

import '../../../helpers/mock_helpers.dart';

void main() {
  group('LocaleCubit', () {
    late MockStorage storage;

    setUp(() {
      storage = MockStorage();
      when(
        () => storage.write(any(), any<dynamic>()),
      ).thenAnswer((_) async {});
      HydratedBloc.storage = storage;
    });

    test('initial state is AppLocale.en when constructed with en', () {
      expect(LocaleCubit(AppLocale.en).state, AppLocale.en);
    });

    test('initial state is AppLocale.es when constructed with es', () {
      expect(LocaleCubit(AppLocale.es).state, AppLocale.es);
    });

    group('AppLocale', () {
      test('fromString returns AppLocale.en for "en"', () {
        expect(AppLocale.fromString('en'), AppLocale.en);
      });

      test('fromString returns AppLocale.es for "es"', () {
        expect(AppLocale.fromString('es'), AppLocale.es);
      });

      test('fromString returns AppLocale.en for unknown value', () {
        expect(AppLocale.fromString('unknown'), AppLocale.en);
        expect(AppLocale.fromString(''), AppLocale.en);
        expect(AppLocale.fromString('fr'), AppLocale.en);
      });

      test('toString returns languageCode for locale without countryCode', () {
        expect(AppLocale.en.toString(), 'en');
        expect(AppLocale.es.toString(), 'es');
      });

      test('toString returns languageCode_countryCode for full locale', () {
        const locale = AppLocale('en', 'US');
        expect(locale.toString(), 'en_US');
      });

      test('equality works correctly', () {
        expect(AppLocale.en, equals(AppLocale.en));
        expect(AppLocale.en, equals(AppLocale.en));
        expect(AppLocale.en, isNot(equals(AppLocale.es)));
        expect(
          const AppLocale('en', 'US'),
          equals(const AppLocale('en', 'US')),
        );
        expect(
          const AppLocale('en', 'US'),
          isNot(equals(const AppLocale('en', 'GB'))),
        );
      });

      test('hashCode is consistent', () {
        expect(AppLocale.en.hashCode, equals(AppLocale.en.hashCode));
        expect(
          const AppLocale('en', 'US').hashCode,
          equals(const AppLocale('en', 'US').hashCode),
        );
      });
    });

    blocTest<LocaleCubit, AppLocale>(
      'emits [AppLocale.en] when setEnglish is called',
      build: () => LocaleCubit(AppLocale.es),
      act: (cubit) => cubit.setEnglish(),
      expect: () => [AppLocale.en],
    );

    blocTest<LocaleCubit, AppLocale>(
      'emits [AppLocale.es] when setSpanish is called',
      build: () => LocaleCubit(AppLocale.en),
      act: (cubit) => cubit.setSpanish(),
      expect: () => [AppLocale.es],
    );

    blocTest<LocaleCubit, AppLocale>(
      'emits custom locale when setLocale is called',
      build: () => LocaleCubit(AppLocale.en),
      act: (cubit) => cubit.setLocale(const AppLocale('fr')),
      expect: () => [const AppLocale('fr')],
    );

    blocTest<LocaleCubit, AppLocale>(
      'emits locale with countryCode when setLocale is called with full locale',
      build: () => LocaleCubit(AppLocale.en),
      act: (cubit) => cubit.setLocale(const AppLocale('en', 'US')),
      expect: () => [const AppLocale('en', 'US')],
    );

    group('toJson/fromJson', () {
      test('work properly for simple locale', () {
        final cubit = LocaleCubit(AppLocale.en);
        final json = cubit.toJson(AppLocale.es)!;
        expect(cubit.fromJson(json), AppLocale.es);
      });

      test('work properly for locale with countryCode', () {
        final cubit = LocaleCubit(AppLocale.en);
        const locale = AppLocale('en', 'US');
        final json = cubit.toJson(locale)!;
        final restored = cubit.fromJson(json);
        expect(restored?.languageCode, 'en');
        expect(restored?.countryCode, 'US');
      });

      test('toJson includes timestamp', () {
        final cubit = LocaleCubit(AppLocale.en);
        final json = cubit.toJson(AppLocale.en)!;
        expect(json.containsKey('timestamp'), isTrue);
        expect(json['timestamp'], isA<String>());
      });

      test('fromJson returns null for empty json', () {
        final cubit = LocaleCubit(AppLocale.en);
        expect(cubit.fromJson({}), null);
      });

      test('fromJson returns null when languageCode is null', () {
        final cubit = LocaleCubit(AppLocale.en);
        expect(cubit.fromJson({'countryCode': 'US'}), null);
      });

      test('fromJson handles null countryCode', () {
        final cubit = LocaleCubit(AppLocale.en);
        final result = cubit.fromJson({'languageCode': 'en'});
        expect(result, isNotNull);
        expect(result?.languageCode, 'en');
        expect(result?.countryCode, null);
      });

      test('fromJson handles exception gracefully', () {
        final cubit = LocaleCubit(AppLocale.en);
        // Pass invalid type that causes type cast exception
        expect(cubit.fromJson({'languageCode': 123}), null);
        expect(cubit.fromJson({'languageCode': <String>[]}), null);
      });

      test('fromJson handles Exception from map access', () {
        final cubit = LocaleCubit(AppLocale.en);
        final throwingMap = _ThrowingMap();
        expect(cubit.fromJson(throwingMap), null);
      });
    });
  });
}

/// Helper class to test exception handling in fromJson
/// Throws Exception when accessing the 'languageCode' key
class _ThrowingMap implements Map<String, dynamic> {
  @override
  dynamic operator [](Object? key) {
    if (key == 'languageCode') {
      throw Exception('Test exception');
    }
    return null;
  }

  @override
  void operator []=(String key, dynamic value) {}

  @override
  void addAll(Map<String, dynamic> other) {}

  @override
  void addEntries(Iterable<MapEntry<String, dynamic>> entries) {}

  @override
  Map<RK, RV> cast<RK, RV>() => <RK, RV>{};

  @override
  void clear() {}

  @override
  bool containsKey(Object? key) => key == 'languageCode';

  @override
  bool containsValue(Object? value) => false;

  @override
  Iterable<MapEntry<String, dynamic>> get entries => [];

  @override
  void forEach(void Function(String key, dynamic value) action) {}

  @override
  bool get isEmpty => false;

  @override
  bool get isNotEmpty => true;

  @override
  Iterable<String> get keys => ['languageCode'];

  @override
  int get length => 1;

  @override
  Map<K2, V2> map<K2, V2>(
    MapEntry<K2, V2> Function(String key, dynamic value) convert,
  ) => <K2, V2>{};

  @override
  dynamic putIfAbsent(String key, dynamic Function() ifAbsent) => null;

  @override
  dynamic remove(Object? key) => null;

  @override
  void removeWhere(bool Function(String key, dynamic value) test) {}

  @override
  dynamic update(
    String key,
    dynamic Function(dynamic value) update, {
    dynamic Function()? ifAbsent,
  }) {
    return null;
  }

  @override
  void updateAll(dynamic Function(String key, dynamic value) update) {}

  @override
  Iterable<dynamic> get values => [];
}
