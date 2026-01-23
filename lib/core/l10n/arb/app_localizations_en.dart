// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Starter App';

  @override
  String get unexpectedError => 'An unexpected error occurred';

  @override
  String get serverError => 'Something went wrong. Please try again.';

  @override
  String get networkError => 'Couldn\'t connect to the server. Please check your connection';

  @override
  String get cacheError => 'Local storage error';

  @override
  String get parseError => 'Invalid data format received. Please contact support.';

  @override
  String get circuitBreakerError => 'Circuit breaker tripped. Please try again later.';
}
