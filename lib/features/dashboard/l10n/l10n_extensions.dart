import 'package:flutter/widgets.dart';
import 'package:starter_app/features/dashboard/l10n/dashboard_localizations.dart';

extension DashboardLocalizationsX on BuildContext {
  /// Get dashboard feature localizations
  DashboardLocalizations get dashboardL10n => DashboardLocalizations.of(this);
}
