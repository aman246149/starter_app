import 'package:flutter/widgets.dart';
import 'package:starter_app/features/auth/l10n/auth_localizations.dart';

extension AuthLocalizationsX on BuildContext {
  /// Get auth feature localizations
  AuthLocalizations get authL10n => AuthLocalizations.of(this);
}
