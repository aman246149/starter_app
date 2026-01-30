// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'auth_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AuthLocalizationsEn extends AuthLocalizations {
  AuthLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get unauthorized => 'Invalid credentials or session expired';

  @override
  String get forbidden => 'Access denied - insufficient permissions';

  @override
  String get notFound => 'Authentication resource not found';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'Enter your email address';

  @override
  String get continueToEmail => 'Continue';

  @override
  String welcomeBack(String email) {
    return 'Welcome back, $email!';
  }

  @override
  String get passwordLabel => 'Password';

  @override
  String get login => 'Login';

  @override
  String createAccount(String email) {
    return 'Create an account for $email.';
  }

  @override
  String get nameLabel => 'Your Name';

  @override
  String get nameEmpty => 'Name cannot be empty';

  @override
  String get register => 'Register';

  @override
  String get retry => 'Retry';

  @override
  String get differentEmail => 'Use a different email';

  @override
  String get returnHome => 'Return to home';

  @override
  String get emailAlreadyInUse =>
      'This email is already registered. Please login instead.';

  @override
  String get invalidInput => 'Please check your input and try again.';
}
