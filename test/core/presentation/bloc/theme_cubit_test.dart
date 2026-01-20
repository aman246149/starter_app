import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/core/presentation/bloc/bloc.dart';

import '../../../helpers/mock_helpers.dart';

void main() {
  group('ThemeCubit', () {
    late MockStorage storage;

    setUp(() {
      storage = MockStorage();
      when(
        () => storage.write(any(), any<dynamic>()),
      ).thenAnswer((_) async {});
      HydratedBloc.storage = storage;
    });

    test('initial state is AppThemeMode.system', () {
      expect(ThemeCubit(AppThemeMode.system).state, AppThemeMode.system);
    });

    test('AppThemeMode.fromString handles invalid values', () {
      expect(AppThemeMode.fromString('invalid'), AppThemeMode.system);
      expect(AppThemeMode.fromString(''), AppThemeMode.system);
      expect(AppThemeMode.fromString('UNKNOWN'), AppThemeMode.system);
    });

    blocTest<ThemeCubit, AppThemeMode>(
      'emits [AppThemeMode.light] when setLightTheme is called',
      build: () => ThemeCubit(AppThemeMode.system),
      act: (cubit) => cubit.setLightTheme(),
      expect: () => [AppThemeMode.light],
    );

    blocTest<ThemeCubit, AppThemeMode>(
      'emits [AppThemeMode.dark] when setDarkTheme is called',
      build: () => ThemeCubit(AppThemeMode.light),
      act: (cubit) => cubit.setDarkTheme(),
      expect: () => [AppThemeMode.dark],
    );

    blocTest<ThemeCubit, AppThemeMode>(
      'emits [AppThemeMode.system] when setSystemTheme is called',
      build: () => ThemeCubit(AppThemeMode.dark),
      act: (cubit) => cubit.setSystemTheme(),
      expect: () => [AppThemeMode.system],
    );

    blocTest<ThemeCubit, AppThemeMode>(
      'emits [AppThemeMode.dark] when toggleTheme is called from light',
      build: () => ThemeCubit(AppThemeMode.light),
      act: (cubit) => cubit.toggleTheme(),
      expect: () => [AppThemeMode.dark],
    );

    blocTest<ThemeCubit, AppThemeMode>(
      'emits [AppThemeMode.light] when toggleTheme is called from dark',
      build: () => ThemeCubit(AppThemeMode.dark),
      act: (cubit) => cubit.toggleTheme(),
      expect: () => [AppThemeMode.light],
    );

    blocTest<ThemeCubit, AppThemeMode>(
      'emits [AppThemeMode.light] when toggleTheme is called from system',
      build: () => ThemeCubit(AppThemeMode.system),
      act: (cubit) => cubit.toggleTheme(),
      expect: () => [AppThemeMode.light],
    );

    blocTest<ThemeCubit, AppThemeMode>(
      'emits [AppThemeMode.dark] when setThemeMode is called with dark',
      build: () => ThemeCubit(AppThemeMode.light),
      act: (cubit) => cubit.setThemeMode(AppThemeMode.dark),
      expect: () => [AppThemeMode.dark],
    );

    blocTest<ThemeCubit, AppThemeMode>(
      'emits [AppThemeMode.light] when setThemeMode is called with light',
      build: () => ThemeCubit(AppThemeMode.dark),
      act: (cubit) => cubit.setThemeMode(AppThemeMode.light),
      expect: () => [AppThemeMode.light],
    );

    group('toJson/fromJson', () {
      test('work properly', () {
        final cubit = ThemeCubit(AppThemeMode.system);
        expect(
          cubit.fromJson(cubit.toJson(AppThemeMode.dark)!),
          AppThemeMode.dark,
        );
      });

      test('fromJson returns null for invalid json', () {
        final cubit = ThemeCubit(AppThemeMode.system);
        expect(cubit.fromJson({}), null);
      });

      test('fromJson returns null when mode is null', () {
        final cubit = ThemeCubit(AppThemeMode.system);
        expect(cubit.fromJson({'other': 'value'}), null);
      });

      test('fromJson handles exception gracefully', () {
        final cubit = ThemeCubit(AppThemeMode.system);
        // Pass invalid data - mode is null returns null
        expect(cubit.fromJson({'mode': null}), null);
        // Test with empty map (no mode key)
        expect(cubit.fromJson(<String, dynamic>{}), null);
      });

      test('fromJson handles TypeError from invalid cast', () {
        final cubit = ThemeCubit(AppThemeMode.system);
        // Pass invalid type that causes TypeError
        expect(cubit.fromJson({'mode': 123}), null);
        expect(cubit.fromJson({'mode': <String>[]}), null);
        expect(cubit.fromJson({'mode': <String, dynamic>{}}), null);
      });

      test('fromJson handles Exception from fromString', () {
        final cubit = ThemeCubit(AppThemeMode.system);
        // Create a custom Map that throws Exception when accessing 'mode'
        // This tests the exception catch block on line 79
        final throwingMap = _ThrowingMap();
        expect(cubit.fromJson(throwingMap), null);
      });
    });
  });
}

/// Helper class to test exception handling in fromJson
/// Throws Exception when accessing the 'mode' key
class _ThrowingMap implements Map<String, dynamic> {
  @override
  dynamic operator [](Object? key) {
    if (key == 'mode') {
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
  bool containsKey(Object? key) => key == 'mode';

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
  Iterable<String> get keys => ['mode'];

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
