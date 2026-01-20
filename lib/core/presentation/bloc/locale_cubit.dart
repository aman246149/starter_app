import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

/// Framework-independent locale representation.
///
/// This class represents a locale without depending on Flutter.
/// Map to Flutter's Locale in the presentation layer.
@immutable
class AppLocale {
  const AppLocale(this.languageCode, [this.countryCode]);

  static AppLocale fromString(String value) {
    return switch (value) {
      'en' => en,
      'es' => es,
      _ => en,
    };
  }

  final String languageCode;
  final String? countryCode;

  /// English locale
  static const en = AppLocale('en');

  /// Spanish locale
  static const es = AppLocale('es');

  @override
  String toString() =>
      countryCode != null ? '${languageCode}_$countryCode' : languageCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppLocale &&
          runtimeType == other.runtimeType &&
          languageCode == other.languageCode &&
          countryCode == other.countryCode;

  @override
  int get hashCode => languageCode.hashCode ^ countryCode.hashCode;
}

/// Cubit for managing locale state with persistence.
///
/// Uses HydratedBloc for automatic state persistence.
/// Provides methods to switch between supported locales.
///
/// Located in `core/presentation/bloc/` because:
/// - Cubits are presentation layer concerns (UI state management)
/// - Locale state is cross-cutting (used by all features)
/// - Localization resources (arb files) stay in `core/l10n/`
///
/// Registered via BlocModule with default [AppLocale.en] value.
/// Must be lazy (not eager) because HydratedBloc.storage must be set first.
class LocaleCubit extends HydratedCubit<AppLocale> {
  LocaleCubit(super.state);

  /// Set locale/language
  void setLocale(AppLocale locale) => emit(locale);

  /// Switch to English
  void setEnglish() => emit(AppLocale.en);

  /// Switch to Spanish
  void setSpanish() => emit(AppLocale.es);

  @override
  AppLocale? fromJson(Map<String, dynamic> json) {
    try {
      final languageCode = json['languageCode'] as String?;
      if (languageCode == null) return null;

      final countryCode = json['countryCode'] as String?;

      return AppLocale(languageCode, countryCode);
      // ignore: avoid_catches_without_on_clauses, Catches TypeError (Error) and Exception
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(AppLocale state) {
    return {
      'languageCode': state.languageCode,
      'countryCode': state.countryCode,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}
