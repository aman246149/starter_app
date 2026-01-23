import 'package:flutter/widgets.dart';
import 'package:starter_app/core/l10n/arb/app_localizations.dart';

// Note: LocaleCubit is now in core/presentation/bloc/locale_cubit.dart
// Import from 'package:starter_app/core/presentation/bloc/bloc.dart' instead

extension AppLocalizationsX on BuildContext {
  /// Get app-level localizations
  AppLocalizations get appL10n => AppLocalizations.of(this);
}
