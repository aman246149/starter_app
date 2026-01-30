// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'profile_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class ProfileLocalizationsEs extends ProfileLocalizations {
  ProfileLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appBarTitle => 'Perfil';

  @override
  String get welcome => 'Bienvenido';

  @override
  String get unexpectedError => 'Ocurrió un error inesperado.';

  @override
  String get serverError =>
      'Ocurrió un error en el servidor. Inténtalo de nuevo más tarde.';

  @override
  String get notFound => 'Perfil no encontrado.';
}
