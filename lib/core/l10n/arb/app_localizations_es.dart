// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Aplicación Inicial';

  @override
  String get unexpectedError => 'Ocurrió un error inesperado';

  @override
  String get serverError => 'Ocurrió un error en el servidor';

  @override
  String get networkError => 'Sin conexión a internet';

  @override
  String get cacheError => 'Error de almacenamiento local';

  @override
  String get parseError => 'Formato de datos inválido recibido';
}
