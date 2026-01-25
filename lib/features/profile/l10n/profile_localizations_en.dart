// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'profile_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class ProfileLocalizationsEn extends ProfileLocalizations {
  ProfileLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appBarTitle => 'Profile';

  @override
  String get welcome => 'Welcome';

  @override
  String get unexpectedError => 'An unexpected error occurred.';

  @override
  String get serverError => 'A server error occurred. Please try again later.';

  @override
  String get notFound => 'Profile not found.';
}
