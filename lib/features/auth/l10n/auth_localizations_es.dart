// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'auth_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AuthLocalizationsEs extends AuthLocalizations {
  AuthLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get unauthorized => 'Credenciales inválidas o sesión expirada';

  @override
  String get forbidden => 'Acceso denegado - permisos insuficientes';

  @override
  String get notFound => 'Recurso de autenticación no encontrado';

  @override
  String get emailLabel => 'Correo electrónico';

  @override
  String get emailHint => 'Ingresa tu dirección de correo electrónico';

  @override
  String get continueToEmail => 'Continuar';

  @override
  String welcomeBack(String email) {
    return '¡Bienvenido de nuevo, $email!';
  }

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get login => 'Iniciar sesión';

  @override
  String createAccount(String email) {
    return 'Crea una cuenta para $email.';
  }

  @override
  String get nameLabel => 'Tu nombre';

  @override
  String get nameEmpty => 'El nombre no puede estar vacío';

  @override
  String get register => 'Registrarse';

  @override
  String get retry => 'Reintentar';

  @override
  String get differentEmail => 'Usar un correo diferente';

  @override
  String get returnHome => 'Volver al inicio';

  @override
  String get emailAlreadyInUse => 'Este correo ya está registrado. Por favor inicia sesión.';

  @override
  String get invalidInput => 'Por favor verifica tus datos e intenta de nuevo.';
}
