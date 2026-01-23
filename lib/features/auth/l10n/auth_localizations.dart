import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'auth_localizations_en.dart';
import 'auth_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AuthLocalizations
/// returned by `AuthLocalizations.of(context)`.
///
/// Applications need to include `AuthLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/auth_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AuthLocalizations.localizationsDelegates,
///   supportedLocales: AuthLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AuthLocalizations.supportedLocales
/// property.
abstract class AuthLocalizations {
  AuthLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AuthLocalizations of(BuildContext context) {
    return Localizations.of<AuthLocalizations>(context, AuthLocalizations)!;
  }

  static const LocalizationsDelegate<AuthLocalizations> delegate = _AuthLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// Error message shown when user authentication fails due to invalid credentials or expired session
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials or session expired'**
  String get unauthorized;

  /// Error message shown when authenticated user doesn't have permission for the requested operation
  ///
  /// In en, this message translates to:
  /// **'Access denied - insufficient permissions'**
  String get forbidden;

  /// Error message shown when an authentication-related resource or endpoint cannot be found
  ///
  /// In en, this message translates to:
  /// **'Authentication resource not found'**
  String get notFound;

  /// Label for email input field
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// Hint text for email input field
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get emailHint;

  /// Button text to continue with email
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueToEmail;

  /// Welcome back message for existing users
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {email}!'**
  String welcomeBack(String email);

  /// Label for password input field
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// Button text to login
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Message for new users to create account
  ///
  /// In en, this message translates to:
  /// **'Create an account for {email}.'**
  String createAccount(String email);

  /// Label for name input field
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get nameLabel;

  /// Error message when name field is empty
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty'**
  String get nameEmpty;

  /// Button text to register
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// Button text to retry failed action
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Link text to change email address
  ///
  /// In en, this message translates to:
  /// **'Use a different email'**
  String get differentEmail;

  /// Button text to return to home page
  ///
  /// In en, this message translates to:
  /// **'Return to home'**
  String get returnHome;

  /// Error message shown when registration fails because email exists
  ///
  /// In en, this message translates to:
  /// **'This email is already registered. Please login instead.'**
  String get emailAlreadyInUse;

  /// Error message shown when server rejects input data
  ///
  /// In en, this message translates to:
  /// **'Please check your input and try again.'**
  String get invalidInput;
}

class _AuthLocalizationsDelegate extends LocalizationsDelegate<AuthLocalizations> {
  const _AuthLocalizationsDelegate();

  @override
  Future<AuthLocalizations> load(Locale locale) {
    return SynchronousFuture<AuthLocalizations>(lookupAuthLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AuthLocalizationsDelegate old) => false;
}

AuthLocalizations lookupAuthLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AuthLocalizationsEn();
    case 'es': return AuthLocalizationsEs();
  }

  throw FlutterError(
    'AuthLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
