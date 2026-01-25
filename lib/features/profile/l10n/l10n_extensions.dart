import 'package:flutter/widgets.dart';
import 'package:starter_app/features/profile/l10n/profile_localizations.dart';

extension ProfileLocalizationsX on BuildContext {
  /// Get profile feature localizations
  ProfileLocalizations get profileL10n => ProfileLocalizations.of(this);
}
